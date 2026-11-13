Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590687;
	b=5I1r4CRSMmEW89j1bep+eHKCp4KQKMbnqQ8o47kHaZ1FsMz5G+5J34z6OV73411LVvcP
	 Wt60EGAn+XhOtNl25lr0Za7WvXVD9wLSQ4AO8fnGtUBcCyimD3RxV8lpxX4lOOj4ERYCj
	 O3WMoxtOX/ELIAe+Kd4QF8W4Ehppg4t1Fk7HIbccuh3DZbtTwRraYEy3dRBg6PbA8u3SM
	 W79O7qOKR8YlJlSb2BikJWA0Y2FN1VR1iXtwS5I83xxCmGlcDmm3vhFwkredJ3vJqAZeh
	 kDhcQla6JttYXL8VmEJ5QCUMnv1FW22BKDj86RK1NXM/I5YKuCxlBhyfFoCREU8JA0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aD+ynWX3uMvrv5VqC1U4s9zTlSb1xykp8W41ZwZrhJk=;
	b=ZXt6f2os+rpW0z9nCIP93vFcN0t3Po3YrDQVTKG+EYLayQspacD3Wl4CTcN3iFKoqpME
	 N+BCDadw7vrAr/JyVfHcA0EiVFAWEPPzG3acFfaQ0/SDRO+SG1grhYXSLUBk2YcvigHDP
	 Rl3KoVo9QWIO8j5nqCzQoTQr5P/hNS3fpFub8QywUVz2taZRPqP7FJ/9ihPwtyzlze1Kr
	 zEWXWcGF2Asj9JgEvvgAl1U//c5ei/IqZW5XWJPXqz2lMbk7hJzz516QFoWD1RyIBL7aq
	 Kw0nBkpPSJ3mSQWuBKKfB2FjevErTAm0eVwhb0RfYh+ERfxMP3FZVB7tXncdXXeBwpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uKmyHs95;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9180606CEE2;
	Fri, 13 Nov 2026 17:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uKmyHs95
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567881F000C6;
	Fri, 13 Nov 2026 17:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590687;
	bh=aD+ynWX3uMvrv5VqC1U4s9zTlSb1xykp8W41ZwZrhJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKmyHs95zmU9rq2gOOuas480kH7wibuhOqPJQrtO52NkW9w+hoJcimM3s08pEm+iD
	 aT0EL/do4E9dGmW2PPI9rNAyhJzgmorXnnzqVloMgk18GQg2yX/GmQjgRYr/Dux3Qa
	 YLR1EI+IMTXfHCiYmzVwOHGlEhV0UOVcu762jrTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 598/686] exfat: advance valid_size to EOF for append writes
Date: Fri, 13 Nov 2026 10:52:11 -0500
Message-ID: <20261113153842.196361207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Moved the pos assignment immediately after generic_write_checks() so the existing direct-I/O alignment check reads an initialized value. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 536c8078f0c19..64569d8ba8d73 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -633,23 +633,18 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
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
 
@@ -660,6 +655,10 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		}
 	}
 
+	if (pos > i_size_read(inode))
+		truncate_pagecache(inode, i_size_read(inode));
+
+	valid_size = ei->valid_size;
 	if (pos > valid_size) {
 		ret = exfat_extend_valid_size(inode, pos);
 		if (ret < 0 && ret != -ENOSPC) {
@@ -669,6 +668,8 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		}
 		if (ret < 0)
 			goto unlock;
+
+		pos = valid_size;
 	}
 
 	ret = __generic_file_write_iter(iocb, iter);
@@ -677,9 +678,6 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	inode_unlock(inode);
 
-	if (pos > valid_size)
-		pos = valid_size;
-
 	if (iocb->ki_pos > pos) {
 		ssize_t err = generic_write_sync(iocb, iocb->ki_pos - pos);
 		if (err < 0)
-- 
2.53.0



