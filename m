Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E153803DC;
	Sat, 17 Oct 2026 17:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257564; cv=none; b=rgXKWa//iQCkaiCnQGH4LHResNTmHveeLkraze9zoasbHzNDrsvOXPPYEvyar6TNbgYh/ut/Ej8RZJ73HdHsXOLsOmzD0ZCqr2k2hvVEKbPnp4pCPG0dUP8/Ztp5X8DHBC5hN4Ra3ffl+AVsMtvqibDdK7bGbnr//GqH08tSuc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257564; c=relaxed/simple;
	bh=0+1231w+WE/lH7OcGtdmFvFeV525zWeieHIbXAoy11g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRF/DeitWGhOXTwBUMwsGwX88QfNMZgALfIR8LIHvEhtGVqnsfCE4938STl39LX0srJ6FL845eDnrcSfa8nSkrjO+MHtSSE7r/TgY0xZjfV6zQGMQRbLFjkOU36ZMH2ZGgUu5qQfe9gYubwgj8TUFzQL5jUKET+dFbSePPXYmXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yg7IWGD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yg7IWGD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3241F000C4;
	Sat, 17 Oct 2026 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257563;
	bh=7MlhxWeJ1qmoh3cgcvD68T2gx5dNwqIJwWw2u6kjbkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yg7IWGD0Hwsb0hO120848aJ8FiIvrNTB4cRQjwsEJ7U+3BdekbTuEWFcVPxze+OWG
	 EMDAls3mkO+3v/7026cDryFIkkkLH3WXRcVreKSGoHAlxPxX2HscX4Ds1zsrZuMqig
	 ckXUuJcF6XxPxLZQLHQrN070QOJ9iMcRjotrJBSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0598/1674] wifi: ath12k: fix reusing m3 memory
Date: Sat, 17 Oct 2026 17:47:50 +0200
Message-ID: <20261017160446.430952327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 00575bb44b2c2aa53d0a768de2b80c9c1af0174d ]

During firmware recovery or suspend/resume, m3 memory could be reused if
the size of the new m3 binary is equal to or less than that of the
existing memory. There will be issues for the latter case, since
m3_mem->size will be updated with a smaller value and this value is
eventually used in the free path, where the original total size should be
used instead.

To fix it, add a new member in m3_mem_region structure to track the original
memory size and use it in free path.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

[ Backport to 6.6.y: 6.6.y only loads the separate m3.bin, so use
  fw->size where upstream uses m3_len. The upstream change to the
  allocation-failure message only matters for the firmware-N.bin path,
  which 6.6.y lacks, so it is dropped. The copyright lines are left as
  they are.
  On its own this changes nothing in 6.6.y, because the reuse path
  currently returns before m3_mem->size is updated. It is needed by the
  following fix to my 6.6.y backport of 05090ae82f44, which copies a
  possibly smaller image into the reused buffer as upstream does. ]

Fixes: 05090ae82f44 ("wifi: ath12k: check M3 buffer size as well whey trying to reuse it")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251029-ath12k-fix-m3-reuse-v1-1-69225bacfc5d@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 7 +++++--
 drivers/net/wireless/ath/ath12k/qmi.h | 3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 48d0043fcee93..86cc61dba0946 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2518,9 +2518,10 @@ static void ath12k_qmi_m3_free(struct ath12k_base *ab)
 	if (!m3_mem->vaddr)
 		return;
 
-	dma_free_coherent(ab->dev, m3_mem->size,
+	dma_free_coherent(ab->dev, m3_mem->total_size,
 			  m3_mem->vaddr, m3_mem->paddr);
 	m3_mem->vaddr = NULL;
+	m3_mem->total_size = 0;
 	m3_mem->size = 0;
 }
 
@@ -2542,7 +2543,7 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 
 	/* In recovery/resume cases, M3 buffer is not freed, try to reuse that */
 	if (m3_mem->vaddr) {
-		if (m3_mem->size >= fw->size) {
+		if (m3_mem->total_size >= fw->size) {
 			release_firmware(fw);
 			return 0;
 		}
@@ -2561,6 +2562,8 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 		return -ENOMEM;
 	}
 
+	m3_mem->total_size = fw->size;
+
 	memcpy(m3_mem->vaddr, fw->data, fw->size);
 	m3_mem->size = fw->size;
 	release_firmware(fw);
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index a996c6d57aa7b..62c7a526f1114 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -119,6 +119,9 @@ struct target_info {
 };
 
 struct m3_mem_region {
+	/* total memory allocated */
+	u32 total_size;
+	/* actual memory being used */
 	u32 size;
 	dma_addr_t paddr;
 	void *vaddr;
-- 
2.53.0



