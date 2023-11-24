Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9E033E9;
	Fri, 24 Nov 2023 19:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVMxfbcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F76C433C7;
	Fri, 24 Nov 2023 19:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852478;
	bh=gddMZUZv3ffaXqpBc8uDm5PVjhPajYpuxv2MhePZtwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVMxfbcYYGtGfy5Sibj+irDp5PXgI2zr8cHzkfKIt0CeomsNhFB+LztX7b6xOKdeh
	 lNb/mA1jWX6XjnZDDquD4621/q1IVu+HczE/CQBHLNBieZI/+YwNp8j4vd3YlnMxCj
	 yGRKblyWAUltHyH5WPOtlUN6PNGBRRgMArm4enlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kai-Heng Feng <kai.heng.geng@canonical.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 372/372] mmc: sdhci-pci-gli: GL9755: Mask the replay timer timeout of AER
Date: Fri, 24 Nov 2023 17:52:39 +0000
Message-ID: <20231124172022.649579980@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Shih <victor.shih@genesyslogic.com.tw>

commit 85dd3af64965c1c0eb7373b340a1b1f7773586b0 upstream.

Due to a flaw in the hardware design, the GL9755 replay timer frequently
times out when ASPM is enabled. As a result, the warning messages will
often appear in the system log when the system accesses the GL9755
PCI config. Therefore, the replay timer timeout must be masked.

Fixes: 36ed2fd32b2c ("mmc: sdhci-pci-gli: A workaround to allow GL9755 to enter ASPM L1.2")
Signed-off-by: Victor Shih <victor.shih@genesyslogic.com.tw>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Kai-Heng Feng <kai.heng.geng@canonical.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231107095741.8832-3-victorshihgli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Victor Shih <victor.shih@genesyslogic.com.tw>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -154,6 +154,9 @@
 #define PCI_GLI_9755_PM_CTRL     0xFC
 #define   PCI_GLI_9755_PM_STATE    GENMASK(1, 0)
 
+#define PCI_GLI_9755_CORRERR_MASK				0x214
+#define   PCI_GLI_9755_CORRERR_MASK_REPLAY_TIMER_TIMEOUT	  BIT(12)
+
 #define GLI_MAX_TUNING_LOOP 40
 
 /* Genesys Logic chipset */
@@ -711,6 +714,11 @@ static void gl9755_hw_setting(struct sdh
 	value &= ~PCI_GLI_9755_PM_STATE;
 	pci_write_config_dword(pdev, PCI_GLI_9755_PM_CTRL, value);
 
+	/* mask the replay timer timeout of AER */
+	pci_read_config_dword(pdev, PCI_GLI_9755_CORRERR_MASK, &value);
+	value |= PCI_GLI_9755_CORRERR_MASK_REPLAY_TIMER_TIMEOUT;
+	pci_write_config_dword(pdev, PCI_GLI_9755_CORRERR_MASK, value);
+
 	gl9755_wt_off(pdev);
 }
 


