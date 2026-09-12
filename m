Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2C0340298;
	Sat, 12 Sep 2026 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236972; cv=none; b=GqV+wzp7eCQec6UNvOwmnzGcWPXq+JvlkNkehEQ7cuX+9pKKSIHP9zQPu6EZhtBqf+ufl6n/XARXhkhxy4VI7em9COUWjH/qikZC3z0VaNZY61+Y+yHekMpIBpZ1aO58uiDVxudUc/3hZ2CjkvRlZ34oc9+STu9q/JaGmdyY/0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236972; c=relaxed/simple;
	bh=l5wxk0Oi1bVtLCandMHAqYSDvBsTnq9Jm+5fn+ljdFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5ZTnJ17hWoxGOuDnj6Cr4RQtY0aB6E3wC+OIpVADYlMwAZa/5NiiWDs+GZC/wH42Rmapz6QCjHq7XncQJzcSyMHzSY5n0ZL7PpInHWgPC+MA49Cf7pBVFWCMh0LFyav90psxeZqyn/eajDKdEA2h98dGL9mO6bhSy18/eJFCKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/4BDvY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/4BDvY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712811F000FF;
	Sat, 12 Sep 2026 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236970;
	bh=wzzdpm75uRFCk2KLyCZsZ+bNG2kquXLXEMWkRohTZdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/4BDvY3EsQ1RgVTy+mBbCMRR2qKqzq2lVIk5OBQIvjgH1GfeLuaqkr1LB5i9YLcO
	 9YXDbGE7ZCYIiQW217jZIrTJ/4/PDUChYBdlza1japIEuLncZ+TpNvf+maNu3aEknw
	 WXVdSHVUG44ZCBhWuk0Q3r9ibmjaCSRM09sKqjyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Claveau <linux-kernel-dev@aliel.fr>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.15 162/935] PCI: meson: Fix GPIO state while requesting PERST#
Date: Sat, 12 Sep 2026 08:53:12 +0200
Message-ID: <20260912065530.535697116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


