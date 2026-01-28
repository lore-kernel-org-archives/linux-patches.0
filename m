Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8B536C0C7;
	Wed, 28 Jan 2026 15:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614048; cv=none; b=G0zkdzml3E74dkZkVI8jM8up7dwGiQsJKL+fAB8iWbrhzQ9iZyrv1veQcyfzUQs8NElr1OyjLBBSo90UPybTrbDslkNWMSAxEOn+WV62VWM8xlO4JtsB9ZHz80mmNkyjBLUvFV9hSOjXxC+RkUa4BTtpIDothcJaTR/0BMyAfnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614048; c=relaxed/simple;
	bh=yhJhjY1feD+e+jzGI5yF7y7fjUu1MQFmiEIeyH2GWGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3nLzapFQiGb5DEUWniIhXNWsxMIA6myIwrp2CYW6na/LxsrrfnUv3si3267qYuwwNNK+Sy/4qqGTnRu3ctP/l56abkBm50OlNIhFM1kpth1kAPKbjhzKKPjpZ5SVKjn4+AttzVhKu2m89SxZnCr3Q8NVk8xhnnKrxzsls0yYwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIcaFED7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIcaFED7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DFCC4CEF7;
	Wed, 28 Jan 2026 15:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614047;
	bh=yhJhjY1feD+e+jzGI5yF7y7fjUu1MQFmiEIeyH2GWGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIcaFED7X+BsjBnXh+35OcMvSkamiC4uk+RtX5ZBrYazM5Udld1tY4/MZ2ZBUpp6p
	 Cbs++VPGNrLnb6egInCZeW30crHwvhreWXmLiwKD+1LODC4Kj46GTh7LRbFxWMRsmF
	 JFBvjx9GT1CAy72rZ6tFGUiK/PVyZlpY1pbTsc7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/254] btrfs: factor out init_space_info() from create_space_info()
Date: Wed, 28 Jan 2026 16:19:56 +0100
Message-ID: <20260128145345.433199960@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit ac5578fef380e68e539a2238ba63dd978a450ef2 ]

Factor out initialization of the space_info struct, which is used in a
later patch. There is no functional change.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: a11224a016d6 ("btrfs: fix memory leaks in create_space_info() error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index bf5e509eb9fa8..38f730246e02f 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -222,19 +222,11 @@ void btrfs_update_space_info_chunk_size(struct btrfs_space_info *space_info,
 	WRITE_ONCE(space_info->chunk_size, chunk_size);
 }
 
-static int create_space_info(struct btrfs_fs_info *info, u64 flags)
+static void init_space_info(struct btrfs_fs_info *info,
+			    struct btrfs_space_info *space_info, u64 flags)
 {
-
-	struct btrfs_space_info *space_info;
-	int i;
-	int ret;
-
-	space_info = kzalloc(sizeof(*space_info), GFP_NOFS);
-	if (!space_info)
-		return -ENOMEM;
-
 	space_info->fs_info = info;
-	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
+	for (int i = 0; i < BTRFS_NR_RAID_TYPES; i++)
 		INIT_LIST_HEAD(&space_info->block_groups[i]);
 	init_rwsem(&space_info->groups_sem);
 	spin_lock_init(&space_info->lock);
@@ -248,6 +240,19 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 
 	if (btrfs_is_zoned(info))
 		space_info->bg_reclaim_threshold = BTRFS_DEFAULT_ZONED_RECLAIM_THRESH;
+}
+
+static int create_space_info(struct btrfs_fs_info *info, u64 flags)
+{
+
+	struct btrfs_space_info *space_info;
+	int ret;
+
+	space_info = kzalloc(sizeof(*space_info), GFP_NOFS);
+	if (!space_info)
+		return -ENOMEM;
+
+	init_space_info(info, space_info, flags);
 
 	ret = btrfs_sysfs_add_space_info_type(info, space_info);
 	if (ret)
-- 
2.51.0



