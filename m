Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37CB15530B;
	Wed,  5 Feb 2025 13:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763863; cv=none; b=uNwfcgfgvM3MU+B0F3F9Pl1mfG2dzaiFhwX/8kTKlgAQnQRdMcdEmCFSd08WKJ+PnGPiG20URt+vTDBa05NuZNiJkyUh2+noOqVWLYaOwRcj8EhoMd9i48JzSglLA2I1PjuolcOXGqdzqXqom22WWaDd5HPG2nqFIfkFentx0uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763863; c=relaxed/simple;
	bh=wrsKT0yUra+TEor7G0JDJjlDM/EA7ulfHnvYAN9TRDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBQackapBYVGhcl4zEwygw90LrPJTRDVfsDu/otn+CnOdD/cqSk1HXqEEh6Zpu/C6dKzc0UpuOlLH8DHLOqASwAk+dJkgzUj7UnzmnmbJthk02jHqdMCVb4B7myYE46ClguPX91G2mztVKQrsgSlRFmrvKp+ddTWkrKW2AcB40g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fbQFpjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fbQFpjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2038EC4CED1;
	Wed,  5 Feb 2025 13:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763863;
	bh=wrsKT0yUra+TEor7G0JDJjlDM/EA7ulfHnvYAN9TRDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fbQFpjBdJyODGfRXvKsoMHme+apOplaaHns1fbM4AAU70e3FpdQeu3UW8GA5YD4U
	 iVTBFXngcU1erNQI/8nUL3dIvOh5H2uaO6RfSdS7/E7NIux4+jvGZ7e28UR82737xz
	 TaT2OGEQ54HrPPSihoU5BG4hWcawzOS32/UaQfjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 025/623] btrfs: improve the warning and error message for btrfs_remove_qgroup()
Date: Wed,  5 Feb 2025 14:36:07 +0100
Message-ID: <20250205134457.191256193@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit c0def46dec9c547679a25fe7552c4bcbec0b0dd2 ]

[WARNING]
There are several warnings about the recently introduced qgroup
auto-removal that it triggers WARN_ON() for the non-zero rfer/excl
numbers, e.g:

 ------------[ cut here ]------------
 WARNING: CPU: 67 PID: 2882 at fs/btrfs/qgroup.c:1854 btrfs_remove_qgroup+0x3df/0x450
 CPU: 67 UID: 0 PID: 2882 Comm: btrfs-cleaner Kdump: loaded Not tainted 6.11.6-300.fc41.x86_64 #1
 RIP: 0010:btrfs_remove_qgroup+0x3df/0x450
 Call Trace:
  <TASK>
  btrfs_qgroup_cleanup_dropped_subvolume+0x97/0xc0
  btrfs_drop_snapshot+0x44e/0xa80
  btrfs_clean_one_deleted_snapshot+0xc3/0x110
  cleaner_kthread+0xd8/0x130
  kthread+0xd2/0x100
  ret_from_fork+0x34/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 ---[ end trace 0000000000000000 ]---
 BTRFS warning (device sda): to be deleted qgroup 0/319 has non-zero numbers, rfer 258478080 rfer_cmpr 258478080 excl 0 excl_cmpr 0

[CAUSE]
Although the root cause is still unclear, as if qgroup is consistent a
fully dropped subvolume (with extra transaction committed) should lead
to all zero numbers for the qgroup.

My current guess is the subvolume drop triggered the new subtree drop
threshold thus marked qgroup inconsistent, then rescan cleared it but
some corner case is not properly handled during subvolume dropping.

But at least for this particular case, since it's only the rfer/excl not
properly reset to 0, and qgroup is already marked inconsistent, there is
nothing to be worried for the end users.

The user space tool utilizing qgroup would queue a rescan to handle
everything, so the kernel wanring is a little overkilled.

[ENHANCEMENT]
Enhance the warning inside btrfs_remove_qgroup() by:

- Only do WARN() if CONFIG_BTRFS_DEBUG is enabled
  As explained the kernel can handle inconsistent qgroups by simply do a
  rescan, there is nothing to bother the end users.

- Treat the reserved space leak the same as non-zero numbers
  By outputting the values and trigger a WARN() if it's a debug build.
  So far I haven't experienced any case related to reserved space so I
  hope we will never need to bother them.

Fixes: 839d6ea4f86d ("btrfs: automatically remove the subvolume qgroup")
Link: https://github.com/kdave/btrfs-progs/issues/922
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f9b214992212d..993b5e803699e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1838,9 +1838,19 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 	 * Thus its reserved space should all be zero, no matter if qgroup
 	 * is consistent or the mode.
 	 */
-	WARN_ON(qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA] ||
-		qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC] ||
-		qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS]);
+	if (qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA] ||
+	    qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC] ||
+	    qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS]) {
+		WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG));
+		btrfs_warn_rl(fs_info,
+"to be deleted qgroup %u/%llu has non-zero numbers, data %llu meta prealloc %llu meta pertrans %llu",
+			      btrfs_qgroup_level(qgroup->qgroupid),
+			      btrfs_qgroup_subvolid(qgroup->qgroupid),
+			      qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA],
+			      qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC],
+			      qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS]);
+
+	}
 	/*
 	 * The same for rfer/excl numbers, but that's only if our qgroup is
 	 * consistent and if it's in regular qgroup mode.
@@ -1849,8 +1859,9 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 	 */
 	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_FULL &&
 	    !(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT)) {
-		if (WARN_ON(qgroup->rfer || qgroup->excl ||
-			    qgroup->rfer_cmpr || qgroup->excl_cmpr)) {
+		if (qgroup->rfer || qgroup->excl ||
+		    qgroup->rfer_cmpr || qgroup->excl_cmpr) {
+			WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG));
 			btrfs_warn_rl(fs_info,
 "to be deleted qgroup %u/%llu has non-zero numbers, rfer %llu rfer_cmpr %llu excl %llu excl_cmpr %llu",
 				      btrfs_qgroup_level(qgroup->qgroupid),
-- 
2.39.5



