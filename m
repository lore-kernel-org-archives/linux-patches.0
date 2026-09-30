Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2465A4E4306;
	Wed, 30 Sep 2026 19:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797135; cv=none; b=k/b0JFCjg/5FXrri7v+b9o5YLpyyS2SBImeME+GNZWMMyy+fGpEWQu11c/z2cCf7mzM7b2IqIIDlfHYgVKCHQmLlaOh/FsGpxLsy2USCRyvnm7AaXS3+atj4NgRIhr4Yb9/D1A6EhyBZt6FQQXxEPoy+vfy8v0i5MOKmIoGbQX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797135; c=relaxed/simple;
	bh=EiCHp6kpWXzv33h1mWYS4qx478TJkO+RDwg9uiEAsnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q44c+Dhp/s9H2sR/VbIAuisKxQa4Z68CK2l71rPEuAtKKyx8O12fvia5zp0wXKWHbcyge9pGsr2B/dZlsqlxkgdN/Ooxg0aKEM+j2Ep65lgem9J8VkT6FXvwWwZ7r4isE+Hgst2teFAmwVdFieRQkZM9zTP95gxKGTvkp8VIwZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2I+Zg18W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2I+Zg18W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D96F1F000FF;
	Wed, 30 Sep 2026 19:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797134;
	bh=JoD4cw5SqnmlHB8bdLKmJNG7XGLFFClD17bb5CVrH5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2I+Zg18WMinO4A1T8dDNrSWk/Oab/joiWXE/C2PdgE5lB1rc5cGcAH+rK6ZH5PV64
	 5xSJQLHFzi0raF0jT9hJr2Frm3M3GDfVofyJ1JJR0dWGaNEMFUqsoHefvpi3jc9txx
	 c73ccumjGj9HuWfLjVxntxzh1Kojq4MtZfSLnkWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1160/1193] wifi: ath12k: check M3 buffer size as well whey trying to reuse it
Date: Wed, 30 Sep 2026 17:30:44 +0200
Message-ID: <20260930152500.015425895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 05090ae82f44570fefddb4e1be1d7e5770d6de40 ]

Currently in recovery/resume cases, we do not free M3 buffer but
instead will reuse it. This is done by checking m3_mem->vaddr: if it
is not NULL we believe M3 buffer is ready and go ahead to reuse it.

Note that m3_mem->size is not checked. This is safe for now because
currently M3 reuse logic only gets executed in recovery/resume cases
and the size keeps unchanged in either of them.

However ideally the size should be checked as well, to make the code
safer. So add the check there. Now if that check fails, free old M3
buffer and reallocate a new one.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

[ Backport to 6.6.y: mapped the M3 size validation onto the target's
  older QMI allocation layout. ]

Fixes: 303c017821d8 ("wifi: ath12k: fix kernel crash during resume")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240425021740.29221-1-quic_bqiang@quicinc.com
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 39 ++++++++++++++++-----------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 7a9868dbab02d..48d0043fcee93 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2511,6 +2511,19 @@ static int ath12k_qmi_load_bdf_qmi(struct ath12k_base *ab,
 	return ret;
 }
 
+static void ath12k_qmi_m3_free(struct ath12k_base *ab)
+{
+	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;
+
+	if (!m3_mem->vaddr)
+		return;
+
+	dma_free_coherent(ab->dev, m3_mem->size,
+			  m3_mem->vaddr, m3_mem->paddr);
+	m3_mem->vaddr = NULL;
+	m3_mem->size = 0;
+}
+
 static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 {
 	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;
@@ -2518,9 +2531,6 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 	char path[100];
 	int ret;
 
-	if (m3_mem->vaddr || m3_mem->size)
-		return 0;
-
 	fw = ath12k_core_firmware_request(ab, ATH12K_M3_FILE);
 	if (IS_ERR(fw)) {
 		ret = PTR_ERR(fw);
@@ -2530,6 +2540,17 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 		return ret;
 	}
 
+	/* In recovery/resume cases, M3 buffer is not freed, try to reuse that */
+	if (m3_mem->vaddr) {
+		if (m3_mem->size >= fw->size) {
+			release_firmware(fw);
+			return 0;
+		}
+
+		/* Old buffer is too small, free and reallocate */
+		ath12k_qmi_m3_free(ab);
+	}
+
 	m3_mem->vaddr = dma_alloc_coherent(ab->dev,
 					   fw->size, &m3_mem->paddr,
 					   GFP_KERNEL);
@@ -2547,18 +2568,6 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 	return 0;
 }
 
-static void ath12k_qmi_m3_free(struct ath12k_base *ab)
-{
-	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;
-
-	if (!m3_mem->vaddr)
-		return;
-
-	dma_free_coherent(ab->dev, m3_mem->size,
-			  m3_mem->vaddr, m3_mem->paddr);
-	m3_mem->vaddr = NULL;
-}
-
 static int ath12k_qmi_wlanfw_m3_info_send(struct ath12k_base *ab)
 {
 	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;
-- 
2.53.0



