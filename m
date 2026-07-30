Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECDF3B52EE;
	Thu, 30 Jul 2026 14:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422678; cv=none; b=LYFgvXrY+cJ2Vg9B2MxhVw9t0I186j/FIzGjlGSZ1PX9xRQgpwQ3t/N+aeLCTAR1lE23fgQUyogYsj37NOmttNXYwLkrT+3MPgelpkZRBA+hb0+KNFzSPdCLt1yHR68jwF70gGiYEsgdqqg1YW9vDAVV0X14LccN64QZ+ndVALg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422678; c=relaxed/simple;
	bh=u4x/jlb0YHnqGw7sYXtWPWjeCI78RAQD7+Z86J1WAb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etkCjayTFxu1ezprDyivxR8O9LVPuDLOjtkbz5CUa+Sc9G/5dDcvxP4Jf6OZ9h9vaQ4cO8WnX++XATuTPHmDrPYIE5ZsrnJqZHn4A0RlzcNd5zRRUFRP5y1rVJdmBzwP1Pq2ROjq5mVdzbxTOe+D+wrvy78YxTx8xaewTqBz5Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVBHthBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVBHthBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67E51F000E9;
	Thu, 30 Jul 2026 14:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422677;
	bh=BKS3vdpitxJeKFxBecLgyOVpFUNhUuVKhTtR01CryJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVBHthBVS3Enfr9DxR+eyLsadOD9NpwYu2ajmTdPOphnd9JTRywSGbLAgS2kvLD5r
	 0RWIVbmhvIPrW5Qchcpbl9k6IrkLmSAIGVc0upEQb61iJm8d0bzMbbdcmLX6+9REVG
	 4wtj7irRaOT8wUQEJa2ZiLx3WbUqqWQZ1Skw35sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 521/744] media: ti: vpe: Fix fwnode_handle leak in vip_probe_complete()
Date: Thu, 30 Jul 2026 16:13:14 +0200
Message-ID: <20260730141455.348904593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 34ca1065a4b2cf776c28d7cece6f6c9d90f7e3a3 upstream.

In vip_probe_complete(), the fwnode_handle reference is not released
if the loop continues via the default switch case or if alloc_port()
fails. This results in a reference count leak.

Switch to using the __free(fwnode_handle) cleanup attribute to ensure
the reference is automatically released when the handle goes out of
scope.

Fixes: fc2873aa4a21 ("media: ti: vpe: Add the VIP driver")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/vpe/vip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/ti/vpe/vip.c b/drivers/media/platform/ti/vpe/vip.c
index 0e91e87bda9b..a3c5e966f64c 100644
--- a/drivers/media/platform/ti/vpe/vip.c
+++ b/drivers/media/platform/ti/vpe/vip.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/cleanup.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
@@ -3389,7 +3390,6 @@ static int vip_probe_complete(struct platform_device *pdev)
 	struct vip_port *port;
 	struct vip_dev *dev;
 	struct device_node *parent = pdev->dev.of_node;
-	struct fwnode_handle *ep = NULL;
 	unsigned int syscon_args[5];
 	int ret, i, slice_id, port_id, p;
 
@@ -3411,8 +3411,9 @@ static int vip_probe_complete(struct platform_device *pdev)
 		ctrl->syscon_bit_field[i] = syscon_args[i + 1];
 
 	for (p = 0; p < (VIP_NUM_PORTS * VIP_NUM_SLICES); p++) {
-		ep = fwnode_graph_get_next_endpoint_by_regs(of_fwnode_handle(parent),
-							    p, 0);
+		struct fwnode_handle *ep __free(fwnode_handle) =
+			fwnode_graph_get_next_endpoint_by_regs(
+				of_fwnode_handle(parent), p, 0);
 		if (!ep)
 			continue;
 
@@ -3447,7 +3448,6 @@ static int vip_probe_complete(struct platform_device *pdev)
 		port = dev->ports[port_id];
 
 		vip_register_subdev_notify(port, ep);
-		fwnode_handle_put(ep);
 	}
 	return 0;
 }
-- 
2.55.0



