Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF1C28E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B953DC433CB;
	Wed, 20 Sep 2023 11:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211055;
	bh=Q2isIbgnekL6WIgprinpaaU72YXk0H02Dm2tvoJgvNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/VkYabbwsglUfJfe2DglnyxkkTdWBa3iJlMY+vLyHuhJIXzyk2H9ehxqxjizHDr5
	 Otnq0QtroQGApHAj0DmX8mNSRUlCSZ0Dk798Rz7kM7UOdr8FJaBI0LNJ9skva0tauK
	 vV1u8N/lqelRQkle/zaGLDtwg1ChJYIwi4kkDIHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/139] btrfs: add a helper to read the superblock metadata_uuid
Date: Wed, 20 Sep 2023 13:30:26 +0200
Message-ID: <20230920112839.039769134@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit 4844c3664a72d36cc79752cb651c78860b14c240 ]

In some cases, we need to read the FSID from the superblock when the
metadata_uuid is not set, and otherwise, read the metadata_uuid. So,
add a helper.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 6bfe3959b0e7 ("btrfs: compare the correct fsid/metadata_uuid in btrfs_validate_super")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 8 ++++++++
 fs/btrfs/volumes.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 567c5c010f931..a40ebd2321d01 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -663,6 +663,14 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 	return -EINVAL;
 }
 
+u8 *btrfs_sb_fsid_ptr(struct btrfs_super_block *sb)
+{
+	bool has_metadata_uuid = (btrfs_super_incompat_flags(sb) &
+				  BTRFS_FEATURE_INCOMPAT_METADATA_UUID);
+
+	return has_metadata_uuid ? sb->metadata_uuid : sb->fsid;
+}
+
 /*
  * Handle scanned device having its CHANGING_FSID_V2 flag set and the fs_devices
  * being created with a disk that has already completed its fsid change. Such
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 099def5613b87..ec2260177038e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -757,5 +757,6 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
 bool btrfs_repair_one_zone(struct btrfs_fs_info *fs_info, u64 logical);
 
 bool btrfs_pinned_by_swapfile(struct btrfs_fs_info *fs_info, void *ptr);
+u8 *btrfs_sb_fsid_ptr(struct btrfs_super_block *sb);
 
 #endif
-- 
2.40.1



