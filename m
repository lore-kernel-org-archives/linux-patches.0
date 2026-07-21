Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD8346E009;
	Tue, 21 Jul 2026 18:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659881; cv=none; b=G5WtXXm5USsoth8NmOdN/HY1R9j/AfdVQYzS0uuP8iR5uNbf5sxvwXBWD5BtS3Ty8/rtQR1DbVMw18zrd/iQSF4ieMcYnAo/JQtkYyZ+PHeVejfqUUXFq6zvQJS9rSlMBYVE3gO7lUogV2WkHAWtiYHmuoSdmwRX0U0fBxoab5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659881; c=relaxed/simple;
	bh=9qLfgsCdj+6pBGanswdHGAIsMazpn3xmKd9uDAuBhFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbmOBpziNCI74tooUj5FCMozR417Fgnskrm4Pp6oFcpXeUzl00FP84KlMtZ53bOsO1hvnlMBBlzkwOTyn8y13mYfyJdXYiXe4BK2Ksfl2vQi6GIdzj7NkhyfvuDxT+pEIiYuwG7ITgV+sGDKozXKw5vkHIpRWhtJWsz75k+VUYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1zhl1wi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1zhl1wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B241F000E9;
	Tue, 21 Jul 2026 18:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659879;
	bh=PSSSqbCKN/WzJHDjgE1Jd4PM3Tk1/mUEr4uyyDO0k8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1zhl1wiQLoi1cyWpibaAOCFz8UbSbkC/qcEt+oCGCOHF0DWT+WQEgfnXGaMrlD2j
	 OXuJ6iyec0tP3BRWCYOMus3rFJpBGZhUb+yV7e33jplg/aRXHYs/Pt6yTaMIVLsjPN
	 T74tnv19iJ/Vo9Meb9o4flDJonPE+wUtfyH8Gg1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wayen.Yan" <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0767/2077] net: airoha: Fix register index for Tx-fwd counter configuration
Date: Tue, 21 Jul 2026 17:07:20 +0200
Message-ID: <20260721152610.887262544@linuxfoundation.org>
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

From: Wayen.Yan <win847@gmail.com>

[ Upstream commit 1402ecccf5630a0b7fa4749d7d2e72abc3f3d73d ]

In airoha_qdma_init_qos_stats(), the Tx-fwd counter configuration
register uses the same index (i << 1) as the Tx-cpu counter, which
overwrites the Tx-cpu configuration. The Tx-fwd counter value register
correctly uses (i << 1) + 1, so the configuration register should use
the same index.

Fix the REG_CNTR_CFG index from (i << 1) to ((i << 1) + 1) so that
the Tx-fwd counter is properly configured instead of clobbering the
Tx-cpu counter config.

Fixes: 20bf7d07c956 ("net: airoha: Add sched ETS offload support")
Signed-off-by: Wayen.Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/6a2b40e7.4dd82583.3a5c46.e566@mx.google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 31cdb11cd78dac..329988a8400c13 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1256,7 +1256,7 @@ static void airoha_qdma_init_qos_stats(struct airoha_qdma *qdma)
 			       FIELD_PREP(CNTR_CHAN_MASK, i));
 		/* Tx-fwd transferred count */
 		airoha_qdma_wr(qdma, REG_CNTR_VAL((i << 1) + 1), 0);
-		airoha_qdma_wr(qdma, REG_CNTR_CFG(i << 1),
+		airoha_qdma_wr(qdma, REG_CNTR_CFG((i << 1) + 1),
 			       CNTR_EN_MASK | CNTR_ALL_QUEUE_EN_MASK |
 			       CNTR_ALL_DSCP_RING_EN_MASK |
 			       FIELD_PREP(CNTR_SRC_MASK, 1) |
-- 
2.53.0



