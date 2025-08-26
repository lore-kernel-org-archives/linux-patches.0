Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793F02BE653;
	Tue, 26 Aug 2025 11:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207591; cv=none; b=FzsG8PKBflPbKWD5WQeiYeAL0BJT9QUonRFfumAL1NdhxvC2nYWf0+7/vAhiIrf2VziYYXTvExp4eAiRbqNJ9whEJeZMaoDv5upjuc5LIosw15yrsaMSvaxHq7PyuCGfaKt5IxkpuvowSf1qxmZzsbZvcsj2cJaez1DPVtP1X6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207591; c=relaxed/simple;
	bh=BlfVSWm7T+gneqGaQ0iE7i5ncaAqwvx3oNuJVU/JS8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuYYnTkLN6Am5k/7IJw22puOAC430i7/eGTxB/JgsN1Bw9GdPCoSiFbI6Zb7b0fhRGd2LIxTwdZwl0I6gTpxJ6U4rsr24g/hhDQgvWWU3d7WZTjOCSGNKV/WmVMlb0qj2/s7sFZAEqQckY+VqGqNQprdqpsb8R982XR3aIP7OE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+kTaoHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+kTaoHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EA1C4CEF1;
	Tue, 26 Aug 2025 11:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207591;
	bh=BlfVSWm7T+gneqGaQ0iE7i5ncaAqwvx3oNuJVU/JS8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+kTaoHMvBsf5iCJNZKiI6gQt8GvI7bG8sTgsR+jRMXUSfJ4lEOmGprVr3IkCas79
	 Q8AlUP+CwwetvtLv3QY29AvmTwP8czhWaKI2/IHlt4ew/HwofEV9379+z0D3MaRG/h
	 YtNFXZmQMa1oNvCoBr121aF67Oftw5QTA7gLPdug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.16 241/457] mmc: sdhci-pci-gli: GL9763e: Mask the replay timer timeout of AER
Date: Tue, 26 Aug 2025 13:08:45 +0200
Message-ID: <20250826110943.328128207@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Shih <victor.shih@genesyslogic.com.tw>

commit 340be332e420ed37d15d4169a1b4174e912ad6cb upstream.

Due to a flaw in the hardware design, the GL9763e replay timer frequently
times out when ASPM is enabled. As a result, the warning messages will
often appear in the system log when the system accesses the GL9763e
PCI config. Therefore, the replay timer timeout must be masked.

Signed-off-by: Victor Shih <victor.shih@genesyslogic.com.tw>
Fixes: 1ae1d2d6e555 ("mmc: sdhci-pci-gli: Add Genesys Logic GL9763E support")
Cc: stable@vger.kernel.org
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250731065752.450231-4-victorshihgli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -1782,6 +1782,9 @@ static void gli_set_gl9763e(struct sdhci
 	value |= FIELD_PREP(GLI_9763E_HS400_RXDLY, GLI_9763E_HS400_RXDLY_5);
 	pci_write_config_dword(pdev, PCIE_GLI_9763E_CLKRXDLY, value);
 
+	/* mask the replay timer timeout of AER */
+	sdhci_gli_mask_replay_timer_timeout(pdev);
+
 	pci_read_config_dword(pdev, PCIE_GLI_9763E_VHS, &value);
 	value &= ~GLI_9763E_VHS_REV;
 	value |= FIELD_PREP(GLI_9763E_VHS_REV, GLI_9763E_VHS_REV_R);


