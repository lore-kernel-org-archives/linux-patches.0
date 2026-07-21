Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF72344AB7F;
	Tue, 21 Jul 2026 21:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668858; cv=none; b=oIjA4kfr/4IQpgiYFEzE3EkSc4ExTvgDMMgtqQTVTPJtwNe4KjJnR5/I/Wzc4tGi1Omw9hOVRvX/hQWxwtREWTmi6NWzaxO2A9zvUG4vKznUwIPw/CXiNFN64os9rQ/2bNZQc80qc3ONDZpsnIMyo0OEYGz/O566RkNiVSzFE+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668858; c=relaxed/simple;
	bh=ralh8AWJWFDDbS+WEFEntIiUrNWps8PdROMxyZSK8+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSNE+7oWYFeqgjxcOjHiFKo6b66PtJSidMI0j3IwzEt9eKOw3KS2D1zWXViM/nMITRv+E2DB1dAxk+96DZscfD+HO8fDh1zaX96T9xgz+mK4VwvsZNI20is3OPEnQ9iJ14xk+IaFRSE2w8yJp/O74fwDIQF1bYnSBG39riePVoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ue6EslwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ue6EslwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304CD1F000E9;
	Tue, 21 Jul 2026 21:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668855;
	bh=FlzRXH9PoLJRTqnLNXp0iA1AR0URxuNDb4o2g+WteHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ue6EslwQcCoc1zR0/5sIBY+Rfourcpudt/kQ1UUble+Tu3RNHzs6hr3W4q4mQp1kR
	 LODi1S1/WlzKkt1a3XlidMDKwcSoXlY0uQSt4/HXs6V+GXuF+LGI6c6fy0lbgUdBZU
	 sSOrHGDRjhMKF+HLPFwtVKJ08izfj8zc9NtXfCPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0291/1067] watchdog: sp5100_tco: Use EFCH MMIO for newer Hygon FCH
Date: Tue, 21 Jul 2026 17:14:52 +0200
Message-ID: <20260721152431.114353066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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



