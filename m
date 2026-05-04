Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3FF3DFC78;
	Mon,  4 May 2026 14:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904731; cv=none; b=skhk7zY0ECUw3F4ztGMJcDOOr4BN6KqmR5di1UO8G3ycV+nZ+x9Hm5kq27vUzxKcCyA8/2xDWCIiP2Ojis9Q/LTlHi0OCTGVS/RiXEPw5m9mmNHpQd8Ha7vDfvXnuwHOu9bozhkkbGqyCseNMVXxM9Ci4RVATQ78zL2GBUxCF64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904731; c=relaxed/simple;
	bh=silKOfg6nsm73bza+Zzb8oT1Nlesx9iqVf9YmADxtNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYCebV7HK9Iu16OYRCOEizkKX8Usk9jFi6YF5oZ+xpB0C3jjkAfKOnMtm8+UYV3m+3VkP48O4f1FG360kr8mHLpKcteYWHEtlaFlNDKlksogpOy3xEXnAcxJgYWOCK174SonKbU0Ge5NkM4elWycjIAAE8RhN/er66E4qqAJXBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5jqGZFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5jqGZFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2474C2BCB8;
	Mon,  4 May 2026 14:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904731;
	bh=silKOfg6nsm73bza+Zzb8oT1Nlesx9iqVf9YmADxtNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5jqGZFtRWBwP86MDZLhp9OnGXdvaV8TPmmlKUFt+EyvcsRLE7XaN+WfPLWbg763e
	 g2bfkdrY++LVsP2ArF9LZpU6uQmSbDM3SMJGe2ytNtVrOWXQW99rvnc2vA+P3MQIHY
	 ddEBehH+nH64vfCD/z7UnNP/mfFw4JvWB979S62A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
	Johan Hovold <johan@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 153/215] can: ucan: fix devres lifetime
Date: Mon,  4 May 2026 15:52:52 +0200
Message-ID: <20260504135135.756519730@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


