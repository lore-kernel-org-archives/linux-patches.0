Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC28837C106;
	Fri,  4 Sep 2026 05:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501568; cv=none; b=jjP2a4z9Z0YxlMUnxuIs+5aZic9xwgdlSe2Bf9iPF4zVXndrERoAq6RAfiUH0mMA7/NhCQZtaRcZtohZKBoVsSpjy+FifYaTXB2DQnyyH+P7uQCVZbmLI2CCwSSZS6dHvmvz9MPBU1q6oRDA2OsM5dGKOwVh6SLec5K9XkNjrZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501568; c=relaxed/simple;
	bh=JO7M/QL/1vJ9KjEF0N3QhbHEvkgttNTcP+hjIOrRFqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VP/TyBPkeTocOeSaMdc3N82GVz0pXz6PWn9XDt0+wpGpoIA2yW5LEX0V8vG7yNb2tKc3PM3BJxjVWzffNHwO7FrPHAxrUHnG6rK5UqRTXcs5D3g9qP7lG/1srIX7LKVq3KK1IVNntag8oX0+6VcwD4m7v4yCMTt6uYwUAFs5mCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3MEJP2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3MEJP2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC131F00A3D;
	Fri,  4 Sep 2026 05:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501566;
	bh=OE3ooQNE1VRxaKw6c+qfBqEoH8HK5Zr5WqARpW0Pmgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3MEJP2xLCFyXcqtPh95pXSxmMcC24ky0/iYJvmTbX73TFciqrOkx84raNtNSEAs8
	 AA4+7P/vsWZrZJmegCJHkT0rlDcjcZdOckL4om8DSXTSn+0/uwpCW+hVgDNIB7VZUq
	 LvYBWqvUIenPUdFUKsUMOkj8kmWGGeK6Y0lfKdAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 456/552] net: ibm: emac: mal: fix NAPI locking
Date: Fri,  4 Sep 2026 07:00:13 +0200
Message-ID: <20260904045801.040541120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


