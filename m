Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065378;
	b=HXDRqzrorVa9knYFZ/YJJAy9BDZQRoyVP/eXiN+juuRuJMTgRtR2GQ/gGuXmpa6kbjOX
	 DMgczFOE1WALGudML+ZXi6SBf6ssxhl3g0Tq0mffvTkctcrvcFZPFjqqLJ2LV6PKBjYK3
	 vhlcJTbxdrN8xmQIlIZrPyBS+Cv0BFosHB4VwHi/n/0otLuj6LMuxRD+8PEz2anTPqsEW
	 5W++113JahLlVQkoGP2PSg/Q8JigIxLmrlyTK/CJFNykVN23Kb2PxWaN1EPuD2OYI5+SE
	 9rhmLDt4rtQjXLTImZCQDl/K1QE7TcNUq/Bi3IWMXfpfSysaV7fz4tnZmuEpS1LYgWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MEw05vrJDsDoyQ7Qqkeou4+i5P/OlaWZRGWe2KOPWwY=;
	b=eGVOVPgoDr2MPkg+yp4z3/m1JAlwdkBYo8Jitt5bqfZTpRlz//y05x6MRETv87ScBYal
	 bkYutB2rGmUNfFvEIS/R09W8q6i5jZOfmHhcqawn0ir3oxL9Acyc6xJGQSHv8id0ui9X8
	 p2nTTex2EXfO1COh97tLZ2jqNps1LqaFOR6a2+lvaClUl9xH3GhYqjSTP2MUtJIfzpfCA
	 zdSS2yGTomVBfADz/2xkrjMAcjHJvARv8AkIDBnNXDn/k6DrIowLK0sevbSne08QWO4p9
	 z9DzmZ+/mGzfAp2SxROk6UXvwsu4g9Oo+JtA+S4VFVB5wJPsd6aRbNwKItbLL39GNVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JggTxjf0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E70606A32C;
	Sat,  7 Nov 2026 15:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JggTxjf0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C181F0089F;
	Sat,  7 Nov 2026 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065378;
	bh=MEw05vrJDsDoyQ7Qqkeou4+i5P/OlaWZRGWe2KOPWwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JggTxjf02tuOk7zauP6eFVBP/qzSUFOX3DMwiU6vQF9/V6FTqwEhBKup+MlRtPeAP
	 qZ/gkJ3OOIgee7Fdp1zLaSOAy3Pr/BlFuaRfh6dBDPjYOsvMvgl8+5OunNlen574KY
	 4NKv0itLATNZiSIartZh0fF6o1IqtRua7L6Z9JAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YoungWoo Rim <xsapiens75@gmail.com>,
	Chao Yu <chao@kernel.org>,
	"Gao Xiang (Docker)" <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1105/1257] erofs: hold real inodes for shared files
Date: Sat,  7 Nov 2026 08:56:41 -0500
Message-ID: <20261107135009.778634748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <xiang@kernel.org>

[ Upstream commit 7259fb011c14977661b7a4680886b466a3089ea7 ]

EROFS page cache sharing uses shared inodes. However, a mmaped VMA
keeps the shared file even after the corresponding fd is closed, while
currently the real inode is never held by any reference associated
with the shared file.

As a result, the real inode could be evicted and removed from the
shared inode's list while the page fault can still invoke on the
shared inode's address space, which causes no candidate is
successfully acquired by erofs_real_inode().

Fix this by simply keeping the original inode in the shared backing
file's private data.

Also replace confusing "realfile"/"rf" names with "sf" (sharedfile)
to unify the terms as well as nullify realinode in erofs_real_inode()
to avoid returning an uninitialized pointer.

Fixes: 5ef3208e3be5 ("erofs: introduce the page cache share feature")
Reported-by: YoungWoo Rim <xsapiens75@gmail.com>
Closes: https://lore.kernel.org/r/atzSVuvqYKgmvDmO@MacBookPro
Cc: stable@vger.kernel.org # 7.0+
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/ishare.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index a1cf2aff8d321..61f48ceb6cb66 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -30,9 +30,18 @@ static int erofs_ishare_iget5_set(struct inode *inode, void *data)
 	return 0;
 }
 
