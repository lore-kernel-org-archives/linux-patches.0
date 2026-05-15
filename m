Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5507303CB0;
	Fri, 15 May 2026 16:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861775; cv=none; b=KisJ32XNbQd1A3xNa6HwkqnmuL0xm4GAlOdjHPFSc//8GzlZH/JKifkeW9aBF+XMT0wzH5bi8g7hsxVXFIQG0fDBP7O6GjjY9DZhsP9cRlE/6grRsgmjodlnQcenTd3kRIsAgZup2PBQZbVPJgJ97RuAXEq+bbA4yUQSs6d65KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861775; c=relaxed/simple;
	bh=v/lVZnVuHXSGuMq9ICmispsYlg+kFo1M5M1W3G24PXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXV9RPu4nJxQYGcEQz8nx8Q4manlXM9c3617ffITgnBzUvhBe0FCsq0PcNASFnlw4hER464AaKY4UFy9RUMvyGmyjqy87bsnL2znvTBRyjRj0BB8/joy33DbDX1k0HiTx2HZPa8QkRlDk6P3pjXLarQCh/nRBlnThgBkLMRAumQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzy0aQWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzy0aQWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288EEC2BCB0;
	Fri, 15 May 2026 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861775;
	bh=v/lVZnVuHXSGuMq9ICmispsYlg+kFo1M5M1W3G24PXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzy0aQWcoRNZQAQOlIpsb/2kbqhYUmzCtjqt+OHUv28Ao/Avz9kbbdVcBLHZfpIew
	 9lFkMBVHtyhes125h8yJewUlVCdwmAj901DFtrMOk2gWrtlAuRz5YgvVD7TIQCpMQq
	 sDQ4tj3oa9hjUKFqKsEdCzKEGo5FevYGallRKWd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Luxing Yin <tr0jan@lzu.edu.cn>,
	Jiexun Wang <wangjiexun2025@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 457/474] batman-adv: stop tp_meter sessions during mesh teardown
Date: Fri, 15 May 2026 17:49:26 +0200
Message-ID: <20260515154724.986941626@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiexun Wang <wangjiexun2025@gmail.com>

commit 3d3cf6a7314aca4df0a6dde28ce784a2a30d0166 upstream.

TP meter sessions remain linked on bat_priv->tp_list after the netlink
request has already finished. When the mesh interface is removed,
batadv_mesh_free() currently tears down the mesh without first draining
these sessions.

