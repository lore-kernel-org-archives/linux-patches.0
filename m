Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E412C1595;
	Sun,  7 Jun 2026 10:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828800; cv=none; b=vEA/khoUo5ww5PgzSUs5eD2jM8t6oeI/EQwEoI/TCiu8HlUwVjaFoYx3jHj2YActg2NYfVqQw480eXV8UEZuaHrk43zwj6Z80IBN1U8do72/HEumozl2zMdpCOOVCDwHQlKHD5k2LyLYaPlUgIKbALftXyLBnLdr4mJwlazauwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828800; c=relaxed/simple;
	bh=GTRducSYqhf7SFFDi2+AL4UEr8lmWdJ7PGORb9NGnY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqjwPK8G+l7utotUsbIAuyU7GScZQnYp44f0SpiKysywRkmcsSCeE1FdItbkDos3i3gqrrAd+FoI8g5lL+oRNQtKiDWflx6npZxAqhDioe7Cg9Q/h2dvJuekxR5QBkP4pVZbQaivBq+leNvMBB3Xk7UUT2Urlz9YLvDYSCPHlDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfSfxSz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfSfxSz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B4D1F00893;
	Sun,  7 Jun 2026 10:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828799;
	bh=uFX6v4PgSENuHGqtCgJdtIgOGMFTcLmQB9KyWTi8XXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfSfxSz98BUI5wfg2wSrq9C3Wtd5iSx5GhCOwi91nhZgMaPTPCzjsegeNhNU8BeQU
	 HrstAeYESpw1/tehPMXj6ekzGh8VRb6VNqgWrTdBDYlXtdIoyh8eflugOw42XL6mFL
	 cs5T6GM7PICgXJjz9TAkajFwyMc1+SNnYpDhA9yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Luxing Yin <tr0jan@lzu.edu.cn>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.18 192/315] xfrm: input: hold netns during deferred transport reinjection
Date: Sun,  7 Jun 2026 11:59:39 +0200
Message-ID: <20260607095734.623137267@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchuan Liang <zcliangcn@gmail.com>

commit c16f74dc1d75d0e2e7670076d5375deda110ebeb upstream.

Transport-mode reinjection stores a struct net pointer in skb->cb and
uses it later from xfrm_trans_reinject(). That pointer must stay valid
until the deferred callback runs.

Take a netns reference when queueing deferred reinjection work and drop
it after the callback completes. Use maybe_get_net() so the queueing
path does not revive a namespace that is already being torn down.

This keeps the existing workqueue design and fixes the netns lifetime
handling in one place for all users of xfrm_trans_queue_net().

Fixes: 7b3801927e52 ("xfrm: introduce xfrm_trans_queue_net")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_input.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -794,9 +794,12 @@ static void xfrm_trans_reinject(struct w
 	spin_unlock_bh(&trans->queue_lock);
 
 	local_bh_disable();
-	while ((skb = __skb_dequeue(&queue)))
-		XFRM_TRANS_SKB_CB(skb)->finish(XFRM_TRANS_SKB_CB(skb)->net,
-					       NULL, skb);
+	while ((skb = __skb_dequeue(&queue))) {
+		struct net *net = XFRM_TRANS_SKB_CB(skb)->net;
+
+		XFRM_TRANS_SKB_CB(skb)->finish(net, NULL, skb);
+		put_net(net);
+	}
 	local_bh_enable();
 }
 
@@ -805,6 +808,7 @@ int xfrm_trans_queue_net(struct net *net
 				       struct sk_buff *))
 {
 	struct xfrm_trans_tasklet *trans;
+	struct net *hold_net;
 
 	trans = this_cpu_ptr(&xfrm_trans_tasklet);
 
@@ -813,8 +817,12 @@ int xfrm_trans_queue_net(struct net *net
 
 	BUILD_BUG_ON(sizeof(struct xfrm_trans_cb) > sizeof(skb->cb));
 
+	hold_net = maybe_get_net(net);
+	if (!hold_net)
+		return -ENODEV;
+
 	XFRM_TRANS_SKB_CB(skb)->finish = finish;
-	XFRM_TRANS_SKB_CB(skb)->net = net;
+	XFRM_TRANS_SKB_CB(skb)->net = hold_net;
 	spin_lock_bh(&trans->queue_lock);
 	__skb_queue_tail(&trans->queue, skb);
 	spin_unlock_bh(&trans->queue_lock);


