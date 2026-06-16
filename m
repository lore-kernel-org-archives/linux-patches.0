Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9036318EDA;
	Tue, 16 Jun 2026 19:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636478; cv=none; b=gklAXq9O3UbTiPSIBkFtaB0x5zgWTuYUxCFg8Ri4vMPBCvo6nuMLl6qenaQa05UZ4dQmflDI+usPkng9b5oSu9kH9ON3mq2CgwQEf2++Mz55JWaY1f/rQI/aTV1H7zqvAYDha6LWNatYNFeBQdKt1NxW14pcSLakzZZy8wqBif0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636478; c=relaxed/simple;
	bh=ZbM8IRYmj3W8slQa5moJ4DEZ98rqofYXTjMwATCPGWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edNxJ5qqvl5TbH1es9L54Vxw0EJgcUhLlJdLaAbr0Z1lf3ATOR7XvBeArk0lAtXaBHRCMJYYN8B27zjvdCklH3B5KAVnCcmPqq2wR4ZMc26hHTMYt47fx+2LDgj953vWZAMo2uwL4ARIPVxjioHuODv3HYowYw8Cpn6rIVtqyG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYutFqdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYutFqdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAF11F000E9;
	Tue, 16 Jun 2026 19:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636477;
	bh=KnCfvisW5rMsnvMYcV3g0uTTB18WDkNPgUPAWyNueNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYutFqdySQnBHFhijIW6GEYPM9qfwoJvqA0nu+89buW2VqarCLOzobp3+eiV7/2KM
	 E3c9kHvqK/+aAhqdBvQHCkKckH/+rljBYEhXWgogDBrsXhf1lZxM3vWVAPhd5e0EP7
	 XegsRdEM7HyN2sqVFXbHxaeDuPapSZRkBx6s49zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
	Johan Hovold <johan@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/342] can: ucan: fix devres lifetime
Date: Tue, 16 Jun 2026 20:29:01 +0530
Message-ID: <20260616145059.630624759@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit fed4626501c871890da287bec62a96e52da1af89 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ucan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1394,7 +1394,7 @@ static int ucan_probe(struct usb_interfa
 	 */
 
 	/* Prepare Memory for control transfers */
-	ctl_msg_buffer = devm_kzalloc(&udev->dev,
+	ctl_msg_buffer = devm_kzalloc(&intf->dev,
 				      sizeof(union ucan_ctl_payload),
 				      GFP_KERNEL);
 	if (!ctl_msg_buffer) {


