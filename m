Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79C015E5BB;
	Sat, 17 Oct 2026 18:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260836; cv=none; b=NPBbiC1i6br9rK9VfgneQEaDmFQxacSjoy6EOfGDerYHZq1Wv4h6sE5Pfwxd4wEATM3yf9/fkQ3qrSy4fQ8U7GovIFpdJwuNn6Q2jxFnR3UHlcL9i6KyzSbwSu+4auTbNMpP1VclCHEBUzDUwXa6DvAuzFkyvrHlWf53P36ZjcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260836; c=relaxed/simple;
	bh=+c1wb54t2tRF1EomA42vhC4Nk3y9CF+04aHIV2IWRAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYsSdTc/XXO5tujbHKVqMfLoUMBnh+OEso+FOczvTe8slXuL0yknGzuf3x0+kJ8XUYLOO3w0jQjwYaOs8/cE1cFMQcLTkrsKa6CxPfy+Gdm818DEFFrUyRVDnreUFybQPCBS/26/lC8ewDmaRGM3x7MenGjRAYIluSHCPD0o9n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siguK/zX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siguK/zX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37041F000C4;
	Sat, 17 Oct 2026 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260835;
	bh=yMAL8+TssBX8/YNVSiTBPf3qGeWlCN/WMkyhWJ3gChQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=siguK/zX2PlUVVz+bpb82Wy+3ZiAh6TiDUkw/SxcTarhr3uUxmt+1zfCeBR7NzF9/
	 nhsNMvSPeuFRlySyQZqW/JjEbbhP2Ky3w/EpWaDeAJdi1y1//qqoHk5jC8gPvzO0lX
	 FUHmgswL9TTlSJViQJ1P2IdaQYVUNDmEq4/NpHsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1636/1674] nvme_core: scan namespaces asynchronously
Date: Sat, 17 Oct 2026 18:05:08 +0200
Message-ID: <20261017160513.073321004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index c34ecb2c96562..c8c62523653db 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2011-2014, Intel Corporation.
  */
 
+#include <linux/async.h>
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
 #include <linux/blk-integrity.h>
@@ -3832,6 +3833,35 @@ static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
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
@@ -3858,11 +3888,15 @@ static int nvme_scan_ns_list(struct nvme_ctrl *ctrl)
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
@@ -3878,19 +3912,23 @@ static int nvme_scan_ns_list(struct nvme_ctrl *ctrl)
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



