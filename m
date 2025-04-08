Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88F4214205;
	Tue,  8 Apr 2025 11:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110621; cv=none; b=ehe7RoE6ChpZeU49yhMWftn+vitlCgy5VfUdUbJgC6olSPwB77fCrkZpfVz5gCIe2sc42E8yjTRfrMDFxjcJQv25G8dOMPj6Nc19rh/pDtillp0IORqxsxqGbG/+3v6AOCGlH3tgNFsSYP2L9UiBL76hfM/FB4LRJSD69pfKmDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110621; c=relaxed/simple;
	bh=cT0stCHWdLoHDZCsTdClFE5V4ajnbV8vRCCxD6jWSSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY7n7nmGFh1qGZtxR3HUxPS/7SgMITuPW8WNgEn3RuYuGy0WmOfd/69qOxZl2mx1Rbc9A0hle4zifgZxcH6k06/skTLHegFL8nC+R7EvWDyg0yx5cTHGMbbOfd7t3UNXdsUNLBAA26qdPZ4leYffLO6Wwao2JW8S6jYum2OWpso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRTAdwNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRTAdwNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E46C4CEE5;
	Tue,  8 Apr 2025 11:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110621;
	bh=cT0stCHWdLoHDZCsTdClFE5V4ajnbV8vRCCxD6jWSSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRTAdwNSkPzi3pdndiblVTLniJKe6xpK+Fmf51ntAcsmjaj6UNLyDOdVxQ2PnCKiB
	 2dGLMIgbsjpfSlwvUKDBm043eERW4O4BvAqkd2aJtnQFgzn81ZDAE9lks5MKsILskI
	 6ArarU+4fAzS3II+ldHInF7oaqM93jpZyVPw4sJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 125/731] wifi: ath11k: Clear affinity hint before calling ath11k_pcic_free_irq() in error path
Date: Tue,  8 Apr 2025 12:40:22 +0200
Message-ID: <20250408104917.186966440@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index b93f04973ad79..eaac9eabcc70a 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -939,6 +939,8 @@ static int ath11k_pci_probe(struct pci_dev *pdev,
 	return 0;
 
 err_free_irq:
+	/* __free_irq() expects the caller to have cleared the affinity hint */
+	ath11k_pci_set_irq_affinity_hint(ab_pci, NULL);
 	ath11k_pcic_free_irq(ab);
 
 err_ce_free:
-- 
2.39.5



