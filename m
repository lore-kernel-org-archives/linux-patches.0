Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB781C68A5;
	Tue, 27 Aug 2024 14:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770016; cv=none; b=SmI2dPdFEQ1XON1mgwlPuYcZ4qjinv6Jdd6xhTsDmSgD32UlUQKBDTTsCvdIIasldcMGjMJVVuLEC/AgNhQSp7wELNjpdYtJgFSSQmjF5N85cx1GFpSiX5oL4UvRfwp27lyCAgS/xJQ0vCCfv5kE1VqDoPNKpoEKWMW/ZIWu5G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770016; c=relaxed/simple;
	bh=6/m4olA2rTfA5/UYD3cOY5nDQxYPvcgcl8m/lI8luUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEibaqMEKizI463u2KY5ko7wISUeryftcnAmvPnTUoFaVV7bZhEjefa2DU8EBKgQqwkbl65pnkBel8BZPM9MI4fLRsUOJuI2e8Xllux+KlwbbR1riT7JWNfrJq2iT4CqaysnOcpzQ6wPxvYjcTytfWHkEXdU/8la8x4XtQpdlzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PdIEgi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PdIEgi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB77FC6106D;
	Tue, 27 Aug 2024 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770016;
	bh=6/m4olA2rTfA5/UYD3cOY5nDQxYPvcgcl8m/lI8luUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0PdIEgi3Xg5Khi9bt6evn9GD9I2C2lKG1qmyQouo+6HQKVWnOXJhzBIq4NOAqyGjS
	 eWHQQ1Ix0fkDHchGP4mDeAv678CBbeRMXNeLUBGdZCqy9YGqK4IOHGW2y9hq6dgLhf
	 ySAmirWrbCGVbd1i/U2Bdz+c7Cin27K9xCcwkpNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Dharanenthiran <quic_mdharane@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/341] wifi: ath12k: fix WARN_ON during ath12k_mac_update_vif_chan
Date: Tue, 27 Aug 2024 16:35:33 +0200
Message-ID: <20240827143847.288786052@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Manish Dharanenthiran <quic_mdharane@quicinc.com>

[ Upstream commit 8b8b990fe495e9be057249e1651b59b5ebacf2ef ]

Fix WARN_ON() from ath12k_mac_update_vif_chan() if vdev is not up.
Since change_chanctx can be called even before vdev_up.

Do vdev stop followed by a vdev start in case of vdev is down.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0-02903-QCAHKSWPL_SILICONZ-1

Signed-off-by: Manish Dharanenthiran <quic_mdharane@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230802085852.19821-2-quic_mdharane@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 61435e4489b9f..ba6fc27f4a1a1 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -6039,13 +6039,28 @@ ath12k_mac_update_vif_chan(struct ath12k *ar,
 		if (WARN_ON(!arvif->is_started))
 			continue;
 
-		if (WARN_ON(!arvif->is_up))
-			continue;
+		/* Firmware expect vdev_restart only if vdev is up.
+		 * If vdev is down then it expect vdev_stop->vdev_start.
+		 */
+		if (arvif->is_up) {
+			ret = ath12k_mac_vdev_restart(arvif, &vifs[i].new_ctx->def);
+			if (ret) {
+				ath12k_warn(ab, "failed to restart vdev %d: %d\n",
+					    arvif->vdev_id, ret);
+				continue;
+			}
+		} else {
+			ret = ath12k_mac_vdev_stop(arvif);
+			if (ret) {
+				ath12k_warn(ab, "failed to stop vdev %d: %d\n",
+					    arvif->vdev_id, ret);
+				continue;
+			}
 
-		ret = ath12k_mac_vdev_restart(arvif, &vifs[i].new_ctx->def);
-		if (ret) {
-			ath12k_warn(ab, "failed to restart vdev %d: %d\n",
-				    arvif->vdev_id, ret);
+			ret = ath12k_mac_vdev_start(arvif, &vifs[i].new_ctx->def);
+			if (ret)
+				ath12k_warn(ab, "failed to start vdev %d: %d\n",
+					    arvif->vdev_id, ret);
 			continue;
 		}
 
-- 
2.43.0



