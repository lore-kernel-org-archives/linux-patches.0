Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622831;
	b=ocR7YV8pNUnB8mtcwwXqh8KC8ui+4EVIozEMCJ2dfniaFOUQjqz5aADGbS3gaz08gEa1
	 oc/qctulGt/1FfUAGmA4qVA6T5RxU5xn2uKOpsexfuGMVG0oJJgYWoB/P8MUMUaA9QBO2
	 d0T1dRh65iGpFQwCA9Gk8oG+NKtTvMnl6yt65uQId4DXYuWbkyv4cyaikPz6QovF3+NKs
	 mcFXm0W0QvoBojlGyf2ADIe6YyTDCQWysp6vG3todSkQZ6BNWWJuTrjfY0PHsoCsGBK3k
	 ChcCzPZ2eHZp354MPjOSwbvkxQoGnWGpqQPoWSzVTX+2CmGk1ACQFgUz060eYA9NkYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7emSZ9Qb06QOPynqhbuF40u2cO+GKpOEpEi1eQ6B/EM=;
	b=vQ6Ggw6bB9d7mKPn/9DcMKU6IdDWJfpT4ldf01h8nmm/YQjPv9CgG0c64zGKhPgF8Qcx
	 iTHol+cLJDRvH1El/oJcKmDrxaeWKVJD5FzOgdk8n4W5gt0pMFf0DrDs5vE2Hg0mem7U9
	 rBYBbo8+bQrMcVF8k7bZ6QgPayTUy8Z6vnDDlyBImO7kqBA487dYVkX/3HfjAXps5eNoL
	 D9PiNEw5KPhyBjg7jyn7VwdVLbOo+4tIYF59jz12ZIWH/916vB648nL0CDbB1drL7fkx7
	 hHMN+151n09ZDiFEBnxOQjAS4EwtEQYruZYbSqZhbWgNfonHzJyizVnuNg7aEgoPO5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kMceGK1u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE671606A323;
	Wed, 25 Nov 2026 16:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kMceGK1u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A2C1F000E1;
	Wed, 25 Nov 2026 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622830;
	bh=7emSZ9Qb06QOPynqhbuF40u2cO+GKpOEpEi1eQ6B/EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMceGK1uBukhKrcv2RdgtQnCXTAIABMQvx95CV80dhbGIfiO0eAySC1zQQuHfgT2Q
	 SOfCMR3iaT0T1U9n5ulqQDpsJQQBQ6JNXvC/qUzveESmK59zh7jlyhf5uvjrKCLuVT
	 y7NX6/jLOncnVMMRFTJjJoZnMDfAZzR//laOaLQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 663/990] mmc: omap: synchronize clock timer before disabling fclk
Date: Wed, 25 Nov 2026 15:33:50 +0100
Message-ID: <20261125143837.620638519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

commit c931c51681e33b24bc8d65c6df35b70e1827daa2 upstream.

mmc_omap_select_slot() removes clk_timer with timer_delete() before
switching slots and changing the functional clock state.  timer_delete()
only removes a pending timer and does not wait for a callback that is
already running.

If mmc_omap_clk_timer() is already running, it can therefore call
mmc_omap_fclk_enable() while the request or slot-switch path changes the
same clock state.  During host removal, the same window can overlap the
final clock shutdown.

Use timer_delete_sync() so the callback has completed before slot switching
or changing the functional clock state.  Keep the timer restartable for
normal request handling.

Fixes: 0807a9b5739a ("MMC: OMAP: Lazy clock shutdown")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/omap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -214,7 +214,7 @@ static void mmc_omap_select_slot(struct
 	host->mmc = slot->mmc;
 	spin_unlock_irqrestore(&host->slot_lock, flags);
 no_claim:
-	timer_delete(&host->clk_timer);
+	timer_delete_sync(&host->clk_timer);
 	if (host->current_slot != slot || !claimed)
 		mmc_omap_fclk_offdelay(host->current_slot);
 
@@ -273,7 +273,7 @@ static void mmc_omap_release_slot(struct
 		/* Keeps clock running for at least 8 cycles on valid freq */
 		mod_timer(&host->clk_timer, jiffies  + HZ/10);
 	else {
-		timer_delete(&host->clk_timer);
+		timer_delete_sync(&host->clk_timer);
 		mmc_omap_fclk_offdelay(slot);
 		mmc_omap_fclk_enable(host, 0);
 	}


