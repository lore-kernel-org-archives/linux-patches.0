Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046982;
	b=G4M98T26tcg0dNM729aSuww/cTdGjrX8qlFqTj+80QXGoEQkIIUWRRUxpJoGD+S0oKP+
	 gAp/HcidnQQS9IKd7PRJyMT+FHf4v0PGwCHyQV9RmH63lN7WOyDbJf5N5s+0UAg3a5VOw
	 Q46Fa4g3VIxelq8sLbQkIU082Zyg5XU6DXTPLRG9Kdo+yAvkasohxgIOs79E6VniU6rCA
	 Os5LHwgQ2NmOSwnBB/kjFzJM14Cw4XO/gbqQzmiDTufgu8zknxu+oXy4LlTbMgCJfUUNK
	 Eq50EbCFa07XAur+dBRThvkItC8ix2bquKT1DXNZYFxSJVLYSG6DZsMizv4Z4bWamCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DgtDhHzwknjD9AD44ppqdauFPrW+VabpGySmcFiZD/8=;
	b=RjufFK8CF66zgI/FE9xYhfigyC7kE4tunQqQAqZu9ox1W5x0wH/q6alwLamYnqlDZWoa
	 ESMk0Pa9cO3cHdAW5PMhBGJawXzEcQZQtpO9/bmg82w3BzW9S2tURbaFB7rUAWIsUAts1
	 lcFyUe5WyIf1XmxyxUbAqjxz9E17LFu3rNVloDeJ1rNuO5etoxcR6srNby/qEVajusc1l
	 7REYw5gNm9AtaF69J1pZa1yVsiealXURmpKE6Tpu/Me7XZxgJdVOeM8OdfKo1ebvzXPss
	 337NqtYE/0irG+1VEjCpUvhKblwLbVdkJlTXVrZeIDeE4hAcakQdkh0ZJYHvy/x7Fvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=02Ru+Gsi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5A3606A325;
	Thu, 19 Nov 2026 00:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=02Ru+Gsi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186521F000C4;
	Thu, 19 Nov 2026 00:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046982;
	bh=DgtDhHzwknjD9AD44ppqdauFPrW+VabpGySmcFiZD/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02Ru+Gsib+713ydQIEj8lgQypDpGYUfKvO/6UVUoIeTQpo0kWoX+IvovKA5yvafHg
	 g3pr/qMCB65c4OljfU9SdT0vyY/a4YiLKU5bsSbXNhzRvy8wtXaj9nWJZS1ZLLYU6N
	 NeQskGPG011vOqW1tRbcL+PwTjJlWNOzn9BQ/nh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1477/2857] IB/hfi1: Shutdown self-rearming timers before freeing
Date: Wed, 18 Nov 2026 15:41:51 +0100
Message-ID: <20261118150254.491587887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 9d3259e41ccd5016cd2c6d013232b89df6d73011 ]

The HFI1 receive error and synthetic counter timers rearm themselves from
their callbacks. Their cleanup paths use timer_delete_sync(), which only
waits for a running callback and does not prevent a concurrent or
subsequent rearm.

Use timer_shutdown_sync() when releasing these timers. This prevents a
callback from enqueueing either timer after cleanup begins, before the
containing hfi1_devdata is freed.

Preserve the existing work cancellation and workqueue destruction ordering
for synthetic counters.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260930070455.2934286-1-runyu.xiao@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ sashal: adjusted context for existing del_timer_sync() calls instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 3ef47ffd3859f..8d9a64637f2cf 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -5575,7 +5575,7 @@ static int init_rcverr(struct hfi1_devdata *dd)
 static void free_rcverr(struct hfi1_devdata *dd)
 {
 	if (dd->rcverr_timer.function)
-		del_timer_sync(&dd->rcverr_timer);
+		timer_shutdown_sync(&dd->rcverr_timer);
 }
 
 static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
@@ -12306,7 +12306,7 @@ static void free_cntrs(struct hfi1_devdata *dd)
 	int i;
 
 	if (dd->synth_stats_timer.function)
-		del_timer_sync(&dd->synth_stats_timer);
+		timer_shutdown_sync(&dd->synth_stats_timer);
 	cancel_work_sync(&dd->update_cntr_work);
 	ppd = (struct hfi1_pportdata *)(dd + 1);
 	for (i = 0; i < dd->num_pports; i++, ppd++) {
-- 
2.53.0



