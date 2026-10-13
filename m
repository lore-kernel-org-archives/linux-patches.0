Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B88D4F7CCD;
	Tue, 13 Oct 2026 11:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892721; cv=none; b=D0z0Pu0co6u4Tg748a96Di2d4woIksoIrtrM76OyKADbqXtLYqL32rXcKMXs51CW0KMqBSLn/58a/SuPEWeKK049zMyDu/fRKc8jnR6GaN8yXTYxxGogpQjue3CgbVf2XAHwLSwrx+yiRAZlj1m6Nzce5eCjmlNsndXm3EaFE8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892721; c=relaxed/simple;
	bh=q56iSok/paUq/LbUvT+u3oQ62Vzl9+SQHqyOyk3oz1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/6mdfjzM+X8qdk7Yx0D6TT+v3x58mn5FpPHIFP90b64xasxK27bTMwxGB6fXvJibCBpHSqVhleYLUtmGgNLGjNn78yFHyOsUl3fG7g8NR4DpGK3uBzNsVbIcGDbME6XHmqAILJwWtC8e5N9JEOM0JTExYplWqu9VNRdq2K+jRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7BX8Y/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7BX8Y/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA3B1F000FF;
	Tue, 13 Oct 2026 11:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892719;
	bh=pVn7MpRY6ohBlXviPhrYz6ScF6T4bkRLCOQlqSdaI/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7BX8Y/tUceJlAj8cG5K4OV2T5WPTLCqpakUcVo1SR4stQj1ENdgEZf+1fDOtQd1t
	 oPfddyAVZJjTG5aoU0028il2p1yHG6iI/0ctS9AFbQ0j/zc240gS/LxKt6Q0yd+rgz
	 TcQLzfVkDek98a+vTqaCBWZIrlNXUyEsc25uqSlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Leto=20Liu=20 ?= <Leto.Liu@airoha.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 223/281] net: airoha: Add retry mechanism to airoha_qdma_set_trtcm_param()
Date: Tue, 13 Oct 2026 13:38:59 +0200
Message-ID: <20261013112900.568618216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leto Liu (刘涛) <Leto.Liu@airoha.com>

[ Upstream commit 7e170da2edec9fb0717543571cc14b0aabee2b46 ]

CPU accesses QDMA via the bus. When multiple modules are using the bus
simultaneously, CPU access to QDMA may encounter bus timeouts and fails,
resulting in QDMA configuration failures and potentially causing packet
transmission issues. In order to mitigate the issue, introduce a retry
mechanism to airoha_qdma_set_trtcm_param routine in order to ensure the
configuration is correctly applied to the hardware.

It's enough to try a second time for the TRTCM config to be actually
applied to make sure we are not in the middle of bucket handling as it does
operate on fixed time slot internally.

Fixes: ef1ca9271313b ("net: airoha: Add sched HTB offload support")
Signed-off-by: Leto Liu (刘涛) <Leto.Liu@airoha.com>
[ improve commit description, drop memory block, apply better loop logic]
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://patch.msgid.link/20260930065855.46171-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 32 +++++++++++++++++++-----
 drivers/net/ethernet/airoha/airoha_eth.h |  2 ++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 2fc8c91f210c6..d4faf4503487e 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2716,14 +2716,34 @@ static int airoha_qdma_set_trtcm_param(struct airoha_qdma *qdma, int channel,
 		     FIELD_PREP(TRTCM_METER_GROUP_MASK, group) |
 		     FIELD_PREP(TRTCM_PARAM_INDEX_MASK, idx) |
 		     FIELD_PREP(TRTCM_PARAM_RATE_TYPE_MASK, mode);
+	int i;
 
-	airoha_qdma_wr(qdma, REG_TRTCM_DATA_LOW(addr), val);
-	airoha_qdma_wr(qdma, REG_TRTCM_CFG_PARAM(addr), config);
+	/*
+	 * HW might be in the middle of bucket handling and might
+	 * require an additional try to actually apply the new TRTCM
+	 * config.
+	 */
+	for (i = 0; i < TRTCM_CONFIG_RETRY_MAX; i++) {
+		u32 data = 0;
 
-	return read_poll_timeout(airoha_qdma_rr, val,
-				 val & TRTCM_PARAM_RW_DONE_MASK,
-				 USEC_PER_MSEC, 10 * USEC_PER_MSEC, true,
-				 qdma, REG_TRTCM_CFG_PARAM(addr));
+		airoha_qdma_wr(qdma, REG_TRTCM_DATA_LOW(addr), val);
+		airoha_qdma_wr(qdma, REG_TRTCM_CFG_PARAM(addr), config);
+
+		if (read_poll_timeout(airoha_qdma_rr, data,
+				      data & TRTCM_PARAM_RW_DONE_MASK,
+				      USEC_PER_MSEC, 10 * USEC_PER_MSEC,
+				      true, qdma, REG_TRTCM_CFG_PARAM(addr)))
+			continue;
+
+		if (airoha_qdma_get_trtcm_param(qdma, channel, addr, param,
+						mode, &data, NULL))
+			continue;
+
+		if (data == val)
+			return 0;
+	}
+
+	return -EBUSY;
 }
 
 static int airoha_qdma_set_trtcm_config(struct airoha_qdma *qdma, int channel,
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 70f16189b2582..dc0c29001f810 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -171,6 +171,8 @@ enum trtcm_param {
 #define TRTCM_TOKEN_RATE_MASK			GENMASK(23, 6)
 #define TRTCM_TOKEN_RATE_FRACTION_MASK		GENMASK(5, 0)
 
+#define TRTCM_CONFIG_RETRY_MAX			2
+
 enum airoha_dma_map_type {
 	AIROHA_DMA_UNMAPPED,
 	AIROHA_DMA_MAP_SINGLE,
-- 
2.53.0



