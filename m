Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B53335BAD;
	Mon, 18 Aug 2025 13:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524771; cv=none; b=WVLG1LWWj2lGotIue8WXMDSK/y31uy8a2u/O5DBmfsAXIfC7EGTHZ+jZwexc/hNFAdRmoWSTf6wwhIDCfzIUwDbk/huzObnjaUHrHWROqedbPxAzI4QORg1BlQP5NZRA3bfTwT40y6HHWPAnlaMg4XDeB+s1H8TBOcrmnSUpWW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524771; c=relaxed/simple;
	bh=vJkVNzx1qVldU51b8ccLichFY1/riL3TZmWXzHFyYSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwE+QXuhjmoTp7lG3jrnBR5MFsBLOotgwZngv/jIOeNU+EzEiN0jbWxuBFKyUStf4gww3oKiVUF9wZ0XYuu5oBlNTmkBedkTtcMy4vALvBLn9vdpSIK02yykfChEqi4j/LZvfkR0nu9CUb8xN8y8fPcXydLpJ56Z7iil/h6zfkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o95Kh4Md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o95Kh4Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B469C4CEEB;
	Mon, 18 Aug 2025 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524770;
	bh=vJkVNzx1qVldU51b8ccLichFY1/riL3TZmWXzHFyYSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o95Kh4MdP8E7JcwiL9KfmJ8bOSKj9UF8qkzAZs2JdWksoQ2eEXMGvN0VIdRBKcWDT
	 nyoHP4WDgTDmlOVdVJEGfybCW1zzU46nBpPTP8cEcEyvzGR4sve+e35UAY5/8qUyml
	 ZeGWlBu2aJpzSfoV4sj9xSv3b9iZcfU4kQaAdoTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Tom Vincent <linux@tlvince.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.16 056/570] mfd: cros_ec: Separate charge-control probing from USB-PD
Date: Mon, 18 Aug 2025 14:40:43 +0200
Message-ID: <20250818124507.970805260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


