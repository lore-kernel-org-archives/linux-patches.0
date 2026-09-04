Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0DD3B19BC;
	Fri,  4 Sep 2026 05:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499957; cv=none; b=YGhh1KEBZ/WLmg7vDIwY5wroDlGQWwAqCYMd16QbMUCzfiA0Itb5OaU/qEL0rBwBJF5GHzsU1soZXMsOvHsStqqLqnZ37vAouOs/lO4newv4Eo2FNiQR1/IiRZbFshIFquLLVYeQxxjDu5hmSXKbXEQwkuMeWhoffjgfYP4sRr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499957; c=relaxed/simple;
	bh=LSDgj7EFSkvxFBArQfh1CvkFocT/O2THVIWTvQGrWxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loqPC2wiAW4cEN18tjusoI28SCkm0E9ZNx69fxv7NLBkMP1EjVSivQtdpHxVIEqD3NGX4i5rAFksweFTAX/wKfM4A5hKmGqmrQbCLH/kUK/cf5XhLOKrfD3JvUtrKuMK1DzBhkoAvQAhuwTTPhSAi2dLb5In7GMYlqHB7IwXeC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLd1HGa3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLd1HGa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63B11F00A3D;
	Fri,  4 Sep 2026 05:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499956;
	bh=ip+AuXXwZEOojl9M93c6FW9GqJhG7AZPF9nx3s7GVCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLd1HGa3lJajoZa1Jw1y8jGn8/OvgmlvpD8MyOR2QRBie6IP6AEaLeQMqle7tCrDT
	 I2QBaJr8CxshOg+NjIlQv7QZMpIwxLNELbm8yNLsvO/MEZ687d/FoUK0mqTtySeL6A
	 gjS5mq4dW+dpAmWGfKjF9Jtc2SH6X2GaMMYlURNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 601/713] net: ibm: emac: mal: fix NAPI locking
Date: Fri,  4 Sep 2026 06:59:29 +0200
Message-ID: <20260904045817.298994951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 43b0213529c6ae2fd4cbf8dbb9baff87a34c27d7 upstream.

Since commit 413f0271f396 ("net: protect NAPI enablement with
netdev_lock()"), napi_enable() and napi_disable() take netdev_lock().

mal_register_commac() and mal_unregister_commac() call these helpers
while holding mal->lock with interrupts disabled. In the unregister
path, napi_disable() may also wait for polling to finish, while the poll
completion path takes mal->lock.

Take netdev_lock() before mal->lock, use the locked NAPI helpers, and
drop mal->lock before napi_disable_locked().

Fixes: 413f0271f396 ("net: protect NAPI enablement with netdev_lock()")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260811070813.377573-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/emac/mal.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -35,6 +35,7 @@ int mal_register_commac(struct mal_insta
 {
 	unsigned long flags;
 
+	netdev_lock(mal->napi.dev);
 	spin_lock_irqsave(&mal->lock, flags);
 
 	MAL_DBG(mal, "reg(%08x, %08x)" NL,
@@ -44,18 +45,20 @@ int mal_register_commac(struct mal_insta
 	if ((mal->tx_chan_mask & commac->tx_chan_mask) ||
 	    (mal->rx_chan_mask & commac->rx_chan_mask)) {
 		spin_unlock_irqrestore(&mal->lock, flags);
+		netdev_unlock(mal->napi.dev);
 		printk(KERN_WARNING "mal%d: COMMAC channels conflict!\n",
 		       mal->index);
 		return -EBUSY;
 	}
 
 	if (list_empty(&mal->list))
-		napi_enable(&mal->napi);
+		napi_enable_locked(&mal->napi);
 	mal->tx_chan_mask |= commac->tx_chan_mask;
 	mal->rx_chan_mask |= commac->rx_chan_mask;
 	list_add(&commac->list, &mal->list);
 
 	spin_unlock_irqrestore(&mal->lock, flags);
+	netdev_unlock(mal->napi.dev);
 
 	return 0;
 }
@@ -64,7 +67,9 @@ void mal_unregister_commac(struct mal_in
 		struct mal_commac *commac)
 {
 	unsigned long flags;
+	bool disable_napi;
 
+	netdev_lock(mal->napi.dev);
 	spin_lock_irqsave(&mal->lock, flags);
 
 	MAL_DBG(mal, "unreg(%08x, %08x)" NL,
@@ -73,10 +78,12 @@ void mal_unregister_commac(struct mal_in
 	mal->tx_chan_mask &= ~commac->tx_chan_mask;
 	mal->rx_chan_mask &= ~commac->rx_chan_mask;
 	list_del_init(&commac->list);
-	if (list_empty(&mal->list))
-		napi_disable(&mal->napi);
+	disable_napi = list_empty(&mal->list);
 
 	spin_unlock_irqrestore(&mal->lock, flags);
+	if (disable_napi)
+		napi_disable_locked(&mal->napi);
+	netdev_unlock(mal->napi.dev);
 }
 
 int mal_set_rcbs(struct mal_instance *mal, int channel, unsigned long size)


