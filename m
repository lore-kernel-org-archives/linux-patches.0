Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E903B9D9D;
	Tue, 21 Jul 2026 22:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671494; cv=none; b=KlIoNkzy3vrk8PkhLezZRuE3Ohi1dbW2jqMBvsmKh7trgbdcsoyu1JEohsJauFfcv/zOW9QKuqS2vrU2m83cPjT+ZTj3wArhkUKN3XMSO74t2ulJhKiuS7haH1PpxL4Nigbimhg+oEvq6SnhVDKlT5T1Dmi2UVrj7w3mcNHCDfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671494; c=relaxed/simple;
	bh=lTbMOU3k696o0h1Jrd1g0Hx79tFrKzJ5WOJX8I0+e2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlAnS9AdMkQ6Z4x8XM/xoWDATnXKslzfWw/SoejWB+HvZlxMQRPTBspcBbiTLdj0eg8XIKTKIVqEuiZ3fDrP8u1tO95RE5xBnNKeyBEblUu2OU+SE0sZdTwBZH6+VsiyYGGbl9BHpjXejGP24vu9b41ZlDbFcYCUk1JZvQ3EnfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7X5Rf/z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7X5Rf/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4441F000E9;
	Tue, 21 Jul 2026 22:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671493;
	bh=3qPABRONAZ4x/GupdXonCMYLEO7OmucQughjTrApq88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7X5Rf/zdRxegZ70Qx2+Htibm14NlBlsQuX+JiWUHHEkTn+/r8R5xd4ifVZuye4Ss
	 O8hsjsbLenmXOsLuMGZKEqz4eKCVXP8GDkiM4P1ySDa7QwOIfaECOLKg2hAdyGeaj+
	 EcXgPSIHkgvh+In3oHN8lOMNY1+53Dodh6bcQfxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 224/843] watchdog: sp5100_tco: Use EFCH MMIO for newer Hygon FCH
Date: Tue, 21 Jul 2026 17:17:39 +0200
Message-ID: <20260721152411.053605567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Yingjie Gao <gaoyingjie@uniontech.com>

[ Upstream commit 4f675f036cd5e9cfbe6df5f24f8338158af96a4b ]

Commit 009637de1f65 ("watchdog: sp5100_tco: support Hygon FCH/SCH
(Server Controller Hub)") added Hygon vendor matching to the efch
layout selection, but newer Hygon 0x790b SMBus devices still need the
efch_mmio path.

The efch_mmio path enables EFCH_PM_DECODEEN_WDT_TMREN before probing the
watchdog MMIO block. If firmware leaves that bit clear and the driver
picks the legacy efch path instead, probe falls back to the alternate
window and fails with "Watchdog hardware is disabled".

Select efch_mmio for Hygon 0x790b devices with revision 0x51 or later,
matching the equivalent AMD behavior and allowing the watchdog to
initialize on those systems.

Fixes: 009637de1f65 ("watchdog: sp5100_tco: support Hygon FCH/SCH (Server Controller Hub)")
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20260402071617.634563-2-gaoyingjie@uniontech.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sp5100_tco.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 0141858188c569..033917c332e8a1 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -85,7 +85,8 @@ static enum tco_reg_layout tco_reg_layout(struct pci_dev *dev)
 	    dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS &&
 	    dev->revision < 0x40) {
 		return sp5100;
-	} else if (dev->vendor == PCI_VENDOR_ID_AMD &&
+	} else if ((dev->vendor == PCI_VENDOR_ID_AMD ||
+		    dev->vendor == PCI_VENDOR_ID_HYGON) &&
 	    sp5100_tco_pci->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS &&
 	    sp5100_tco_pci->revision >= AMD_ZEN_SMBUS_PCI_REV) {
 		return efch_mmio;
-- 
2.53.0



