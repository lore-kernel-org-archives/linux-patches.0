Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756C22E7641;
	Tue, 15 Jul 2025 13:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587703; cv=none; b=mTNX82/lV9qvHwQ5UW1nt4IBkSTTJhAqz3XxRL+c/u+9rfG+5N6nQooj5n7Y0a/ywvZ1IcMdHWCFGSlZM7Rx6sm5hxDWNjgzUT233XBr48CE6LkSoaXAFHJnLfBilvLOx7p2ygqYpqPrnlYiwMJK/ek3BqO/hyVm/IVLjaHJ3SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587703; c=relaxed/simple;
	bh=F8s/nY/0RZ1TTQhD37cA2pIYndMZJtQoQ9dw8zbnRJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjDLvNnNszk/QlzL9E9wWnFaW45236QZKVAZGQaT9BMQIN1WxvgJzNX8V6Bied2+wmM3iJn/oymLOIeC7uvYcDFVf3GWdyqz/YcCIZ7EvY2SeBvB9qaAjn5VPLMR7NlTsZa9TbCdmUY6lp6cLpBKbD9L2A2BoZkn/IK3LA9Olik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvutzSyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvutzSyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069D3C4CEE3;
	Tue, 15 Jul 2025 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587703;
	bh=F8s/nY/0RZ1TTQhD37cA2pIYndMZJtQoQ9dw8zbnRJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvutzSyPVT1y/GC8v+iosCPXf7i+4DSsJ6FcHXaV7q+tavcryte3Rr+eTXXomD/gv
	 fVkldVp9mdmIPlBszotA+YDvOAbo5J+Gm3lJdpZS/eHpSBFyMrbsKFNwneU/3Kd9we
	 ZBU8kd4yib05gXL14LEGZpHlBG3XKfLpNuLhP2R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/208] mtk-sd: reset host->mrq on prepare_data() error
Date: Tue, 15 Jul 2025 15:13:41 +0200
Message-ID: <20250715130815.434585110@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit ec54c0a20709ed6e56f40a8d59eee725c31a916b ]

Do not leave host with dangling ->mrq pointer if we hit
the msdc_prepare_data() error out path.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Fixes: f5de469990f1 ("mtk-sd: Prevent memory corruption from DMA map failure")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250625052106.584905-1-senozhatsky@chromium.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 2c998683e3e33..8d0f888b219ac 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1290,6 +1290,7 @@ static void msdc_ops_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	if (mrq->data) {
 		msdc_prepare_data(host, mrq->data);
 		if (!msdc_data_prepared(mrq->data)) {
+			host->mrq = NULL;
 			/*
 			 * Failed to prepare DMA area, fail fast before
 			 * starting any commands.
-- 
2.39.5



