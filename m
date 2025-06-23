Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EDA19F120;
	Mon, 23 Jun 2025 22:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717136; cv=none; b=JhfltFEmx84P0E8tosvaoDdU0iCFYrSP+0p4Gj1eKY/i1KyjP1vL86pcFER0526/Me6M8j7CrqEldah3PFosVrP0jyhQ7wzHPMPCEOtqiJM36GDoVSPzhPKgeHjD8A7QKMA0ZS6GTq6R/I7p0NnGCu6sXw8qrJ/8fLG2zRysYgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717136; c=relaxed/simple;
	bh=iSycNqXTpXZnncmxPgCHVBAHdf75BoK/iwB1iUCugNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xn3p5r52+JoN+ZzxBVT9z4MlYUV4lKtQpnBxT4LCiWgOFMG9Je6uhOzAez+dqp0tIbUH5oFPFdpNKKLUtSP3k0mqzhp4HIo9Fbxnxu1Db3jUMiLMacUZ7p0N3TT+EU+Y+njB/72DIvppRvbJHeVej23uOu0zRdjIMGMHLngrd0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAGZOthp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAGZOthp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F34C4CEEA;
	Mon, 23 Jun 2025 22:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717136;
	bh=iSycNqXTpXZnncmxPgCHVBAHdf75BoK/iwB1iUCugNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAGZOthpCQ2015DZoBJTvNuXUq6NykSDmQR0xmxmyI9PsSPFf37ctu0fFR1AA2caB
	 WR7oryH2qmA5neQVRyxkL9P0WuwRuyKmPH9WLcHU+ypgqqTTFrk2qZ7/SMy2HxtAcH
	 ejOMSTOAV4r45tzgrfN8zGA/h1kn9XbGTUtNToPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.12 328/414] wifi: ath12k: Clear affinity hint before calling ath12k_pci_free_irq() in error path
Date: Mon, 23 Jun 2025 15:07:45 +0200
Message-ID: <20250623130650.190141437@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit b43b1e2c52db77c872bd60d30cdcc72c47df70c7 upstream.

If a shared IRQ is used by the driver due to platform limitation, then the
IRQ affinity hint is set right after the allocation of IRQ vectors in
ath12k_pci_msi_alloc(). This does no harm unless one of the functions
requesting the IRQ fails and attempt to free the IRQ.

This may end up with a warning from the IRQ core that is expecting the
affinity hint to be cleared before freeing the IRQ:

kernel/irq/manage.c:

	/* make sure affinity_hint is cleaned up */
	if (WARN_ON_ONCE(desc->affinity_hint))
		desc->affinity_hint = NULL;

So to fix this issue, clear the IRQ affinity hint before calling
ath12k_pci_free_irq() in the error path. The affinity will be cleared once
again further down the error path due to code organization, but that does
no harm.

Fixes: a3012f206d07 ("wifi: ath12k: set IRQ affinity to CPU0 in case of one MSI vector")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250225053447.16824-3-manivannan.sadhasivam@linaro.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1506,6 +1506,8 @@ static int ath12k_pci_probe(struct pci_d
 	return 0;
 
 err_free_irq:
+	/* __free_irq() expects the caller to have cleared the affinity hint */
+	ath12k_pci_set_irq_affinity_hint(ab_pci, NULL);
 	ath12k_pci_free_irq(ab);
 
 err_ce_free:


