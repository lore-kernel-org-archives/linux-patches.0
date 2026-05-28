Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11A71EA65;
	Thu, 28 May 2026 20:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000102; cv=none; b=tSh62SjVMFUTA6QMX0HFmEBU+UiY/8TWWdQdB9gfut/wbii9ibRy0cNuR03oAYYXMBBKei5EDFC/pxaYe04TGbef2eGqH4D/VvSyrzpwWysk+Jh3ayV8g4p0t7Jj9D5I08fMBEGGlSFsm+3HIdjuTZjoaKuxEmZL2Hx0ajz8kUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000102; c=relaxed/simple;
	bh=l5yct5Bpc4KYA1qiQG5rfkmW2+enr9pffCn6ug3WrLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLmxn/wKSVH1C7+roMFCC5Jcb5lXZE8Rc/tHOCMoR6yjL+65is2/BM4BYFZA31K4A4xINrz2IXb3Kl3f+Stb3/gJ1/kHWb9EfrYl+ES70qK7Mo2qX6peNRrdx6tyIVR8BMooXS0JLXExLYoVZ+/K//K6ciNzQDmzDKz3Vc1SQ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEF4cuTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEF4cuTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA001F000E9;
	Thu, 28 May 2026 20:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000101;
	bh=OUXwBz/8qTeNqaS2i+oTokRSfwBR5mEF4owsIvVPXCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OEF4cuTWbf6sj7HjF5a0xSsuk2QDhLdNrStTlravuMixFHL7cZx4PKOl+Q+t1oWra
	 KF58/wLIePOQ6qEaQh9hjCdgIlVJDY1ZPic7JB1rQF8BPeUyU2yT5LjTFRUHh/S5qo
	 GyPB8kXoIEBbn34nqIAtJPz8kSx8pb27Jl9yo/7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/377] btrfs: relax squota parent qgroup deletion rule
Date: Thu, 28 May 2026 21:49:00 +0200
Message-ID: <20260528194647.103671133@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit adb0af40fe89fd42f1ef277bf60d9cfa7c2ae472 ]

Currently, with squotas, we do not allow removing a parent qgroup with
no members if it still has usage accounted to it. This makes it really
difficult to recover from accounting bugs, as we have no good way of
getting back to 0 usage.

Instead, allow deletion (it's safe at 0 members..) while still warning
about the inconsistency by adding a squota parent check.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 1e92637722ae ("btrfs: check for subvolume before deleting squota qgroup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 50 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index db1df67bccf38..c7bc2065bcd68 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1723,6 +1723,36 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 	return ret;
 }
 
+static bool can_delete_parent_qgroup(struct btrfs_qgroup *qgroup)
+
+{
+	ASSERT(btrfs_qgroup_level(qgroup->qgroupid));
+	return list_empty(&qgroup->members);
+}
+
+/*
+ * Return true if we can delete the squota qgroup and false otherwise.
+ *
+ * Rules for whether we can delete:
+ *
+ * A subvolume qgroup can be removed iff the subvolume is fully deleted, which
+ * is iff there is 0 usage in the qgroup.
+ *
+ * A higher level qgroup can be removed iff it has no members.
+ * Note: We audit its usage to warn on inconsitencies without blocking deletion.
+ */
+static bool can_delete_squota_qgroup(struct btrfs_fs_info *fs_info, struct btrfs_qgroup *qgroup)
+{
+	ASSERT(btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE);
+
+	if (btrfs_qgroup_level(qgroup->qgroupid) > 0) {
+		squota_check_parent_usage(fs_info, qgroup);
+		return can_delete_parent_qgroup(qgroup);
+	}
+
+	return !(qgroup->rfer || qgroup->excl || qgroup->rfer_cmpr || qgroup->excl_cmpr);
+}
+
 /*
  * Return 0 if we can not delete the qgroup (not empty or has children etc).
  * Return >0 if we can delete the qgroup.
@@ -1733,23 +1763,13 @@ static int can_delete_qgroup(struct btrfs_fs_info *fs_info, struct btrfs_qgroup
 	struct btrfs_key key;
 	BTRFS_PATH_AUTO_FREE(path);
 
-	/*
-	 * Squota would never be inconsistent, but there can still be case
-	 * where a dropped subvolume still has qgroup numbers, and squota
-	 * relies on such qgroup for future accounting.
-	 *
-	 * So for squota, do not allow dropping any non-zero qgroup.
-	 */
-	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE &&
-	    (qgroup->rfer || qgroup->excl || qgroup->excl_cmpr || qgroup->rfer_cmpr))
-		return 0;
+	/* Since squotas cannot be inconsistent, they have special rules for deletion. */
+	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
+		return can_delete_squota_qgroup(fs_info, qgroup);
 
 	/* For higher level qgroup, we can only delete it if it has no child. */
-	if (btrfs_qgroup_level(qgroup->qgroupid)) {
-		if (!list_empty(&qgroup->members))
-			return 0;
-		return 1;
-	}
+	if (btrfs_qgroup_level(qgroup->qgroupid))
+		return can_delete_parent_qgroup(qgroup);
 
 	/*
 	 * For level-0 qgroups, we can only delete it if it has no subvolume
-- 
2.53.0



