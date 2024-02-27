Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B12613B798;
	Tue, 27 Feb 2024 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043467; cv=none; b=ZN8IxXGvsQ9Iq1BFzYB8GG4QCFM7/va5tO6H0dPBqfGfAPU2GFZ+q2Tq61BNcAHEc15gIAny8Hcs10V+VDHGj3k6fzo220Blej+Jq3rSEA0P1GWujYgaJaHVXxNU0p3kMQP+Z9lymyuPt04GKUHZYiEu5gxm70u/3GktlcMvO2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043467; c=relaxed/simple;
	bh=FKlG5jiBdRPaaAbXiPMxQRIzcSW1AgNDX6AhDo16kyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3hpMjrQHZD99Cy2Ho4PE8Chnf6xiRmlow0hm+TGLD4XrRoLnGGP7u1kH+scrZWQaT5rr3g57Q3nMAL7OdsE5nBSiOLKsQdk3zaW6Aqf4hFB63dtzg4LS4F4k1lOgnNOZ8rVi7jIddkVtkbEb3LPytXixJzJi9A+3TsEEpxICi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtaZ/BbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtaZ/BbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC15DC433C7;
	Tue, 27 Feb 2024 14:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043467;
	bh=FKlG5jiBdRPaaAbXiPMxQRIzcSW1AgNDX6AhDo16kyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtaZ/BbGtI6m7Vzf/XN9ITas7D/Kov3ThfZN8jYVTLObuRbyPCtfc2AgNATIBHdb+
	 qtQ+us7VSqlBvSFXgYuRHdP7RNVNK8eQLSStYBG5U0zZUCx3Eg50gyD8GCinS0boXv
	 53QDwLEmoEWfqigddva5sBuOjeM/v0S1/iGjp698=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 118/195] usb: dwc3: gadget: Dont disconnect if not started
Date: Tue, 27 Feb 2024 14:26:19 +0100
Message-ID: <20240227131614.354518084@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit b191a18cb5c47109ca696370a74a5062a70adfd0 upstream.

Don't go through soft-disconnection sequence if the controller hasn't
started. Otherwise, there will be timeout and warning reports from the
soft-disconnection flow.

Cc: stable@vger.kernel.org
Fixes: 61a348857e86 ("usb: dwc3: gadget: Fix NULL pointer dereference in dwc3_gadget_suspend")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/linux-usb/20240215233536.7yejlj3zzkl23vjd@synopsys.com/T/#mb0661cd5f9272602af390c18392b9a36da4f96e6
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/e3be9b929934e0680a6f4b8f6eb11b18ae9c7e07.1708043922.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2548,6 +2548,11 @@ static int dwc3_gadget_soft_disconnect(s
 	int ret;
 
 	spin_lock_irqsave(&dwc->lock, flags);
+	if (!dwc->pullups_connected) {
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		return 0;
+	}
+
 	dwc->connected = false;
 
 	/*


