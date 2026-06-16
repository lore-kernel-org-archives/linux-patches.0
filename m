Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D6647AF6B;
	Tue, 16 Jun 2026 17:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630946; cv=none; b=Cm6Qxz0BzB1b5vM5bwwEnIZxU91V0b86pFn0/trSKI7hod0rh7elLi8tT3Z9BOn6ZBnVl9MRvAuyQpFXrU+1zzG4RMTS33g7hA924UDfEII4+U/QXOAKu8PSUWyAMHWqLRPbF+WLypvQtFRvQxVHfi6fYlcW5pWxXYVfQSU9eGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630946; c=relaxed/simple;
	bh=lOPBc7y9pchS8OFpoXtX6eWzYQRw2CbFIc6/KSdqXJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDnkihkQ8+2IGSGrDv3cViqrUFrqbbCqUV/TtNqjUvMoolgYJ4ptEy9m1foI6OirbDPuxQ3NTx7gcrqvZGCbx8p2A0w2pQzmcRB25tzWJUx+XZLgNsEP3M0B84vFCAOu5CC/bYZCFd4r8zed64Kb128Zk1zJSwWHRNd2zNuB4lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpfDoTiy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpfDoTiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25EA1F000E9;
	Tue, 16 Jun 2026 17:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630944;
	bh=PGsCIJX+I/IxTpjcZNzIAZRU2emilKOTMm7wARRmd04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpfDoTiyFnzI+DCeCYqD6uCuCGZ67/AKpdClvLSE4EyATo4Frq8jTb6XUB1L1LDqT
	 oaVDN4zILcD5TV0kJDMUJSn4hV3KVlaAtPuAWgvkMGuRSMojHq4gLK7maBtoBdUkBM
	 7prHc5pulO9CzUBMgiYBZNp4ioZuapyQrwoI61Sg=
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
Subject: [PATCH 6.1 126/522] xfrm: input: hold netns during deferred transport reinjection
Date: Tue, 16 Jun 2026 20:24:33 +0530
Message-ID: <20260616145131.893173697@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -759,9 +759,12 @@ static void xfrm_trans_reinject(struct w
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
 
@@ -770,6 +773,7 @@ int xfrm_trans_queue_net(struct net *net
 				       struct sk_buff *))
 {
 	struct xfrm_trans_tasklet *trans;
+	struct net *hold_net;
 
 	trans = this_cpu_ptr(&xfrm_trans_tasklet);
 
@@ -778,8 +782,12 @@ int xfrm_trans_queue_net(struct net *net
 
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


