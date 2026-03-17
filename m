Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F803EAC6F;
	Tue, 17 Mar 2026 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766232; cv=none; b=KXbeXaJ+8DzLOKUH6iTJEU1UhYos1YUaD5OihiskhdeiUtQG6E3hdRW7FZn/v8KNSWfCHv7pUwNYRdYwZLsdAGCE0dHZc0YzNFgM57nSWhGsJwT6r5Vlk+YaDMNOZAP4ZUSAJ4x2+GMdhpPMwHOxd1weAQP9y49MtFv87cRgrmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766232; c=relaxed/simple;
	bh=RQGNOHfEi0JmuzdbRSlLhqjOO/EVjlOVhYTiO2ZW3pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co8wG8W/OMokJ1J3gyDJIbxB83RO9S0fmiwLTNdfBynyGjQNuZZ/9zL1431VptQPrT3Xg4LVRupsmNSAf2x1deX3os9B/fC5VmHPfIRoh8rfKRw9ZJnYnJDnNqJXI5u6MxELXVRAJbKd5kwespznifGyGknOniq7FWyR3iK8Ddw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByCI8yXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByCI8yXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C69C4CEF7;
	Tue, 17 Mar 2026 16:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766231;
	bh=RQGNOHfEi0JmuzdbRSlLhqjOO/EVjlOVhYTiO2ZW3pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByCI8yXw9KdD9VOEL+Yy/g9XohPm2t1QFv9WK7XDfg9OKN96dhMFH65qxdL0OBvNm
	 PbXuSX8SGP0VrB/91xldVlJxuHn+IEEKQ8vIgUdHH7jKNv1KU+75jpU+iQMHaHwXLA
	 FHpdcR8DMDDVT3BuiEG5WHC2kaB5/HpdbqbKmnDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	kernel test robot <oliver.sang@intel.com>,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.19 166/378] usb: legacy: ncm: Fix NPE in gncm_bind
Date: Tue, 17 Mar 2026 17:32:03 +0100
Message-ID: <20260317163013.117481515@linuxfoundation.org>
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

commit fde0634ad9856b3943a2d1a8cc8de174a63ac840 upstream.

Commit 56a512a9b410 ("usb: gadget: f_ncm: align net_device lifecycle
with bind/unbind") deferred the allocation of the net_device. This
change leads to a NULL pointer dereference in the legacy NCM driver as
it attempts to access the net_device before it's fully instantiated.

Store the provided qmult, host_addr, and dev_addr into the struct
ncm_opts->net_opts during gncm_bind(). These values will be properly
applied to the net_device when it is allocated and configured later in
the binding process by the NCM function driver.

Fixes: 56a512a9b410 ("usb: gadget: f_ncm: align net_device lifecycle with bind/unbind")
Cc: stable@kernel.org
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202602181727.fd76c561-lkp@intel.com
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260221-legacy-ncm-v2-1-dfb891d76507@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/ncm.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/legacy/ncm.c
+++ b/drivers/usb/gadget/legacy/ncm.c
@@ -15,8 +15,10 @@
 /* #define DEBUG */
 /* #define VERBOSE_DEBUG */
 
+#include <linux/hex.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 #include <linux/usb/composite.h>
 
 #include "u_ether.h"
@@ -129,6 +131,7 @@ static int gncm_bind(struct usb_composit
 	struct usb_gadget	*gadget = cdev->gadget;
 	struct f_ncm_opts	*ncm_opts;
 	int			status;
+	u8			mac[ETH_ALEN];
 
 	f_ncm_inst = usb_get_function_instance("ncm");
 	if (IS_ERR(f_ncm_inst))
@@ -136,11 +139,15 @@ static int gncm_bind(struct usb_composit
 
 	ncm_opts = container_of(f_ncm_inst, struct f_ncm_opts, func_inst);
 
-	gether_set_qmult(ncm_opts->net, qmult);
-	if (!gether_set_host_addr(ncm_opts->net, host_addr))
+	ncm_opts->net_opts.qmult = qmult;
+	if (host_addr && mac_pton(host_addr, mac)) {
+		memcpy(&ncm_opts->net_opts.host_mac, mac, ETH_ALEN);
 		pr_info("using host ethernet address: %s", host_addr);
-	if (!gether_set_dev_addr(ncm_opts->net, dev_addr))
+	}
+	if (dev_addr && mac_pton(dev_addr, mac)) {
+		memcpy(&ncm_opts->net_opts.dev_mac, mac, ETH_ALEN);
 		pr_info("using self ethernet address: %s", dev_addr);
+	}
 
 	/* Allocate string descriptor numbers ... note that string
 	 * contents can be overridden by the composite_dev glue.


