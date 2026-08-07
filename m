Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8DD3DEAF6;
	Fri,  7 Aug 2026 15:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117462; cv=none; b=WveqGyC5Jy50ZPJsLPqoIicI28md//P3lnYqsBytrHKdgF3kuqxWdeiKJK1YCGi8Xu6jPibu/zFzsI8qRtDUF+DHHfUyUUzlv04ynd2gjnDHX9jfLwmFwSeVR+ELBde5SezaJb4PHTthm7GaYho3wzkowiZi7W49M0+n/lTQJl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117462; c=relaxed/simple;
	bh=Eh/i/B5x5vngecC3ir3sgnxf598ZIsJwWAXGOZrJqiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGiWcYmUUmGM7L6RTanyPVbwClGU81J1c69ENjZgukyZyjmWMSEzU/BPwdgG1/WOC8ErNq8gKrUq0sE/lRAPG849Ui/PIjn0j+ANjUDPoUHRGQaudThIgQ/0SNQQ3TTlD0jEfZsmPPKbpYt3e8ntFrvB/GI/zRgejvygVXr3674=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLaQ6Ng8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLaQ6Ng8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F241F000E9;
	Fri,  7 Aug 2026 15:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117460;
	bh=hKVuWMws6EoB10tE+JzKqMQdFCYlCAqFUpq/gqRrn/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLaQ6Ng8/XW+2BpIME6mk09N95s42f6olSJA3Yi+j1J/tNpDeeCqJ1YAl5iva4mt2
	 sxJTObV+3bZQhD3xAYTrrqjT43QptB0YwfXCkVW1eVc7/vOefhQLdpCKCDxwIEllLn
	 BlcrkpIoQMUU2FtjwzOmLsOnsYONsaFn7uLQZTN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.1 327/438] gpiolib: tolerate gpio-hogs lacking a hogging state
Date: Fri,  7 Aug 2026 16:38:43 +0200
Message-ID: <20260807143434.946923561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

commit e1cc8fa0fb9e5112d15f2c310b68ac316981c06c upstream.

Commit d1d564ec4992 ("gpio: move hogs into GPIO core") made
gpiochip_add_hog() return -EINVAL for hog nodes lacking any of the
'input', 'output-low' or 'output-high' properties. The error is
propagated by gpiochip_hog_lines() and fails registration of the
whole GPIO chip.

The previous OF-specific implementation tolerated such nodes:
of_parse_own_gpio() warned "no hogging state specified, bailing out"
and of_gpiochip_add_hog() stopped processing the node without failing
chip registration.

Some boards deliberately ship hog nodes without a hogging state in
their base devicetree and supply the state via overlay, e.g. the PCIe
slot key selection hogs on the BananaPi R4 Pro added in
commit e309fa232d12 ("arm64: dts: mediatek: mt7988a-bpi-r4pro: rework
pcie gpio-hog handling"), as the polarity set in the base devicetree
could not be overridden from an overlay.

Booting such a board without an overlay applied now fails to register
the gpiochip. On the BananaPi R4 Pro this means the MT7988A pinctrl
device fails to probe, all peripherals including the console UART
defer forever, and the board finally hangs when clk_disable_unused()
gates the clocks of the UART still in use by earlycon:

  gpiochip_add_data_with_key: GPIOs 512..595 (pinctrl_moore) failed to register, -22
  mt7988-pinctrl 1001f000.pinctrl: error -EINVAL: Failed to add gpio_chip
  ...
  clk: Disabling unused clocks
  (hangs)

Restore the previous behaviour by warning about hog nodes lacking a
hogging state and skipping them instead of failing the registration
of the whole GPIO chip.

Fixes: d1d564ec4992 ("gpio: move hogs into GPIO core")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/4c67cf0839ccf57db35a826df6d8fc779531509a.1783974733.git.daniel@makrotopia.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -975,14 +975,17 @@ int gpiochip_add_hog(struct gpio_chip *g
 	if (ret < 0)
 		return ret;
 
-	if (fwnode_property_present(fwnode, "input"))
+	if (fwnode_property_present(fwnode, "input")) {
 		dflags |= GPIOD_IN;
-	else if (fwnode_property_present(fwnode, "output-low"))
+	} else if (fwnode_property_present(fwnode, "output-low")) {
 		dflags |= GPIOD_OUT_LOW;
-	else if (fwnode_property_present(fwnode, "output-high"))
+	} else if (fwnode_property_present(fwnode, "output-high")) {
 		dflags |= GPIOD_OUT_HIGH;
-	else
-		return -EINVAL;
+	} else {
+		gpiochip_warn(gc, "%pfwP: no hogging state specified, bailing out\n",
+			      fwnode);
+		return 0;
+	}
 
 	fwnode_property_read_string(fwnode, "line-name", &name);
 


