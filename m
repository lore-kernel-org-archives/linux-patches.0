Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0C8349CDC;
	Thu,  2 Jul 2026 16:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009658; cv=none; b=LSjgpQjKZ2tUW2m3MEeTU+BcC2M54UG5JKz4xwEo9J1Nli1EQlEwaayg0/EaYWaXvJzsH7Tj2aY3H4IWEy6TFx4/5cJBLcbgwxUIqLxtrGjSuLHyE4X+HyquIpZknmy1qgZOk8dkQ21ICwgTIpUKh2iXQGmq4aUQx9s/Xd8CLJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009658; c=relaxed/simple;
	bh=cJsXWUmETnAg6bu6kdRiq2KaUd7Lq2qXanXg490afX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3Lcgb0R8ypdRF43td+WoHyRc57fAR1uPhGqEDXCL2KBkfsINyehIuTdCNbDrLfPb1EbhEQphXousQ2J7lqphKXW8Fe8S+ixXA09G5oru9dYW3q+1oaAnOQWcmp0qQEubgYg6ZtVFui1ZxcPCehqRaoCIe4UbZU7H10D6YNTkgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5RErBQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5RErBQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4BD1F000E9;
	Thu,  2 Jul 2026 16:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009652;
	bh=o3QUJCU8P61mcBX2KIVqIzWwuxi4s1tUb76ls1nnaXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5RErBQkeU0mmESiHXbH7v1LyBgFN08p4WqB/iVNZdRZ7vtQint/H2ImsI2wL6f1h
	 FDjiJoOM6a64KJaEMwnotZpUtFun1VrdYpm2YZ9MzmRBtkd4IXws3H+gQjmjkSjJxN
	 2FxUPkKsFljJUNA7toJfZn+50Besv0pRF/bbA2Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/95] batman-adv: tp_meter: add only finished tp_vars to lists
Date: Thu,  2 Jul 2026 18:19:38 +0200
Message-ID: <20260702155109.946421107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 15ccbf685222274f5add1387af58c2a41a95f81e upstream.

When the receiver variables (aka "session") are initialized, then they are
added to the list of sessions before the timer is set up. A RCU protected
reader could therefore find the entry and run mod_setup before
batadv_tp_init_recv() finished the timer initialization.

The same is true for batadv_tp_start(), which must first initialize the
finish_work and the test_length to avoid a similar problem.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 7385cd02abf9f0..257f8d042d158e 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1096,21 +1096,21 @@ void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 	tp_vars->prerandom_offset = 0;
 	spin_lock_init(&tp_vars->prerandom_lock);
 
-	kref_get(&tp_vars->refcount);
-	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
-	spin_unlock_bh(&bat_priv->tp_list_lock);
-
 	tp_vars->test_length = test_length;
 	if (!tp_vars->test_length)
 		tp_vars->test_length = BATADV_TP_DEF_TEST_LENGTH;
 
+	/* init work item for finished tp tests */
+	INIT_DELAYED_WORK(&tp_vars->finish_work, batadv_tp_sender_finish);
+
+	kref_get(&tp_vars->refcount);
+	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
+	spin_unlock_bh(&bat_priv->tp_list_lock);
+
 	batadv_dbg(BATADV_DBG_TP_METER, bat_priv,
 		   "Meter: starting throughput meter towards %pM (length=%ums)\n",
 		   dst, test_length);
 
-	/* init work item for finished tp tests */
-	INIT_DELAYED_WORK(&tp_vars->finish_work, batadv_tp_sender_finish);
-
 	/* start tp kthread. This way the write() call issued from userspace can
 	 * happily return and avoid to block
 	 */
@@ -1430,10 +1430,10 @@ batadv_tp_init_recv(struct batadv_priv *bat_priv,
 	INIT_LIST_HEAD(&tp_vars->unacked_list);
 
 	kref_get(&tp_vars->refcount);
-	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
+	timer_setup(&tp_vars->timer, batadv_tp_receiver_shutdown, 0);
 
 	kref_get(&tp_vars->refcount);
-	timer_setup(&tp_vars->timer, batadv_tp_receiver_shutdown, 0);
+	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
 
 	batadv_tp_reset_receiver_timer(tp_vars);
 
-- 
2.53.0



