Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BB27261B;
	Tue, 15 Jul 2025 13:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585438; cv=none; b=R8ySK1Bx7dLc984k1PGOTCbeB1+vgGxdL5XKoo6tWpTa2K1otWmbuykJFlmmcMTaGUpL8h+bjJV4mb4xHKUC0ndXX/J/3BvB9ZSD+0y/Bf/TKrdN6f1Nc3+zGsxEpF+8IgxBdGyzU1X3C+VUiiI28HoXL6NXVFzr8wzAbKjGYeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585438; c=relaxed/simple;
	bh=zK8mxX0Pm2ThdAZKWdjHRs7+x6W4Dlh8MmlV7DxSmCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyKYaHu9W+akndz7L+k+uZMfhmOiz1DLTuLoUzd0lmJ26SWGPm0j9u5TWVRL0XWDgiJRAFGJQ152GSrceEBKo9acOiI5wUkD3jBJ7Kom06nHZizPWOauIirIK0DRdAlfSRrdkVQ4HwVyYY8/F20T9MObuXxOG/miE10IeUO4/Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ylvxT77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ylvxT77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537A9C4CEE3;
	Tue, 15 Jul 2025 13:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585438;
	bh=zK8mxX0Pm2ThdAZKWdjHRs7+x6W4Dlh8MmlV7DxSmCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ylvxT77DnjW9mdXs8aaeXcMl66+4lPkHhzoeWHI/Xli1yvobDpvh5u/UirGxu59X
	 o+RFQ3v0spZNESPdm3kDXD5jyOlSfZ3CB6IRu0OVxGv37ftP/55m/YKQVL/OV+BsmE
	 rfcAdPSs0AUBR5Np7sNnVUfAfdJjg2r1jJ/fDQlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/163] atm: clip: Fix potential null-ptr-deref in to_atmarpd().
Date: Tue, 15 Jul 2025 15:11:48 +0200
Message-ID: <20250715130810.364972415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0d7744442b25a..59bd67aac168d 100644
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



