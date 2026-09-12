Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0392E7631;
	Sat, 12 Sep 2026 13:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220653; cv=none; b=AN8qmX+vUBeIAu/d5dgujkNIhf03bGM8vvheHBzt7O3K2vhlehMVg4WSz45Gr13LfLTmxz1TnPyTn6WHRE3VZRh9QwfWiM+D6HqXMPtTOSxr4s11QqpMjPHhrERjY6RawTnlZ2sFLWHDV5tGKNGRdihp8o6A/LdriCNprotnyYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220653; c=relaxed/simple;
	bh=k8i27vP7eRYKezc2pHKb27G07MKGZIafJ7QrEmqkRXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUHGCjmTHOlgeBqPokv4NR5Cp6nlXmt8yWk7SCi8oIfh13+S958/2PUxtCz1cSPw8bJ53dH6EK7h08+5MVmCZm2A1mfryTtZ2ZtBaYCXnDgZA4praY8ZCdOlbm5euV9G3A8XJteDFe5d+W6urMROmlkSJoc3Z9cQ8O2CC/0r6Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEZe0qF/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEZe0qF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDC21F000FF;
	Sat, 12 Sep 2026 13:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220652;
	bh=zmFlu0lWs7JdLpnTQF+Dg/FmIgzM+NR9UGlDYZvxGDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEZe0qF/Mo1TiJulQhf6NRKJnvD+7ZbugD140i4jMrI7POPxAkS2C6foETQTZUzx0
	 wVHIdwLfjjX3Me+QYac9/8bAzpRdjlKNcIcui+wMHSlrJ9U/HxV/SbA+LWJPOSgDUj
	 ROjyrE87WH6MnVIBW5xPKpE15nBdEsivGTiaRu7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.6 0222/1424] PCI: Fix 32-bit config write in Intel PCH Root Port MPC ACS quirk
Date: Sat, 12 Sep 2026 08:44:14 +0200
Message-ID: <20260912065612.258167319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

commit 23d7eed5974989de56273c964d7e510e4aad91e8 upstream.

pci_quirk_enable_intel_rp_mpc_acs() reads a 32-bit DWORD from the MPC
register, sets bit 26 (INTEL_MPC_REG_IRBNCE), but it writes it back using
pci_write_config_word().

Because bit 26 resides in the upper 16 bits of the 32-bit register, a
16-bit write drops the newly set bit. The quirk logs that it is enabling
IRBNCE, but the hardware never actually receives the command.

Use pci_write_config_dword() to ensure the full 32-bit value is written
back to the hardware.

Fixes: d99321b63b1f ("PCI: Enable quirks for PCIe ACS on Intel PCH root ports")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260723171203.4892-1-raizudeen.kerneldev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5325,7 +5325,7 @@ static void pci_quirk_enable_intel_rp_mp
 	if (!(mpc & INTEL_MPC_REG_IRBNCE)) {
 		pci_info(dev, "Enabling MPC IRBNCE\n");
 		mpc |= INTEL_MPC_REG_IRBNCE;
-		pci_write_config_word(dev, INTEL_MPC_REG, mpc);
+		pci_write_config_dword(dev, INTEL_MPC_REG, mpc);
 	}
 }
 


