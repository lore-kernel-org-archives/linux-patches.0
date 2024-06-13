Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCA213C691;
	Thu, 13 Jun 2024 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281739; cv=none; b=vAS3mF3RDEidtxeAb1T0RlqyImU9eE2wPhiKxljkbS9d02VuDl6qCh3cYc43NvJSBqvEkKF1a7jNdc3ebI1AmWeXkSS0/4DuMgms6y0+CjJLxAi0Fvr52R2FyFu1tG8jpQ8bzUodyZR5q8/j5VPzfDa2uIaD7Yu03j6l6leCZHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281739; c=relaxed/simple;
	bh=01dlqzvgHfhXkI058ktidj9ymorZ+VfeORPujujPaY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeTWdYKqsmTAVdj0NCAbnIr0oQ6eHKUcP3Ao+1QfdozUUaYyyWpvfvx6FRShECtSKpWBgucYfEOLZct5YfDR7Ywjs0esQkscmTbldLXGCAaa3wP7iqLeQ+a8POvhT8pIyn9GMjatAxHUUwAz76hl7+69zftYTueom9BsAZWJhqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whk29x51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whk29x51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61B3C2BBFC;
	Thu, 13 Jun 2024 12:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281739;
	bh=01dlqzvgHfhXkI058ktidj9ymorZ+VfeORPujujPaY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whk29x51yM5sOLDq527pNCD/PFPsEvcqIhbEXJ3ENkOV8HwsLK8aX95wr7tegy0i3
	 v81CQlwYNWzGqwbC6bZKwktkVXY2Spy6TKhoXjXrBt8mmB2cwFzZdMjf2OHDE85IgK
	 Qh1F2WF3ylXPYhNF6SuCV59rppDB+BFftoO2l6Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/402] firmware: raspberrypi: Use correct device for DMA mappings
Date: Thu, 13 Jun 2024 13:29:56 +0200
Message-ID: <20240613113303.662702312@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dba315f675bc7..ec223976c972d 100644
--- a/drivers/firmware/raspberrypi.c
+++ b/drivers/firmware/raspberrypi.c
@@ -9,6 +9,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/kref.h>
 #include <linux/mailbox_client.h>
+#include <linux/mailbox_controller.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
@@ -96,8 +97,8 @@ int rpi_firmware_property_list(struct rpi_firmware *fw,
 	if (size & 3)
 		return -EINVAL;
 
-	buf = dma_alloc_coherent(fw->cl.dev, PAGE_ALIGN(size), &bus_addr,
-				 GFP_ATOMIC);
+	buf = dma_alloc_coherent(fw->chan->mbox->dev, PAGE_ALIGN(size),
+				 &bus_addr, GFP_ATOMIC);
 	if (!buf)
 		return -ENOMEM;
 
@@ -125,7 +126,7 @@ int rpi_firmware_property_list(struct rpi_firmware *fw,
 		ret = -EINVAL;
 	}
 
-	dma_free_coherent(fw->cl.dev, PAGE_ALIGN(size), buf, bus_addr);
+	dma_free_coherent(fw->chan->mbox->dev, PAGE_ALIGN(size), buf, bus_addr);
 
 	return ret;
 }
-- 
2.43.0



