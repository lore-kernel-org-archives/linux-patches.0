Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D195E1170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552CDC433C7;
	Mon, 11 Sep 2023 14:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441598;
	bh=yXBezTM4l84KrdeQRcJGaHK7HdkbG9uJ4hakC7gFtxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgCJBN7gwS3bjCmmmJDnZT2jiH2xrG6YZB0HE9j1yqrtJEqlxEhSLDpva8PTqghjM
	 EjeGTm2giVDq8AhZmgTlhsorviCEo0k7UITBkjWLIKIgflIyvbdLx6Lkj08f8FFPQA
	 /QRWt8+jM3xucRdPtSv/gIobIYXy06uKyCRmI1DM=
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
Subject: [PATCH 6.5 428/739] wifi: ath12k: Use RMW accessors for changing LNKCTL
Date: Mon, 11 Sep 2023 15:43:47 +0200
Message-ID: <20230911134703.131846053@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit f5a7ac118faf6d4f794975947b3300717eae8fc5 ]

Don't assume that only the driver would be accessing LNKCTL. ASPM policy
changes can trigger write to LNKCTL outside of driver's control.

Use RMW capability accessors which do proper locking to avoid losing
concurrent updates to the register value. On restore, clear the ASPMC field
properly.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Link: https://lore.kernel.org/r/20230717120503.15276-10-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 5990a55801f0a..e4f08a066ca10 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -794,8 +794,8 @@ static void ath12k_pci_aspm_disable(struct ath12k_pci *ab_pci)
 		   u16_get_bits(ab_pci->link_ctl, PCI_EXP_LNKCTL_ASPM_L1));
 
 	/* disable L0s and L1 */
-	pcie_capability_write_word(ab_pci->pdev, PCI_EXP_LNKCTL,
-				   ab_pci->link_ctl & ~PCI_EXP_LNKCTL_ASPMC);
+	pcie_capability_clear_word(ab_pci->pdev, PCI_EXP_LNKCTL,
+				   PCI_EXP_LNKCTL_ASPMC);
 
 	set_bit(ATH12K_PCI_ASPM_RESTORE, &ab_pci->flags);
 }
@@ -803,8 +803,10 @@ static void ath12k_pci_aspm_disable(struct ath12k_pci *ab_pci)
 static void ath12k_pci_aspm_restore(struct ath12k_pci *ab_pci)
 {
 	if (test_and_clear_bit(ATH12K_PCI_ASPM_RESTORE, &ab_pci->flags))
-		pcie_capability_write_word(ab_pci->pdev, PCI_EXP_LNKCTL,
-					   ab_pci->link_ctl);
+		pcie_capability_clear_and_set_word(ab_pci->pdev, PCI_EXP_LNKCTL,
+						   PCI_EXP_LNKCTL_ASPMC,
+						   ab_pci->link_ctl &
+						   PCI_EXP_LNKCTL_ASPMC);
 }
 
 static void ath12k_pci_kill_tasklets(struct ath12k_base *ab)
-- 
2.40.1



