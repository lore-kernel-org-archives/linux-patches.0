Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE4C3BCD0A;
	Fri,  4 Sep 2026 05:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501383; cv=none; b=Xo1Cw07T6IYo/rgJGCnEYaczZ2kT7usEzoHBl5nE1PUhGVV3onuUoZp72Brj09vOkGdWxLau0E5k8o3TIKrR/pkFXj5jiCWLmQ06MQA3Uocnh0iCq2jjsdLRRo8pLOmIBv91EflFXYUoOfWsibbLTwmau/KnznJwKJjksO9xjQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501383; c=relaxed/simple;
	bh=sHy645F/99D7tGx3536/+7zi6BgioHRbdkQbBiW9IcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQbpXiOlESbO8F5lxcbQ9LiFnht6LRoNHV4wBesbfFo1I5gx2+sXuvEcwyHIIR/dq6EOEBVwRK1Ebcux1ivr2jaiurPMVladjpwC1oJ4Jyrheu7q/xIvMp8zQLqJKlmxyvMu4NLXkiAh7kMGEuniEjH0uMxfI5dyPENee8TeUv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8l6fUrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8l6fUrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333751F00A3D;
	Fri,  4 Sep 2026 05:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501381;
	bh=n53tZvxCSQwMKaMuBlyBxIcmHDDMfC5stBEstp9mTmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8l6fUrvJtWIJs+HDX1+SVF221WfXLcmx4zGTj7bD9mjgFEDZXVndXv+GyirYHNSS
	 ld9YUPoOITGFmHfovfhOB6D2zrSfLLRyMvo4urH3obTwm2ymJ+IRiACGOq0ysBpp6/
	 uvx0qs0uIHiN5QHgWZWdpx9lxggW36mZyvckBxg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Claveau <linux-kernel-dev@aliel.fr>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.18 388/552] PCI: meson: Fix GPIO state while requesting PERST#
Date: Fri,  4 Sep 2026 06:59:05 +0200
Message-ID: <20260904045759.004959458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronald Claveau <linux-kernel-dev@aliel.fr>

commit 40fb390cbcc11797c44c16dabdf763ec87643671 upstream.

Meson devicetree defines the PERST# GPIO as 'reset' GPIO.  Commit
4d3186a525b3 ("PCI: amlogic: Fix reset assertion via gpio descriptor")
inverted the PERST# assertion logic to use proper GPIO descriptor semantics
and moved the polarity configuration to the device tree as GPIO_ACTIVE_LOW.
However, the initial PERST# GPIO state "GPIOD_OUT_LOW" was not updated
accordingly.

This results in the enumeration failure of the endpoint devices as
PERST# would get deasserted while requesting the GPIO even before
power and REFCLK becomes stable.

Without this fix:

  ahci 0000:01:00.0: enabling device (0000 -> 0002)
  ahci 0000:01:00.0: SSS flag set, parallel bus scan disabled
  ahci 0000:01:00.0: Controller reset failed (0xffffffff)
  ahci 0000:01:00.0: probe with driver ahci failed with error -5

With this fix:

  ahci 0000:01:00.0: enabling device (0000 -> 0002)
  ahci 0000:01:00.0: AHCI vers 0001.0300, 32 command slots, 6 Gbps, SATA mode
  ahci 0000:01:00.0: 1/1 ports implemented (port mask 0x1)
  ahci 0000:01:00.0: flags: 64bit ncq led clo only pio ccc

Change the GPIO request flag from GPIOD_OUT_LOW to GPIOD_OUT_HIGH to get
the right behaviour.

Fixes: 4d3186a525b3 ("PCI: amlogic: Fix reset assertion via gpio descriptor")
Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
[mani: CCed stable and commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260616-fix-meson-pcie-reset-gpio-v1-1-fca404b4c8be@aliel.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-meson.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -402,7 +402,7 @@ static int meson_pcie_probe(struct platf
 		return PTR_ERR(mp->phy);
 	}
 
-	mp->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	mp->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(mp->reset_gpio)) {
 		dev_err(dev, "get reset gpio failed\n");
 		return PTR_ERR(mp->reset_gpio);


