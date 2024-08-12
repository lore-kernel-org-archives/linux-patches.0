Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8872184551;
	Mon, 12 Aug 2024 16:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479079; cv=none; b=sqsHxTL59HPqx21gJ6f99qVeQuGogtCzH+FFXbWhdyZV8LJdIusei+vUbMDkKdu+aIOht3wRCg9hYHLCPErwvgenO4ByK+K3xxjMQJmDBEk0Ss5gJTnpeLyJsU649AMp/c8s73sS3S12rvTXkjLlvlQVkurF1ojnLfv617rB2B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479079; c=relaxed/simple;
	bh=e/Y4V2sNpQeIxU8KErcCBNrZVe4Kfec3LqB2HYsl7ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wlydnjz0+fSm2Oszle1uAbOP/BYmGqmzudkTb3068EKC+kQUeHicN7dfYuvGIwRMOZi/Uic/hbXLtmnIUEkNfB2ZeYAsX3M7aiewSGtzOmtHdtwgYpjSg0FrnJr4//HQVRqI5Df7tEWRngJrnaP7kVIEG+gDLA7qRO9K2/ufr3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItMTqa5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItMTqa5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B39BC4AF09;
	Mon, 12 Aug 2024 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479079;
	bh=e/Y4V2sNpQeIxU8KErcCBNrZVe4Kfec3LqB2HYsl7ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItMTqa5HIofdmpkvdBh1GGzlA9WcOQBlEwDpUKi8Qh19zKmcDdiZZ3jirfRH2Tlwn
	 cIJsActqqpFejnyPs6T/dkCtpuwWfcBXRy3rke2vodtSmqSe2UCPxs1qpRj/+QgwlR
	 hPOMUwZ+dddaPsL3A06uSD0++xiwZTDDL/5B/faA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <crwulff@gmail.com>
Subject: [PATCH 6.1 095/150] usb: gadget: core: Check for unset descriptor
Date: Mon, 12 Aug 2024 18:02:56 +0200
Message-ID: <20240812160128.829840408@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wulff <crwulff@gmail.com>

commit 973a57891608a98e894db2887f278777f564de18 upstream.

Make sure the descriptor has been set before looking at maxpacket.
This fixes a null pointer panic in this case.

This may happen if the gadget doesn't properly set up the endpoint
for the current speed, or the gadget descriptors are malformed and
the descriptor for the speed/endpoint are not found.

No current gadget driver is known to have this problem, but this
may cause a hard-to-find bug during development of new gadgets.

Fixes: 54f83b8c8ea9 ("USB: gadget: Reject endpoints with 0 maxpacket value")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Wulff <crwulff@gmail.com>
Link: https://lore.kernel.org/r/20240725010419.314430-2-crwulff@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -118,12 +118,10 @@ int usb_ep_enable(struct usb_ep *ep)
 		goto out;
 
 	/* UDC drivers can't handle endpoints with maxpacket size 0 */
-	if (usb_endpoint_maxp(ep->desc) == 0) {
-		/*
-		 * We should log an error message here, but we can't call
-		 * dev_err() because there's no way to find the gadget
-		 * given only ep.
-		 */
+	if (!ep->desc || usb_endpoint_maxp(ep->desc) == 0) {
+		WARN_ONCE(1, "%s: ep%d (%s) has %s\n", __func__, ep->address, ep->name,
+			  (!ep->desc) ? "NULL descriptor" : "maxpacket 0");
+
 		ret = -EINVAL;
 		goto out;
 	}


