Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC79F1078F;
	Mon, 27 May 2024 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836490; cv=none; b=iwduFrYPb6E/w0Dc3BfyNACMf8sFo5PEiVw8EhvTc0hMdCT445g1adLg+1/FYomFqfRD334P/heyc/UdMXUl57nAjDOmzFgrFlfNR8kkgG2K787hRC2IvrdkrnGQsHyluG8BcqpL0b8hgtoDSEOOwSnymIGZE3eVPH6BgthGe5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836490; c=relaxed/simple;
	bh=4DltXQC+ZAfHzXvaMW9k7iBWyNARxvCFCkGdBI143qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vn9IySTRMwEZm++1syw706vAnzuZRukQZ/1CgGPC6CUlZYH7nQh2rB8h0Y3f0KnH9ZsznDdS5FqOPVye/ti3BIt6dC1GsxIOb2F0YPK5zdxZ0rAk4wbF78TLK8WtgzwiXvozi+NOjuf3cTKw9OUJZfv9MzN2k8XHhOtA5ijxVGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+KIV9FP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+KIV9FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D93CC2BBFC;
	Mon, 27 May 2024 19:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836490;
	bh=4DltXQC+ZAfHzXvaMW9k7iBWyNARxvCFCkGdBI143qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+KIV9FPrnGKZUgoV4DFAd8qKGjWYgQOULpifI3SYmr2NEw3EBIpgcSsdwftFS/Jn
	 FDSIc+FX3gS3tLDF3VQsa164R542/c19HDFG4UpZobp26gIExKIpygm24LprpzXo1t
	 EEHqTrPDeW38MZ28dtNrL9Sjh0xBnibYbfSeR0x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 047/427] firmware: raspberrypi: Use correct device for DMA mappings
Date: Mon, 27 May 2024 20:51:34 +0200
Message-ID: <20240527185606.138712011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



