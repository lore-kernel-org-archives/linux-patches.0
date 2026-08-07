Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50572389E13;
	Fri,  7 Aug 2026 14:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113743; cv=none; b=ON/vO34VXnyzHAWL0tv5ywQHhvqtrKwNuSajAT9kyG11fY4+AUgWeBGMUmQDo1/hpYsbOO+R5WMqy0EidwxykdkoZTvatg2JYq1697lQHIBKRtgrsvmFZVWiHF1Nz+GYv12PyKaCCRFr97X+h/2sNejuD8atcIYRp6zvqH/NuTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113743; c=relaxed/simple;
	bh=ltbeGHErsj4qtUDBw9chXsn6Fjibp4MuWES5NxNmX4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MY9zIfL6CII2vVr8Q2TN65HU7UyLTYjD3RVOr5NSKXaYj9XSXYqSqiT5SCkrvKTYltlqSVr0GmT9fEufEpV+v8BZbhLdnTEkHwQa7Y3NtIGxY782IEUCjrzG6sXZc6kuChzzTWsWQcgD7rqyVOOtkl+/s2WB32DldqxjbRsJYfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOnBHjB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOnBHjB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E4B1F00A3D;
	Fri,  7 Aug 2026 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113720;
	bh=QVxnOs6ng/T2z/d4sbqtR2fzVzzMy7sJFTEtTirmvWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOnBHjB5YhrvsjhGS57p6/R6w+XGunsh6fWy80SpVD+h1m7bT/J591cbZPtTrwZ6K
	 yFkeOhavVgeam4TNSkNdZs05q9tnoIZt8+I/q11Ik/8R72SR0pL41Ku6BwsAO5V4Tu
	 c4zZAN9y8pC0e6Eq8tnnsKqMmiQ1S403oafUyRkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wayen.Yan" <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/337] net: airoha: Fix register index for Tx-fwd counter configuration
Date: Fri,  7 Aug 2026 16:33:35 +0200
Message-ID: <20260807143418.787426408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 58e5791e9cd4..9ebc9788ded7 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2022,7 +2022,7 @@ static void airoha_qdma_init_qos_stats(struct airoha_qdma *qdma)
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