+static int erofs_ishare_backing_release(struct inode *inode, struct file *file)
+{
+	iput(file->private_data);
+	file->private_data = NULL;
+	return 0;
+}
+
 bool erofs_ishare_fill_inode(struct inode *inode)
 {
-	static const struct file_operations empty_fops = {};
+	static const struct file_operations backing_fops = {
+		.release = erofs_ishare_backing_release,
+	};
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
 	const struct address_space_operations *aops;
 	struct erofs_inode *vi = EROFS_I(inode);
@@ -50,7 +59,7 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 			  xxh32(fp.opaque, fp.size, 0),
 			  erofs_ishare_iget5_eq, erofs_ishare_iget5_set, &fp);
 	if (si && (inode_state_read_once(si) & I_NEW)) {
-		si->i_fop = &empty_fops;
+		si->i_fop = &backing_fops;
 		si->i_mapping->a_ops = aops;
 		si->i_mode = 0444 | S_IFREG;
 		si->i_size = inode->i_size;
@@ -100,16 +109,24 @@ static int erofs_ishare_file_open(struct inode *inode, struct file *file)
 		.mnt = erofs_ishare_mnt,
 		.dentry = EROFS_I(inode)->sharedentry,
 	};
-	struct file *rf;
+	struct file *sf;
 
 	if (file->f_flags & O_DIRECT)
 		return -EINVAL;
 
-	rf = backing_file_open(file, file->f_flags | O_NOATIME,
+	sf = backing_file_open(file, file->f_flags | O_NOATIME,
 			       &sharedpath, current_cred());
-	if (IS_ERR(rf))
-		return PTR_ERR(rf);
-	file->private_data = rf;
+	if (IS_ERR(sf))
+		return PTR_ERR(sf);
+	/*
+	 * A VMA only holds a reference to the shared file so that the original
+	 * file may be released: the shared file must therefore hold a reference
+	 * to one of the real inodes ("inode" passed here), and that reference
+	 * will be released by erofs_ishare_backing_release().
+	 */
+	ihold(inode);
+	sf->private_data = inode;
+	file->private_data = sf;
 	return 0;
 }
 
@@ -123,13 +140,13 @@ static int erofs_ishare_file_release(struct inode *inode, struct file *file)
 static ssize_t erofs_ishare_file_read_iter(struct kiocb *iocb,
 					   struct iov_iter *to)
 {
-	struct file *realfile = iocb->ki_filp->private_data;
+	struct file *sf = iocb->ki_filp->private_data;
 	struct kiocb dedup_iocb;
 	ssize_t nread;
 
 	if (!iov_iter_count(to))
 		return 0;
-	kiocb_clone(&dedup_iocb, iocb, realfile);
+	kiocb_clone(&dedup_iocb, iocb, sf);
 	nread = filemap_read(&dedup_iocb, to, 0);
 	iocb->ki_pos = dedup_iocb.ki_pos;
 	return nread;
@@ -137,12 +154,12 @@ static ssize_t erofs_ishare_file_read_iter(struct kiocb *iocb,
 
 static int erofs_ishare_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct file *realfile = file->private_data;
+	struct file *sf = file->private_data;
 	int err;
 
-	vma_set_file(vma, realfile);
+	vma_set_file(vma, sf);
 
-	err = security_mmap_backing_file(vma, realfile, file);
+	err = security_mmap_backing_file(vma, sf, file);
 	if (err)
 		return err;
 
@@ -176,7 +193,7 @@ const struct file_operations erofs_ishare_fops = {
 struct inode *erofs_real_inode(struct inode *inode, bool *need_iput)
 {
 	struct erofs_inode *vi, *vi_share;
-	struct inode *realinode;
+	struct inode *realinode = NULL;
 
 	*need_iput = false;
 	if (inode->i_sb != erofs_ishare_mnt->mnt_sb)
-- 
2.53.0



