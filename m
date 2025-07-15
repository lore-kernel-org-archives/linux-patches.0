Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10772E974E;
	Tue, 15 Jul 2025 13:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586769; cv=none; b=DDm8egac2vpEKgikC/KOyslL02G1j/D/olyjMsoPJudWaYOSHggf1fJGyrKzQNISkK00jJye7YNug2PbJW5GH6eTDARz8maK89BMewu0+fHF5piJdPJQ0kvaIJhP5bI04VQ5YJRP373KTNYizl3kNMZaez0KYSHRwXMLEFXBGJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586769; c=relaxed/simple;
	bh=rtsZkhPgsTBY0RzoLhKXQlCyywFlVL84iPp+YQvbehc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDckMrvcMFlTiiy/NCcAGCeqlFMJI4574Meu0obLcxBnMkxRq7XAK8kdmE06xPJcAZ+BHO6lYSutmXhSpuNRUm/DukyzR0dpwuYOyCQKIYc19LRshWc/3+W1PjSWSsLA45aQC0imzXZ4aHMbFuzuoKDplIoriu/Yz20JjEg0n/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6SSks22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6SSks22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BD2C4CEE3;
	Tue, 15 Jul 2025 13:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586769;
	bh=rtsZkhPgsTBY0RzoLhKXQlCyywFlVL84iPp+YQvbehc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6SSks22CErKZ85LE5yeNL7CAAP4FEQH6aALHHWvmachX4zV8eT26KH6ucoFMwFKi
	 Elz4SOXXf0xBkv/bZNTksQpBeRINmJmENI8lfIytnftsyrrL6HCKQykExs7p1rCjlx
	 Jn1HWOA//XFieqvf2bb7E9KdRqe48XdpSDe/298M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 041/192] atm: clip: Fix potential null-ptr-deref in to_atmarpd().
Date: Tue, 15 Jul 2025 15:12:16 +0200
Message-ID: <20250715130816.502959961@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 706cc36477139c1616a9b2b96610a8bb520b7119 ]

atmarpd is protected by RTNL since commit f3a0592b37b8 ("[ATM]: clip
causes unregister hang").

However, it is not enough because to_atmarpd() is called without RTNL,
especially clip_neigh_solicit() / neigh_ops->solicit() is unsleepable.

Also, there is no RTNL dependency around atmarpd.

Let's use a private mutex and RCU to protect access to atmarpd in
to_atmarpd().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250704062416.1613927-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/clip.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/net/atm/clip.c b/net/atm/clip.c
index b234dc3bcb0d4..f36f2c7d87146 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -45,7 +45,8 @@
 #include <net/atmclip.h>
 
 static struct net_device *clip_devs;
-static struct atm_vcc *atmarpd;
+static struct atm_vcc __rcu *atmarpd;
+static DEFINE_MUTEX(atmarpd_lock);
 static struct timer_list idle_timer;
 static const struct neigh_ops clip_neigh_ops;
 
@@ -53,24 +54,35 @@ static int to_atmarpd(enum atmarp_ctrl_type type, int itf, __be32 ip)
 {
 	struct sock *sk;
 	struct atmarp_ctrl *ctrl;
+	struct atm_vcc *vcc;
 	struct sk_buff *skb;
+	int err = 0;
 
 	pr_debug("(%d)\n", type);
-	if (!atmarpd)
-		return -EUNATCH;
+
+	rcu_read_lock();
+	vcc = rcu_dereference(atmarpd);
+	if (!vcc) {
+		err = -EUNATCH;
+		goto unlock;
+	}
 	skb = alloc_skb(sizeof(struct atmarp_ctrl), GFP_ATOMIC);
-	if (!skb)
-		return -ENOMEM;
+	if (!skb) {
+		err = -ENOMEM;
+		goto unlock;
+	}
 	ctrl = skb_put(skb, sizeof(struct atmarp_ctrl));
 	ctrl->type = type;
 	ctrl->itf_num = itf;
 	ctrl->ip = ip;
-	atm_force_charge(atmarpd, skb->truesize);
+	atm_force_charge(vcc, skb->truesize);
 
-	sk = sk_atm(atmarpd);
+	sk = sk_atm(vcc);
 	skb_queue_tail(&sk->sk_receive_queue, skb);
 	sk->sk_data_ready(sk);
-	return 0;
+unlock:
+	rcu_read_unlock();
+	return err;
 }
 
 static void link_vcc(struct clip_vcc *clip_vcc, struct atmarp_entry *entry)
@@ -607,10 +619,12 @@ static void atmarpd_close(struct atm_vcc *vcc)
 {
 	pr_debug("\n");
 
-	rtnl_lock();
-	atmarpd = NULL;
+	mutex_lock(&atmarpd_lock);
+	RCU_INIT_POINTER(atmarpd, NULL);
+	mutex_unlock(&atmarpd_lock);
+
+	synchronize_rcu();
 	skb_queue_purge(&sk_atm(vcc)->sk_receive_queue);
-	rtnl_unlock();
 
 	pr_debug("(done)\n");
 	module_put(THIS_MODULE);
@@ -631,15 +645,15 @@ static struct atm_dev atmarpd_dev = {
 
 static int atm_init_atmarp(struct atm_vcc *vcc)
 {
-	rtnl_lock();
+	mutex_lock(&atmarpd_lock);
 	if (atmarpd) {
-		rtnl_unlock();
+		mutex_unlock(&atmarpd_lock);
 		return -EADDRINUSE;
 	}
 
 	mod_timer(&idle_timer, jiffies + CLIP_CHECK_INTERVAL * HZ);
 
-	atmarpd = vcc;
+	rcu_assign_pointer(atmarpd, vcc);
 	set_bit(ATM_VF_META, &vcc->flags);
 	set_bit(ATM_VF_READY, &vcc->flags);
 	    /* allow replies and avoid getting closed if signaling dies */
@@ -648,7 +662,7 @@ static int atm_init_atmarp(struct atm_vcc *vcc)
 	vcc->push = NULL;
 	vcc->pop = NULL; /* crash */
 	vcc->push_oam = NULL; /* crash */
-	rtnl_unlock();
+	mutex_unlock(&atmarpd_lock);
 	return 0;
 }
 
-- 
2.39.5



