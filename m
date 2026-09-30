Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AD240F74B;
	Wed, 30 Sep 2026 19:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795203; cv=none; b=B8oSbXCUX2+Y13sLJ472iRx0WTrBS++ZHY8oonPZYn/6D7kyLUEad2woV5pOZA+l9PO2IfbLhf9ko/d5b4j9h8rl7Xyuy1fJPiGhCBPvKjgjiWjYVlp6+gaUEqRuHmTdMqtYctBXL/tuXu9KwNj92XIGol9JsbCj2tMaFiXV4SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795203; c=relaxed/simple;
	bh=7Tjtc1PIb2yQisbj2tr6ZaCmFs6YhLsu5n8gKCIG4y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4W459REt9uOc6mGvxVLDYOr5k1YCQr3MupKAmhRPYDj8ELZ6A/nhHNaMvmj2GH7A53pBO0bLlTdFcT8Qr+Uu97KYtsJHGlZfCt+zZeclIxwR/+x87SyjGQeCl7zdrF4/Ta+VmryyaYryOpV57YBUMV0eGLQy7hxoRjRvv0jG4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0d8ZlaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0d8ZlaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0081F000FF;
	Wed, 30 Sep 2026 19:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795202;
	bh=JbQr7ka/AJj79cpfFw0EdTeIcVWT0Keq5cA+/ea0Afs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0d8ZlaZOwuUSOVzKzOJH+1MQ3bI10nd2ojOVY56KSG9wacoLvx7uOs7zt23m/DSh
	 fi6Ph00z3QUMgzvSTJF4H0mPcfRZnY6QlVhBX8NVA4fptoepRkPWDGiNLN6hTXv5/w
	 dWnDq2dJHQQSF4YF5PAWcvhD+ss9BevHsAUPQRAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0480/1193] nvme_core: scan namespaces asynchronously
Date: Wed, 30 Sep 2026 17:19:24 +0200
Message-ID: <20260930152444.822852335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Stuart Hayes <stuart.w.hayes@gmail.com>

[ Upstream commit 4e893ca8117022de68ce1b61c0309e3d17bb8a25 ]

Use async function calls to make namespace scanning happen in parallel.

Without the patch, NVME namespaces are scanned serially, so it can take
a long time for all of a controller's namespaces to become available,
especially with a slower (TCP) interface with large number of
namespaces.

It is not uncommon to have large numbers (hundreds or thousands) of
namespaces on nvme-of with storage servers.

The time it took for all namespaces to show up after connecting (via
TCP) to a controller with 1002 namespaces was measured on one system:

network latency   without patch   with patch
     0                 6s            1s
    50ms             210s           10s
   100ms             417s           18s

Measurements taken on another system show the effect of the patch on the
time nvme_scan_work() took to complete, when connecting to a linux
nvme-of target with varying numbers of namespaces, on a network of
400us.

namespaces    without patch   with patch
     1            16ms           14ms
     2            24ms           16ms
     4            49ms           22ms
     8           101ms           33ms
    16           207ms           56ms
   100           1.4s           0.6s
  1000          12.9s           2.0s

On the same system, connecting to a local PCIe NVMe drive (a Samsung
PM1733) instead of a network target:

namespaces    without patch   with patch
     1            13ms           12ms
     2            41ms           13ms

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Stable-dep-of: 4ed7f3d7d435 ("nvme: remove stale namespaces by NSID range during scan")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d02ca033db439..a8f0329393b00 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2011-2014, Intel Corporation.
  */
 
+#include <linux/async.h>
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
 #include <linux/blk-integrity.h>
@@ -3829,6 +3830,35 @@ static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	}
 }
 
+/**
+ * struct async_scan_info - keeps track of controller & NSIDs to scan
+ * @ctrl:	Controller on which namespaces are being scanned
+ * @next_nsid:	Index of next NSID to scan in ns_list
+ * @ns_list:	Pointer to list of NSIDs to scan
+ *
+ * Note: There is a single async_scan_info structure shared by all instances
+ * of nvme_scan_ns_async() scanning a given controller, so the atomic
+ * operations on next_nsid are critical to ensure each instance scans a unique
+ * NSID.
+ */
+struct async_scan_info {
+	struct nvme_ctrl *ctrl;
+	atomic_t next_nsid;
+	__le32 *ns_list;
+};
+
+static void nvme_scan_ns_async(void *data, async_cookie_t cookie)
+{
+	struct async_scan_info *scan_info = data;
+	int idx;
+	u32 nsid;
+
+	idx = (u32)atomic_fetch_inc(&scan_info->next_nsid);
+	nsid = le32_to_cpu(scan_info->ns_list[idx]);
+
+	nvme_scan_ns(scan_info->ctrl, nsid);
+}
+
 static void nvme_remove_invalid_namespaces(struct nvme_ctrl *ctrl,
 					unsigned nsid)
 {
@@ -3855,11 +3885,15 @@ static int nvme_scan_ns_list(struct nvme_ctrl *ctrl)
 	__le32 *ns_list;
 	u32 prev = 0;
 	int ret = 0, i;
+	ASYNC_DOMAIN(domain);
+	struct async_scan_info scan_info;
 
 	ns_list = kzalloc(NVME_IDENTIFY_DATA_SIZE, GFP_KERNEL);
 	if (!ns_list)
 		return -ENOMEM;
 
+	scan_info.ctrl = ctrl;
+	scan_info.ns_list = ns_list;
 	for (;;) {
 		struct nvme_command cmd = {
 			.identify.opcode	= nvme_admin_identify,
@@ -3875,19 +3909,23 @@ static int nvme_scan_ns_list(struct nvme_ctrl *ctrl)
 			goto free;
 		}
 
+		atomic_set(&scan_info.next_nsid, 0);
 		for (i = 0; i < nr_entries; i++) {
 			u32 nsid = le32_to_cpu(ns_list[i]);
 
 			if (!nsid)	/* end of the list? */
 				goto out;
-			nvme_scan_ns(ctrl, nsid);
+			async_schedule_domain(nvme_scan_ns_async, &scan_info,
+						&domain);
 			while (++prev < nsid)
 				nvme_ns_remove_by_nsid(ctrl, prev);
 		}
+		async_synchronize_full_domain(&domain);
 	}
  out:
 	nvme_remove_invalid_namespaces(ctrl, prev);
  free:
+	async_synchronize_full_domain(&domain);
 	kfree(ns_list);
 	return ret;
 }
-- 
2.53.0



