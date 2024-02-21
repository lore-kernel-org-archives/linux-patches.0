Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FC779DD7;
	Wed, 21 Feb 2024 13:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522237; cv=none; b=FBl1WWITIEBQ9NmjEZ9wahvwDjBc7SqY5/Dz4csGJXZ62ZhZgb0cnuw4xGJwc7OQPnsqF0r0Eb2hGgh5RfFu6ep1FBVgsh9cd6eRTOXwYdZngdU9ZZ/R9vkVxuae64m2mcjpZwI7u/RbK6vTSK8a/zHfkwgEOpyGXGqsKOyZ67w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522237; c=relaxed/simple;
	bh=BZYoWM7bIbETJgqk4CXQKh5pInpt7mupamqM2AM5nqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1TWMDj0DlNU8CcfNV+jibKPYz1uN8KF7gBcpVX8gEVdkfkHvkJX+neiPj7dZZ/+vJWjoZv432DDz+d1Mdp7wpTSZbp9QkD3WUHdrVhWWeHLkdHttbI6uoFktwML22XNCKvFXhrQGXVBzfqvUM6LvgdTaAUxEt5rDCTyJ3ThU0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JumYB72j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JumYB72j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5356EC43394;
	Wed, 21 Feb 2024 13:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522236;
	bh=BZYoWM7bIbETJgqk4CXQKh5pInpt7mupamqM2AM5nqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JumYB72jGqirXmoZxEZCcfpNiMrjWN9BhC4yTvoECk9kbxlnMRvvJgcPMYtPFTfd/
	 Yo1eWzaB6LQkYVcSeMk8xy5f43DOU1F5Aam4nNsImV7M5YLtd4G6csOTN4Gpv536rD
	 T7a4l9FGeblzcs64ieuURU+POTCn+zu+RC0D+vh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/476] btrfs: add definition for EXTENT_TREE_V2
Date: Wed, 21 Feb 2024 14:02:41 +0100
Message-ID: <20240221130012.035460073@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 2c7d2a230237e7c43fa067d695937b7e484bb92a ]

This adds the initial definition of the EXTENT_TREE_V2 incompat feature
flag.  This also hides the support behind CONFIG_BTRFS_DEBUG.

THIS IS A IN DEVELOPMENT FORMAT CHANGE, DO NOT USE UNLESS YOU ARE A
DEVELOPER OR A TESTER.

The format is in flux and will be added in stages, any fs will need to
be re-made between updates to the format.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 7081929ab257 ("btrfs: don't abort filesystem when attempting to snapshot deleted subvolume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h           | 21 +++++++++++++++++++++
 fs/btrfs/sysfs.c           |  5 ++++-
 include/uapi/linux/btrfs.h |  1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7905f178efa3..17ebcf19b444 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -282,6 +282,26 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
 
+#ifdef CONFIG_BTRFS_DEBUG
+/*
+ * Extent tree v2 supported only with CONFIG_BTRFS_DEBUG
+ */
+#define BTRFS_FEATURE_INCOMPAT_SUPP			\
+	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
+	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
+	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
+	 BTRFS_FEATURE_INCOMPAT_BIG_METADATA |		\
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_ZSTD |		\
+	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
+	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
+	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES	|	\
+	 BTRFS_FEATURE_INCOMPAT_METADATA_UUID	|	\
+	 BTRFS_FEATURE_INCOMPAT_RAID1C34	|	\
+	 BTRFS_FEATURE_INCOMPAT_ZONED		|	\
+	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2)
+#else
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
@@ -296,6 +316,7 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_METADATA_UUID	|	\
 	 BTRFS_FEATURE_INCOMPAT_RAID1C34	|	\
 	 BTRFS_FEATURE_INCOMPAT_ZONED)
+#endif
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 899dda6eb835..93a9dfbc8d13 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -283,9 +283,11 @@ BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
 BTRFS_FEAT_ATTR_INCOMPAT(metadata_uuid, METADATA_UUID);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
 BTRFS_FEAT_ATTR_INCOMPAT(raid1c34, RAID1C34);
-/* Remove once support for zoned allocation is feature complete */
 #ifdef CONFIG_BTRFS_DEBUG
+/* Remove once support for zoned allocation is feature complete */
 BTRFS_FEAT_ATTR_INCOMPAT(zoned, ZONED);
+/* Remove once support for extent tree v2 is feature complete */
+BTRFS_FEAT_ATTR_INCOMPAT(extent_tree_v2, EXTENT_TREE_V2);
 #endif
 #ifdef CONFIG_FS_VERITY
 BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
@@ -314,6 +316,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(raid1c34),
 #ifdef CONFIG_BTRFS_DEBUG
 	BTRFS_FEAT_ATTR_PTR(zoned),
+	BTRFS_FEAT_ATTR_PTR(extent_tree_v2),
 #endif
 #ifdef CONFIG_FS_VERITY
 	BTRFS_FEAT_ATTR_PTR(verity),
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 4693b6ba30a1..493b10b9fedd 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -310,6 +310,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_METADATA_UUID	(1ULL << 10)
 #define BTRFS_FEATURE_INCOMPAT_RAID1C34		(1ULL << 11)
 #define BTRFS_FEATURE_INCOMPAT_ZONED		(1ULL << 12)
+#define BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2	(1ULL << 13)
 
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
-- 
2.43.0



