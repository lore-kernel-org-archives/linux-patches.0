Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A81168C4;
	Mon, 27 May 2024 19:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837712; cv=none; b=iyuRx1cMoBdbs1C6GnptxLKgEcPk2FxMcwC8jHTOgktnhaKcMQJDr2yFYZqCculjXtz0FA8gTklPpwizONM9t/UO/QlB8sXRTKk3PmhkE2WuUPyaUAVBiWU+ifPqPjxskS0par7to7l4CocXclF9WMDYD+Bxdw9avdz04Bo52fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837712; c=relaxed/simple;
	bh=TUmW+e+/MzlSwlcM4dFPSGRL+1GEtvTktKxR8s0zrcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rdlwyd/9fnhpOMg/SwJwqLKfu4/eEFM1tCrC/tHLM/GLWRBYxuV6TQ9Fj6dISxCnmwbLVzu21XDX9XfgLCJBxEoWdewa9urtsPuXfa+tSS9KNdfoSD9iASd40LIJe8PdDpaE4/9pvNXSU6jZosCJ+2Fak6dt2pQMtQcby/epATo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jxklf6q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jxklf6q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD55C2BBFC;
	Mon, 27 May 2024 19:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837712;
	bh=TUmW+e+/MzlSwlcM4dFPSGRL+1GEtvTktKxR8s0zrcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jxklf6q83RZS6fzQ8/ksRig/j+Mbhg4s7mEENR7j9PvvIWYGM5bDvNX5AvJuXjFLq
	 Jztt4lQSt+XfZO/HB0LmFFFi/PN2mUOXedPcgBFeWAP1vl57c9Z2I1lL13EY0dWVB2
	 Hvwof75w0petEZpsPFEZ4O6eealtI4IWJbi2oso0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 114/493] firmware: raspberrypi: Use correct device for DMA mappings
Date: Mon, 27 May 2024 20:51:56 +0200
Message-ID: <20240527185634.253160082@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit df518a0ae1b982a4dcf2235464016c0c4576a34d ]

The buffer used to transfer data over the mailbox interface is mapped
using the client's device. This is incorrect, as the device performing
the DMA transfer is the mailbox itself. Fix it by using the mailbox
controller device instead.

This requires including the mailbox_controller.h header to dereference
the mbox_chan and mbox_controller structures. The header is not meant to
be included by clients. This could be fixed by extending the client API
with a function to access the controller's device.

Fixes: 4e3d60656a72 ("ARM: bcm2835: Add the Raspberry Pi firmware driver")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Tested-by: Ivan T. Ivanov <iivanov@suse.de>
Link: https://lore.kernel.org/r/20240326195807.15163-3-laurent.pinchart@ideasonboard.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/raspberrypi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/raspberrypi.c b/drivers/firmware/raspberrypi.c
index 322aada20f742..ac34876a97f8b 100644
--- a/drivers/firmware/raspberrypi.c
+++ b/drivers/firmware/raspberrypi.c
@@ -9,6 +9,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/kref.h>
 #include <linux/mailbox_client.h>
+#include <linux/mailbox_controller.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -97,8 +98,8 @@ int rpi_firmware_property_list(struct rpi_firmware *fw,
 	if (size & 3)
 		return -EINVAL;
 
-	buf = dma_alloc_coherent(fw->cl.dev, PAGE_ALIGN(size), &bus_addr,
-				 GFP_ATOMIC);
+	buf = dma_alloc_coherent(fw->chan->mbox->dev, PAGE_ALIGN(size),
+				 &bus_addr, GFP_ATOMIC);
 	if (!buf)
 		return -ENOMEM;
 
@@ -126,7 +127,7 @@ int rpi_firmware_property_list(struct rpi_firmware *fw,
 		ret = -EINVAL;
 	}
 
-	dma_free_coherent(fw->cl.dev, PAGE_ALIGN(size), buf, bus_addr);
+	dma_free_coherent(fw->chan->mbox->dev, PAGE_ALIGN(size), buf, bus_addr);
 
 	return ret;
 }
-- 
2.43.0



