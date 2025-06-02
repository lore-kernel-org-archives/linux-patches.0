Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0276D230D1E;
	Mon,  2 Jun 2025 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873894; cv=none; b=kAaEJZeEuZlA49piDtNfjJPCHJjMYiunqJQf2P5F79OwIpQ2kNqcaYl48W9jS081BgZkv2aw5DOTSf3v35618gcUVWMxWNhvzhon65kpIoheHVWOPCzKJbya7BwxLHQLRPMuut6A4T6cgzWeIY4S9H2Ldut44zWzsTis5ph3re8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873894; c=relaxed/simple;
	bh=nQ2m8EpBRXs8LHSTbmVGFLcENYMQ8jPlDGDfEe6NryE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxwcBvd25N6aGZ0o5Tp3tbnqByuuhrL+WGAr4zUCMVqx/5teQES4lfTZDeTfQXPtB/9cJLic9pkMF1gLyE65ibsmVHJSdiiq9VclTAe7qN+1V8dki+5nLNL7x8c5xKQLwyetbzlDed6W1cncoz0qVBguwRGtZkWtSfHzoyau+b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ys0akuVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ys0akuVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0D8C4CEEB;
	Mon,  2 Jun 2025 14:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873893;
	bh=nQ2m8EpBRXs8LHSTbmVGFLcENYMQ8jPlDGDfEe6NryE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ys0akuVUMCvjAva6q4FrQMHPAp2fIQVKhvdW1YxZ7WIsuDJ+os2Y+R9GCZ5LnIAGh
	 V5gNytpWhYSKCXYDm0rNXtOjhXNFrgKHf0PiuIKp/zYJ8KQ6g6GnlpNDZFUBvrSx6W
	 cFnH1lV0iPmL75ihkPz9quUmpSFFk3bhQl3FQKvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avula Sri Charan <quic_asrichar@quicinc.com>,
	Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/444] wifi: ath12k: Avoid napi_sync() before napi_enable()
Date: Mon,  2 Jun 2025 15:45:53 +0200
Message-ID: <20250602134352.684866734@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avula Sri Charan <quic_asrichar@quicinc.com>

[ Upstream commit 268c73d470a5790a492a2fc2ded084b909d144f3 ]

In case of MHI error a reset work will be queued which will try
napi_disable() after napi_synchronize().

As the napi will be only enabled after qmi_firmware_ready event,
trying napi_synchronize() before napi_enable() will result in
indefinite sleep in case of a firmware crash in QMI init sequence.

To avoid this, introduce napi_enabled flag to check if napi is enabled
or not before calling napi_synchronize().

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1

Signed-off-by: Avula Sri Charan <quic_asrichar@quicinc.com>
Signed-off-by: Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>
Reviewed-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250124090058.3194299-1-quic_tamizhr@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.h |  1 +
 drivers/net/wireless/ath/ath12k/pci.c  | 13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 33f4706af880d..18dfd7aab610c 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -125,6 +125,7 @@ struct ath12k_ext_irq_grp {
 	u32 num_irq;
 	u32 grp_id;
 	u64 timestamp;
+	bool napi_enabled;
 	struct napi_struct napi;
 	struct net_device napi_ndev;
 };
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 041a9602f0e15..5fd80f90ecafe 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -442,8 +442,11 @@ static void __ath12k_pci_ext_irq_disable(struct ath12k_base *ab)
 
 		ath12k_pci_ext_grp_disable(irq_grp);
 
-		napi_synchronize(&irq_grp->napi);
-		napi_disable(&irq_grp->napi);
+		if (irq_grp->napi_enabled) {
+			napi_synchronize(&irq_grp->napi);
+			napi_disable(&irq_grp->napi);
+			irq_grp->napi_enabled = false;
+		}
 	}
 }
 
@@ -976,7 +979,11 @@ void ath12k_pci_ext_irq_enable(struct ath12k_base *ab)
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		napi_enable(&irq_grp->napi);
+		if (!irq_grp->napi_enabled) {
+			napi_enable(&irq_grp->napi);
+			irq_grp->napi_enabled = true;
+		}
+
 		ath12k_pci_ext_grp_enable(irq_grp);
 	}
 }
-- 
2.39.5



