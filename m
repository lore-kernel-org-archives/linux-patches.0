Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036545;
	b=qx57hfaBEFc8+V9lO3PJmheMAEZqx0D/8Y1qao2wwzYKv6Inv/cFoqRHDUVaE6grnmah
	 KH/4gZRnJ9pzMizAmHS8zX/l3F1PcObBpa487CvrMbE6KWhUw3xPP4Mm6oTuIupgXvePX
	 rHf7oQQkEcZP85Egh1XSILv6yotyz/ddHuWMW7Kcu0QUTzvF0p5cxoYaE4LxUHUmWoG6p
	 5sfxYPefCQvMuyAoXzClaJThdNU07txhW+J+EU0wnCv8AbjLPnBoILyjaSlzzA6DvExUJ
	 sBs5gkpV20zdNKaVLw42TWC0wadFIOHtYXDYA/G/sSWnsA/ohcIg0ezkId+OrUFFNVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1v3hfV3ORKmCrPUxl9k3uf+Ay8RRjcyc2suGMGDaun0=;
	b=t9mRWDpCllZQoN1/uuVhZQrR17Kjmb1p4c3r1Ut+F9fR3gwLQ8T8FZ3FeBfyPzd85Jir
	 xSCpOFCkFFxrLHgyDW7aBeir65967mkJ00RleD9wdtXdskvu+nTx5jYDZZDY5FVKcDYrJ
	 als14x/Tlurl9ymWvTbMb46K93ltfkjBw0srw8VCSBThRUyv9Q4iU2pZ5lkzOgflHRZUv
	 mBkqvZlvuGRNjcrZCfkL0KTPJA9cnmuV5oelcqvXJVRvTrEpklxabhl7xMTFPSwZKiAng
	 lZertH7H5j7LOvAVy4jWKrqYjSd8pp3tDI9drvbtLLMhc8MLAVX+9/axKbUvuEARq8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bhtrtjBp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41CA606A339;
	Wed, 18 Nov 2026 21:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bhtrtjBp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3D61F000C4;
	Wed, 18 Nov 2026 21:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036544;
	bh=1v3hfV3ORKmCrPUxl9k3uf+Ay8RRjcyc2suGMGDaun0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhtrtjBp9fySTXLndAfX9ZVpNKF04HjmKNNX5IE4dRCSj6YPyPADzWAZYnpd4R8uu
	 GyqXwwbRFctxgOIvZT5GkpHs9dhoa/VXxrx9S00AdfnT9Ash4qmPuDgTWlMOW5Jx69
	 MsQR+R9baqWg8UHBMhrWKNv80eCNQUlc5NU//Dac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1097/3318] f2fs: read i_size once in f2fs_vm_page_mkwrite
Date: Wed, 18 Nov 2026 15:28:39 +0100
Message-ID: <20261118150352.887597053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>

[ Upstream commit c04f209773ecb31e592cababce0d6658ee0b8d58 ]

f2fs_vm_page_mkwrite() reads i_size twice: once to check whether the
folio is partially beyond EOF, and once to calculate the offset for
folio_zero_segment(). But a concurrent buffered write can extend isize
and cause the following race condition to corrupt data:

buffered write writes [0,3500)

CPU0 (write fault)                        CPU1 (buffered write)
 ----                                     ----
 f2fs_vm_page_mkwrite()
 folio_lock(folio)
 if (((loff_t)(folio->index + 1) << PAGE_SHIFT) >
 i_size_read(inode))
 /* i_size_read() = 3500 */
                                           write(fd, buf, 200, 4096)
                                           /* writes into page1, does not
                                              wait for folio lock */
                                           i_size_write(inode, 4296)
 offset = i_size_read(inode) & ~PAGE_MASK
 /* i_size_read() = 4296, offset = 200 */
 folio_zero_segment(folio, offset, folio_size(folio))
 /* valid data [200, 3500) is zeroed */

Fix this by reading i_size once and using the same value for both the
EOF check and the zeroing offset.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261012030315.978375-1-zhaonanzhe%40xiaomi.com
Fixes: fbfa2cc58d53 ("f2fs: add file operations")
Cc: stable@vger.kernel.org
Signed-off-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index b0b2dc7304687..aca5a0560116b 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -124,6 +124,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dnode_of_data dn;
 	bool need_alloc = !f2fs_is_pinned_file(inode);
+	loff_t isize;
 	int err = 0;
 	vm_fault_t ret;
 
@@ -178,8 +179,14 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	filemap_invalidate_lock_shared(inode->i_mapping);
 
 	folio_lock(folio);
+	/*
+	 * A concurrent buffered write can extend isize, so we store isize in a
+	 * local variable to let the zeroing offset match the EOF check below.
+	 */
+	isize = i_size_read(inode);
+
 	if (unlikely(folio->mapping != inode->i_mapping ||
-			folio_pos(folio) > i_size_read(inode) ||
+			folio_pos(folio) > isize ||
 			!folio_test_uptodate(folio))) {
 		folio_unlock(folio);
 		err = -EFAULT;
@@ -215,11 +222,10 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 		goto out_sem;
 
 	/* page is wholly or partially inside EOF */
-	if (((loff_t)(folio->index + 1) << PAGE_SHIFT) >
-						i_size_read(inode)) {
+	if (((loff_t)(folio->index + 1) << PAGE_SHIFT) > isize) {
 		loff_t offset;
 
-		offset = i_size_read(inode) & ~PAGE_MASK;
+		offset = isize & ~PAGE_MASK;
 		folio_zero_segment(folio, offset, folio_size(folio));
 	}
 	folio_mark_dirty(folio);
-- 
2.53.0



