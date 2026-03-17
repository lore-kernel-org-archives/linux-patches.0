Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C011A9B58;
	Tue, 17 Mar 2026 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767755; cv=none; b=hSo9CKeOJAgOEQIQToXdr4kU5h7UJAt7jlAgek23OZbqmnQ7vyzbqmcJvEcWoVCPqUP8k//uNFwtp0cskgRMaZnLOhjCHleNPzhGeHSMtqg1eCRrdOMwVwbAkcOGJwzUGMXBED5T5Skwbr1HuOF+lpu7YXHWPAd9wgk7GJv9gtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767755; c=relaxed/simple;
	bh=vGDxWPRPOry4zdP8Eim85IQbi7KMfnJ7Rt08lOtHwjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyymB1Crk69yzHK9NZYfDwtM7KykQM4/WUThoFwfNQG/Yx5WepjDrk5GpePwkQgpxfqb8nbw2ng5UeGE0CkcIOCEWS3t4r6TRcgYUS/ANZ0nO4vWP8YODQ4JlLFGrk6CqNp4McEGELG9IQ24dwuRa8qKRj/XeS9S1AH/dOewR8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFVYk5at; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFVYk5at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A46C4CEF7;
	Tue, 17 Mar 2026 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767754;
	bh=vGDxWPRPOry4zdP8Eim85IQbi7KMfnJ7Rt08lOtHwjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFVYk5atuFpp86p1/p7AqJSKmJ5TFoZeugU7EC5CMSpxmfgo3deqEngKJT1vdcEbg
	 G+sEgTmvN5JCVNRfk00RRswscf1vU6oGV7IaNJsnIX0W1DTqsRGgXgHuvbKPrMBIGV
	 wP5Vd7J9yvdALWKcuKooy83IBJNGXrDKL8zf3uz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.18 151/333] Revert "usb: legacy: ncm: Fix NPE in gncm_bind"
Date: Tue, 17 Mar 2026 17:33:00 +0100
Message-ID: <20260317163004.957467269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
 drivers/usb/gadget/legacy/ncm.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/legacy/ncm.c b/drivers/usb/gadget/legacy/ncm.c
index e8d565534053..0f1b45e3abd1 100644
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
@@ -131,7 +129,6 @@ static int gncm_bind(struct usb_composite_dev *cdev)
 	struct usb_gadget	*gadget = cdev->gadget;
 	struct f_ncm_opts	*ncm_opts;
 	int			status;
-	u8			mac[ETH_ALEN];
 
 	f_ncm_inst = usb_get_function_instance("ncm");
 	if (IS_ERR(f_ncm_inst))
@@ -139,15 +136,11 @@ static int gncm_bind(struct usb_composite_dev *cdev)
 
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
-- 
2.53.0



