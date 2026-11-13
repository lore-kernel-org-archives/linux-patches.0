Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591559;
	b=dA1FCaJmSOjSOMuY/uVI26QrU6dfmXzcI/vzsoSqY9ERDmKKNrPNYl31QAzkv3bMRPZR
	 hbCT24vgZXK3lRVBb+JRjmn4E0m4uDQ7eFPHocypOZt70MizE9i/pcsdglPEJKsSVXwSs
	 JE1azEd46h0KMfv3I+GK5/NWVCWv1bMhF2bZ8ksuV+oadMzYK38BpjYjrcZZ6k0tfX3R3
	 KhURChyxBmEgtpHCIq2oZfbZBOAacRXFX+ptfUZZkmKDaI/Xw/EBgmvpRENa8xQp/08sC
	 0bhou6LH4A4lV0JicSZwV955vQxKX4F8Ar0YJsRQO1BMA4bt4q56fH8rs/7+ph7OPaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vt/pEqEV4Ze1PApSrc6JPObeKAG5So8mdGEh7MoXoNg=;
	b=GjlHxOn6/rqNQm5iNHOvcRF/gQso6mQtHct3WNA7o0Dvte/qb1eswWgIW/i2ugwSDIwQ
	 jKql/gxBg9hTUBhQRFfYRBx/Xiz7CqIjmpPdVvNFveXfTImZpvACDX1Ma6rMmx5nvN5g+
	 nud9P3Xh6UBEQPOV+YEd2ru2652D0jlzommp3xHYcv3fvnbWgfRo3XLcQAkj9VkYFR12S
	 nHoGjsWb3Y2BmyvUFHnaUjiL83QorWlHWtjrySNXftHf3i+moKV8W3JlHFOO1isPYU1ps
	 DpUWxFjdJye+xrspVClVxTqW+4YcTQ6nqUmenBl/PxoHrtGTBmFeyKZZXGtUX7PPDxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eo19dYUo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69945606E228;
	Fri, 13 Nov 2026 17:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eo19dYUo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C119C1F000C4;
	Fri, 13 Nov 2026 17:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591559;
	bh=vt/pEqEV4Ze1PApSrc6JPObeKAG5So8mdGEh7MoXoNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eo19dYUoSGDJ175x5bplfezJHCMGg8y3WypED4CaGsqLDxVSmIPDT9ewyS1zi/z+R
	 vNIZkakOAbg7YcWVTfiwiYcLsX97EEJ4TlhQ20MjK+N2nrH7i1QrRSZRHSPA2HQxKs
	 tUE00+3i/PiQ9oCI3mXVA8zJ23aus4qxHDL+rW9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 568/670] exfat: advance valid_size to EOF for append writes
Date: Fri, 13 Nov 2026 10:52:12 -0500
Message-ID: <20261113153831.117386379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit b70ab407503706289163dd59f1ac3e942bacc37d ]

For an append write, the write position is recalculated by
generic_write_checks(). Therefore, the write position must be obtained
after generic_write_checks() returns.

Using the original write position to advance valid_size may cause the
valid_size update to be skipped, potentially exposing stale data.

Also move the truncate_pagecache() check below the recalculated
position, so that pos is never read before it is assigned.

Fixes: 11a347fb6cef ("exfat: change to get file size from DataLength")
Cc: stable@vger.kernel.org
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: moved pos initialization before the existing direct I/O alignment checks ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 033852efe5dc3..b624dc527f675 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -581,23 +581,18 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct exfat_inode_info *ei = EXFAT_I(inode);
-	loff_t pos = iocb->ki_pos;
-	loff_t valid_size;
+	loff_t pos, valid_size;
 
 	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
 		return -EIO;
 
 	inode_lock(inode);
 
-	if (pos > i_size_read(inode))
-		truncate_pagecache(inode, i_size_read(inode));
-
-	valid_size = ei->valid_size;
-
 	ret = generic_write_checks(iocb, iter);
 	if (ret <= 0)
 		goto unlock;
 
+	pos = iocb->ki_pos;
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		unsigned long align = pos | iov_iter_alignment(iter);
 
@@ -608,6 +603,10 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		}
 	}
 
+	if (pos > i_size_read(inode))
+		truncate_pagecache(inode, i_size_read(inode));
+
+	valid_size = ei->valid_size;
 	if (pos > valid_size) {
 		ret = exfat_extend_valid_size(file, pos);
 		if (ret < 0 && ret != -ENOSPC) {
@@ -617,6 +616,8 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		}
 		if (ret < 0)
 			goto unlock;
+
+		pos = valid_size;
 	}
 
 	ret = __generic_file_write_iter(iocb, iter);
@@ -625,9 +626,6 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	inode_unlock(inode);
 
-	if (pos > valid_size)
-		pos = valid_size;
-
 	if (iocb->ki_pos > pos) {
 		ssize_t err = generic_write_sync(iocb, iocb->ki_pos - pos);
 		if (err < 0)
-- 
2.53.0



