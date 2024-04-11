Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967F0140E3D;
	Thu, 11 Apr 2024 10:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830791; cv=none; b=jnOasbHa6PyfbODrOdazR8e5KHGJ3UmHxKspcVLbPVz5E4okzEUMCTlL+DvBiG3Q+DmzK9wc62fFdP24bbhW7V4gxPmqI24mkRmej848OxeDPj+2gBMMeaBlXKYdxmo3atnL0BeuolpXjFkee0o5MzpNkTw8kQ/GqPMnMx8GKdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830791; c=relaxed/simple;
	bh=Dp+GbCL387QOVlRNQruPIj+v9W+m6F5J4gLx9jbfdpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYso68MYdl1Uck1dT1svjXS7ULlAuD4cyB1HXSxuejz3yK3lIIV8+TnARAyK6REYb4h0iCaZmvIAOPPjUWRqq+JQz0VYpX0GM5ODmpLZTa4gTHuVRCl0wy5/OqvKg3PxDc5ye8kQSqQJmEgQLVhguhs73+o/o0h3ecTM3YPc0gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3QnJf+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3QnJf+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A353C433C7;
	Thu, 11 Apr 2024 10:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830791;
	bh=Dp+GbCL387QOVlRNQruPIj+v9W+m6F5J4gLx9jbfdpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3QnJf+oWlNjst89Mque2VLcqM76NS830yw2TZifwx+zJAzXk6XwXGID/m4c2HeIg
	 BMhhsOFJeK8AtxDsDAgFh5zcOkbT6Dbw2MfIA7uhkD1u4+kajAJayS3g3klH9obn4b
	 +dIRnBhX3kl3cU0weXkJZwGdlanc7NrLNvU2ibOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.4 120/215] usb: dwc2: host: Fix remote wakeup from hibernation
Date: Thu, 11 Apr 2024 11:55:29 +0200
Message-ID: <20240411095428.509989578@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit bae2bc73a59c200db53b6c15fb26bb758e2c6108 upstream.

Starting from core v4.30a changed order of programming
GPWRDN_PMUACTV to 0 in case of exit from hibernation on
remote wakeup signaling from device.

Fixes: c5c403dc4336 ("usb: dwc2: Add host/device hibernation functions")
CC: stable@vger.kernel.org
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/99385ec55ce73445b6fbd0f471c9bd40eb1c9b9e.1708939799.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core.h |    1 +
 drivers/usb/dwc2/hcd.c  |   17 +++++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -1087,6 +1087,7 @@ struct dwc2_hsotg {
 	bool needs_byte_swap;
 
 	/* DWC OTG HW Release versions */
+#define DWC2_CORE_REV_4_30a	0x4f54430a
 #define DWC2_CORE_REV_2_71a	0x4f54271a
 #define DWC2_CORE_REV_2_72a     0x4f54272a
 #define DWC2_CORE_REV_2_80a	0x4f54280a
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5523,10 +5523,12 @@ int dwc2_host_exit_hibernation(struct dw
 	dwc2_writel(hsotg, hr->hcfg, HCFG);
 
 	/* De-assert Wakeup Logic */
-	gpwrdn = dwc2_readl(hsotg, GPWRDN);
-	gpwrdn &= ~GPWRDN_PMUACTV;
-	dwc2_writel(hsotg, gpwrdn, GPWRDN);
-	udelay(10);
+	if (!(rem_wakeup && hsotg->hw_params.snpsid >= DWC2_CORE_REV_4_30a)) {
+		gpwrdn = dwc2_readl(hsotg, GPWRDN);
+		gpwrdn &= ~GPWRDN_PMUACTV;
+		dwc2_writel(hsotg, gpwrdn, GPWRDN);
+		udelay(10);
+	}
 
 	hprt0 = hr->hprt0;
 	hprt0 |= HPRT0_PWR;
@@ -5551,6 +5553,13 @@ int dwc2_host_exit_hibernation(struct dw
 		hprt0 |= HPRT0_RES;
 		dwc2_writel(hsotg, hprt0, HPRT0);
 
+		/* De-assert Wakeup Logic */
+		if ((rem_wakeup && hsotg->hw_params.snpsid >= DWC2_CORE_REV_4_30a)) {
+			gpwrdn = dwc2_readl(hsotg, GPWRDN);
+			gpwrdn &= ~GPWRDN_PMUACTV;
+			dwc2_writel(hsotg, gpwrdn, GPWRDN);
+			udelay(10);
+		}
 		/* Wait for Resume time and then program HPRT again */
 		mdelay(100);
 		hprt0 &= ~HPRT0_RES;


