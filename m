Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ACA611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24D2C433EF;
	Sun, 28 May 2023 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301608;
	bh=m4zUMVlH4RXNs7q92jH+FeVRWqcFbZNC6ftQdLogTH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOWN7c4xUJ696wqQt0Xm2PkX87Ed9OMizvCFtt+6BmYcI4W7kiEzf/hyXs9vQWlrY
	 MmUsOZZWV5K9163hQx1pnTljVgyphoii3DLeIlHQ4zdoXCtBFp+okx0XngXHUjnHaH
	 p1FTwIKFNLB+Kb9plX2jU/Bz2ZkF65BlMGRglCI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/132] usb: gadget: u_ether: Convert prints to device prints
Date: Sun, 28 May 2023 20:10:36 +0100
Message-Id: <20230528190836.619417713@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 938fc645317632d79c048608689683b5437496ea ]

The USB ethernet gadget driver implements its own print macros which
call printk. Device drivers should use the device prints that print the
device name. Fortunately, the same macro names are defined in the header
file 'linux/usb/composite.h' and these use the device prints. Therefore,
remove the local definitions in the USB ethernet gadget driver and use
those in 'linux/usb/composite.h'. The only difference is that now the
device name is printed instead of the ethernet interface name.

Tested using ethernet gadget on Jetson AGX Orin.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20230209125319.18589-1-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3c0f4f09c063 ("usb: gadget: u_ether: Fix host MAC address case")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_ether.c | 36 +--------------------------
 1 file changed, 1 insertion(+), 35 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 2fe91f120bb1d..561a090ced6de 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -17,6 +17,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
+#include <linux/usb/composite.h>
 
 #include "u_ether.h"
 
@@ -102,41 +103,6 @@ static inline int qlen(struct usb_gadget *gadget, unsigned qmult)
 
 /*-------------------------------------------------------------------------*/
 
-/* REVISIT there must be a better way than having two sets
- * of debug calls ...
- */
-
-#undef DBG
-#undef VDBG
-#undef ERROR
-#undef INFO
-
-#define xprintk(d, level, fmt, args...) \
-	printk(level "%s: " fmt , (d)->net->name , ## args)
-
-#ifdef DEBUG
-#undef DEBUG
-#define DBG(dev, fmt, args...) \
-	xprintk(dev , KERN_DEBUG , fmt , ## args)
-#else
-#define DBG(dev, fmt, args...) \
-	do { } while (0)
-#endif /* DEBUG */
-
-#ifdef VERBOSE_DEBUG
-#define VDBG	DBG
-#else
-#define VDBG(dev, fmt, args...) \
-	do { } while (0)
-#endif /* DEBUG */
-
-#define ERROR(dev, fmt, args...) \
-	xprintk(dev , KERN_ERR , fmt , ## args)
-#define INFO(dev, fmt, args...) \
-	xprintk(dev , KERN_INFO , fmt , ## args)
-
-/*-------------------------------------------------------------------------*/
-
 /* NETWORK DRIVER HOOKUP (to the layer above this driver) */
 
 static void eth_get_drvinfo(struct net_device *net, struct ethtool_drvinfo *p)
-- 
2.39.2



