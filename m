Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9AF339BE;
	Fri, 24 Nov 2023 19:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHEhuPWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485F7C433C8;
	Fri, 24 Nov 2023 19:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853653;
	bh=aPXeT0BHA9U/fx7kv/42lQfiQId7C1lqT+7wl+ixO9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHEhuPWdxCK3Ihrm1UaN6NhvWvyeznUnPm3qxbYuWmpzo0O+fBVdYDFMyfrBgmVG5
	 SC4izDkEWKdxu2Bx438A8XBjHmjW74I3J9+k5nfplEMfqxJWDxT6CYcePSLKlrpj4H
	 Nu1GutswYCAhA8p1KMfFcbjGu4/vjT/BwaEXxrVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kai-Heng Feng <kai.heng.geng@canonical.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 275/297] mmc: sdhci-pci-gli: GL9750: Mask the replay timer timeout of AER
Date: Fri, 24 Nov 2023 17:55:17 +0000
Message-ID: <20231124172009.752007983@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Victor Shih <victor.shih@genesyslogic.com.tw>

commit 015c9cbcf0ad709079117d27c2094a46e0eadcdb upstream.

Due to a flaw in the hardware design, the GL9750 replay timer frequently
times out when ASPM is enabled. As a result, the warning messages will
often appear in the system log when the system accesses the GL9750
PCI config. Therefore, the replay timer timeout must be masked.

Fixes: d7133797e9e1 ("mmc: sdhci-pci-gli: A workaround to allow GL9750 to enter ASPM L1.2")
Signed-off-by: Victor Shih <victor.shih@genesyslogic.com.tw>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Kai-Heng Feng <kai.heng.geng@canonical.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231107095741.8832-2-victorshihgli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -26,6 +26,9 @@
 #define PCI_GLI_9750_PM_CTRL	0xFC
 #define   PCI_GLI_9750_PM_STATE	  GENMASK(1, 0)
 
+#define PCI_GLI_9750_CORRERR_MASK				0x214
+#define   PCI_GLI_9750_CORRERR_MASK_REPLAY_TIMER_TIMEOUT	  BIT(12)
+
 #define SDHCI_GLI_9750_CFG2          0x848
 #define   SDHCI_GLI_9750_CFG2_L1DLY    GENMASK(28, 24)
 #define   GLI_9750_CFG2_L1DLY_VALUE    0x1F
@@ -446,6 +449,11 @@ static void gl9750_hw_setting(struct sdh
 	value &= ~PCI_GLI_9750_PM_STATE;
 	pci_write_config_dword(pdev, PCI_GLI_9750_PM_CTRL, value);
 
+	/* mask the replay timer timeout of AER */
+	pci_read_config_dword(pdev, PCI_GLI_9750_CORRERR_MASK, &value);
+	value |= PCI_GLI_9750_CORRERR_MASK_REPLAY_TIMER_TIMEOUT;
+	pci_write_config_dword(pdev, PCI_GLI_9750_CORRERR_MASK, value);
+
 	gl9750_wt_off(host);
 }
 


