Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255722E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC77C433C7;
	Wed, 20 Sep 2023 12:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212072;
	bh=LsUG9XansfjOdxlmu5BGLvn3gMH60klMbOVwqluv9XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDblnFb2z50kjtBNT8BiXDe/NqD74Se72zGKrKyoqvKTFV4M+Pxo0YsfyH5ubfPJZ
	 C02FLl6a8D/V71SJyrJPO+Cc2CJAfPiAFYTAudnCn9lB5NcnoJUhuMhiLTZYZzdaCG
	 uEJ8uz3PIqeuhyL0B7qH/mwIZ4WlAufVFv3Y5PKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/273] wifi: ath10k: Use RMW accessors for changing LNKCTL
Date: Wed, 20 Sep 2023 13:29:23 +0200
Message-ID: <20230920112850.298078464@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit f139492a09f15254fa261245cdbd65555cdf39e3 ]

Don't assume that only the driver would be accessing LNKCTL. ASPM policy
changes can trigger write to LNKCTL outside of driver's control.

Use RMW capability accessors which does proper locking to avoid losing
concurrent updates to the register value. On restore, clear the ASPMC field
properly.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Fixes: 76d870ed09ab ("ath10k: enable ASPM")
Link: https://lore.kernel.org/r/20230717120503.15276-11-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 92757495c73b6..c929a62c722ad 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1957,8 +1957,9 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	ath10k_pci_irq_enable(ar);
 	ath10k_pci_rx_post(ar);
 
-	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
-				   ar_pci->link_ctl);
+	pcie_capability_clear_and_set_word(ar_pci->pdev, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_ASPMC,
+					   ar_pci->link_ctl & PCI_EXP_LNKCTL_ASPMC);
 
 	return 0;
 }
@@ -2813,8 +2814,8 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 
 	pcie_capability_read_word(ar_pci->pdev, PCI_EXP_LNKCTL,
 				  &ar_pci->link_ctl);
-	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
-				   ar_pci->link_ctl & ~PCI_EXP_LNKCTL_ASPMC);
+	pcie_capability_clear_word(ar_pci->pdev, PCI_EXP_LNKCTL,
+				   PCI_EXP_LNKCTL_ASPMC);
 
 	/*
 	 * Bring the target up cleanly.
-- 
2.40.1



