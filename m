Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E3E1A2C11;
	Thu, 15 Aug 2024 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731865; cv=none; b=RRV1KeD9YNaDcb6RANayY0DLRT38Cg7WuD6Ig9/3efrrQuoKTThE4p/OaqupSCyHm68SvvNmUewEZeBR0Bdpyyzayd86RgAjHQoSRpT5SN1edrsvg0MrZK5Fm9O7WCOy6ouX3RzkMUwMkb01asAuTdUOMYEyqZqc/g5LaTkIEqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731865; c=relaxed/simple;
	bh=PL0Zb5h2hA6pi0t8odArRtCu6LKokH+O+MiDhY/5UsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLxZh51pM8aLuChmxrSgEjjBB4uEW/ezijCDVprM6bjUz+EdjGHj90yZZQF+1HeYsuRDwRiUaoF0ACQkZxRB9K//it+pz7qKkKNhlvFGduM2Eb7MXQRbXYwvdHSF+6HGVPeL7J0A6r0NsNyOkNnNZdgms5f6p/sqttAE20Ja2dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spf/2k+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spf/2k+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBF6C4AF0C;
	Thu, 15 Aug 2024 14:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731865;
	bh=PL0Zb5h2hA6pi0t8odArRtCu6LKokH+O+MiDhY/5UsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spf/2k+jW0IE0jWoSYnOTP+mWkPvSEXSGi/TBuEW7vJa+DJ1cGpCKUWk/vfafY2/P
	 ddPRsFtDfS8FvFW3PHji6T7IL9iugL3jh5/EC6GYgJ7l5wgz9pOCmtda5JyWiIgek2
	 129dLJ0LyvSOn/G1KG9rwYCs8+ttxK7uVaLbpYvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wulff <crwulff@gmail.com>
Subject: [PATCH 5.4 233/259] usb: gadget: core: Check for unset descriptor
Date: Thu, 15 Aug 2024 15:26:06 +0200
Message-ID: <20240815131911.775028541@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -99,12 +99,10 @@ int usb_ep_enable(struct usb_ep *ep)
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


