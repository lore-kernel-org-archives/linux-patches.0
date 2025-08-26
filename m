Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AECE11187;
	Tue, 26 Aug 2025 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215239; cv=none; b=RBBHzCypWP/C0+abtyFcxj9tDyJrvngN7YlepfoLsIioSTfL8LT8g+yFbLwhbqkZMUtGAoFOuUD5WpVhRtNFTsGEjplPtPAzuVF0eWCaXueKSbMz4YODduXdAzkUnNhd8gmy68xZ/YA8Sb5KWTFIKI94O/Vt5giPBN0v7WFaANg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215239; c=relaxed/simple;
	bh=NgbuTvRGxwKlXgYq6G49zf6llQvte9qvPuXhmqKIB/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBoTDqgl1+IFSp93LePeOpWZZ4qeiDIhSnn3AHiwKXVfYOXCuUbX0bb6gx99daMi9tmqu0yChTrIboV0zUc5QDnY0oKB2ZPvlU4j8jh0gW8zGRq9CrLUFV8Cvyj41Bi60PunCLtMWhVCZgn6zLEsG1DRltHx272h1KxNX7VXmhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wP/rLEaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wP/rLEaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F1DC4CEF1;
	Tue, 26 Aug 2025 13:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215239;
	bh=NgbuTvRGxwKlXgYq6G49zf6llQvte9qvPuXhmqKIB/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wP/rLEaHpyeSs7NHZRLUjQT7WjGiUxc+Xv2KFTRXaQ/4dYSOV0QutFBypCGoJBSox
	 DqDAt3CXig7kohwndkykMtt1RRtNC3rSPE2x4JiWaRG3SBDhubIHOOzzj1N1n5Zqq0
	 hrI0nrZD5ZmM3m70bZeHtmZAN/+3f/Wit2i0m+iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 439/482] mmc: sdhci-pci-gli: GL9763e: Mask the replay timer timeout of AER
Date: Tue, 26 Aug 2025 13:11:32 +0200
Message-ID: <20250826110941.677296861@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Shih <victor.shih@genesyslogic.com.tw>

[ Upstream commit 340be332e420ed37d15d4169a1b4174e912ad6cb ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -988,6 +988,9 @@ static void gl9763e_hw_setting(struct sd
 	value |= FIELD_PREP(GLI_9763E_HS400_RXDLY, GLI_9763E_HS400_RXDLY_5);
 	pci_write_config_dword(pdev, PCIE_GLI_9763E_CLKRXDLY, value);
 
+	/* mask the replay timer timeout of AER */
+	sdhci_gli_mask_replay_timer_timeout(pdev);
+
 	pci_read_config_dword(pdev, PCIE_GLI_9763E_VHS, &value);
 	value &= ~GLI_9763E_VHS_REV;
 	value |= FIELD_PREP(GLI_9763E_VHS_REV, GLI_9763E_VHS_REV_R);


