Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6A51519B4;
	Wed,  5 Feb 2025 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768127; cv=none; b=BYqN52mJOVMYJ6tsIYDTkta3nX9Y6NOBLYGqkcqMLopwZFSlr1fpZGivsl9VY9W5KedlP9NuNBo1iGLMXncwUiBrISHpUHmqFzq3B5kF+dz0kUaTVnZhB4yL4XYmihrvgJgrM95PT+2ieeya01FIoncRb4xRoyw1BHF3+gcjvUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768127; c=relaxed/simple;
	bh=jsN8NzJnh8MHkXA3lc+7LAMYZbb1DuBcDPEEpsFJrX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoKTwXbIMpbQw+iSXZ8AMM6RuAOROcWU4in2t044rNcy9Z051i1e8rAvpAzLybzF2g7z3Clq6xK7b0y9z0j/wF8/pf1Y+Jhy4Tx5EA33xJy83ec7dKmlTptMyFvEsieRDnfHKZv5tHB0kbwMSJAErdm/YydL0BbaJowybEZwDFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXJbBzHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXJbBzHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0138C4CED1;
	Wed,  5 Feb 2025 15:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768127;
	bh=jsN8NzJnh8MHkXA3lc+7LAMYZbb1DuBcDPEEpsFJrX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXJbBzHznmpSve1YF02ShhnQAUFyMbk3Tcd6fn3iNrURZyFT/Y3KjrIlz0GVsGS+t
	 j5/9A78htdIaYStF9Y9lClucVWB1a6Tg/8KETf+E8Gn5DfRwauP3ra1CGjAosyNMeE
	 WCaE/aWOY0rzKct54oAex0eqW5fEITrBLTWsnn0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kyle Tso <kyletso@google.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 557/590] usb: dwc3: core: Defer the probe until USB power supply ready
Date: Wed,  5 Feb 2025 14:45:12 +0100
Message-ID: <20250205134516.579400576@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kyle Tso <kyletso@google.com>

commit 66e0ea341a2a78d14336117f19763bd9be26d45d upstream.

Currently, DWC3 driver attempts to acquire the USB power supply only
once during the probe. If the USB power supply is not ready at that
time, the driver simply ignores the failure and continues the probe,
leading to permanent non-functioning of the gadget vbus_draw callback.

Address this problem by delaying the dwc3 driver initialization until
the USB power supply is registered.

Fixes: 6f0764b5adea ("usb: dwc3: add a power supply for current control")
Cc: stable <stable@kernel.org>
Signed-off-by: Kyle Tso <kyletso@google.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250115044548.2701138-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1660,8 +1660,6 @@ static void dwc3_get_properties(struct d
 	u8			tx_thr_num_pkt_prd = 0;
 	u8			tx_max_burst_prd = 0;
 	u8			tx_fifo_resize_max_num;
-	const char		*usb_psy_name;
-	int			ret;
 
 	/* default to highest possible threshold */
 	lpm_nyet_threshold = 0xf;
@@ -1696,13 +1694,6 @@ static void dwc3_get_properties(struct d
 
 	dwc->sys_wakeup = device_may_wakeup(dwc->sysdev);
 
-	ret = device_property_read_string(dev, "usb-psy-name", &usb_psy_name);
-	if (ret >= 0) {
-		dwc->usb_psy = power_supply_get_by_name(usb_psy_name);
-		if (!dwc->usb_psy)
-			dev_err(dev, "couldn't get usb power supply\n");
-	}
-
 	dwc->has_lpm_erratum = device_property_read_bool(dev,
 				"snps,has-lpm-erratum");
 	device_property_read_u8(dev, "snps,lpm-nyet-threshold",
@@ -2105,6 +2096,23 @@ static int dwc3_get_num_ports(struct dwc
 	return 0;
 }
 
+static struct power_supply *dwc3_get_usb_power_supply(struct dwc3 *dwc)
+{
+	struct power_supply *usb_psy;
+	const char *usb_psy_name;
+	int ret;
+
+	ret = device_property_read_string(dwc->dev, "usb-psy-name", &usb_psy_name);
+	if (ret < 0)
+		return NULL;
+
+	usb_psy = power_supply_get_by_name(usb_psy_name);
+	if (!usb_psy)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	return usb_psy;
+}
+
 static int dwc3_probe(struct platform_device *pdev)
 {
 	struct device		*dev = &pdev->dev;
@@ -2161,6 +2169,10 @@ static int dwc3_probe(struct platform_de
 
 	dwc3_get_software_properties(dwc);
 
+	dwc->usb_psy = dwc3_get_usb_power_supply(dwc);
+	if (IS_ERR(dwc->usb_psy))
+		return dev_err_probe(dev, PTR_ERR(dwc->usb_psy), "couldn't get usb power supply\n");
+
 	dwc->reset = devm_reset_control_array_get_optional_shared(dev);
 	if (IS_ERR(dwc->reset)) {
 		ret = PTR_ERR(dwc->reset);


