Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF19207658;
	Fri,  6 Dec 2024 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498382; cv=none; b=cd+fOieaov8nBxO1BpioOIXWkYQSLNp6zgX2/P1XrgXYXYU48bSIVb2WCX6Z7MjHvn7pOFS3ec5lKbGmeDh2mclerSKGsYwyBdsUBUYszTQg4/Zrm4vTzPJX3oRglJK34TGr8xMbWVT8nZ6E+tLn6Fx2ItXMIPY5f8FeyzjNcpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498382; c=relaxed/simple;
	bh=On4X2aVokC9al2INLloeJBrPMl11hDj/Ee8kCRqmJr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Di+/vQ9onditXGvBUd6JkG2o3+yiZ23UDaPcFdGH00MBNhSs3j7Ma95YEMFVt5rd9pDWEPxbVsmwBFRSmo90yXg2QickPMCS5t2e4fAJN4Amg0oIuzZvBIjtRgUgAookinia+/wkAGnkWM5vl1w9iyKYglahAmFmta8jcRF1AGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXG+XSq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXG+XSq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77864C4CEDE;
	Fri,  6 Dec 2024 15:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498382;
	bh=On4X2aVokC9al2INLloeJBrPMl11hDj/Ee8kCRqmJr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXG+XSq0BeWuK34AxU61S5wH/OAEJp4LZ5QNIrF4q+ZI+EniT5rvFhFANP7AqWB+M
	 YJ1+XtjgSg9WcD0ZL17hallpOA68Kp+mfwcht3wiJkZM2s4dornW797vkSctbDPukG
	 nKeRDYGTdb9szly+e+lN6kWXcFrmwqPW5jpq0t8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 569/676] nvme-multipath: avoid hang on inaccessible namespaces
Date: Fri,  6 Dec 2024 15:36:28 +0100
Message-ID: <20241206143715.586758691@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 3b97f5a05cfc55e7729ff3769f63eef64e2178bb ]

During repetitive namespace remapping operations on the target the
namespace might have changed between the time the initial scan
was performed, and partition scan was invoked by device_add_disk()
in nvme_mpath_set_live(). We then end up with a stuck scanning process:

[<0>] folio_wait_bit_common+0x12a/0x310
[<0>] filemap_read_folio+0x97/0xd0
[<0>] do_read_cache_folio+0x108/0x390
[<0>] read_part_sector+0x31/0xa0
[<0>] read_lba+0xc5/0x160
[<0>] efi_partition+0xd9/0x8f0
[<0>] bdev_disk_changed+0x23d/0x6d0
[<0>] blkdev_get_whole+0x78/0xc0
[<0>] bdev_open+0x2c6/0x3b0
[<0>] bdev_file_open_by_dev+0xcb/0x120
[<0>] disk_scan_partitions+0x5d/0x100
[<0>] device_add_disk+0x402/0x420
[<0>] nvme_mpath_set_live+0x4f/0x1f0 [nvme_core]
[<0>] nvme_mpath_add_disk+0x107/0x120 [nvme_core]
[<0>] nvme_alloc_ns+0xac6/0xe60 [nvme_core]
[<0>] nvme_scan_ns+0x2dd/0x3e0 [nvme_core]
[<0>] nvme_scan_work+0x1a3/0x490 [nvme_core]

This happens when we have several paths, some of which are inaccessible,
and the active paths are removed first. Then nvme_find_path() will requeue
I/O in the ns_head (as paths are present), but the requeue list is never
triggered as all remaining paths are inactive.

This patch checks for NVME_NSHEAD_DISK_LIVE in nvme_available_path(),
and requeue I/O after NVME_NSHEAD_DISK_LIVE has been cleared once
the last path has been removed to properly terminate pending I/O.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 5dd18f09ce73 ("nvme/multipath: Fix RCU list traversal to use SRCU primitive")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 2fa137738ac8d..989d1e50fb8cc 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -420,6 +420,9 @@ static bool nvme_available_path(struct nvme_ns_head *head)
 {
 	struct nvme_ns *ns;
 
+	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags))
+		return NULL;
+
 	list_for_each_entry_rcu(ns, &head->list, siblings) {
 		if (test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ns->ctrl->flags))
 			continue;
@@ -996,8 +999,7 @@ void nvme_mpath_shutdown_disk(struct nvme_ns_head *head)
 {
 	if (!head->disk)
 		return;
-	kblockd_schedule_work(&head->requeue_work);
-	if (test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
+	if (test_and_clear_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
 		nvme_cdev_del(&head->cdev, &head->cdev_device);
 		/*
 		 * requeue I/O after NVME_NSHEAD_DISK_LIVE has been cleared
@@ -1007,6 +1009,12 @@ void nvme_mpath_shutdown_disk(struct nvme_ns_head *head)
 		kblockd_schedule_work(&head->requeue_work);
 		del_gendisk(head->disk);
 	}
+	/*
+	 * requeue I/O after NVME_NSHEAD_DISK_LIVE has been cleared
+	 * to allow multipath to fail all I/O.
+	 */
+	synchronize_srcu(&head->srcu);
+	kblockd_schedule_work(&head->requeue_work);
 }
 
 void nvme_mpath_remove_disk(struct nvme_ns_head *head)
-- 
2.43.0



