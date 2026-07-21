Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBD646A5FB;
	Tue, 21 Jul 2026 16:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649616; cv=none; b=r8yB5R7ZVmR7gv3SQtaCDqub6Pptn5pBaVIGINZu/AMPzD1kP2bUsN1gZ7BjYP/qK0Mij5t1Ij6pLiMz6v/dJr/I+EZkEu5dq376Fh0nsV2xzUgkgfsYZuGKgbSgJo9eDdtx4cS3zbray4hch1aaTGC0/ZzaAnvEI8wfYegaj/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649616; c=relaxed/simple;
	bh=nYXLpcxkuj5DsgCGoqPTfxiwVhVpP+T3fjSCYwN6OXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHHHYwuHGQfEi9OOE6OxpgMq+oyYR53h/SNxENIFH35WZlen5thDicb0wohspqsXZ6VnFLdEMzJb6nqRim6Uqboia37w4YwUtnL+THGI7EMjdKFdz7Hw4FNhGTXOtICXl0aN7eOw2ZdPGrGhFaXIbCBi7aPXy6a3qe2x86etE9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4BmL98I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4BmL98I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C111F000E9;
	Tue, 21 Jul 2026 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649615;
	bh=1LqkPPgegM2QyCJ8mJuYpucaLF4o2qLr1M0PG45tIRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4BmL98I9/KDqwGhEdwWR+NOiGMbIg/KEWRZ1om++a8fX4si3RqliKhfRbj3GgbD4
	 yQiEUp03L3lOOTzsvgDk7TBwv/qAO5U7YXue7R7T9lhCuUGD1OSgUVUOI1xoErggEN
	 meRvkWENqUY6jQhimSxakrlBhw+HgQ9I4Es/hzBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0600/2077] wifi: ath12k: fix EAPOL TX failure caused by stale tcl_metadata bits
Date: Tue, 21 Jul 2026 17:04:33 +0200
Message-ID: <20260721152606.955770136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit fdea4d44e4b9c3f7021c85f8cd766e84e224472d ]

On WCN7850, after the following sequence:

  1. load ath12k and connect to a non-MLO AP
  2. disconnect and connect to an MLO AP
  3. disconnect and reconnect to the non-MLO AP

the third connection always fails with a 4-Way handshake timeout. The
supplicant transmits message 2 of 4 four times in response to AP
retries of message 1, but the AP never sees any of them.

ath12k_dp_vdev_tx_attach() composes dp_link_vif->tcl_metadata using |=,
but dp_link_vif is embedded in struct ath12k_dp_vif and its slots are
reused across vif/peer teardown and setup. Since tcl_metadata is never
cleared on detach, vdev_id bits from a previous attach remain set when
the same link slot is reused with a different vdev_id. In this specific
issue, the same link slot is used for vdev_id 0, then vdev_id 1, then
vdev_id 0 again, the OR yields tcl_metadata == 0x9, which encodes
vdev_id 1 in the HTT_TCL_META_DATA_VDEV_ID field even though
ti.vdev_id is 0. Firmware then routes the EAPOL frame to the wrong
vdev and the AP never receives message 2.

Use plain assignment instead of |= so the field is fully recomputed
from the current arvif on every attach.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: af66c7640cf9 ("wifi: ath12k: Refactor ath12k_vif structure")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260609-ath12k-fix-eapol-tcl-metadata-v1-1-d47e6f90d4ee@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 90802ed1aa59f9..af5f11fc1d84ab 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -943,11 +943,11 @@ void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif)
 
 	dp_link_vif = ath12k_dp_vif_to_dp_link_vif(&ahvif->dp_vif, link_id);
 
-	dp_link_vif->tcl_metadata |= u32_encode_bits(1, HTT_TCL_META_DATA_TYPE) |
-				     u32_encode_bits(arvif->vdev_id,
-						     HTT_TCL_META_DATA_VDEV_ID) |
-				     u32_encode_bits(ar->pdev->pdev_id,
-						     HTT_TCL_META_DATA_PDEV_ID);
+	dp_link_vif->tcl_metadata = u32_encode_bits(1, HTT_TCL_META_DATA_TYPE) |
+				    u32_encode_bits(arvif->vdev_id,
+						    HTT_TCL_META_DATA_VDEV_ID) |
+				    u32_encode_bits(ar->pdev->pdev_id,
+						    HTT_TCL_META_DATA_PDEV_ID);
 
 	/* set HTT extension valid bit to 0 by default */
 	dp_link_vif->tcl_metadata &= ~HTT_TCL_META_DATA_VALID_HTT;
-- 
2.53.0



