Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67CA4ABBAE;
	Thu, 17 Sep 2026 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659138; cv=none; b=YPaFh7LvGaz47MeWUdo0Swm9pn4viN4mwgC+rZZyZbxB2T43YyOXiZcF+P/zUe7zb5FcfDOE2XRaJfSbz70wfL/GaUb130W4Ge0lHWD2YLAMaBR8Drl/OhWi4LRaA5/YhidQPQDxjHOvvjdGLm7a3efAIkq1ebyWXkyJ5Eo+kFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659138; c=relaxed/simple;
	bh=m90JYbmbSkyiu7lIayqeWnZhtg+mgXjH/25sJKdGdyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qv/0E4lNH/BVpMIrrvgtDtWN9pzdpw/JodXx4PtuxjAaoL8QIIdGLt1y8bJLvX1JBL2TWIV4lFiNFOyILRuDw0YJKY+Tu2KQgufHZjCpiI8jnXabwZisEYcUQGX1aQHo+HptwPnjL3/L3l343MNupfhfiwOoO3wakCB9M0iyiwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlivWa6n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlivWa6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62F71F000FF;
	Thu, 17 Sep 2026 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659126;
	bh=dz61OOd/gt+59o7k3L+mJbLDYAxBQVeCCSrByc4ZdlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JlivWa6nRtJqWB0E6zeco1yOscAigSgty2ZZdtYvz/PdhY2KONbJWFwzdf2su28lZ
	 eXkAukPh47GZeNWi2E2wLj6u68uGth21IGo3VtcJ0DsaW4UdY0jgG11P02/0a0WYHb
	 OvHZ2xJQ5tOcJH6QwDSXaiEsnVjznVs8CzyyLaNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 151/733] net: bonding: annotate lockless writes with WRITE_ONCE()
Date: Thu, 17 Sep 2026 16:07:39 +0100
Message-ID: <20260917151354.820728251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bc93419130bb70fabf6561e197054caae85c160c ]

Several fields in bonding are read locklessly using READ_ONCE()
(or ACCESS_ONCE() previously) but have corresponding writes that
do not use WRITE_ONCE().

Add WRITE_ONCE() annotations to:
- bond->send_peer_notif decrements in bond_peer_notify_may_events()
  and reset in bond_close().
- bond->slave_cnt increments and decrements in bond_enslave() and
  __bond_release_one().
- bond->recv_probe updates in bond_open(), bond_option_arp_interval_set()
  and rlb_initialize().
- slaves->count decrement in bond_skip_slave().

Fixes: 4d97480b1806 ("bonding: use local function pointer of bond->recv_probe in bond_handle_frame")
Fixes: 9a72c2da690d ("bonding: fix div by zero while enslaving and transmitting")
Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that use xmit_hash")
Fixes: 429208aab9db ("net: bonding: add the READ_ONCE/WRITE_ONCE for outside lock accessing")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jay Vosburgh <jv@jvosburgh.net>
Reviewed-by: Xuanqiang Luo<luoxuanqiang@kylinos.cn>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260831081027.3209554-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_alb.c     |  2 +-
 drivers/net/bonding/bond_main.c    | 14 +++++++-------
 drivers/net/bonding/bond_options.c |  4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 839f7482dc182..d2fb67a47cf99 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -875,7 +875,7 @@ static int rlb_initialize(struct bonding *bond)
 	spin_unlock_bh(&bond->mode_lock);
 
 	/* register to receive ARPs */
-	bond->recv_probe = rlb_arp_recv;
+	WRITE_ONCE(bond->recv_probe, rlb_arp_recv);
 
 	return 0;
 }
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 522eab060f9ed..909ecec0de4d6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1245,7 +1245,7 @@ static void bond_peer_notify_may_events(struct bonding *bond, bool force)
 	}
 
 	if (notified || force)
-		bond->send_peer_notif--;
+		WRITE_ONCE(bond->send_peer_notif, bond->send_peer_notif - 1);
 }
 
 /**
@@ -2284,7 +2284,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		}
 	}
 
-	bond->slave_cnt++;
+	WRITE_ONCE(bond->slave_cnt, bond->slave_cnt + 1);
 	netdev_compute_master_upper_features(bond->dev, true);
 	bond_set_carrier(bond);
 
@@ -2533,7 +2533,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 
 	unblock_netpoll_tx();
 	synchronize_rcu();
-	bond->slave_cnt--;
+	WRITE_ONCE(bond->slave_cnt, bond->slave_cnt - 1);
 
 	if (!bond_has_slaves(bond)) {
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, bond->dev);
@@ -4385,13 +4385,13 @@ static int bond_open(struct net_device *bond_dev)
 
 	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
 		queue_delayed_work(bond->wq, &bond->arp_work, 0);
-		bond->recv_probe = bond_rcv_validate;
+		WRITE_ONCE(bond->recv_probe, bond_rcv_validate);
 	}
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		queue_delayed_work(bond->wq, &bond->ad_work, 0);
 		/* register to receive LACPDUs */
-		bond->recv_probe = bond_3ad_lacpdu_recv;
+		WRITE_ONCE(bond->recv_probe, bond_3ad_lacpdu_recv);
 		bond_3ad_initiate_agg_selection(bond, 1);
 
 		bond_for_each_slave(bond, slave, iter)
@@ -4413,7 +4413,7 @@ static int bond_close(struct net_device *bond_dev)
 	struct slave *slave;
 
 	bond_work_cancel_all(bond);
-	bond->send_peer_notif = 0;
+	WRITE_ONCE(bond->send_peer_notif, 0);
 	WRITE_ONCE(bond->recv_probe, NULL);
 
 	/* Wait for any in-flight RX handlers */
@@ -5124,7 +5124,7 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
 		if (skipslave == slaves->arr[idx]) {
 			slaves->arr[idx] =
 				slaves->arr[slaves->count - 1];
-			slaves->count--;
+			WRITE_ONCE(slaves->count, slaves->count - 1);
 			break;
 		}
 	}
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index e590c8dee86e1..d8cdbfca1bb16 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1147,11 +1147,11 @@ static int bond_option_arp_interval_set(struct bonding *bond,
 		 */
 		if (!newval->value) {
 			if (bond->params.arp_validate)
-				bond->recv_probe = NULL;
+				WRITE_ONCE(bond->recv_probe, NULL);
 			cancel_delayed_work_sync(&bond->arp_work);
 		} else {
 			/* arp_validate can be set only in active-backup mode */
-			bond->recv_probe = bond_rcv_validate;
+			WRITE_ONCE(bond->recv_probe, bond_rcv_validate);
 			cancel_delayed_work_sync(&bond->mii_work);
 			queue_delayed_work(bond->wq, &bond->arp_work, 0);
 		}
-- 
2.53.0



