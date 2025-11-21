Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEB621ABB9;
	Fri, 21 Nov 2025 13:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731821; cv=none; b=fPLSyYNvX30EtPZDQBr45oK4A/GHOXplX+/GTuBKKH+TmRaowXYIvYhitNwHjd29zoXRH99KhmBRUMrI10hNzA9WaiB9HCepXhLn469cGmAZ8izmJmBE2zkN+a6Ykm8F30h63/dWXeqqfFg+tAUKGqRGvjQkkCZXopkyK4w2lRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731821; c=relaxed/simple;
	bh=Eo13NM/ZC80aSrOmbnSkQf6oKpXAXoMeijCUtT5NJf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAheWVNzlORuxvkRKAurXVSFKLBiOThgoZbk1hXW9P741qEfqpOz2sGTr0H0usn+ErfHNump0wEtXViZF8QW974E6Y6knPmcw4gu1xrdGigGg4AvwL5zp8Z99apmaOXvh57NAGMTYIK33jIRDGPFsoX/LoQP16rsJhqO1toezZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKRf5jR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKRf5jR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763D6C4CEF1;
	Fri, 21 Nov 2025 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731820;
	bh=Eo13NM/ZC80aSrOmbnSkQf6oKpXAXoMeijCUtT5NJf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKRf5jR30c8iF/qz7Zgnpy7ih0Mc3VrO9Lwzz2mF7lEwnkXQnf8O8zre4d+JxkN/K
	 zJJMZYqtpRCb5ueX+c7O3JnK5gkxiYumzsGYdTJ74R/De+yhXRraiGyrdUPLEfgMNq
	 KoOgc5Bgp+dTEOBdgzEk3PThfxXK2sE5M1okAje0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/185] wifi: ath11k: Clear affinity hint before calling ath11k_pcic_free_irq() in error path
Date: Fri, 21 Nov 2025 14:11:52 +0100
Message-ID: <20251121130146.935642618@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 68410c5bd381a81bcc92b808e7dc4e6b9ed25d11 ]

If a shared IRQ is used by the driver due to platform limitation, then the
IRQ affinity hint is set right after the allocation of IRQ vectors in
ath11k_pci_alloc_msi(). This does no harm unless one of the functions
requesting the IRQ fails and attempt to free the IRQ. This results in the
below warning:

WARNING: CPU: 7 PID: 349 at kernel/irq/manage.c:1929 free_irq+0x278/0x29c
Call trace:
 free_irq+0x278/0x29c
 ath11k_pcic_free_irq+0x70/0x10c [ath11k]
 ath11k_pci_probe+0x800/0x820 [ath11k_pci]
 local_pci_probe+0x40/0xbc

The warning is due to not clearing the affinity hint before freeing the
IRQs.

So to fix this issue, clear the IRQ affinity hint before calling
ath11k_pcic_free_irq() in the error path. The affinity will be cleared once
again further down the error path due to code organization, but that does
no harm.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-05266-QCAHSTSWPLZ_V2_TO_X86-1

Cc: Baochen Qiang <quic_bqiang@quicinc.com>
Fixes: 39564b475ac5 ("wifi: ath11k: fix boot failure with one MSI vector")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250225053447.16824-2-manivannan.sadhasivam@linaro.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 6ebfa5d02e2e5..c1d576ff77faa 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -936,6 +936,8 @@ static int ath11k_pci_probe(struct pci_dev *pdev,
 	return 0;
 
 err_free_irq:
+	/* __free_irq() expects the caller to have cleared the affinity hint */
+	ath11k_pci_set_irq_affinity_hint(ab_pci, NULL);
 	ath11k_pcic_free_irq(ab);
 
 err_ce_free:
-- 
2.51.0



