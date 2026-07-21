Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553E846EC8F;
	Tue, 21 Jul 2026 17:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656340; cv=none; b=rYENG1TKMQEhENQRy3oEV4rnvD/iiHyViuv3cr9BgQYgT4OqvBigtd9VWTKpTiloWa92jMI2MWvqFBmjetClTDT7xMzZlB6rytTM23YeCjaTR44yhYU+OGWa1JXHN1kSwIFrLUcpr32DzRrPu0dR7tYhwoNCpwhYTsewrGI1jQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656340; c=relaxed/simple;
	bh=rsIJO9UQWkREE3FOGEy3VH6QfIYLfqzjxoQOSrFpeAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7VXF+A0GTFTQqYs8tkVvEhACBkggk7sOhgKV4YXCUnY4fmpoMdAxeYQOiz360Fi4DmMW/LMbKUYotv7OSCYpNrSd4gcMlw3BjHjEPSx1rHknnuaYRF6RzPoMZ7d4JsPFx54lRaaT/nW0L4YSLh+nDvVgA+ULQSgq5K5wYyZPx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFBH9EOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFBH9EOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB9F1F000E9;
	Tue, 21 Jul 2026 17:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656339;
	bh=RLLvveSI6OtrfmCVUng8morODRB/Mvn1fReaz18kDdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFBH9EOD1muxmO/KIksLph6ydz012AdRZkMsNSBP0ZQ7Z7vOPAz8+JVR3z2+qTw9w
	 TxjEG+2Ngcye5MHka+Lmfh/oi2IgW98vENouY8w/SVRP8UV0tmBwQASIhlFB3zEpnL
	 2X/8Ciy9XesHL9VbA2D16Op6Ld9USh5mceVjGuJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0350/1611] RDMA/hfi1: Open-code rvt_set_ibdev_name()
Date: Tue, 21 Jul 2026 17:07:46 +0200
Message-ID: <20260721152523.006644209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0ee8ac903e5aa100a70bef8d0afc19a336ffa775 ]

clang warns about a function missing a printf attribute:

include/rdma/rdma_vt.h:457:47: error: diagnostic behavior may be improved by adding the 'format(printf, 2, 3)' attribute to the declaration of 'rvt_set_ibdev_name' [-Werror,-Wmissing-format-attribute]
  447 | static inline void rvt_set_ibdev_name(struct rvt_dev_info *rdi,
      | __attribute__((format(printf, 2, 3)))
  448 |                                       const char *fmt, const char *name,
  449 |                                       const int unit)

The helper was originally added as an abstraction for the hfi1 and
qib drivers needing the same thing, but now qib is gone, and hfi1
is the only remaining user of rdma_vt.

Avoid the warning and allow the compiler to check the format string by
open-coding the helper and directly assigning the device name.

Fixes: 5084c8ff21f2 ("IB/{rdmavt, hfi1, qib}: Self determine driver name")
Link: https://patch.msgid.link/r/20260602140453.3542427-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 13 ++++++++++++-
 include/rdma/rdma_vt.h            | 20 --------------------
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index b35f92e7d865f0..7e0298c62882e0 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1208,6 +1208,7 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 					       size_t extra)
 {
 	struct hfi1_devdata *dd;
+	struct ib_device *ibdev;
 	int ret, nports;
 
 	/* extra is * number of ports */
@@ -1229,7 +1230,17 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 			"Could not allocate unit ID: error %d\n", -ret);
 		goto bail;
 	}
-	rvt_set_ibdev_name(&dd->verbs_dev.rdi, "%s_%d", class_name(), dd->unit);
+
+	/*
+	 * FIXME: rvt and its users want to touch the ibdev before
+	 * registration and have things like the name work. We don't have the
+	 * infrastructure in the core to support this directly today, hack it
+	 * to work by setting the name manually here.
+	 */
+	ibdev = &dd->verbs_dev.rdi.ibdev;
+	dev_set_name(&ibdev->dev, "%s_%d", class_name(), dd->unit);
+	strscpy(ibdev->name, dev_name(&ibdev->dev), IB_DEVICE_NAME_MAX);
+
 	/*
 	 * If the BIOS does not have the NUMA node information set, select
 	 * NUMA 0 so we get consistent performance.
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index c429d6ddb1292e..d69df6ebc80a74 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -428,26 +428,6 @@ struct rvt_dev_info {
 	struct rvt_wss *wss;
 };
 
-/**
- * rvt_set_ibdev_name - Craft an IB device name from client info
- * @rdi: pointer to the client rvt_dev_info structure
- * @name: client specific name
- * @unit: client specific unit number.
- */
-static inline void rvt_set_ibdev_name(struct rvt_dev_info *rdi,
-				      const char *fmt, const char *name,
-				      const int unit)
-{
-	/*
-	 * FIXME: rvt and its users want to touch the ibdev before
-	 * registration and have things like the name work. We don't have the
-	 * infrastructure in the core to support this directly today, hack it
-	 * to work by setting the name manually here.
-	 */
-	dev_set_name(&rdi->ibdev.dev, fmt, name, unit);
-	strscpy(rdi->ibdev.name, dev_name(&rdi->ibdev.dev), IB_DEVICE_NAME_MAX);
-}
-
 /**
  * rvt_get_ibdev_name - return the IB name
  * @rdi: rdmavt device
-- 
2.53.0



