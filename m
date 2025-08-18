Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F462765D9;
	Mon, 18 Aug 2025 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522808; cv=none; b=dJviCOzcu4Z5mXrpb6vozGLuWI1UK8CbGxhRkZzHsCAYVt6iJX0a5VYqVoBLRdHZ/0CUPpW0O7wqzkg/uhDFKaay8oSz8EJCgoeoLqFexyYz5W28C9qEOv4Pj2H3iuWGgM20Aoz9BqT/NZu3ZF7lpnf5Kpm6hPobmkIGOe+WD7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522808; c=relaxed/simple;
	bh=QpuBbwPa0wk1G/SdyTQoc8NmHazaYfC845h8qbW8Qx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q8mwm5AfaKYumfpANy7lTDaBV9Ok1TRbJB6aJ6gF54oG5u1vhjGQtsvUa2BiOZ5upH2q5LmzpeN7upOAfI0qLdI413L6JVzKX+kQn60o1q/Wzh2qhv+vQMsKgsDeOwk0N+kUlLhQCtNsmy4C19Y0+YJZJYQO1XY0LoHNKaT249o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQPVHDOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQPVHDOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305EAC4CEEB;
	Mon, 18 Aug 2025 13:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522808;
	bh=QpuBbwPa0wk1G/SdyTQoc8NmHazaYfC845h8qbW8Qx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQPVHDOmd0anDsBRQWNruu1AHUvwSuiqq40Oxb3OXYxtJ5SvYzdOMHiRe/IG6kivV
	 6T6jGIZcVKIgaJ6/VhBU8bPtT3s7vl8j9RVtl9qeWL93uho5wa+1s7ibXqxGizse8k
	 JRF4dXWFX07SCJfL4uxQS3aqqL66tdr8J3TuMSLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Tom Vincent <linux@tlvince.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 426/444] mfd: cros_ec: Separate charge-control probing from USB-PD
Date: Mon, 18 Aug 2025 14:47:32 +0200
Message-ID: <20250818124504.924446596@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -108,6 +107,10 @@ static const struct mfd_cell cros_ec_key
 	{ .name = "cros-keyboard-leds", },
 };
 
+static const struct mfd_cell cros_ec_charge_control_cells[] = {
+	{ .name = "cros-charge-control", },
+};
+
 static const struct cros_feature_to_cells cros_subdevices[] = {
 	{
 		.id		= EC_FEATURE_CEC,
@@ -144,6 +147,11 @@ static const struct cros_feature_to_cell
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


