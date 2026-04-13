Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8754330649;
	Mon, 13 Apr 2026 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099839; cv=none; b=imcDxl0nxPltqEoFfbIiV49NjB7PZQI+hZT47M7zgw3szqkw/nyV0HRG47PeaojBAqonkpWZYCaHJ/6faBSFvAAJQ6UztqDwgnj2TNrX2wpggN4OnZOAqWxbFfV1p3d/LbTnIYWP7I1ga5zDkkphPytY1h2wINIFTLaoBvhuSZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099839; c=relaxed/simple;
	bh=Gr5jJ5pnmchs25gxcd+3TTDIcE+ni/ZpslwZrt/2FVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHrla71nOtQvh/5f4UlKcbGGq78Fq54pjFjxlPOndJj1JymFaSJytZpxpSZnm1Wczh2aI+7vOZFzq/u3RAK8ibIwdPtLnKiZ3Gq94fHCIqXv5VeP4oOB0meDhsvhXudTVP8uNegoQrYoeqwNvfd8kVkjsRYsfP3aRRmj5CNHJHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLN/ZF+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLN/ZF+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7F8C2BCAF;
	Mon, 13 Apr 2026 17:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099839;
	bh=Gr5jJ5pnmchs25gxcd+3TTDIcE+ni/ZpslwZrt/2FVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLN/ZF+TqSkcNJzMs1r56qWZPJ04UKeCJiBJqZiBVbEfEw/EO3giAx6TLLLgscEIh
	 7hVPahSpqtyzl06JzsSrlqyhh075cLkt844bOkA4CDmT5JoW6qrAmCQVKrbXRcpoX4
	 CZSNyfKgwAjW39cEcE0t3k3ONEWdvfO9g6/gVMVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 462/491] usb: gadget: u_ether: Fix race between gether_disconnect and eth_stop
Date: Mon, 13 Apr 2026 18:01:47 +0200
Message-ID: <20260413155836.334742408@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

[ Upstream commit e1eabb072c75681f78312c484ccfffb7430f206e ]

A race condition between gether_disconnect() and eth_stop() leads to a
NULL pointer dereference. Specifically, if eth_stop() is triggered
concurrently while gether_disconnect() is tearing down the endpoints,
eth_stop() attempts to access the cleared endpoint descriptor, causing
the following NPE:

  Unable to handle kernel NULL pointer dereference
  Call trace:
   __dwc3_gadget_ep_enable+0x60/0x788
   dwc3_gadget_ep_enable+0x70/0xe4
   usb_ep_enable+0x60/0x15c
   eth_stop+0xb8/0x108

Because eth_stop() crashes while holding the dev->lock, the thread
running gether_disconnect() fails to acquire the same lock and spins
forever, resulting in a hardlockup:

  Core - Debugging Information for Hardlockup core(7)
  Call trace:
   queued_spin_lock_slowpath+0x94/0x488
   _raw_spin_lock+0x64/0x6c
   gether_disconnect+0x19c/0x1e8
   ncm_set_alt+0x68/0x1a0
   composite_setup+0x6a0/0xc50

The root cause is that the clearing of dev->port_usb in
gether_disconnect() is delayed until the end of the function.

Move the clearing of dev->port_usb to the very beginning of
gether_disconnect() while holding dev->lock. This cuts off the link
immediately, ensuring eth_stop() will see dev->port_usb as NULL and
safely bail out.

Fixes: 2b3d942c4878 ("usb ethernet gadget: split out network core")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260311-gether-disconnect-npe-v1-1-454966adf7c7@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -1141,6 +1141,10 @@ void gether_disconnect(struct gether *li
 
 	DBG(dev, "%s\n", __func__);
 
+	spin_lock(&dev->lock);
+	dev->port_usb = NULL;
+	spin_unlock(&dev->lock);
+
 	netif_stop_queue(dev->net);
 	netif_carrier_off(dev->net);
 
@@ -1178,10 +1182,6 @@ void gether_disconnect(struct gether *li
 	dev->header_len = 0;
 	dev->unwrap = NULL;
 	dev->wrap = NULL;
-
-	spin_lock(&dev->lock);
-	dev->port_usb = NULL;
-	spin_unlock(&dev->lock);
 }
 EXPORT_SYMBOL_GPL(gether_disconnect);
 


