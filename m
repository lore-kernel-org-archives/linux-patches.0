Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6522E436BC6;
	Tue, 21 Jul 2026 19:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661490; cv=none; b=CosJNoZkG6WhrOkQCrjNMkoEkiTx1CHy59GPlF1ZNg8uSGg94QGiFV3MoaS3UaibrPDWVq/vegcmkl9PEGEDOsIajV4noi3OWBBF5Kcvy+O/T4V87zhLnLFgGPBG9iiXjNcvrbvpFBc5bjYazFfdur/+T8S3gVmN8gCFFQnIo7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661490; c=relaxed/simple;
	bh=Hb1XR0AFrCkJCj6HzK0X9Y3OkFPuesmU7Em9WqHkvc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnINOmYsJH99jOA3Gp/h97UvpQyGsDN2kqmZ4WvvDGahHbQWTphoLuWJYA2Ph1Ugc/rrSisyF3ibU+/aDzJ3leLxUH917yPSTWAItzrsmE083PkeBHTL0OoGA5bqyy7Y6+h/Uym8C804VaFpMiYnwQqodRwglcLULXXf2AUVzGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uK1l+4C+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uK1l+4C+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6091F000E9;
	Tue, 21 Jul 2026 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661489;
	bh=zdD+2Zp5adcgAmHlRPljYUp6R4dUbnL7zqafhTPXS14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uK1l+4C+5xMFQQu/P7Tvb/MiTR3jXyccgJeE5CVjTODmySxluKnqpJAJExPFvceFw
	 Unyvs6+7r8SMewqH/9MF2ElGuO0mZAdcMek3/kUNNSXs9NejWE9CizM5JZnxR6hJ7b
	 u78nFRLzs6UIYZx3iJElf/jZzKAXtc51ECv6Ueew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0084/1276] watchdog: sp5100_tco: Use EFCH MMIO for newer Hygon FCH
Date: Tue, 21 Jul 2026 17:08:47 +0200
Message-ID: <20260721152447.974905985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



