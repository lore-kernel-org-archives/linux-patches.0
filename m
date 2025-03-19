Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9371C6FEE;
	Wed, 19 Mar 2025 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394851; cv=none; b=T0Fhac+3DyXfAYuI0yNIBdCyQ5W/unZUZ/IlCTlnG/fvgUwd5DmEFIm/v0ZhbtwmekNNV+Gjc7QOcUrs8nTPQZGbb1Jo2td6wAaOqKOhxcmJqOYMaerdEZYCJKR4Q7EgcNndof/P9QZwC62Kz62jMmIr2cRKvSS6C7HaxlLI1sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394851; c=relaxed/simple;
	bh=LGoIfHqRP/91vX60RKy1qMVNMyP9fxItIui3VRa1FFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5TjmYmvTMp/OukdDVYmcb/CNc08NOpNZkXm+eqjVGQh6oAvcKBSa2Xp71WFceX8+YjlU0AHpF+bbuGzTzlc3rLM1edS2+nrvsxD+WjAk/iHayJEH3GBdobQY16mviplquD6iGC1iwigFQuf20TgASU2FO8Fi56eDIs7Ny3fzww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlswP/JA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlswP/JA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14690C4CEEC;
	Wed, 19 Mar 2025 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394851;
	bh=LGoIfHqRP/91vX60RKy1qMVNMyP9fxItIui3VRa1FFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlswP/JAfVoy0sZ0IELgT+DnFhX9doJE+DVSY9h+EPOBECiGWX49pPQiRfCNLHmqE
	 C2Pe/CDuvH6CA5/GRCAu1+a7bhnU7nNaQmA7fVSNgN49zVMoFdELzlKoSfDj3sR8qh
	 EgkJsOFHXJH6QyqYnICkrv8Zuw6CzNW2bW54A6oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 038/241] net: switchdev: Convert blocking notification chain to a raw one
Date: Wed, 19 Mar 2025 07:28:28 -0700
Message-ID: <20250319143028.660477498@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 62531a1effa87bdab12d5104015af72e60d926ff ]

A blocking notification chain uses a read-write semaphore to protect the
integrity of the chain. The semaphore is acquired for writing when
adding / removing notifiers to / from the chain and acquired for reading
when traversing the chain and informing notifiers about an event.

In case of the blocking switchdev notification chain, recursive
notifications are possible which leads to the semaphore being acquired
twice for reading and to lockdep warnings being generated [1].

Specifically, this can happen when the bridge driver processes a
SWITCHDEV_BRPORT_UNOFFLOADED event which causes it to emit notifications
about deferred events when calling switchdev_deferred_process().

Fix this by converting the notification chain to a raw notification
chain in a similar fashion to the netdev notification chain. Protect
the chain using the RTNL mutex by acquiring it when modifying the chain.
Events are always informed under the RTNL mutex, but add an assertion in
call_switchdev_blocking_notifiers() to make sure this is not violated in
the future.

Maintain the "blocking" prefix as events are always emitted from process
context and listeners are allowed to block.

[1]:
WARNING: possible recursive locking detected
6.14.0-rc4-custom-g079270089484 #1 Not tainted
--------------------------------------------
ip/52731 is trying to acquire lock:
ffffffff850918d8 ((switchdev_blocking_notif_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x58/0xa0

but task is already holding lock:
ffffffff850918d8 ((switchdev_blocking_notif_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x58/0xa0

other info that might help us debug this:
Possible unsafe locking scenario:
CPU0
----
lock((switchdev_blocking_notif_chain).rwsem);
lock((switchdev_blocking_notif_chain).rwsem);

*** DEADLOCK ***
May be due to missing lock nesting notation
3 locks held by ip/52731:
 #0: ffffffff84f795b0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x727/0x1dc0
 #1: ffffffff8731f628 (&net->rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x790/0x1dc0
 #2: ffffffff850918d8 ((switchdev_blocking_notif_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x58/0xa0

stack backtrace:
...
? __pfx_down_read+0x10/0x10
? __pfx_mark_lock+0x10/0x10
? __pfx_switchdev_port_attr_set_deferred+0x10/0x10
blocking_notifier_call_chain+0x58/0xa0
switchdev_port_attr_notify.constprop.0+0xb3/0x1b0
? __pfx_switchdev_port_attr_notify.constprop.0+0x10/0x10
? mark_held_locks+0x94/0xe0
? switchdev_deferred_process+0x11a/0x340
switchdev_port_attr_set_deferred+0x27/0xd0
switchdev_deferred_process+0x164/0x340
br_switchdev_port_unoffload+0xc8/0x100 [bridge]
br_switchdev_blocking_event+0x29f/0x580 [bridge]
notifier_call_chain+0xa2/0x440
blocking_notifier_call_chain+0x6e/0xa0
switchdev_bridge_port_unoffload+0xde/0x1a0
...

Fixes: f7a70d650b0b6 ("net: bridge: switchdev: Ensure deferred event delivery on unoffload")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20250305121509.631207-1-amcohen@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/switchdev/switchdev.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 6488ead9e4645..4d5fbacef496f 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -472,7 +472,7 @@ bool switchdev_port_obj_act_is_deferred(struct net_device *dev,
 EXPORT_SYMBOL_GPL(switchdev_port_obj_act_is_deferred);
 
 static ATOMIC_NOTIFIER_HEAD(switchdev_notif_chain);
-static BLOCKING_NOTIFIER_HEAD(switchdev_blocking_notif_chain);
+static RAW_NOTIFIER_HEAD(switchdev_blocking_notif_chain);
 
 /**
  *	register_switchdev_notifier - Register notifier
@@ -518,17 +518,27 @@ EXPORT_SYMBOL_GPL(call_switchdev_notifiers);
 
 int register_switchdev_blocking_notifier(struct notifier_block *nb)
 {
-	struct blocking_notifier_head *chain = &switchdev_blocking_notif_chain;
+	struct raw_notifier_head *chain = &switchdev_blocking_notif_chain;
+	int err;
+
+	rtnl_lock();
+	err = raw_notifier_chain_register(chain, nb);
+	rtnl_unlock();
 
-	return blocking_notifier_chain_register(chain, nb);
+	return err;
 }
 EXPORT_SYMBOL_GPL(register_switchdev_blocking_notifier);
 
 int unregister_switchdev_blocking_notifier(struct notifier_block *nb)
 {
-	struct blocking_notifier_head *chain = &switchdev_blocking_notif_chain;
+	struct raw_notifier_head *chain = &switchdev_blocking_notif_chain;
+	int err;
 
-	return blocking_notifier_chain_unregister(chain, nb);
+	rtnl_lock();
+	err = raw_notifier_chain_unregister(chain, nb);
+	rtnl_unlock();
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(unregister_switchdev_blocking_notifier);
 
@@ -536,10 +546,11 @@ int call_switchdev_blocking_notifiers(unsigned long val, struct net_device *dev,
 				      struct switchdev_notifier_info *info,
 				      struct netlink_ext_ack *extack)
 {
+	ASSERT_RTNL();
 	info->dev = dev;
 	info->extack = extack;
-	return blocking_notifier_call_chain(&switchdev_blocking_notif_chain,
-					    val, info);
+	return raw_notifier_call_chain(&switchdev_blocking_notif_chain,
+				       val, info);
 }
 EXPORT_SYMBOL_GPL(call_switchdev_blocking_notifiers);
 
-- 
2.39.5



