Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC27357A4A;
	Tue, 17 Mar 2026 16:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766240; cv=none; b=uMo2cbKRlY94bubVI5Uzr8n/mbLU4TMCWOqJjTwPsLM8EX75QbmaX/7IWOkmbu4Gzd5eaSwTYMDYmkUwJSBZ4qUMcWZHEQa25vxSDU/saSsALtJ0nx9QbROpR0R0zbbhqatDC062QhXpC1uDRJWJBbmPIPullF9mMiHxX85mMec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766240; c=relaxed/simple;
	bh=tcfy3OK9iapy829/oL5HZ2xpVSdXHnxNirZ1Tr8X7Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAK1eqvyYY7++Tspo+zwxlnOWFodDRiS8zgXKZ1hjGdxWTtTIBEj9gQkCzCs0WXiqbMzSImeaYjF0TW3/U+Q/TDYTb7iNG7YYFlkskpk1RNb7laVjZ81oiOR302uX59njhER2pvkgSX6tgDcfb4x/2T5FQxwV/YwlZ/dthWN11o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBuIj1cI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBuIj1cI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABCDC19424;
	Tue, 17 Mar 2026 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766240;
	bh=tcfy3OK9iapy829/oL5HZ2xpVSdXHnxNirZ1Tr8X7Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBuIj1cI2KY3WwXub5Chl/FKL7mt9gY4QVXZbpPWT2Sluu6eh7h8ZMVVuq3kyM/7A
	 gmR08Pr6NJAgq+Z89tcOuZ+5zVzRU15GO6yXF0Qfeh7dG80TepsU8Fz9wkVBkbvd0j
	 YAh72LKub4xZU3hSfb97cHNcp72ivwSsIjCCzb2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.19 168/378] Revert "usb: legacy: ncm: Fix NPE in gncm_bind"
Date: Tue, 17 Mar 2026 17:32:05 +0100
Message-ID: <20260317163013.190322808@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

commit f2524c0e6ff0a5f72f1e1a32441c69d3b56430c4 upstream.

This reverts commit fde0634ad9856b3943a2d1a8cc8de174a63ac840.

This commit is being reverted as part of a series-wide revert.

By deferring the net_device allocation to the bind() phase, a single
function instance will spawn multiple network devices if it is symlinked
to multiple USB configurations.

This causes regressions for userspace tools (like the postmarketOS DHCP
daemon) that rely on reading the interface name (e.g., "usb0") from
configfs. Currently, configfs returns the template "usb%d", causing the
userspace network setup to fail.

Crucially, because this patch breaks the 1:1 mapping between the
function instance and the network device, this naming issue cannot
simply be patched. Configfs only exposes a single 'ifname' attribute per
instance, making it impossible to accurately report the actual interface
name when multiple underlying network devices can exist for that single
instance.

All configurations tied to the same function instance are meant to share
a single network device. Revert this change to restore the 1:1 mapping
by allocating the network device at the instance level (alloc_inst).

Reported-by: David Heidelberg <david@ixit.cz>
Closes: https://lore.kernel.org/linux-usb/70b558ea-a12e-4170-9b8e-c951131249af@ixit.cz/
Fixes: 56a512a9b410 ("usb: gadget: f_ncm: align net_device lifecycle with bind/unbind")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260309-f-ncm-revert-v2-2-ea2afbc7d9b2@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/ncm.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/legacy/ncm.c
+++ b/drivers/usb/gadget/legacy/ncm.c
@@ -15,10 +15,8 @@
 /* #define DEBUG */
 /* #define VERBOSE_DEBUG */
 
-#include <linux/hex.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/string.h>
 #include <linux/usb/composite.h>
 
 #include "u_ether.h"
@@ -131,7 +129,6 @@ static int gncm_bind(struct usb_composit
 	struct usb_gadget	*gadget = cdev->gadget;
 	struct f_ncm_opts	*ncm_opts;
 	int			status;
-	u8			mac[ETH_ALEN];
 
 	f_ncm_inst = usb_get_function_instance("ncm");
 	if (IS_ERR(f_ncm_inst))
@@ -139,15 +136,11 @@ static int gncm_bind(struct usb_composit
 
 	ncm_opts = container_of(f_ncm_inst, struct f_ncm_opts, func_inst);
 
-	ncm_opts->net_opts.qmult = qmult;
-	if (host_addr && mac_pton(host_addr, mac)) {
-		memcpy(&ncm_opts->net_opts.host_mac, mac, ETH_ALEN);
+	gether_set_qmult(ncm_opts->net, qmult);
+	if (!gether_set_host_addr(ncm_opts->net, host_addr))
 		pr_info("using host ethernet address: %s", host_addr);
-	}
-	if (dev_addr && mac_pton(dev_addr, mac)) {
-		memcpy(&ncm_opts->net_opts.dev_mac, mac, ETH_ALEN);
+	if (!gether_set_dev_addr(ncm_opts->net, dev_addr))
 		pr_info("using self ethernet address: %s", dev_addr);
-	}
 
 	/* Allocate string descriptor numbers ... note that string
 	 * contents can be overridden by the composite_dev glue.


