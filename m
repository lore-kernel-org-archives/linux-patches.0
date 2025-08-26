Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5427E1FECAB;
	Tue, 26 Aug 2025 11:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208590; cv=none; b=QytW1bj3OttmcZDgm4kitCq8VmNdkHtPMwF5BfnucLHuivjcLSQ4k/CcngYoGiys9FMpX+uH32cPt8p2RDBwOimHap8EiLZPxlp7T8WjuR5n9bIG1s+VdUHDWliYfB2tzekMYbXg14cQwj8VCCDl2GA2Mg9404SkQlybqToXPsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208590; c=relaxed/simple;
	bh=j91ZgInV8bTta/g11aqBkgXk4S0M5J0n4UpyqxM5vFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/bnQMnOMA80lHg9YNlwBq1J8LEtHwRURoJXnR6TQFDLnyJqkiUJhF6CjZRmBddoBnaDiw5hpd/J/xCnoJXPHAtszJA6/oga4/233O0mBnk+PT+bjDdJX6io6HAljTNI4bs4h8WE0xBC0TSWHvHBbitL/wpDIZVZ84gjmrvvHfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhZ+BIz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhZ+BIz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1DCC4CEF1;
	Tue, 26 Aug 2025 11:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208590;
	bh=j91ZgInV8bTta/g11aqBkgXk4S0M5J0n4UpyqxM5vFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhZ+BIz4ID85pQZ2bD4gEfiZXoZvLGWgCvxamGD1DqdbWoZqLrtmyRrV2LUvMoxqN
	 je+gfrJNvvtUf8k7BOMZlsjeBxniVEZfNTUoEID/Hw256ZweZRuhlbOo2Vwcz3ka40
	 fzXNyw7VgaTuY+6t1ebUoSF3H/sw3564I6vo6cfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 168/322] mmc: sdhci-pci-gli: GL9763e: Mask the replay timer timeout of AER
Date: Tue, 26 Aug 2025 13:09:43 +0200
Message-ID: <20250826110919.982339018@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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
@@ -1364,6 +1364,9 @@ static void gli_set_gl9763e(struct sdhci
 	value |= FIELD_PREP(GLI_9763E_HS400_RXDLY, GLI_9763E_HS400_RXDLY_5);
 	pci_write_config_dword(pdev, PCIE_GLI_9763E_CLKRXDLY, value);
 
+	/* mask the replay timer timeout of AER */
+	sdhci_gli_mask_replay_timer_timeout(pdev);
+
 	pci_read_config_dword(pdev, PCIE_GLI_9763E_VHS, &value);
 	value &= ~GLI_9763E_VHS_REV;
 	value |= FIELD_PREP(GLI_9763E_VHS_REV, GLI_9763E_VHS_REV_R);


