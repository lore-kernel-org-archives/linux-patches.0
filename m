Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C522D2E7BBD;
	Tue, 15 Jul 2025 13:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587697; cv=none; b=FeCbk66SMIiWEnNjLRKPpeS+/COpFYZtE43QFXpsfKRnHEqF1MsA9vWFdGPn3dnRDkuO22Z73tBKmqyH77CAl4EFhnNWkg5vYirNjcyG61ORFg7yK+aLKd0SPQ7V5qzd+LE5hCYB+lbiqLVkgtURWfVY57odamH6fZ3wAeHV+1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587697; c=relaxed/simple;
	bh=ZzBm4Q7IJcFoxBCxICyH4K/AGoD05nsNBwf37xiSoLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNyKjGN4MCAhV2lVq+zlzDOXV2JIH+0tQ4GJSxFA2yQLFRHLqV0NaXY8v8DRlcpa8JuX4GSdTSN8bPc+Q8EmXAANL3m3Zk2OtjymdfqskmMUnzzwYqIW6k83KbANcoz9iGHJ4pLzg9y/IJFimLmaFNtkSbrf47UGDahASqRVO7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/4Etyw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/4Etyw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59141C4CEE3;
	Tue, 15 Jul 2025 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587697;
	bh=ZzBm4Q7IJcFoxBCxICyH4K/AGoD05nsNBwf37xiSoLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/4Etyw06ZMFz5RLcE4XnZRaRkiUy+KOsy6rAI/9cFef+HwY18EMS4B2iuPN+96mG
	 mkDupeSEekG8hYE5aoUNKsk2TxRlmBL78w0LZDphWIASErSW4Er/IDT02eFzQM+POP
	 bsNjCrJmNA5BwUxCpJb/DvSfy7i+noCSVU/yuXpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@yulong.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/208] mmc: mediatek: use data instead of mrq parameter from msdc_{un}prepare_data()
Date: Tue, 15 Jul 2025 15:13:39 +0200
Message-ID: <20250715130815.356450284@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Hu <huyue2@yulong.com>

[ Upstream commit 151071351bb6f3d1861e99a22c4cebadf81911a0 ]

We already have 'mrq->data' before calling these two functions, no
need to find it again via 'mrq->data' internally. Also remove local
data variable accordingly.

Signed-off-by: Yue Hu <huyue2@yulong.com>
Link: https://lore.kernel.org/r/20210517100900.1620-1-zbestahu@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: f5de469990f1 ("mtk-sd: Prevent memory corruption from DMA map failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 3f82e0f9dc057..f6bb3b45b37ff 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -708,10 +708,8 @@ static inline void msdc_dma_setup(struct msdc_host *host, struct msdc_dma *dma,
 	writel(lower_32_bits(dma->gpd_addr), host->base + MSDC_DMA_SA);
 }
 
-static void msdc_prepare_data(struct msdc_host *host, struct mmc_request *mrq)
+static void msdc_prepare_data(struct msdc_host *host, struct mmc_data *data)
 {
-	struct mmc_data *data = mrq->data;
-
 	if (!(data->host_cookie & MSDC_PREPARE_FLAG)) {
 		data->sg_count = dma_map_sg(host->dev, data->sg, data->sg_len,
 					    mmc_get_dma_dir(data));
@@ -720,10 +718,8 @@ static void msdc_prepare_data(struct msdc_host *host, struct mmc_request *mrq)
 	}
 }
 
-static void msdc_unprepare_data(struct msdc_host *host, struct mmc_request *mrq)
+static void msdc_unprepare_data(struct msdc_host *host, struct mmc_data *data)
 {
-	struct mmc_data *data = mrq->data;
-
 	if (data->host_cookie & MSDC_ASYNC_FLAG)
 		return;
 
@@ -1116,7 +1112,7 @@ static void msdc_request_done(struct msdc_host *host, struct mmc_request *mrq)
 
 	msdc_track_cmd_data(host, mrq->cmd, mrq->data);
 	if (mrq->data)
-		msdc_unprepare_data(host, mrq);
+		msdc_unprepare_data(host, mrq->data);
 	if (host->error)
 		msdc_reset_hw(host);
 	mmc_request_done(mmc_from_priv(host), mrq);
@@ -1287,7 +1283,7 @@ static void msdc_ops_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	host->mrq = mrq;
 
 	if (mrq->data)
-		msdc_prepare_data(host, mrq);
+		msdc_prepare_data(host, mrq->data);
 
 	/* if SBC is required, we have HW option and SW option.
 	 * if HW option is enabled, and SBC does not have "special" flags,
@@ -1308,7 +1304,7 @@ static void msdc_pre_req(struct mmc_host *mmc, struct mmc_request *mrq)
 	if (!data)
 		return;
 
-	msdc_prepare_data(host, mrq);
+	msdc_prepare_data(host, data);
 	data->host_cookie |= MSDC_ASYNC_FLAG;
 }
 
@@ -1316,14 +1312,14 @@ static void msdc_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
 		int err)
 {
 	struct msdc_host *host = mmc_priv(mmc);
-	struct mmc_data *data;
+	struct mmc_data *data = mrq->data;
 
-	data = mrq->data;
 	if (!data)
 		return;
+
 	if (data->host_cookie) {
 		data->host_cookie &= ~MSDC_ASYNC_FLAG;
-		msdc_unprepare_data(host, mrq);
+		msdc_unprepare_data(host, data);
 	}
 }
 
-- 
2.39.5