A running sender thread or a late incoming tp_meter packet can then keep
processing against a mesh instance which is already shutting down.
Synchronize tp_meter with the mesh lifetime by stopping all active
sessions from batadv_mesh_free() and waiting for sender threads to exit
before teardown continues.

Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Jiexun Wang <wangjiexun2025@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/main.c     |    1 
 net/batman-adv/tp_meter.c |   94 +++++++++++++++++++++++++++++++++++++---------
 net/batman-adv/tp_meter.h |    1 
 net/batman-adv/types.h    |    4 +
 4 files changed, 82 insertions(+), 18 deletions(-)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -262,6 +262,7 @@ void batadv_mesh_free(struct net_device
 	atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
 
 	batadv_purge_outstanding_packets(bat_priv, NULL);
+	batadv_tp_stop_all(bat_priv);
 
 	batadv_gw_node_free(bat_priv);
 
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -12,6 +12,7 @@
 #include <linux/byteorder/generic.h>
 #include <linux/cache.h>
 #include <linux/compiler.h>
+#include <linux/completion.h>
 #include <linux/container_of.h>
 #include <linux/err.h>
 #include <linux/etherdevice.h>
@@ -365,23 +366,38 @@ static void batadv_tp_vars_put(struct ba
 }
 
 /**
- * batadv_tp_sender_cleanup() - cleanup sender data and drop and timer
- * @bat_priv: the bat priv with all the soft interface information
- * @tp_vars: the private data of the current TP meter session to cleanup
+ * batadv_tp_list_detach() - remove tp session from mesh session list once
+ * @tp_vars: the private data of the current TP meter session
  */
-static void batadv_tp_sender_cleanup(struct batadv_priv *bat_priv,
-				     struct batadv_tp_vars *tp_vars)
+static void batadv_tp_list_detach(struct batadv_tp_vars *tp_vars)
 {
-	cancel_delayed_work(&tp_vars->finish_work);
+	bool detached = false;
 
 	spin_lock_bh(&tp_vars->bat_priv->tp_list_lock);
-	hlist_del_rcu(&tp_vars->list);
+	if (!hlist_unhashed(&tp_vars->list)) {
+		hlist_del_init_rcu(&tp_vars->list);
+		detached = true;
+	}
 	spin_unlock_bh(&tp_vars->bat_priv->tp_list_lock);
 
+	if (!detached)
+		return;
+
+	atomic_dec(&tp_vars->bat_priv->tp_num);
+
 	/* drop list reference */
 	batadv_tp_vars_put(tp_vars);
+}
 
-	atomic_dec(&tp_vars->bat_priv->tp_num);
+/**
+ * batadv_tp_sender_cleanup() - cleanup sender data and drop and timer
+ * @tp_vars: the private data of the current TP meter session to cleanup
+ */
+static void batadv_tp_sender_cleanup(struct batadv_tp_vars *tp_vars)
+{
+	cancel_delayed_work_sync(&tp_vars->finish_work);
+
+	batadv_tp_list_detach(tp_vars);
 
 	/* kill the timer and remove its reference */
 	del_timer_sync(&tp_vars->timer);
@@ -886,7 +902,8 @@ out:
 	batadv_orig_node_put(orig_node);
 
 	batadv_tp_sender_end(bat_priv, tp_vars);
-	batadv_tp_sender_cleanup(bat_priv, tp_vars);
+	batadv_tp_sender_cleanup(tp_vars);
+	complete(&tp_vars->finished);
 
 	batadv_tp_vars_put(tp_vars);
 
@@ -918,7 +935,8 @@ static void batadv_tp_start_kthread(stru
 		batadv_tp_vars_put(tp_vars);
 
 		/* cleanup of failed tp meter variables */
-		batadv_tp_sender_cleanup(bat_priv, tp_vars);
+		batadv_tp_sender_cleanup(tp_vars);
+		complete(&tp_vars->finished);
 		return;
 	}
 
@@ -1024,6 +1042,7 @@ void batadv_tp_start(struct batadv_priv
 	tp_vars->start_time = jiffies;
 
 	init_waitqueue_head(&tp_vars->more_bytes);
+	init_completion(&tp_vars->finished);
 
 	spin_lock_init(&tp_vars->unacked_lock);
 	INIT_LIST_HEAD(&tp_vars->unacked_list);
@@ -1126,14 +1145,7 @@ static void batadv_tp_receiver_shutdown(
 		   "Shutting down for inactivity (more than %dms) from %pM\n",
 		   BATADV_TP_RECV_TIMEOUT, tp_vars->other_end);
 
-	spin_lock_bh(&tp_vars->bat_priv->tp_list_lock);
-	hlist_del_rcu(&tp_vars->list);
-	spin_unlock_bh(&tp_vars->bat_priv->tp_list_lock);
-
-	/* drop list reference */
-	batadv_tp_vars_put(tp_vars);
-
-	atomic_dec(&bat_priv->tp_num);
+	batadv_tp_list_detach(tp_vars);
 
 	spin_lock_bh(&tp_vars->unacked_lock);
 	list_for_each_entry_safe(un, safe, &tp_vars->unacked_list, list) {
@@ -1497,6 +1509,52 @@ out:
 }
 
 /**
+ * batadv_tp_stop_all() - stop all currently running tp meter sessions
+ * @bat_priv: the bat priv with all the mesh interface information
+ */
+void batadv_tp_stop_all(struct batadv_priv *bat_priv)
+{
+	struct batadv_tp_vars *tp_vars[BATADV_TP_MAX_NUM];
+	struct batadv_tp_vars *tp_var;
+	size_t count = 0;
+	size_t i;
+
+	spin_lock_bh(&bat_priv->tp_list_lock);
+	hlist_for_each_entry(tp_var, &bat_priv->tp_list, list) {
+		if (WARN_ON_ONCE(count >= BATADV_TP_MAX_NUM))
+			break;
+
+		if (!kref_get_unless_zero(&tp_var->refcount))
+			continue;
+
+		tp_vars[count++] = tp_var;
+	}
+	spin_unlock_bh(&bat_priv->tp_list_lock);
+
+	for (i = 0; i < count; i++) {
+		tp_var = tp_vars[i];
+
+		switch (tp_var->role) {
+		case BATADV_TP_SENDER:
+			batadv_tp_sender_shutdown(tp_var,
+						  BATADV_TP_REASON_CANCEL);
+			wake_up(&tp_var->more_bytes);
+			wait_for_completion(&tp_var->finished);
+			break;
+		case BATADV_TP_RECEIVER:
+			batadv_tp_list_detach(tp_var);
+			if (timer_shutdown_sync(&tp_var->timer))
+				batadv_tp_vars_put(tp_var);
+			break;
+		}
+
+		batadv_tp_vars_put(tp_var);
+	}
+
+	synchronize_net();
+}
+
+/**
  * batadv_tp_meter_init() - initialize global tp_meter structures
  */
 void __init batadv_tp_meter_init(void)
--- a/net/batman-adv/tp_meter.h
+++ b/net/batman-adv/tp_meter.h
@@ -17,6 +17,7 @@ void batadv_tp_start(struct batadv_priv
 		     u32 test_length, u32 *cookie);
 void batadv_tp_stop(struct batadv_priv *bat_priv, const u8 *dst,
 		    u8 return_value);
+void batadv_tp_stop_all(struct batadv_priv *bat_priv);
 void batadv_tp_meter_recv(struct batadv_priv *bat_priv, struct sk_buff *skb);
 
 #endif /* _NET_BATMAN_ADV_TP_METER_H_ */
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -14,6 +14,7 @@
 #include <linux/average.h>
 #include <linux/bitops.h>
 #include <linux/compiler.h>
+#include <linux/completion.h>
 #include <linux/if.h>
 #include <linux/if_ether.h>
 #include <linux/kref.h>
@@ -1396,6 +1397,9 @@ struct batadv_tp_vars {
 	/** @finish_work: work item for the finishing procedure */
 	struct delayed_work finish_work;
 
+	/** @finished: completion signaled when a sender thread exits */
+	struct completion finished;
+
 	/** @test_length: test length in milliseconds */
 	u32 test_length;
 


