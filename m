Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285803203BE;
	Mon, 18 Aug 2025 13:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522863; cv=none; b=pKMEdeJw2uCTb6vzEPZmHUGfUyCSt3Tbc6AHXh8ypUucAhjUFuIiTgDuznRmdhU/vI4CJWXLc9r4ReclkPQ3UIBMOufBj1h+GmhfogpC0lmMrvEE0dwOwsA8eP/ViRn+HYc6dFPeVSCReFn8yqVTexRPpMa6JsP2JMnF21G/sas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522863; c=relaxed/simple;
	bh=YEAVy3RiVmUDH6BlXDL/BdKY1HqC1gU6A9pxFMq+TgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IulC8L1cF9+pBXxZF617fXzMlCBQoH3c3adB/DruV16ZCQbG1QcZfaq7CYdY/o8W6RVHE1DTPy8L5trSPoFqWz5uNgH+fLS6hXWBfttlLoU26tbLv0y0BLlObL+Z4L5dhZeU0GufFbVYNX8PPT4+A29qwUa8lPIavka89Lbw1g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOBJdRuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOBJdRuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D157C113D0;
	Mon, 18 Aug 2025 13:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522863;
	bh=YEAVy3RiVmUDH6BlXDL/BdKY1HqC1gU6A9pxFMq+TgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOBJdRuWOTbSyvmET0eYGIQw/l2agDfjvwCuK75zFC7g98cvQW4a9qg/CAycp0RWi
	 J3EAvhzvYmJuIGA1O9Jxzy+dMHCu0/pux8JGZhPOepzAykG+WI+UmIbdorYLEL8aEe
	 8HyNAYRARvtyTZPKELM6zQXDRlgVzbGRfcKixbE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <niks@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 444/444] PCI: Honor Max Link Speed when determining supported speeds
Date: Mon, 18 Aug 2025 14:47:50 +0200
Message-ID: <20250818124505.608319775@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit 3202ca221578850f34e0fea39dc6cfa745ed7aac upstream.

The Supported Link Speeds Vector in the Link Capabilities 2 Register
indicates the *supported* link speeds.  The Max Link Speed field in the
Link Capabilities Register indicates the *maximum* of those speeds.

pcie_get_supported_speeds() neglects to honor the Max Link Speed field and
will thus incorrectly deem higher speeds as supported.  Fix it.

One user-visible issue addressed here is an incorrect value in the sysfs
attribute "max_link_speed".

But the main motivation is a boot hang reported by Niklas:  Intel JHL7540
"Titan Ridge 2018" Thunderbolt controllers supports 2.5-8 GT/s speeds,
but indicate 2.5 GT/s as maximum.  Ilpo recalls seeing this on more
devices.  It can be explained by the controller's Downstream Ports
supporting 8 GT/s if an Endpoint is attached, but limiting to 2.5 GT/s
if the port interfaces to a PCIe Adapter, in accordance with USB4 v2
sec 11.2.1:

   "This section defines the functionality of an Internal PCIe Port that
    interfaces to a PCIe Adapter. [...]
    The Logical sub-block shall update the PCIe configuration registers
    with the following characteristics: [...]
    Max Link Speed field in the Link Capabilities Register set to 0001b
    (data rate of 2.5 GT/s only).
    Note: These settings do not represent actual throughput. Throughput
    is implementation specific and based on the USB4 Fabric performance."

The present commit is not sufficient on its own to fix Niklas' boot hang,
but it is a prerequisite:  A subsequent commit will fix the boot hang by
enabling bandwidth control only if more than one speed is supported.

The GENMASK() macro used herein specifies 0 as lowest bit, even though
the Supported Link Speeds Vector ends at bit 1.  This is done on purpose
to avoid a GENMASK(0, 1) macro if Max Link Speed is zero.  That macro
would be invalid as the lowest bit is greater than the highest bit.
Ilpo has witnessed a zero Max Link Speed on Root Complex Integrated
Endpoints in particular, so it does occur in practice.  (The Link
Capabilities Register is optional on RCiEPs per PCIe r6.2 sec 7.5.3.)

Fixes: d2bd39c0456b ("PCI: Store all PCIe Supported Link Speeds")
Closes: https://lore.kernel.org/r/70829798889c6d779ca0f6cd3260a765780d1369.camel@kernel.org
Link: https://lore.kernel.org/r/fe03941e3e1cc42fb9bf4395e302bff53ee2198b.1734428762.git.lukas@wunner.de
Reported-by: Niklas Schnelle <niks@kernel.org>
Tested-by: Niklas Schnelle <niks@kernel.org>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6235,12 +6235,14 @@ u8 pcie_get_supported_speeds(struct pci_
 	pcie_capability_read_dword(dev, PCI_EXP_LNKCAP2, &lnkcap2);
 	speeds = lnkcap2 & PCI_EXP_LNKCAP2_SLS;
 
+	/* Ignore speeds higher than Max Link Speed */
+	pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &lnkcap);
+	speeds &= GENMASK(lnkcap & PCI_EXP_LNKCAP_SLS, 0);
+
 	/* PCIe r3.0-compliant */
 	if (speeds)
 		return speeds;
 
-	pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &lnkcap);
-
 	/* Synthesize from the Max Link Speed field */
 	if ((lnkcap & PCI_EXP_LNKCAP_SLS) == PCI_EXP_LNKCAP_SLS_5_0GB)
 		speeds = PCI_EXP_LNKCAP2_SLS_5_0GB | PCI_EXP_LNKCAP2_SLS_2_5GB;


