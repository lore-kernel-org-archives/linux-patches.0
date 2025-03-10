Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B21217CA12;
	Mon, 10 Mar 2025 17:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629147; cv=none; b=fFlbSR3iyU8/ZgzVkh3FxspzV+Tc4GSjFCVfztj1o3fv22fytlWLC+OPZdyxVheC8LxI47Bj6wE2FcJwa1WPyPLo5BmAfNFc7k6Vh6x0fa3eBP22nPHny70W8PN05n6FBXETGo1+uW8La1/xf6mYlCYxdbXiPf4U1wVg0LclXEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629147; c=relaxed/simple;
	bh=ILyERJNU7xpiGH2FBULmfe91Gm5VZFDYx7KCuLjqvKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p24MAGV/KVzAf0NWgoWYuEZpO9FXYa3jXM3fnaOfcbF0QB4eY7DGMuapitDu7SNKLopICbhvQd/pjkXhD+MVZIG4DdJewtZBseT5ulMz5dtKr5xaeyNB36MLK54QwWyOnk23/QOMKbdIpNIz4uBRY1ej/vPfPzCO7GkF6QMqA80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zD1dgfno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zD1dgfno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1236BC4CEE5;
	Mon, 10 Mar 2025 17:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629146;
	bh=ILyERJNU7xpiGH2FBULmfe91Gm5VZFDYx7KCuLjqvKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zD1dgfnoH81hFiYlR6p+O+39WJ2bUBT+OaMvJBLVavEpP3vHWunIdyQOqVjADSdcR
	 9HlsgU/BKsw16JE8ed5YMtieW2an6HjdKG7qlamSDMG1HF6TOZWaEqf4G/PR1jrkUr
	 Lf6w2Jz/GoNCjPQzT9+XUs9+Vknb0hAtGfO9s6kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kyle Tso <kyletso@google.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 194/620] usb: dwc3: core: Defer the probe until USB power supply ready
Date: Mon, 10 Mar 2025 18:00:40 +0100
Message-ID: <20250310170553.289910131@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1314,8 +1314,6 @@ static void dwc3_get_properties(struct d
 	u8			tx_thr_num_pkt_prd = 0;
 	u8			tx_max_burst_prd = 0;
 	u8			tx_fifo_resize_max_num;
-	const char		*usb_psy_name;
-	int			ret;
 
 	/* default to highest possible threshold */
 	lpm_nyet_threshold = 0xf;
@@ -1348,13 +1346,6 @@ static void dwc3_get_properties(struct d
 	else
 		dwc->sysdev = dwc->dev;
 
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
@@ -1564,6 +1555,23 @@ static void dwc3_check_params(struct dwc
 	}
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
@@ -1608,6 +1616,10 @@ static int dwc3_probe(struct platform_de
 
 	dwc3_get_properties(dwc);
 
+	dwc->usb_psy = dwc3_get_usb_power_supply(dwc);
+	if (IS_ERR(dwc->usb_psy))
+		return dev_err_probe(dev, PTR_ERR(dwc->usb_psy), "couldn't get usb power supply\n");
+
 	dwc->reset = devm_reset_control_array_get_optional_shared(dev);
 	if (IS_ERR(dwc->reset))
 		return PTR_ERR(dwc->reset);


