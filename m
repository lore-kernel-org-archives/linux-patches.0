Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038420;
	b=OA7WkQUCubp6fnwVKPnWMMNk+HNSSiwrocdcvFik2GtoT0nX8ucfZm3ZFNRtVABI5XfG
	 yJLPxsw6QvOdxXKaVw3SSYdTF9PYw5FvhSvYgva8pjw+AslPfYsuNGMY0XXRF21Z2C7fz
	 EkTiZBv7JrRFwvuq9p+8P01B/wsjRxX6gnoPNufVX4tf6lf9D07L5XGSiGOfu2/Oml3Qy
	 I7MWYtFACOzxUsFPuEF18T7i3O3rkevUtn3aj+a/f1SyoRgE+S2BnLkzMMgbsR7W1IXy9
	 PB+TxujswQ2J2mn04wh9unew9eix312fMP1AXgojnxyhJc6DqFRsSnlM7dJKNQu7Ayw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qyFMQRLITMVohTOBqqNEonr5/sXY8i2J1dAZq2UtN3w=;
	b=kcc90xTsHHBmHC6IuELDtZ0pGboWifNzWcqlYn34y4qd7GxU6/IPpmD31jqLrjKWfmLz
	 Xr3vNJe7yp7ALnyf2OnCEMbZDSxMkbgYiXNUDSqFr0xUE7UZOvlZDybYlgU06+FUyKD9L
	 9OFAlSdxXGDXJy7X/jBTpUTLBX24cyM+lZj9kqFpJBiSFSOChuQB9zhRraEmums1NEh7/
	 Xe7r6RL6SizP+TnVCtCAw9QJ/ouDqilnWNRQD9JXawwZzEVaujrIVnlyMdWLZ7wOGZpX1
	 KOukirxEUz2Y8rS2GLrOf/R6FiEdzUjZzc6K1Wekif+xpNh5GMtCb6QlBzsh2/DGVVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uKtuafq0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2695A606A325;
	Wed, 18 Nov 2026 21:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uKtuafq0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1CA1F000C4;
	Wed, 18 Nov 2026 21:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038420;
	bh=qyFMQRLITMVohTOBqqNEonr5/sXY8i2J1dAZq2UtN3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKtuafq0+ZJkA4U+ZMaPrmvtUY4rYR0fhRN5WiLei5UM1m0bEqvMZlmNd73MjKLnx
	 yX6yDd0XlRDK7S45bFicfcrqQ2FfwKWGEOgQ8liWmMKq5VcyCMGupY32R3XPCQnpNc
	 JsuiRy5blFUqY/Bex9OOn1fmHQHfS+tZ/auOeffQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1735/3318] IB/hfi1: Shutdown self-rearming timers before freeing
Date: Wed, 18 Nov 2026 15:39:17 +0100
Message-ID: <20261118150413.916587527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 00a054007822f..c40ae27e9a94b 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -5576,7 +5576,7 @@ static int init_rcverr(struct hfi1_devdata *dd)
 static void free_rcverr(struct hfi1_devdata *dd)
 {
 	if (dd->rcverr_timer.function)
-		del_timer_sync(&dd->rcverr_timer);
+		timer_shutdown_sync(&dd->rcverr_timer);
 }
 
 static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
@@ -12308,7 +12308,7 @@ static void free_cntrs(struct hfi1_devdata *dd)
 	int i;
 
 	if (dd->synth_stats_timer.function)
-		del_timer_sync(&dd->synth_stats_timer);
+		timer_shutdown_sync(&dd->synth_stats_timer);
 	cancel_work_sync(&dd->update_cntr_work);
 	ppd = (struct hfi1_pportdata *)(dd + 1);
 	for (i = 0; i < dd->num_pports; i++, ppd++) {
-- 
2.53.0



