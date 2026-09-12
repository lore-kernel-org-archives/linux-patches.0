Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECD9274B46;
	Sat, 12 Sep 2026 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224100; cv=none; b=EGrff+WGYY4SC8A2hZXDHZ6trr52zJLDBPReuzAx9EDRP8y+XTSG5ge1CqMzVcqMIC4VF0wXnHhn0OFuKaKQcNZDM1Qta9+PSyKSBDLS5AGgn0h1kmANFbZ701euyMxTvJTyRxjA+7RU6+xOw6bwEvYKFuFSHLBiLtYqcgFiSCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224100; c=relaxed/simple;
	bh=i5nzVfh8QDlKAwn0nyh+B963zxILwx1p8BTyj/mzP5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnU2uLaw5J8t0tfBHyssw6rGfzdC3OXT1wRL6tnQOUNzD3EldNreih6cEkJTVmGTWeABXamARFAoJWou2HqswLxoZ1lBInrRQjniCsz3SbKHsAugYvPu0GrB35E3OY11WHQ6PYrfV9SVz702egXlC5eqts7W/xmQQgs5f5l6Y50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGyvEsTF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGyvEsTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C761F000FF;
	Sat, 12 Sep 2026 14:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224093;
	bh=DCbYndsFrrfuLnPGNCxil4cSeUDmFqTKkxCLoov+pCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGyvEsTFxggjhXAjgbLDmNR1dmzrAJl7IGrCnsxYlp4ywrP/HFCdTW0ug4wMMXCOO
	 aWTyGHMde/Dd2P4BOn/Zjix2VX/jg0P9R10cefJFT4bjjDPcVUKTL3vFqaQTWXxI8u
	 Uyld8sDZbVvZ+05IaYq6HA5sDnfLRaJ2CCScUHuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0924/1424] wifi: ath11k: qmi: refactor ath11k_qmi_m3_load()
Date: Sat, 12 Sep 2026 08:55:56 +0200
Message-ID: <20260912065628.016617512@linuxfoundation.org>
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

From: Kalle Valo <quic_kvalo@quicinc.com>

[ Upstream commit b49381d3de3af1b84b4b1f08eda301b8befb4b05 ]

Simple refactoring to make it easier to add firmware-2.bin support in the
following patch.

Earlier ath11k_qmi_m3_load() supported changing m3.bin contents while ath11k is
running. But that's not going to actually work, m3.bin is supposed to be the
same during the lifetime of ath11k, for example we don't support changing the
firmware capabilities on the fly. Due to this ath11k requests m3.bin firmware
file first and only then checks m3_mem->vaddr, so we are basically requesting
the firmware file even if it's not needed. Reverse the code so that m3_mem
buffer is checked first, and only if it doesn't exist, then m3.bin is requested
from user space.

Checking for m3_mem->size is redundant when m3_mem->vaddr is NULL, we would
not be able to use the buffer in that case. So remove the check for size.

Simplify the exit handling and use 'goto out'.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.9

Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://lore.kernel.org/r/20230727100430.3603551-3-kvalo@kernel.org
Stable-dep-of: 208d7fdb8597 ("wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 84d214c38f0f4..c27d2a6cbd9da 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2518,6 +2518,10 @@ static int ath11k_qmi_m3_load(struct ath11k_base *ab)
 	char path[100];
 	int ret;
 
+	if (m3_mem->vaddr)
+		/* m3 firmware buffer is already available in the DMA buffer */
+		return 0;
+
 	fw = ath11k_core_firmware_request(ab, ATH11K_M3_FILE);
 	if (IS_ERR(fw)) {
 		ret = PTR_ERR(fw);
@@ -2527,25 +2531,25 @@ static int ath11k_qmi_m3_load(struct ath11k_base *ab)
 		return ret;
 	}
 
-	if (m3_mem->vaddr || m3_mem->size)
-		goto skip_m3_alloc;
-
 	m3_mem->vaddr = dma_alloc_coherent(ab->dev,
 					   fw->size, &m3_mem->paddr,
 					   GFP_KERNEL);
 	if (!m3_mem->vaddr) {
 		ath11k_err(ab, "failed to allocate memory for M3 with size %zu\n",
 			   fw->size);
-		release_firmware(fw);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
-skip_m3_alloc:
 	memcpy(m3_mem->vaddr, fw->data, fw->size);
 	m3_mem->size = fw->size;
+
+	ret = 0;
+
+out:
 	release_firmware(fw);
 
-	return 0;
+	return ret;
 }
 
 static void ath11k_qmi_m3_free(struct ath11k_base *ab)
-- 
2.53.0



