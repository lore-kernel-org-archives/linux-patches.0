Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063347;
	b=ykvYU5XVkxGvipVa5nWjtYhEBQ4XehtKAdrfkNXqKTpWHxKsEYk08rkQQtI5D9MQeOMd
	 Dckjp8s029rdsSQrMSI4NUi0OhJNmQ9lJpnmqJrn7kjH0mjFGcA2isntCFILHgzAGY4+9
	 afd9GJrMt8CLtIGcvTIxKPUECvF/KkRDI+IX5oC2JkAAAEyKDEFq3mRFmzzPZaJV7hRFD
	 60AzEqoSjf0jUMpgodpD5dxI8BKqTu+M31J3u+gkREqvzwg7OaMBq5TV/79taY3dYDCt4
	 a65dFx1h2FsH2pExwwqIA0b4BSwML2abOSsJniEDijnCyJH+TVbwuwhJwr9TPCg46NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0XublP86Eu4OfnMt/fQ0ulFoVbYYg4GeEwBrUq32N8=;
	b=q+XbdCNzQ459aPIEgzQDewGpTFdF/4Z113fxohznX5t3dwoFgSQ9Ux528Y0F9zsQCAAn
	 WWNUtMk9IK5sLxXaFx+WdETSQG08pl3MSQFrU5YcxWFqo1zTA6DahYs41jfK4w4rykuju
	 B7Rrzhw4mC6RAIjrg32IRHDD4oC9m7DoMWIiziZqRLOSq1a4HFUQHbuePzqug8Re38CdD
	 POqobnmb9tJZjqXDddD71hkhxqFCVTR2v8F4qu+cliRSy+zNVlLklZrwpzLUeIkrtT13j
	 ADdE3G6CaOemOgncBHyy1LjtHgtF4tFBwdL9Ky8n1F3tYf2biAraIaOA7fmlVIGvhqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vA6JEYVZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D155606D82C;
	Sat,  7 Nov 2026 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vA6JEYVZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268051F0089F;
	Sat,  7 Nov 2026 14:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063347;
	bh=h0XublP86Eu4OfnMt/fQ0ulFoVbYYg4GeEwBrUq32N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vA6JEYVZzQU8TYu8pYA7YCRx1kfHPBYklrVmnZFraGATabzQ/hFaxnWa/LZ7IXohf
	 91x7yCiyk7SHGfNoFPw1+eNSIwlZy2o4IA+LUDpMsQp7rKhrmNMoqHoRWDYacht/DH
	 P2xU6KVbUzgtiRgWVOt0b8CH882hoHZOwSoGCPzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 529/869] f2fs: read i_size once in f2fs_vm_page_mkwrite
Date: Sat,  7 Nov 2026 08:53:31 -0500
Message-ID: <20261107134911.412675285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index e5de7c3557260..df625a48d725e 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -123,6 +123,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dnode_of_data dn;
 	bool need_alloc = !f2fs_is_pinned_file(inode);
+	loff_t isize;
 	int err = 0;
 	vm_fault_t ret;
 
@@ -177,8 +178,14 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
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
@@ -208,11 +215,10 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
 
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



