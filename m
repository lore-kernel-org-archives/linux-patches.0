Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063060;
	b=mmER65DVTOCVCKqhiTsgX5vBmiKqtlNvLTBZCCCx05sJ63FM/35VE3cbXZWFmUelC7bS
	 H6+YSciTiKixTprwPya+QytvLMzY4A20N2Xuqn7yyjODoz/s7kc4LRjfdB8SObGYMf8G5
	 Zsl8BHIsd79eeeFRTDN6RI7lpx2UU6Xr61yt2DpJk79Im/x8qZAsS6SCO+AdcNG+lEzgm
	 W6XvllymMa3daWV1h9cl0Xzb9VgjCmCcDnOs422QSjqwqSsAEqCXRyxS2xbNjTZjbnHFP
	 9eybcwiLX0iLNaPnccpebN7IGW64yjzvDl2v6B5Nb8RjYBHNQ76ipcxpLB2YUdKeHUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mynafsa33fdWbIPTsomvcLqpbax6j5fw+iLjFLybIuc=;
	b=3G9YKHyOwtkJC7gSMLSO+Eg9+BYRUlWZbMtvUNfUVG/gsDkNKgMLfn+77FM59bj+8bHK
	 iJ2TjH5Fby4J4GYU6bdz0XcgFt2fpphp3M4hXIjYCIT96pwMTqUhoDVk0VQVkM+vMkCC4
	 Z/DQyprSym9ZSWTTsF2F2cHxyi8ChpOpxVEcM+eJqYG3vAe83dBKGkgkHI+hwLcsmcxLa
	 T7VkC1qKKSi7hWRQFH4N9tYJHcfCmSr5onI6Bwf+b2ohjcJ7IAagz1usANZwOEKNYcsdh
	 KO/9ZTlF6Eezc+cHVLiTaHehSvjBblPjpcfK19nx07w36LsXHbW59pQNNHepBHFokcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KR/lrT9L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD50606D80E;
	Sat,  7 Nov 2026 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KR/lrT9L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF271F0089F;
	Sat,  7 Nov 2026 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063060;
	bh=mynafsa33fdWbIPTsomvcLqpbax6j5fw+iLjFLybIuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KR/lrT9Lg8FLfCGKMyLmpoOWT5Q4INXHie4huK0f0Haoae6rD74YtN87TbhsCya6Q
	 2uFXYzcK8CHnCkETOFGEHxtsKcMwA52Z3ByhN5DN8jJBEAuX9hsE8YxIAjwOfYt93s
	 YdM3vNztBRie8JzfXXoERtOJFS4pFmdkNr0CTbWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/869] IB/hfi1: Shutdown self-rearming timers before freeing
Date: Sat,  7 Nov 2026 08:49:44 -0500
Message-ID: <20261107134902.812303084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 57c70384d2107..648b31f37aa80 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -5576,7 +5576,7 @@ static int init_rcverr(struct hfi1_devdata *dd)
 static void free_rcverr(struct hfi1_devdata *dd)
 {
 	if (dd->rcverr_timer.function)
-		timer_delete_sync(&dd->rcverr_timer);
+		timer_shutdown_sync(&dd->rcverr_timer);
 }
 
 static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
@@ -12308,7 +12308,7 @@ static void free_cntrs(struct hfi1_devdata *dd)
 	int i;
 
 	if (dd->synth_stats_timer.function)
-		timer_delete_sync(&dd->synth_stats_timer);
+		timer_shutdown_sync(&dd->synth_stats_timer);
 	cancel_work_sync(&dd->update_cntr_work);
 	ppd = (struct hfi1_pportdata *)(dd + 1);
 	for (i = 0; i < dd->num_pports; i++, ppd++) {
-- 
2.53.0



