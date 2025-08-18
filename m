Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A65322760;
	Mon, 18 Aug 2025 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523143; cv=none; b=YX05pIOo5VYjzd+1RCYZ4ayxDKaZ1M0AdakcU8YEJqDSKYlzhehdhbvUf7oMbd4mZhw5OG0eBmnscsl8Cee18COXffkU1yUckBblGB9NmS8quyy/azqaxoFH5HBDg8ojQ/mDAdp1hHXokKEKua/FjPXHBVW9IKOpjRLp2DakKH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523143; c=relaxed/simple;
	bh=kqG2unEDCEbhmLpjzdyzbOPfgUrQF1vfzZI+HlnEOwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OocMzd6PAR3/29i6pKYrPv7fAjuwsU6SQFI7cFSfGtG7q3W9RJ8Hn5dEGBeh8OFya0oNdarWFH/9u14ZmE4xLLuX/YwVxxhodehMiwmDMOwzXgAQuGPAKbfq75+Lc9Zb5jy3wjnALAlH4EZCjHD2XCAuoWlwka6fuKu/kItoTYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3Yzu3ov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3Yzu3ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A964AC4CEEB;
	Mon, 18 Aug 2025 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523143;
	bh=kqG2unEDCEbhmLpjzdyzbOPfgUrQF1vfzZI+HlnEOwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3Yzu3ov7htQjTq+yGxoyFWNRYxZj+45baF8gOM2Bct6nXBcyOVMCMiRb9fd9XVOA
	 AoCdArYEupdISJqL7dodPTcxHcWahdpz9KSvA3uul6ZmePIrE8ihoCT1VGll/KYbWK
	 BpBbSI9DSt5W2PGj7LwDqSbe3oTyd+vr+XAHhpRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Tom Vincent <linux@tlvince.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.15 052/515] mfd: cros_ec: Separate charge-control probing from USB-PD
Date: Mon, 18 Aug 2025 14:40:38 +0200
Message-ID: <20250818124500.423251226@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit e40fc1160d491c3bcaf8e940ae0dde0a7c5e8e14 upstream.

The charge-control subsystem in the ChromeOS EC is not strictly tied to
its USB-PD subsystem.

Since commit 7613bc0d116a ("mfd: cros_ec: Don't load charger with UCSI")
the presence of EC_FEATURE_UCSI_PPM would inhibit the probing of the
charge-control driver.

Furthermore recent versions of the EC firmware in Framework laptops
hard-disable EC_FEATURE_USB_PD to avoid probing cros-usbpd-charger,
which then also breaks cros-charge-control.

Instead use the dedicated EC_FEATURE_CHARGER.

Cc: stable@vger.kernel.org
Link: https://github.com/FrameworkComputer/EmbeddedController/commit/1d7bcf1d50137c8c01969eb65880bc83e424597e
Fixes: 555b5fcdb844 ("mfd: cros_ec: Register charge control subdevice")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Tested-by: Tom Vincent <linux@tlvince.com>
Link: https://lore.kernel.org/r/20250521-cros-ec-mfd-chctl-probe-v1-1-6ebfe3a6efa7@weissschuh.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/cros_ec_dev.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/mfd/cros_ec_dev.c
+++ b/drivers/mfd/cros_ec_dev.c
@@ -87,7 +87,6 @@ static const struct mfd_cell cros_ec_sen
 };
 
 static const struct mfd_cell cros_usbpd_charger_cells[] = {
-	{ .name = "cros-charge-control", },
 	{ .name = "cros-usbpd-charger", },
 	{ .name = "cros-usbpd-logger", },
 };
@@ -112,6 +111,10 @@ static const struct mfd_cell cros_ec_ucs
 	{ .name = "cros_ec_ucsi", },
 };
 
+static const struct mfd_cell cros_ec_charge_control_cells[] = {
+	{ .name = "cros-charge-control", },
+};
+
 static const struct cros_feature_to_cells cros_subdevices[] = {
 	{
 		.id		= EC_FEATURE_CEC,
@@ -148,6 +151,11 @@ static const struct cros_feature_to_cell
 		.mfd_cells	= cros_ec_keyboard_leds_cells,
 		.num_cells	= ARRAY_SIZE(cros_ec_keyboard_leds_cells),
 	},
+	{
+		.id		= EC_FEATURE_CHARGER,
+		.mfd_cells	= cros_ec_charge_control_cells,
+		.num_cells	= ARRAY_SIZE(cros_ec_charge_control_cells),
+	},
 };
 
 static const struct mfd_cell cros_ec_platform_cells[] = {


