Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DD846AA60;
	Tue, 21 Jul 2026 15:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648215; cv=none; b=anbML+o0KOwM4v1MtKON3NEyRa7fCOnMnvitCHmIFkctGhLs6iHcNb9h73n6NQh6IPmJcgyJavg4eoe+53GmMAC1zRwkBYbAnolhl9lEmdcMcJuNbIs9u+Pwn3FSgE7FLjs/z6HwqJS+5OhlpRETvIM/0YylevxxK5mR+pCOG4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648215; c=relaxed/simple;
	bh=UiXuYxp7cup5S/5Jvf3hytaXvwQ0GjG7dROi/FHsQhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDdPxwOd3zauBrCtOO4q5EGUGpQ029Pcfn/LDc4nVWel/dmq2iDGjNndmqFVKpdiOpmCzB1n40origI6ETqs/COvmG3vM7KPmffKny4Wz2y93qNT2iCdfddu26oDWqXcBR5rLPJ8CuWwHtnQTqebFERuf5WlAKJjcsUJeAQxNFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbgKw3gF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbgKw3gF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29701F000E9;
	Tue, 21 Jul 2026 15:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648214;
	bh=PhF64J6MLZC4yA+KcZXYKYy7c/022wj5HUZH7YAYBRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbgKw3gFomHiYO8mZmt0Mu0l72TvyJRN9KxmIJJgj9cRWH0p1Vvy5sv1Fhp4+eER2
	 mBguAbZl0GmWIjf8nFYjwpMNzwSSvgrDQf4UfF0UTPkzrviCUiNX0pZ/75hxvAf0XD
	 2lPFofgk1KL64IBe9nX2DDCmjVQuFF41vWtGjPrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0114/2077] watchdog: sp5100_tco: Use EFCH MMIO for newer Hygon FCH
Date: Tue, 21 Jul 2026 16:56:27 +0200
Message-ID: <20260721152555.385990983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index 2bd3dc25cb0304..7e99c3b1f3676b 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -92,7 +92,8 @@ static enum tco_reg_layout tco_reg_layout(struct pci_dev *dev)
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



