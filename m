Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623623;
	b=fXREBugUskbFRqWoNoxaRCX7HsQ+GU6tITgarzDnkeZltt+Gb8Qjb6y0rvdg0Tfu0FTu
	 Xn6jZKWTYOdCJZ80ml8UrCJfXw5LyilMQw408o0XIYZmk+qXrX2MCBWLL1+7O42NPkpvM
	 DbcfNYcaM9WbS81wSFo9E3gH47gNfaOydnuqqdqBV+2h06QCvi5wOcei28Zodus3KHKdJ
	 ivCa6xs4wHHcT3F0IC2aS9NLOLlheJq9HFkdDFseILVEjV++AG/bAlMMG6iWxw4V9vwyD
	 RrkgDKjYqylVzEwO4TdQzwUNFDIh9XRoS5X/pGNK5JhrewiEeUMMe5omV99DOEkM1PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PMrW6KH+Cl482WQ+OLL0YigBVzRIRc0Ebc4XcKqwRy4=;
	b=4TJrWzNjFUsArDU/wXUlhErlGr212MSyHqEZgVjPiitsOX53tb/NkZBEhVvxhIWeqZ5j
	 5aC79F9WS9FL7BAoXH53agOVoAVL+I4VadkjXrU7yLrUU0yns4lpTx7HCYtZTa/rFFPJk
	 ZBE7bwrVPLgKm0BOoPx/wtNjKiS01p+WGqqDgnKQHm+2OLjxGlu1XzmsGBRCRU3wLvfB0
	 Y26UV3Rdv3eamBWQvAaFYYcTdlFcCP1LIhLFmxps+fiq7BxymqO0NJDMZz0uUNypod89G
	 WjUd6/UaZZAW+ypi0+tecQPRzqH3gMMb8sS1Ps5001alg9Kj24HrSyxg/1dnK7/RQdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QEKPZ38j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89EE606A31E;
	Wed, 25 Nov 2026 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QEKPZ38j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FA61F000D2;
	Wed, 25 Nov 2026 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623623;
	bh=PMrW6KH+Cl482WQ+OLL0YigBVzRIRc0Ebc4XcKqwRy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEKPZ38j4kB7YwhnStdxtFQjmJylXXGUGQUvUwB5hAeo1V+ZcgzvHwHfPOzof7AJh
	 spAbB1OjjjZLFEePncxVhqqeRxcCWM5YuU/0JFpgW4G+cfGqdH9q/WFojcjNE41Ey7
	 WXbllU6fsMrXKx/ZticLIveacZ3pMZGZN3oFl4X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.18 918/990] usb: dwc3: gadget: Reject requests to a disabled endpoint
Date: Wed, 25 Nov 2026 15:38:05 +0100
Message-ID: <20261125143843.506105590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 5eb11b1647b0534b3a61a21473d77ebf4ffbed7c upstream.

__dwc3_gadget_ep_disable() releases the lock while giving back requests,
and DWC3_EP_ENABLED is only cleared afterward. A function driver can
queue a new request in this window, and the driver would start a
transfer on an endpoint that is already disabled in hardware.

Clear DWC3_EP_ENABLED before giving back the requests, and reject
requests queued to an endpoint that is not enabled.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/4ceab6aa5d6af0e4780f9d3a964fd5d8168a0a02.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1087,6 +1087,8 @@ static int __dwc3_gadget_ep_disable(stru
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc, DWC3_DALEPENA, reg);
 
+	dep->flags &= ~DWC3_EP_ENABLED;
+
 	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
@@ -1998,7 +2000,8 @@ static int __dwc3_gadget_ep_queue(struct
 {
 	struct dwc3		*dwc = dep->dwc;
 
-	if (!dep->endpoint.desc || !dwc->pullups_connected || !dwc->connected) {
+	if (!(dep->flags & DWC3_EP_ENABLED) || !dep->endpoint.desc ||
+	    !dwc->pullups_connected || !dwc->connected) {
 		dev_dbg(dwc->dev, "%s: can't queue to disabled endpoint\n",
 				dep->name);
 		return -ESHUTDOWN;


