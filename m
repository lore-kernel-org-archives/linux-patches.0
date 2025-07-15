Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67E42E54B7;
	Tue, 15 Jul 2025 13:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586478; cv=none; b=fHNDDB/Y4T/LqdeMDYQdulNVyKtYdtBhRGQNAfUDiuuhjzGojW8S+h/Yeae2083UD3DOIVQEvMcKWecDCM1H+Z9s0wKPcJh8lrM+uqkUUUvj1pJgSpJt/HbiDxQaf+aM0OU2brn+mIMWrFr//u1jrxgdEOeDcVLg6XXE9oD+d24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586478; c=relaxed/simple;
	bh=Qels/7FSUrJiI/CH+g+/+VtrnRWAtFJkKB7jWbK39SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/WzHl0exyr8jQ0P8KmuCl6Czil9BcfKGo4k0iBw9TzjVKYDJzpt0OUaeVPKiGi6yTRPQcgsTb819Fxr3I0CHhzCu42n44Lh7Bq20UmfEU7goiOo6zdS4UlNV/XQLDzV/ddFVxUepKnmjCTt38JAppTXjbixbGwyuq04IQbBPwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2A4jpsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2A4jpsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29409C4CEE3;
	Tue, 15 Jul 2025 13:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586478;
	bh=Qels/7FSUrJiI/CH+g+/+VtrnRWAtFJkKB7jWbK39SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2A4jpsO30GeIE6qe7dk6YCgd8IC/EsVWSAUkU+MX26BEbzq1cHb9uax2RbSYksvB
	 Am6qD603dtUwWAPNanR1maFSAO2RAyInXehGHo8l4DHRXzJvxbXBI0Gz2ZkOsPDazD
	 JKC4MI3QYuk9n3O3lXCNbtb4cq3Hq2oqWklXQvj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@yulong.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/148] mmc: mediatek: use data instead of mrq parameter from msdc_{un}prepare_data()
Date: Tue, 15 Jul 2025 15:13:23 +0200
Message-ID: <20250715130803.565069705@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c87227bf6e68f..5d330f2a3faae 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -676,10 +676,8 @@ static inline void msdc_dma_setup(struct msdc_host *host, struct msdc_dma *dma,
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
@@ -688,10 +686,8 @@ static void msdc_prepare_data(struct msdc_host *host, struct mmc_request *mrq)
 	}
 }
 
-static void msdc_unprepare_data(struct msdc_host *host, struct mmc_request *mrq)
+static void msdc_unprepare_data(struct msdc_host *host, struct mmc_data *data)
 {
-	struct mmc_data *data = mrq->data;
-
 	if (data->host_cookie & MSDC_ASYNC_FLAG)
 		return;
 
@@ -1034,7 +1030,7 @@ static void msdc_request_done(struct msdc_host *host, struct mmc_request *mrq)
 
 	msdc_track_cmd_data(host, mrq->cmd, mrq->data);
 	if (mrq->data)
-		msdc_unprepare_data(host, mrq);
+		msdc_unprepare_data(host, mrq->data);
 	if (host->error)
 		msdc_reset_hw(host);
 	mmc_request_done(host->mmc, mrq);
@@ -1203,7 +1199,7 @@ static void msdc_ops_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	host->mrq = mrq;
 
 	if (mrq->data)
-		msdc_prepare_data(host, mrq);
+		msdc_prepare_data(host, mrq->data);
 
 	/* if SBC is required, we have HW option and SW option.
 	 * if HW option is enabled, and SBC does not have "special" flags,
@@ -1224,7 +1220,7 @@ static void msdc_pre_req(struct mmc_host *mmc, struct mmc_request *mrq)
 	if (!data)
 		return;
 
-	msdc_prepare_data(host, mrq);
+	msdc_prepare_data(host, data);
 	data->host_cookie |= MSDC_ASYNC_FLAG;
 }
 
@@ -1232,14 +1228,14 @@ static void msdc_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
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



