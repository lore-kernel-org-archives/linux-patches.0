Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48A813B2B4;
	Tue, 27 Feb 2024 14:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043815; cv=none; b=HicW6APYY30gT/tETjjAg3DWnVXCNgp4qyOpe1/M//WzTCKgwtO4lyuk3TWyFTRPiiqhc+MXaezV++SLz3mMjm9DhjS6NAeDQJh9uyooqW8UzayoS1WZPRaxbKMbP/Zt3hN1crXiwIDMeluFqWpj8YCirpwbNtrfWuv12atKDCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043815; c=relaxed/simple;
	bh=B/7Ltrk/5a/O3hw67qh27SckG31ejwL0zdtHrw68mxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgkIeghOLJfRs8oCuyLdb2R6jXSAhovJ31veSjRhTzzL3fBjhqLAgRTFUS2/CaZHLsrv29DYQr1j+d90KAyDXXrJMAJw1WG1LDwrmCV0kcs8Y3DuS/k1vHk5UHLKJOaINctxSDpxLi9NSYMMqw1Uvrf4x1o207tD+7gEcIvk0B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQ0H9AzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQ0H9AzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCFCC433F1;
	Tue, 27 Feb 2024 14:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043815;
	bh=B/7Ltrk/5a/O3hw67qh27SckG31ejwL0zdtHrw68mxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQ0H9AzM/IxuvsIIpyxFuRuFaq79/miEd29o4CcK28LSztO4s+JFMtNbIHdiwRrgL
	 yUZkg12Xw14Q7TH9uU6ig9c6rHnIQodF4qzH0+6X5uu6gq5lgg0I2hfBTNIneDBAuI
	 2SlsXo0VYlIOOiyueWhSaYFWiQra/if5Bk+uLdaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+5d5d25f90f195a3cfcb4@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 08/84] nilfs2: replace WARN_ONs for invalid DAT metadata block requests
Date: Tue, 27 Feb 2024 14:26:35 +0100
Message-ID: <20240227131553.142264341@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 5124a0a549857c4b87173280e192eea24dea72ad upstream.

If DAT metadata file block access fails due to corruption of the DAT file
or abnormal virtual block numbers held by b-trees or inodes, a kernel
warning is generated.

This replaces the WARN_ONs by error output, so that a kernel, booted with
panic_on_warn, does not panic.  This patch also replaces the detected
return code -ENOENT with another internal code -EINVAL to notify the bmap
layer of metadata corruption.  When the bmap layer sees -EINVAL, it
handles the abnormal situation with nilfs_bmap_convert_error() and finally
returns code -EIO as it should.

Link: https://lkml.kernel.org/r/0000000000005cc3d205ea23ddcf@google.com
Link: https://lkml.kernel.org/r/20230126164114.6911-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: <syzbot+5d5d25f90f195a3cfcb4@syzkaller.appspotmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/dat.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -40,8 +40,21 @@ static inline struct nilfs_dat_info *NIL
 static int nilfs_dat_prepare_entry(struct inode *dat,
 				   struct nilfs_palloc_req *req, int create)
 {
-	return nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
-					    create, &req->pr_entry_bh);
+	int ret;
+
+	ret = nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
+					   create, &req->pr_entry_bh);
+	if (unlikely(ret == -ENOENT)) {
+		nilfs_msg(dat->i_sb, KERN_ERR,
+			  "DAT doesn't have a block to manage vblocknr = %llu",
+			  (unsigned long long)req->pr_entry_nr);
+		/*
+		 * Return internal code -EINVAL to notify bmap layer of
+		 * metadata corruption.
+		 */
+		ret = -EINVAL;
+	}
+	return ret;
 }
 
 static void nilfs_dat_commit_entry(struct inode *dat,
@@ -123,11 +136,7 @@ static void nilfs_dat_commit_free(struct
 
 int nilfs_dat_prepare_start(struct inode *dat, struct nilfs_palloc_req *req)
 {
-	int ret;
-
-	ret = nilfs_dat_prepare_entry(dat, req, 0);
-	WARN_ON(ret == -ENOENT);
-	return ret;
+	return nilfs_dat_prepare_entry(dat, req, 0);
 }
 
 void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *req,
@@ -154,10 +163,8 @@ int nilfs_dat_prepare_end(struct inode *
 	int ret;
 
 	ret = nilfs_dat_prepare_entry(dat, req, 0);
-	if (ret < 0) {
-		WARN_ON(ret == -ENOENT);
+	if (ret < 0)
 		return ret;
-	}
 
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,


