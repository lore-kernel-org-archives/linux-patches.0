Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FBB1FB3E1;
	Wed,  6 Nov 2024 12:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897601; cv=none; b=Jj5EYrL/tOKpWxc/Gp3UgVCg4tRAZMS2mHwQv6lUy69u0MWBFtZ+T03GiQclLVyXMVac54htszjsD4TnFpuvxtQ5apbSu71HWqnQsYa8REBzxjPI2QtpFCp7n+mJGIqSuQE3yCw7y22d7lM3BEDKYgmUP9qEWzypHzuABrJnCXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897601; c=relaxed/simple;
	bh=nhlbmUuiV6hCI0s7r4xBYJnxn1eEjEaFEtdpDAwMPXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCGiK5prpHCxX+vslGg5v01Z5hEHRcjO9yAsYCv7GLhVZfWtXNVGdgOQ7LHpOCVIE2rfYshmBuhAmgBjIRd5qmRrtPuHeg+pLtiww1THu/Q9qAkyK5tE4f9i5FmKfHMp6cZkt4ODXt4L5a5UIGkkL8UV7UdXxpsgFFUCUyYybQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oE8vR53V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oE8vR53V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE90AC4CECD;
	Wed,  6 Nov 2024 12:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897601;
	bh=nhlbmUuiV6hCI0s7r4xBYJnxn1eEjEaFEtdpDAwMPXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oE8vR53VrqOaqzbtD4rSXMtlZnIHZzKIqLTOKEbvrQ/V/moBMk8oyBJMRLuX7TmJg
	 iJmHrckkusFWBWJ92D8oMlgV71t61N7XcRMFKlPimkZpeQm4PtCtSO1BDu0KlB+LKn
	 0e3cwq0NYRTnrlrBymTBZ2dmuwh4uqwILo3Jkr5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Ben Chuang <ben.chuang@genesyslogic.com.tw>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 107/151] mmc: sdhci-pci-gli: GL9767: Fix low power mode on the set clock function
Date: Wed,  6 Nov 2024 13:04:55 +0100
Message-ID: <20241106120311.814798695@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Chuang <ben.chuang@genesyslogic.com.tw>

commit 8c68b5656e55e9324875881f1000eb4ee3603a87 upstream.

On sdhci_gl9767_set_clock(), the vendor header space(VHS) is read-only
after calling gl9767_disable_ssc_pll() and gl9767_set_ssc_pll_205mhz().
So the low power negotiation mode cannot be enabled again.
Introduce gl9767_set_low_power_negotiation() function to fix it.

The explanation process is as below.

static void sdhci_gl9767_set_clock()
{
	...
        gl9767_vhs_write();
        ...
	value |= PCIE_GLI_9767_CFG_LOW_PWR_OFF;
        pci_write_config_dword(pdev, PCIE_GLI_9767_CFG, value); <--- (a)

        gl9767_disable_ssc_pll(); <--- (b)
        sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);

        if (clock == 0)
                return;  <-- (I)

	...
        if (clock == 200000000 && ios->timing == MMC_TIMING_UHS_SDR104) {
		...
                gl9767_set_ssc_pll_205mhz(); <--- (c)
        }
	...
	value &= ~PCIE_GLI_9767_CFG_LOW_PWR_OFF;
        pci_write_config_dword(pdev, PCIE_GLI_9767_CFG, value); <-- (II)
        gl9767_vhs_read();
}

(a) disable low power negotiation mode. When return on (I), the low power
mode is disabled.  After (b) and (c), VHS is read-only, the low power mode
cannot be enabled on (II).

Reported-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Fixes: d2754355512e ("mmc: sdhci-pci-gli: Set SDR104's clock to 205MHz and enable SSC for GL9767")
Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Tested-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Message-ID: <20241025060017.1663697-1-benchuanggli@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -902,28 +902,40 @@ static void gl9767_disable_ssc_pll(struc
 	gl9767_vhs_read(pdev);
 }
 
+static void gl9767_set_low_power_negotiation(struct pci_dev *pdev, bool enable)
+{
+	u32 value;
+
+	gl9767_vhs_write(pdev);
+
+	pci_read_config_dword(pdev, PCIE_GLI_9767_CFG, &value);
+	if (enable)
+		value &= ~PCIE_GLI_9767_CFG_LOW_PWR_OFF;
+	else
+		value |= PCIE_GLI_9767_CFG_LOW_PWR_OFF;
+	pci_write_config_dword(pdev, PCIE_GLI_9767_CFG, value);
+
+	gl9767_vhs_read(pdev);
+}
+
 static void sdhci_gl9767_set_clock(struct sdhci_host *host, unsigned int clock)
 {
 	struct sdhci_pci_slot *slot = sdhci_priv(host);
 	struct mmc_ios *ios = &host->mmc->ios;
 	struct pci_dev *pdev;
-	u32 value;
 	u16 clk;
 
 	pdev = slot->chip->pdev;
 	host->mmc->actual_clock = 0;
 
-	gl9767_vhs_write(pdev);
-
-	pci_read_config_dword(pdev, PCIE_GLI_9767_CFG, &value);
-	value |= PCIE_GLI_9767_CFG_LOW_PWR_OFF;
-	pci_write_config_dword(pdev, PCIE_GLI_9767_CFG, value);
-
+	gl9767_set_low_power_negotiation(pdev, false);
 	gl9767_disable_ssc_pll(pdev);
 	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
 
-	if (clock == 0)
+	if (clock == 0) {
+		gl9767_set_low_power_negotiation(pdev, true);
 		return;
+	}
 
 	clk = sdhci_calc_clk(host, clock, &host->mmc->actual_clock);
 	if (clock == 200000000 && ios->timing == MMC_TIMING_UHS_SDR104) {
@@ -932,12 +944,7 @@ static void sdhci_gl9767_set_clock(struc
 	}
 
 	sdhci_enable_clk(host, clk);
-
-	pci_read_config_dword(pdev, PCIE_GLI_9767_CFG, &value);
-	value &= ~PCIE_GLI_9767_CFG_LOW_PWR_OFF;
-	pci_write_config_dword(pdev, PCIE_GLI_9767_CFG, value);
-
-	gl9767_vhs_read(pdev);
+	gl9767_set_low_power_negotiation(pdev, true);
 }
 
 static void gli_set_9767(struct sdhci_host *host)


