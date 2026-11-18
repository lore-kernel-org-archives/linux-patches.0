Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053889;
	b=x0+WbB49LvGvd78Wb8MlT4Idn+IzAaORrsNT1p1skbgDdWPuNAemDKqzb7QQ0NtX2krq
	 iiOl9gNo5rSN7rihL1KsnDrhJlPEC/NXYJWje56S1wG9Z8bG7qTYXBgsE3ApAQWilPq5V
	 kUwTnxICtdVdH9K/0tf0RrWYFy1csBQ2OFo6eaEo73FCs0aLNEiFFHgdaQgdxuleZkc0H
	 N9/suvZbMjfb1rtHcQBK2m7crTiWzFpA9NljYQalqFpgeliLzMq9aYGerVNvFJNFjtkM2
	 48OCX7ku3WsnoOLpgeo2ZcltFOwg4ekJRnL2eWJ1JPHnADSGFQrsJU0/5TiONYudEvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qxfesz+KzdnXZIgjGta5CdJGUH/5UaXxo+ZWnSR8iOU=;
	b=z2J5nRbqV/x5GdhWyFWitrjMeSKp8iWVvF1Z0MkiPc0cNoX+2islXM/X5rxSTE7/eqjN
	 UqAfoqT8SKX+MSBRPY0h+3lsqokOwIx+g88ZKSPUBy48AeAZyMp/AeakRjFZnJOgsu1lI
	 mdISL722WOWDzSMhCWLenxqYzWXfff0W0BB5iGB97CgVm3xQbCMaCZ3IR77hZmb88fHAs
	 Fgkr/LVY05PNo2SyufRimYNNPVMgJxrbIa3LD08m2noLcFgpRIaW9HqVJEgLjb+DD81cT
	 zKgySukgFrrQtxB7drsKhJHg7qRjaHSZKyBvRRWeUP3NAsDbXWXow3WrDGAjEJRvXwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EiZMQ+dp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DC0606A325;
	Thu, 19 Nov 2026 02:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EiZMQ+dp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8CD1F000C4;
	Thu, 19 Nov 2026 02:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053888;
	bh=qxfesz+KzdnXZIgjGta5CdJGUH/5UaXxo+ZWnSR8iOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiZMQ+dpxoPVNJ5YOvCL9QZuzREo/li5Gc21AaJNvKIkI6fmFvQSwEi7z7z+2Ejx1
	 CZnHwURgsaJHUSlsgxX7KYK7sn5AXSdB0px8YVg8YjXs3q4u8xNku7JgkRZSIwXXMZ
	 7vBSLi2qZ2H7arZzgF8Ht5fXd/2E3OgBPhjalaSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1080/2214] IB/hfi1: Shutdown self-rearming timers before freeing
Date: Wed, 18 Nov 2026 15:45:56 +0100
Message-ID: <20261118150055.451256475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for del_timer_sync() instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 6bdc2152cb41e..c1bf19ad0bab0 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -5574,7 +5574,7 @@ static int init_rcverr(struct hfi1_devdata *dd)
 static void free_rcverr(struct hfi1_devdata *dd)
 {
 	if (dd->rcverr_timer.function)
-		del_timer_sync(&dd->rcverr_timer);
+		timer_shutdown_sync(&dd->rcverr_timer);
 }
 
 static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
@@ -12305,7 +12305,7 @@ static void free_cntrs(struct hfi1_devdata *dd)
 	int i;
 
 	if (dd->synth_stats_timer.function)
-		del_timer_sync(&dd->synth_stats_timer);
+		timer_shutdown_sync(&dd->synth_stats_timer);
 	cancel_work_sync(&dd->update_cntr_work);
 	ppd = (struct hfi1_pportdata *)(dd + 1);
 	for (i = 0; i < dd->num_pports; i++, ppd++) {
-- 
2.53.0



