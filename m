Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39E9BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F0CC4339B;
	Tue,  7 Mar 2023 18:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214018;
	bh=WxcdnQRtTIIbUoK9Qlj+sTN+47VElCZ8S7NU9YiN58w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJrA2+0HzkokS3MhwFN86DLSfRzyl3yK4ELzW2KQO1FYPxdLiDnyvi+fWPgbot8RI
	 pBEYBjCZuLRcgSnqfs/wmCNf2XFTR+4syvd1EpBPVE3KdZg4qXT6sGSNmuhqbidDFw
	 ew5rVxmit5RHOwje6FkyKGrzRBiQPbv25ev3TEcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yugui <wangyugui@e16-tech.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Andy Wu <Andy.Wu@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 694/885] exfat: fix inode->i_blocks for non-512 byte sector size device
Date: Tue,  7 Mar 2023 18:00:28 +0100
Message-Id: <20230307170032.258955647@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit 39c1ce8eafc0ff64fb9e28536ccc7df6a8e2999d upstream.

inode->i_blocks is not real number of blocks, but 512 byte ones.

Fixes: 98d917047e8b ("exfat: add file operations")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Tested-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/file.c  |    3 +--
 fs/exfat/inode.c |    6 ++----
 fs/exfat/namei.c |    2 +-
 fs/exfat/super.c |    3 +--
 4 files changed, 5 insertions(+), 9 deletions(-)

--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -211,8 +211,7 @@ void exfat_truncate(struct inode *inode,
 	if (err)
 		goto write_size;
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 write_size:
 	aligned_size = i_size_read(inode);
 	if (aligned_size & (blocksize - 1)) {
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -221,8 +221,7 @@ static int exfat_map_cluster(struct inod
 		num_clusters += num_to_be_allocated;
 		*clu = new_clu.dir;
 
-		inode->i_blocks +=
-			num_to_be_allocated << sbi->sect_per_clus_bits;
+		inode->i_blocks += EXFAT_CLU_TO_B(num_to_be_allocated, sbi) >> 9;
 
 		/*
 		 * Move *clu pointer along FAT chains (hole care) because the
@@ -582,8 +581,7 @@ static int exfat_fill_inode(struct inode
 
 	exfat_save_attr(inode, info->attr);
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 	inode->i_mtime = info->mtime;
 	inode->i_ctime = info->mtime;
 	ei->i_crtime = info->crtime;
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -387,7 +387,7 @@ static int exfat_find_empty_entry(struct
 		ei->i_size_ondisk += sbi->cluster_size;
 		ei->i_size_aligned += sbi->cluster_size;
 		ei->flags = p_dir->flags;
-		inode->i_blocks += 1 << sbi->sect_per_clus_bits;
+		inode->i_blocks += sbi->cluster_size >> 9;
 	}
 
 	return dentry;
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -373,8 +373,7 @@ static int exfat_read_root(struct inode
 	inode->i_op = &exfat_dir_inode_operations;
 	inode->i_fop = &exfat_dir_operations;
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 	ei->i_pos = ((loff_t)sbi->root_dir << 32) | 0xffffffff;
 	ei->i_size_aligned = i_size_read(inode);
 	ei->i_size_ondisk = i_size_read(inode);


