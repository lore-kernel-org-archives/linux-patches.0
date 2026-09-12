Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20811DE4EF;
	Sat, 12 Sep 2026 14:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222343; cv=none; b=MLeIwIpAc7XsmQnZZSCD69IWwys4KhKLLJpvmuMQ5Fd6kLVustvpl3ju7ZGGmOiW9JB+h1Hq0fPHbZxWf2BmhcJuhr7xb8Se+7vnDcNhx+vkMqUX3XsvMyUwTrVat80ZO7DFpG13GcB5PKrPsF3XL4z3loXJSMUHW9upLBwiFC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222343; c=relaxed/simple;
	bh=Ubo/UO8MYFxt9EqycOJD3bVbl3wL6q+UV8mV4O0VbpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2B/B4V1lVYFsg7jB65qWfA2v2ApEsyJqtOFKb8hY/N1s18jQiHM3wL9IVpjN2Pf6f4+T/WAiLEgy5lCujgSLqkklZNKA0vhu/wJ0Tnza/PHZD6c49KJxrSJxJoSW6gM3FHUq4M+0YrjTXLetnPicQFyUSVz1Y9OOV9TKF4SKyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiO1LRdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiO1LRdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C431F000FF;
	Sat, 12 Sep 2026 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222342;
	bh=sUnjh1ytCwwsYmT5Jp7MP/iNvq0iwM4f6pvp9nuhhLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiO1LRdhbbfZw9H5Fa4nnkfrppeN+Luhs8JUfsS5mCnWe7+HtLaC4jZUdfXtITJ+A
	 OZv+4kT9sw8zRBeL4m7mWIyezR3sOeqSRt6HBlOswKOqgy8HSSU2SK90+78I3FfbXx
	 1rGyufh/sIG/bVJ9dzOAxCRwUNjRZ+HM3LBREjTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0540/1424] wifi: ath11k: Clear affinity hint before calling ath11k_pcic_free_irq() in error path
Date: Sat, 12 Sep 2026 08:49:32 +0200
Message-ID: <20260912065619.394088540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 966ba712ff909..02c261a30a4db 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -908,6 +908,8 @@ static int ath11k_pci_probe(struct pci_dev *pdev,
 	return 0;
 
 err_free_irq:
+	/* __free_irq() expects the caller to have cleared the affinity hint */
+	ath11k_pci_set_irq_affinity_hint(ab_pci, NULL);
 	ath11k_pcic_free_irq(ab);
 
 err_ce_free:
-- 
2.53.0



