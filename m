Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB42381DC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRAHvut2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9BAC433C9;
	Wed, 15 Nov 2023 19:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076941;
	bh=J7yT9CjBdGcKaA6q4pvIt1asz24efJ5Xgkgf0FUOM4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRAHvut2TQejiR8ZkysEs85yFY8E1KZIfUFs74eL47W9J/O0jSczlm0ewBsZ+J9F0
	 qnc7Dswr9ia8Pk9U3qbrx7gj2Az/2qwWOljM7R12g0Hy+KZZeSGbXeObboGJH5lpTk
	 CQXGk/sz5o/U8chP0DRMZVVtmKeXiSg4BCYBZ/6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/603] wifi: ath11k: fix boot failure with one MSI vector
Date: Wed, 15 Nov 2023 14:10:20 -0500
Message-ID: <20231115191618.296567278@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 39564b475ac5a589e6c22c43a08cbd283c295d2c ]

Commit 5b32b6dd96633 ("ath11k: Remove core PCI references from
PCI common code") breaks with one MSI vector because it moves
affinity setting after IRQ request, see below log:

[ 1417.278835] ath11k_pci 0000:02:00.0: failed to receive control response completion, polling..
[ 1418.302829] ath11k_pci 0000:02:00.0: Service connect timeout
[ 1418.302833] ath11k_pci 0000:02:00.0: failed to connect to HTT: -110
[ 1418.303669] ath11k_pci 0000:02:00.0: failed to start core: -110

The detail is, if do affinity request after IRQ activated,
which is done in request_irq(), kernel caches that request and
returns success directly. Later when a subsequent MHI interrupt is
fired, kernel will do the real affinity setting work, as a result,
changs the MSI vector. However at that time host has configured
old vector to hardware, so host never receives CE or DP interrupts.

Fix it by setting affinity before registering MHI controller
where host is, for the first time, doing IRQ request.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3
Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23
Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-01160-QCAMSLSWPLZ-1

Fixes: 5b32b6dd9663 ("ath11k: Remove core PCI references from PCI common code")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230907015606.16297-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index a5aa1857ec14b..09e65c5e55c4a 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -854,10 +854,16 @@ static int ath11k_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto err_pci_disable_msi;
 
+	ret = ath11k_pci_set_irq_affinity_hint(ab_pci, cpumask_of(0));
+	if (ret) {
+		ath11k_err(ab, "failed to set irq affinity %d\n", ret);
+		goto err_pci_disable_msi;
+	}
+
 	ret = ath11k_mhi_register(ab_pci);
 	if (ret) {
 		ath11k_err(ab, "failed to register mhi: %d\n", ret);
-		goto err_pci_disable_msi;
+		goto err_irq_affinity_cleanup;
 	}
 
 	ret = ath11k_hal_srng_init(ab);
@@ -878,12 +884,6 @@ static int ath11k_pci_probe(struct pci_dev *pdev,
 		goto err_ce_free;
 	}
 
-	ret = ath11k_pci_set_irq_affinity_hint(ab_pci, cpumask_of(0));
-	if (ret) {
-		ath11k_err(ab, "failed to set irq affinity %d\n", ret);
-		goto err_free_irq;
-	}
-
 	/* kernel may allocate a dummy vector before request_irq and
 	 * then allocate a real vector when request_irq is called.
 	 * So get msi_data here again to avoid spurious interrupt
@@ -892,20 +892,17 @@ static int ath11k_pci_probe(struct pci_dev *pdev,
 	ret = ath11k_pci_config_msi_data(ab_pci);
 	if (ret) {
 		ath11k_err(ab, "failed to config msi_data: %d\n", ret);
-		goto err_irq_affinity_cleanup;
+		goto err_free_irq;
 	}
 
 	ret = ath11k_core_init(ab);
 	if (ret) {
 		ath11k_err(ab, "failed to init core: %d\n", ret);
-		goto err_irq_affinity_cleanup;
+		goto err_free_irq;
 	}
 	ath11k_qmi_fwreset_from_cold_boot(ab);
 	return 0;
 
-err_irq_affinity_cleanup:
-	ath11k_pci_set_irq_affinity_hint(ab_pci, NULL);
-
 err_free_irq:
 	ath11k_pcic_free_irq(ab);
 
@@ -918,6 +915,9 @@ static int ath11k_pci_probe(struct pci_dev *pdev,
 err_mhi_unregister:
 	ath11k_mhi_unregister(ab_pci);
 
+err_irq_affinity_cleanup:
+	ath11k_pci_set_irq_affinity_hint(ab_pci, NULL);
+
 err_pci_disable_msi:
 	ath11k_pci_free_msi(ab_pci);
 
-- 
2.42.0



