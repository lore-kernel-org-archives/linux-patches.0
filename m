Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591487;
	b=wpOWQTsbb4xUxktnnRbdNQC/uTM7LDWrWzEKqaCVb3lKGjJn7iMRy6+Q5rgZVrQwtxBR
	 NZOkgDrXh8nTIEc2IAQKOVcXMSWFQzvptOUkBikaeKGMinRfaW9tsviJgwiBqK39E/b/u
	 u8F5ta3IjhvNNbTglkRgSflD4RbCYw6ffJJoJhyH+Vvl9H1sUXze84obSBNfSi8mIb+7F
	 QGPE7eQDWztxq6tT86i7SV0zGqQvtctsJugi7Z4rckF/xea9LSuSuVHu6jrc3oepo5Gnl
	 eM/CRQz4xJRVvbOarbic22gnot41+xSq1QeHc2zwwNrWzdfSSEfRcPOZyqWj8gH0JhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ClftgY2hzZH5nk4xdqLo2kUteMzD6l0xfwfvo5ZUm9c=;
	b=MkQpbkulRguViLZVuvccET1OX63Thc4LGGWKTHAiH9k8xBw/+DTm8KLLI01aA1ODdpCG
	 J0GGAvpLx49aMAEKp6sLNxynRk446HagsdpOADl9X5aGKthwaWoHazI89v+Mug8n1HF1/
	 ubmKkNdxI1jbQI5MIfmNtrZP+R6xJsIA9UeKZzy2M62xXPhChS0vcH4aLlscDTY5q9tuv
	 E72l6aI7YbaauU6rl1dQS6Tn+Rt5SElj/vTBtiz/S+qU/BF0xUrUh0R2Zy7pqO91Ligps
	 zBXyrhOkT0ExKrvUGVVMqeDr1c5f+21kyMtpwlPFNQnu5pEyGNTlYuq5xDfbS9DsG+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=to5PvkBO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC95607E042;
	Fri, 13 Nov 2026 17:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=to5PvkBO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5141F000C7;
	Fri, 13 Nov 2026 17:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591486;
	bh=ClftgY2hzZH5nk4xdqLo2kUteMzD6l0xfwfvo5ZUm9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=to5PvkBOs+WxM0EorJeXgoFz5SZ9trVFpJRUsD5Hayz2MF543flQhsbQCg/XqSJV5
	 NJrOdAqDB2OEMAXvd7Sj3Pm7vqigsBX8mUBtq7fndmOXhsD9WY/sT5Sz/Wr52Ad+5K
	 kFHg17idL7HwG2kLWAQKqvuvoy+GxAT5ELL5rZ1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 561/670] IB/hfi1: Shutdown self-rearming timers before freeing
Date: Fri, 13 Nov 2026 10:52:05 -0500
Message-ID: <20261113153830.892374044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the replacements to target del_timer_sync() instead of timer_delete_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index db96a7547fb7c..721f0d367281d 100644
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



