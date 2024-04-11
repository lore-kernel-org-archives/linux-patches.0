Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBF6145FEE;
	Thu, 11 Apr 2024 10:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829776; cv=none; b=AWID0KptcLe1j8siLu0NrvhqATPeu1qFe2Q1pFqzZPCv8PuGzmFtj+vKF17vcDH3K0M12AUPRuHizi0yn9jZLGKjZgkrnLh1l5N76smIqgHYntHEmw9PEfKlsa9Ku0RxLca2euzvaoUpno+Tc/B5PZyXfopV8xx0FnsPtRovAjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829776; c=relaxed/simple;
	bh=FLtZDO+iBpV1VvJvMTIfYtNU5Z29E4IiPOIqglhiYuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHwBO8/HS+oSVGBaaiR8l/YecgdnGMmvTi9iYwrfReeETr4JqDh5qdwttNbuby/eBReOmzS9Da5//teKtbzuYKJ2rAEQSLzmtcaU0W5yLDrxdognWyt+36CfSopJoXkvNmkZmppIobYiCxOuuQUaD6nTic+W+NUhs+l8bGiiSio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6Gr7NPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6Gr7NPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6D8C433C7;
	Thu, 11 Apr 2024 10:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829776;
	bh=FLtZDO+iBpV1VvJvMTIfYtNU5Z29E4IiPOIqglhiYuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6Gr7NPT0s9mc0visEh+xwwh1mrFh3095mbUB9SBk0pU8WLH8FRcXOwhs/K1WmF/F
	 p+kn70FyRgLCu/LnEH7L1JMKAWAzjmMFTzV54ZnYb9mVQcDEuwNF1wso3d30c/OBVG
	 VoL9arxKa8rWAW7QFCVTAFXWZlSidE1OZWBZCx4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 4.19 101/175] usb: dwc2: host: Fix remote wakeup from hibernation
Date: Thu, 11 Apr 2024 11:55:24 +0200
Message-ID: <20240411095422.611159656@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1052,6 +1052,7 @@ struct dwc2_hsotg {
 	bool needs_byte_swap;
 
 	/* DWC OTG HW Release versions */
+#define DWC2_CORE_REV_4_30a	0x4f54430a
 #define DWC2_CORE_REV_2_71a	0x4f54271a
 #define DWC2_CORE_REV_2_72a     0x4f54272a
 #define DWC2_CORE_REV_2_80a	0x4f54280a
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5684,10 +5684,12 @@ int dwc2_host_exit_hibernation(struct dw
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
@@ -5712,6 +5714,13 @@ int dwc2_host_exit_hibernation(struct dw
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


