Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54BD26A08F;
	Mon, 23 Mar 2026 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277554; cv=none; b=ehU7VfgID6R5Q4y6w69VHyGQV+1be/3/b2UzOdBeub1cReHEOlQUa9uDuPSdcO0jGNaX5XmwlpMPS1//lSieCCtkS9Ztv8qqqeYgYk3RRjLWFJD/ndy7HqThh1kmQUxvWKx+9f9pg16gfxCl3lcLGCVyem92feHVBu8E6r3f66k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277554; c=relaxed/simple;
	bh=+HDwDEzzWTWpmHIB94UYN2BiS83mbJAxu+DxZjh0x8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch4pJvkpW8HA326qOVXGgRw3amkFSUM7B1kZBwQtaTLSxySas95HHHxuMSKhFrFNh67MgtrBJdofjMPVB+2f3NmSAfP8b6UikfbPfwrpbnWnt1N2WNYnxEcZMcRTD1f37BdlrU8OdGcwUFLXP6s4/DaWlbA/RBPtk4lWIuFdotc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKcacgYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKcacgYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D946C4CEF7;
	Mon, 23 Mar 2026 14:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277554;
	bh=+HDwDEzzWTWpmHIB94UYN2BiS83mbJAxu+DxZjh0x8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKcacgYEzOrHy+SY8nJ6KgA+Z6tN0320C4AI2MqK9Hd5esP41q+gq4C/VGkkaQ52w
	 dxoMoBKImI9pbHML70KP9Kz8zQ9XobiCOvoiKBmpnF8VlPt9hsAPkt+qdfdgq041ga
	 d3wnURGJRJdsB4k4AENa/Fztc3b6XttASSuw9Omk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/567] btrfs: add raid stripe tree definitions
Date: Mon, 23 Mar 2026 14:38:58 +0100
Message-ID: <20260323134534.216086213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit ee1293308e01d359688243d665138f35a6f1f9b8 ]

Add definitions for the raid stripe tree. This tree will hold information
about the on-disk layout of the stripes in a RAID set.

Each stripe extent has a 1:1 relationship with an on-disk extent item and
is doing the logical to per-drive physical address translation for the
extent item in question.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 511dc8912ae3 ("btrfs: fix incorrect key offset in error message in check_dev_extent_item()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/accessors.h            |  8 ++++++++
 fs/btrfs/locking.c              |  1 +
 include/uapi/linux/btrfs_tree.h | 29 +++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
index 8cfc8214109ca..341c07b4c2272 100644
--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -305,6 +305,14 @@ BTRFS_SETGET_FUNCS(timespec_nsec, struct btrfs_timespec, nsec, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_timespec_sec, struct btrfs_timespec, sec, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_timespec_nsec, struct btrfs_timespec, nsec, 32);
 
+BTRFS_SETGET_FUNCS(stripe_extent_encoding, struct btrfs_stripe_extent, encoding, 8);
+BTRFS_SETGET_FUNCS(raid_stride_devid, struct btrfs_raid_stride, devid, 64);
+BTRFS_SETGET_FUNCS(raid_stride_physical, struct btrfs_raid_stride, physical, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_stripe_extent_encoding,
+			 struct btrfs_stripe_extent, encoding, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_raid_stride_devid, struct btrfs_raid_stride, devid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_raid_stride_physical, struct btrfs_raid_stride, physical, 64);
+
 /* struct btrfs_dev_extent */
 BTRFS_SETGET_FUNCS(dev_extent_chunk_tree, struct btrfs_dev_extent, chunk_tree, 64);
 BTRFS_SETGET_FUNCS(dev_extent_chunk_objectid, struct btrfs_dev_extent,
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 7979449a58d6b..51737e7350669 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -73,6 +73,7 @@ static struct btrfs_lockdep_keyset {
 	{ .id = BTRFS_UUID_TREE_OBJECTID,	DEFINE_NAME("uuid")	},
 	{ .id = BTRFS_FREE_SPACE_TREE_OBJECTID,	DEFINE_NAME("free-space") },
 	{ .id = BTRFS_BLOCK_GROUP_TREE_OBJECTID, DEFINE_NAME("block-group") },
+	{ .id = BTRFS_RAID_STRIPE_TREE_OBJECTID, DEFINE_NAME("raid-stripe") },
 	{ .id = 0,				DEFINE_NAME("tree")	},
 };
 
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index fc3c32186d7eb..ca65d7b7a6ca1 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -73,6 +73,9 @@
 /* Holds the block group items for extent tree v2. */
 #define BTRFS_BLOCK_GROUP_TREE_OBJECTID 11ULL
 
+/* Tracks RAID stripes in block groups. */
+#define BTRFS_RAID_STRIPE_TREE_OBJECTID 12ULL
+
 /* device stats in the device tree */
 #define BTRFS_DEV_STATS_OBJECTID 0ULL
 
@@ -261,6 +264,8 @@
 #define BTRFS_DEV_ITEM_KEY	216
 #define BTRFS_CHUNK_ITEM_KEY	228
 
+#define BTRFS_RAID_STRIPE_KEY	230
+
 /*
  * Records the overall state of the qgroups.
  * There's only one instance of this key present,
@@ -719,6 +724,30 @@ struct btrfs_free_space_header {
 	__le64 num_bitmaps;
 } __attribute__ ((__packed__));
 
+struct btrfs_raid_stride {
+	/* The id of device this raid extent lives on. */
+	__le64 devid;
+	/* The physical location on disk. */
+	__le64 physical;
+} __attribute__ ((__packed__));
+
+/* The stripe_extent::encoding, 1:1 mapping of enum btrfs_raid_types. */
+#define BTRFS_STRIPE_RAID0	1
+#define BTRFS_STRIPE_RAID1	2
+#define BTRFS_STRIPE_DUP	3
+#define BTRFS_STRIPE_RAID10	4
+#define BTRFS_STRIPE_RAID5	5
+#define BTRFS_STRIPE_RAID6	6
+#define BTRFS_STRIPE_RAID1C3	7
+#define BTRFS_STRIPE_RAID1C4	8
+
+struct btrfs_stripe_extent {
+	__u8 encoding;
+	__u8 reserved[7];
+	/* An array of raid strides this stripe is composed of. */
+	struct btrfs_raid_stride strides[];
+} __attribute__ ((__packed__));
+
 #define BTRFS_HEADER_FLAG_WRITTEN	(1ULL << 0)
 #define BTRFS_HEADER_FLAG_RELOC		(1ULL << 1)
 
-- 
2.51.0



