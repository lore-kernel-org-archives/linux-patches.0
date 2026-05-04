Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6262F3DE452;
	Mon,  4 May 2026 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904193; cv=none; b=LaVcvPU7i8pncPSunsKczdCx7pmOAcppz/lmKqup/WYkvOl0Kg+DsMh/DTfzeWrzsIgCBTDl2axajIVYKTjpE4xxY2WW/DX+fo7z/vnoQW9D9QfxM/5hXeoXqR8o4npKtTM1MbDhco7w/VF/uJUC5pPW3XhtDw8b4A+eb2Ut8Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904193; c=relaxed/simple;
	bh=kyIN2em/VeRdfVxPUASKQnokBywP1WhQbcNnHIm/apo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6jVOKNxgKAu/hMjNnB4C0moyhY1/X+6s0WLW9pF+VTdkS1IIyWpv2nADCqpckciT38WKj/FT3zE8TUGSYexq4nYMq/syR+TFmYMGdtFmEHLyfd8AgqFazALJ2abGwCk3F/Lnyh5tROEoDXKbl81Z/BDCI1l5+Iamf3YNV3O+N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foN33J94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foN33J94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED2DC2BCB8;
	Mon,  4 May 2026 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904193;
	bh=kyIN2em/VeRdfVxPUASKQnokBywP1WhQbcNnHIm/apo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foN33J94dDKTXxPzJCK9KxfqfOBrihoiBdwqdBmxyFKsYXn2mDs/0odBpyyC1nsia
	 3qmsmclTG/7AiDoXYmMn8A3IIfPivVAGugpjKLS91n0F+C91EA+VBf9VnBZheVIjHk
	 yXCHF/oww0G+0W0JARWy9Y8lJjaPH9D9YJNDfB9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
	Johan Hovold <johan@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 219/275] can: ucan: fix devres lifetime
Date: Mon,  4 May 2026 15:52:39 +0200
Message-ID: <20260504135151.206809956@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit fed4626501c871890da287bec62a96e52da1af89 upstream.

USB drivers bind to USB interfaces and any device managed resources
should have their lifetime tied to the interface rather than parent USB
device. This avoids issues like memory leaks when drivers are unbound
without their devices being physically disconnected (e.g. on probe
deferral or configuration changes).

Fix the control message buffer lifetime so that it is released on driver
unbind.

Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Cc: stable@vger.kernel.org	# 4.19
Cc: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260327104520.1310158-1-johan@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ucan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1399,7 +1399,7 @@ static int ucan_probe(struct usb_interfa
 	 */
 
 	/* Prepare Memory for control transfers */
-	ctl_msg_buffer = devm_kzalloc(&udev->dev,
+	ctl_msg_buffer = devm_kzalloc(&intf->dev,
 				      sizeof(union ucan_ctl_payload),
 				      GFP_KERNEL);
 	if (!ctl_msg_buffer) {


