Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA68F183CA6;
	Mon, 12 Aug 2024 16:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479542; cv=none; b=WYJAMTL9/RSaHG0zSGJkvB+MZDNmT35OyEVIBWZpNdu1+tB/wo4lOl6dVTslVhlLyfG0STrP+V1mFf5lc7HwXeFYqepgXcEvrFJ9LmjOkRWXDH78BRJcjUQ5IDVW6fNcAnlqX4GNH9vpCKLOuXLxv/mFG1BWQ+B3ebt58dEdNOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479542; c=relaxed/simple;
	bh=GevQF1Y4uGMo/lCQ2PVE/O9RMAeDZboS2DXL8qSPiYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8+vcB1y6uFYxJVaLKQ4XB4tQeY4d6B7L5SPvK3BH9UyDiboI7EXazmXqZNGkLDKxmKitk+uL1cK7q6bGyMNSvHqnAGrr4h2STFycQUtBo4rZQ094etlMrzRnRmlBfZwccx4fKHLW1EsU9uF6oa9Y53pLlpkIx1U26oX8bUciFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPEq/mcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPEq/mcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37694C32782;
	Mon, 12 Aug 2024 16:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479542;
	bh=GevQF1Y4uGMo/lCQ2PVE/O9RMAeDZboS2DXL8qSPiYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPEq/mcybRlewjfx4vBev6LKNH4mcVW0zvJQdoyJQJigjKUGT+WGJ0lpwCRxfGSAO
	 tvqdokFZTpIs2F6yxgyHUtAFIoC5EMPIarZIRLxnsUJBpwEbV+AjTOKbycOFeF1V4W
	 tHhJ6e0VBct8yJjtqr1C2qAJHVn5NZdRFigJVtg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <crwulff@gmail.com>
Subject: [PATCH 6.6 119/189] usb: gadget: core: Check for unset descriptor
Date: Mon, 12 Aug 2024 18:02:55 +0200
Message-ID: <20240812160136.726933431@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


