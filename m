Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2331F3FF8;
	Mon, 23 Jun 2025 21:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713358; cv=none; b=G2odq4jsDn73x92S+J0zLNT3ZxktSZCqXnPYBj/ZN4yBVKUBe6AM7uhOBoCxYqVMlLkK4YNM5aivXiEttMDQsJWn8qMnTB6txlpLbHEw9HFb/HgQwdCehkYkseeg7YKS4canR635IWUalNogglEzXaPEy02ytH1qnjkz2/agGCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713358; c=relaxed/simple;
	bh=n60aG+bdWOQWMeXyzoQMf7igex74wJaH9odel6WjSDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrBC0cLa+ja6hnaw2msl1SIkCla2wXNW0HxTccrCrK0CPTPXPaUEDho+tQBpXdfa/+F+qx47vPlDnig+iC/xLWUy4jzeJ53guq7H7KQ6VoAl4pggX+SCcGFXv6IB5S0D89qqJt8T+FscJ8v8KX/SGk560hIeZsnmI3UL9BBnpUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6+QG0Rf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6+QG0Rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230C4C4CEED;
	Mon, 23 Jun 2025 21:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713358;
	bh=n60aG+bdWOQWMeXyzoQMf7igex74wJaH9odel6WjSDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6+QG0RfMgA5eMzvPao0EJmSTtmSCAt5eJ1LLB2LEDpQqgawtddlvH3fyfoJUDbhz
	 HYZZc0zJBi4AAd/Mu/k9AbrZ/oZu9PdOh/XIkoMjih418a+GS8gHvE27b4GIeLVls6
	 tqiuZu7EwHNJOl0kblXjGlJZdhsJ8KZTDrpBoU4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liangliang Zou <rawdiamondmc@outlook.com>,
	Mingcong Bai <jeffbai@aosc.io>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.12 040/414] wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 11ad:1723
Date: Mon, 23 Jun 2025 15:02:57 +0200
Message-ID: <20250623130643.038705788@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingcong Bai <jeffbai@aosc.io>

commit 77a6407c6ab240527166fb19ee96e95f5be4d3cd upstream.

RTL8723BE found on some ASUSTek laptops, such as F441U and X555UQ with
subsystem ID 11ad:1723 are known to output large amounts of PCIe AER
errors during and after boot up, causing heavy lags and at times lock-ups:

  pcieport 0000:00:1c.5: AER: Correctable error message received from 0000:00:1c.5
  pcieport 0000:00:1c.5: PCIe Bus Error: severity=Correctable, type=Physical Layer, (Receiver ID)
  pcieport 0000:00:1c.5:   device [8086:9d15] error status/mask=00000001/00002000
  pcieport 0000:00:1c.5:    [ 0] RxErr

Disable ASPM on this combo as a quirk.

This patch is a revision of a previous patch (linked below) which
attempted to disable ASPM for RTL8723BE on all Intel Skylake and Kaby Lake
PCIe bridges. I take a more conservative approach as all known reports
point to ASUSTek laptops of these two generations with this particular
wireless card.

Please note, however, before the rtl8723be finishes probing, the AER
errors remained. After the module finishes probing, all AER errors would
indeed be eliminated, along with heavy lags, poor network throughput,
and/or occasional lock-ups.

Cc: <stable@vger.kernel.org>
Fixes: a619d1abe20c ("rtlwifi: rtl8723be: Add new driver")
Reported-by: Liangliang Zou <rawdiamondmc@outlook.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218127
Link: https://lore.kernel.org/lkml/05390e0b-27fd-4190-971e-e70a498c8221@lwfinger.net/T/
Tested-by: Liangliang Zou <rawdiamondmc@outlook.com>
Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250422061755.356535-1-jeffbai@aosc.io
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -155,6 +155,16 @@ static void _rtl_pci_update_default_sett
 	    ((u8)init_aspm) == (PCI_EXP_LNKCTL_ASPM_L0S |
 				PCI_EXP_LNKCTL_ASPM_L1 | PCI_EXP_LNKCTL_CCC))
 		ppsc->support_aspm = false;
+
+	/* RTL8723BE found on some ASUSTek laptops, such as F441U and
+	 * X555UQ with subsystem ID 11ad:1723 are known to output large
+	 * amounts of PCIe AER errors during and after boot up, causing
+	 * heavy lags, poor network throughput, and occasional lock-ups.
+	 */
+	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8723BE &&
+	    (rtlpci->pdev->subsystem_vendor == 0x11ad &&
+	     rtlpci->pdev->subsystem_device == 0x1723))
+		ppsc->support_aspm = false;
 }
 
 static bool _rtl_pci_platform_switch_device_pci_aspm(


