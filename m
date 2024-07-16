Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A770117CA0E;
	Tue, 16 Jul 2024 16:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146069; cv=none; b=ltbFwovBj0cZtX26yHDap2nDr/v1IGLMoToM5hac5RmQ1GIN4N+7tDMVaJ1sXj86XOOeav9aEcv8cEJDyFrxfo/6A1Hr8ed6gjcQt+3Yi47iF/PJ5p+pQTHNz9jqu009uTds4vP07Cqfs2taynEaodAz2XXkPreyf2KwgIKAtyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146069; c=relaxed/simple;
	bh=VRw2cGm5wYJtQzFPZs1nS29EvmwRWm7mOQl8+WsnVYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp53W75UxQLORzfaGHBfFfGFoHCeeb2QqlVZOrcTUZ/td2GC1U1VJmJCuXGZP3DvdqVkwFsRHSixqzV77SR/7TaAnQ3T+yGmDdFFrwi0C4bF8wSapo36XjlODQQvsg1qURFYgjgA9WEcZbeOmaxmtd2rds9/Mc/dVK4uYyHEHzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1qiZ4Cw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1qiZ4Cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E53C116B1;
	Tue, 16 Jul 2024 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146069;
	bh=VRw2cGm5wYJtQzFPZs1nS29EvmwRWm7mOQl8+WsnVYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1qiZ4CwclpEPhpQZwFPYGW88IVasvZajH17JM7tttDxYPaqKCCYiF86BUerw6uyv
	 eFSBnZ8aLhJvWLeHwp24+FcYS5Rnycxl0UanPvQ1GEXmjSBgLPX9KI+t6up6yTZyOU
	 nDRYYgpty3wSc/GMVJ2jd7ms6xZlAQ2m87uTeseA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hillf Danton <hdanton@sina.com>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 047/144] nilfs2: fix inode number range checks
Date: Tue, 16 Jul 2024 17:31:56 +0200
Message-ID: <20240716152754.355053604@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit e2fec219a36e0993642844be0f345513507031f4 upstream.

Patch series "nilfs2: fix potential issues related to reserved inodes".

This series fixes one use-after-free issue reported by syzbot, caused by
nilfs2's internal inode being exposed in the namespace on a corrupted
filesystem, and a couple of flaws that cause problems if the starting
number of non-reserved inodes written in the on-disk super block is
intentionally (or corruptly) changed from its default value.


This patch (of 3):

In the current implementation of nilfs2, "nilfs->ns_first_ino", which
gives the first non-reserved inode number, is read from the superblock,
but its lower limit is not checked.

As a result, if a number that overlaps with the inode number range of
reserved inodes such as the root directory or metadata files is set in the
super block parameter, the inode number test macros (NILFS_MDT_INODE and
NILFS_VALID_INODE) will not function properly.

In addition, these test macros use left bit-shift calculations using with
the inode number as the shift count via the BIT macro, but the result of a
shift calculation that exceeds the bit width of an integer is undefined in
the C specification, so if "ns_first_ino" is set to a large value other
than the default value NILFS_USER_INO (=11), the macros may potentially
malfunction depending on the environment.

Fix these issues by checking the lower bound of "nilfs->ns_first_ino" and
by preventing bit shifts equal to or greater than the NILFS_USER_INO
constant in the inode number test macros.

Also, change the type of "ns_first_ino" from signed integer to unsigned
integer to avoid the need for type casting in comparisons such as the
lower bound check introduced this time.

Link: https://lkml.kernel.org/r/20240623051135.4180-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240623051135.4180-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/nilfs.h     |    5 +++--
 fs/nilfs2/the_nilfs.c |    6 ++++++
 fs/nilfs2/the_nilfs.h |    2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -116,9 +116,10 @@ enum {
 #define NILFS_FIRST_INO(sb) (((struct the_nilfs *)sb->s_fs_info)->ns_first_ino)
 
 #define NILFS_MDT_INODE(sb, ino) \
-	((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & BIT(ino)))
+	((ino) < NILFS_USER_INO && (NILFS_MDT_INO_BITS & BIT(ino)))
 #define NILFS_VALID_INODE(sb, ino) \
-	((ino) >= NILFS_FIRST_INO(sb) || (NILFS_SYS_INO_BITS & BIT(ino)))
+	((ino) >= NILFS_FIRST_INO(sb) ||				\
+	 ((ino) < NILFS_USER_INO && (NILFS_SYS_INO_BITS & BIT(ino))))
 
 /**
  * struct nilfs_transaction_info: context information for synchronization
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -452,6 +452,12 @@ static int nilfs_store_disk_layout(struc
 	}
 
 	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
+	if (nilfs->ns_first_ino < NILFS_USER_INO) {
+		nilfs_err(nilfs->ns_sb,
+			  "too small lower limit for non-reserved inode numbers: %u",
+			  nilfs->ns_first_ino);
+		return -EINVAL;
+	}
 
 	nilfs->ns_blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
 	if (nilfs->ns_blocks_per_segment < NILFS_SEG_MIN_BLOCKS) {
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -182,7 +182,7 @@ struct the_nilfs {
 	unsigned long		ns_nrsvsegs;
 	unsigned long		ns_first_data_block;
 	int			ns_inode_size;
-	int			ns_first_ino;
+	unsigned int		ns_first_ino;
 	u32			ns_crc_seed;
 
 	/* /sys/fs/<nilfs>/<device> */


