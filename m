Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A141684AC;
	Thu, 15 Aug 2024 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730484; cv=none; b=Xk2WiQvqgPL5YDLmTkCmfFIy3mrlSi9T2ULeTsfZPo1MS/3oa/PYFkAg4Jgy8tLtSBLaD0CzeX2acchQBqD4DfwmfLawOOtnouZOmXvQknevYJdBQiBC4QvZ0WRomcGyKTKIpakX6x+yxoxLKebuxHmSJcbdz/+JPLVR8EiEdTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730484; c=relaxed/simple;
	bh=BWaHfP8ti7wg9HomF+PEesfYh3lE43pAqWmKJuXLjcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRSQrwK1w4IvvbOuxFf5RsHM08lx5cHMgpoBtgu81afIys2hJSEYP2bw9oFQpK0bl+hbAhqHAnZU4Q/ik2BnC2wwMnO/PYqLnLY+pxmbLT0rO7S+oaE7fwbxbZpM5Mz5Bzfuypoa5n5cBYRJCj8zfUF6aE6PvR/JKTnNOcY4EEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAU4/85H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAU4/85H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CB3C32786;
	Thu, 15 Aug 2024 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730483;
	bh=BWaHfP8ti7wg9HomF+PEesfYh3lE43pAqWmKJuXLjcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAU4/85Hjj10y9iBiRomoZJmCGbD2Yr+6zVuPYxXJvHLRhx2c/+QDQHmJjxTM8YLg
	 LQFKoEh3CgM8ziQvyrvRQawR7Ht9bA6oNvO3cj95naXm/Lr3cL+TeKAuzK4vjRy2oy
	 MTvHjbB4DRgaxs9QXC3EFJVO/svyEa461VrQmpWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <crwulff@gmail.com>
Subject: [PATCH 5.15 422/484] usb: gadget: core: Check for unset descriptor
Date: Thu, 15 Aug 2024 15:24:40 +0200
Message-ID: <20240815131957.755224364@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
@@ -101,12 +101,10 @@ int usb_ep_enable(struct usb_ep *ep)
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


