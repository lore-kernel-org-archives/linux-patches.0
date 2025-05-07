Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9992F214813;
	Wed,  7 May 2025 19:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645211; cv=none; b=W8WIZ2Kt/U2OikWroq4oGhahhPqhNHy0YJ+0JogaUq5pBOJraH6UKidSjzyKhzeXSejTcxQ1Jb/MUrIggpu+xOTIlWsr5rRXWZ1tsJfMqYIGbL/dNnoZNIJblrOQTshbmf6O55tyXPUor3ADC53ECLxGT1Qrw/RN7M1qoQtehJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645211; c=relaxed/simple;
	bh=IRlO3JacgFUJsIq5z3VALqTyt0ZtOIVSblnpYOJFaRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ob0haarUgzoXRBTgACuGqWfsoEsRiLaX09CkebOO4oDZkFxXSbCQmR2bxIuZOAlr3mQ7ElSZhyHm8/T3GWgX4WumTp/oTzM/UbTGmj0Azo6Nq53CGVdlz96Zu+sb11jYLHs4u3FE2ER/2CTic442edy97IJ1Pvf7/07CTNWIfEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpbqY2FI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpbqY2FI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07656C4CEEB;
	Wed,  7 May 2025 19:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645211;
	bh=IRlO3JacgFUJsIq5z3VALqTyt0ZtOIVSblnpYOJFaRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpbqY2FIS+xG6EKAZ78kv7nmldM5aX8pv6EunUyuuaepnPRHHtWeUfFXeTA2iJJzM
	 a7Ky2Nkr7X17e5Yq5/7UaNvJ16aoGjQiOvjqBSHFPxoNu8RGiDoPI9y2tc3gbx1hts
	 XZz0raOXmiXYRuICI6m0QIAXU/pf6r9pHyal9x/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/129] xhci: support setting interrupt moderation IMOD for secondary interrupters
Date: Wed,  7 May 2025 20:40:53 +0200
Message-ID: <20250507183818.330509540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 9c0c11bb87b09a8b7cdc21ca1090e7b36abe9d09 ]

Allow creators of seconday interrupters to specify the interrupt
moderation interval value in nanoseconds when creating the interrupter.

If not sure what value to use then use the xhci driver default
xhci->imod_interval

Suggested-by: Wesley Cheng <quic_wcheng@quicinc.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240905143300.1959279-13-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bea5892d0ed2 ("xhci: Limit time spent with xHC interrupts disabled during bus resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 8 +++++++-
 drivers/usb/host/xhci.c     | 4 ++--
 drivers/usb/host/xhci.h     | 5 ++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 489f54cf9a8a2..2c44855be75ed 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2353,7 +2353,8 @@ xhci_add_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir,
 }
 
 struct xhci_interrupter *
-xhci_create_secondary_interrupter(struct usb_hcd *hcd, unsigned int segs)
+xhci_create_secondary_interrupter(struct usb_hcd *hcd, unsigned int segs,
+				  u32 imod_interval)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_interrupter *ir;
@@ -2386,6 +2387,11 @@ xhci_create_secondary_interrupter(struct usb_hcd *hcd, unsigned int segs)
 		return NULL;
 	}
 
+	err = xhci_set_interrupter_moderation(ir, imod_interval);
+	if (err)
+		xhci_warn(xhci, "Failed to set interrupter %d moderation to %uns\n",
+			  i, imod_interval);
+
 	xhci_dbg(xhci, "Add secondary interrupter %d, max interrupters %d\n",
 		 i, xhci->max_interrupters);
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index d6a0c79e5fada..0af298c5af65a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -324,8 +324,8 @@ static int xhci_disable_interrupter(struct xhci_interrupter *ir)
 }
 
 /* interrupt moderation interval imod_interval in nanoseconds */
-static int xhci_set_interrupter_moderation(struct xhci_interrupter *ir,
-					   u32 imod_interval)
+int xhci_set_interrupter_moderation(struct xhci_interrupter *ir,
+				    u32 imod_interval)
 {
 	u32 imod;
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 156e43977cdd4..9d05a21392bb8 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1867,7 +1867,8 @@ struct xhci_container_ctx *xhci_alloc_container_ctx(struct xhci_hcd *xhci,
 void xhci_free_container_ctx(struct xhci_hcd *xhci,
 		struct xhci_container_ctx *ctx);
 struct xhci_interrupter *
-xhci_create_secondary_interrupter(struct usb_hcd *hcd, unsigned int segs);
+xhci_create_secondary_interrupter(struct usb_hcd *hcd, unsigned int segs,
+				  u32 imod_interval);
 void xhci_remove_secondary_interrupter(struct usb_hcd
 				       *hcd, struct xhci_interrupter *ir);
 
@@ -1905,6 +1906,8 @@ int xhci_alloc_tt_info(struct xhci_hcd *xhci,
 		struct xhci_virt_device *virt_dev,
 		struct usb_device *hdev,
 		struct usb_tt *tt, gfp_t mem_flags);
+int xhci_set_interrupter_moderation(struct xhci_interrupter *ir,
+				    u32 imod_interval);
 
 /* xHCI ring, segment, TRB, and TD functions */
 dma_addr_t xhci_trb_virt_to_dma(struct xhci_segment *seg, union xhci_trb *trb);
-- 
2.39.5



