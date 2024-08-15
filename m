Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A89063D5;
	Thu, 15 Aug 2024 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732465; cv=none; b=qa6mevk1zwEhndzzTN8rTUkfwoW2fkOUKahR+reDmFydVUcLUbAobPgzUlyYWCC5nY8j8sLMkbsaMeEIbAE4DFQxGv9wmsukpHX2732pk3VnPg067mqYaX0aFKwFizg8+QgBEDW6CTkWAKqgo2nTxNpye5Aj6+RhNunoJlekCv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732465; c=relaxed/simple;
	bh=5iPikVGRUJ/eYOCJrpouDGddRUtvyC5e7XNVq4TZ0L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l5mq1AhI83kebni1OWNBZiuRPGinCZPiLGFfbc2ImF0q25OuRvQ4+uxcUoLSd1zKgyAgUCSK2Zolj4C9rj8br5pDx7JP4suCA9Oa5532YsIaPIn13ag5HMyJm5WCkkQuJtdUQAnFHzoNGjmm5OhTBitePjgH+KI8K8swjtMe0ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzQKKhYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzQKKhYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0956AC32786;
	Thu, 15 Aug 2024 14:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732465;
	bh=5iPikVGRUJ/eYOCJrpouDGddRUtvyC5e7XNVq4TZ0L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzQKKhYQLWBw08OMzjiFm69VBH/maNBu9aYPElSOfUZ/9aHsHkMmlMMID6w1c4/Vo
	 V1DOqoEldI2Qh/Cfye4aTgMBKANJEERr7k/aKwYfBTAByYZVFIlj3uEVlHL6vrLjm4
	 zcoEtIGG2mWFs5uunlIESYLG6YBlZBSJuDEsIHsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 147/352] leds: ss4200: Convert PCIBIOS_* return codes to errnos
Date: Thu, 15 Aug 2024 15:23:33 +0200
Message-ID: <20240815131924.943238423@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit ce068e83976140badb19c7f1307926b4b562fac4 upstream.

ich7_lpc_probe() uses pci_read_config_dword() that returns PCIBIOS_*
codes. The error handling code assumes incorrectly it's a normal errno
and checks for < 0. The return code is returned from the probe function
as is but probe functions should return normal errnos.

Remove < 0 from the check and convert PCIBIOS_* returns code using
pcibios_err_to_errno() into normal errno before returning it.

Fixes: a328e95b82c1 ("leds: LED driver for Intel NAS SS4200 series (v5)")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240527132700.14260-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-ss4200.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -356,8 +356,10 @@ static int ich7_lpc_probe(struct pci_dev
 
 	nas_gpio_pci_dev = dev;
 	status = pci_read_config_dword(dev, PMBASE, &g_pm_io_base);
-	if (status)
+	if (status) {
+		status = pcibios_err_to_errno(status);
 		goto out;
+	}
 	g_pm_io_base &= 0x00000ff80;
 
 	status = pci_read_config_dword(dev, GPIO_CTRL, &gc);
@@ -369,8 +371,9 @@ static int ich7_lpc_probe(struct pci_dev
 	}
 
 	status = pci_read_config_dword(dev, GPIO_BASE, &nas_gpio_io_base);
-	if (0 > status) {
+	if (status) {
 		dev_info(&dev->dev, "Unable to read GPIOBASE.\n");
+		status = pcibios_err_to_errno(status);
 		goto out;
 	}
 	dev_dbg(&dev->dev, ": GPIOBASE = 0x%08x\n", nas_gpio_io_base);


