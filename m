Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BFD31E84B;
	Sat, 12 Sep 2026 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227475; cv=none; b=DTD21P42Gbp6dbPvuposRuFfq4XB/bcj5HwAzWTC+9OA2lD9bzd0/cTVDKQmk4pd2MjJzGt27xYOIZsBl596udW9v+3nZyvpdTrDBj/vdh8qbmw55qU0zPPO9AdieC6bwMUp7lwjIjDGW36Xd0twiieWTEguHURd5nYxdVTnfRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227475; c=relaxed/simple;
	bh=7nT0i/RBgTsG3nJQd8NBCmBAlpZdkAJOGRkTKvXxPfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdGltuaSd5B0Cf909UXud1dR5UFXuii3C/wANb0hlLdEMnoulda+7DfPY5JOv7D/2W2L92iguDvkAE7GPKV1aVNDrcaPhhxRs3SZcgQxtb66wyssMZ5h/14KB0CEvjkvxv7dvawttXWf104vGwYFpjIX05vvsVBNt/jB4Jyag2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrbaFCQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrbaFCQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC421F000FF;
	Sat, 12 Sep 2026 15:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227472;
	bh=rgDudpwgEYqyRygxBZTLLdtfUkeHC3FrRmLTkQDNg+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrbaFCQI1qNbGQfrwv5qtLymneYI7Fng1SIgvccR0DUHWmGXOAgZupV9MLOFzM0Qy
	 UG3Ky0+iy+UtTeJb40XTe4VfuuTG9/1e1CW3Mzily++uXMwe16ZGEqhIAhNsr4PNEh
	 7+345+FNtU9zHumCDcccDGOrV8eEZTWJn/iiroQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Claveau <linux-kernel-dev@aliel.fr>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 0186/1191] PCI: meson: Fix GPIO state while requesting PERST#
Date: Sat, 12 Sep 2026 08:48:34 +0200
Message-ID: <20260912065552.390983156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -415,7 +415,7 @@ static int meson_pcie_probe(struct platf
 		return PTR_ERR(mp->phy);
 	}
 
-	mp->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	mp->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(mp->reset_gpio)) {
 		dev_err(dev, "get reset gpio failed\n");
 		return PTR_ERR(mp->reset_gpio);


