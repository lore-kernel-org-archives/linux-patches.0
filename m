Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503322AD00;
	Sun,  7 Jun 2026 10:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827645; cv=none; b=P3kAKi3aXYSSbjJMUN3U24mrvjXuY+liVVhAAxeC93eHj0kGE6CfjXVkzw4VuGxgfhn1o6htdA9OwrRvKLLZSLwMLdalFQX0+iHn05L4sD71cc9tqvC9XUcE/g5srdY+6PCJ7/6F5xu9ukjCciEIJysDkBcJis+9sPg6uNNRTiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827645; c=relaxed/simple;
	bh=hrpCifZjnyjEyGkhb0Slv1O6f/7jjzhMZxgKEmPSi3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXs2DOWj9tZgbcHL+harWOuqShqD1sB0nVy3lSD2CX5cJzuxUnTjy2KVim7rtvVPpSVMsAi2IxXtLL8gzV57+jDtgBXmlS681pZZYn4tjaLIglpMsqrTxxO9fJfePITt1lI9GRAJz7mA+EyGhZJLijKE1BhxGyK0l0fn/dDDmUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSMxfP1K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSMxfP1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABE71F00893;
	Sun,  7 Jun 2026 10:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827644;
	bh=+6XBEoaklgE3Fb/th2jipRfbHOagvpqRxZLb8VgqlWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSMxfP1Kjeyc26W9WV359d2KUwsbmWPE0EqUQwlcQGX8GvhAMYZgQorCCXro9l8nm
	 CHxsq9YwYxo2ZfIZUeF2+BdgEaxdMgujZTVLVxKeL8qTDeU6GRs3XDzUd8C3eLMF2Q
	 FyBjpFhxI+DjhaMM4me30ltvlBP/unT8g8+gFv1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Juri Lelli <juri.lelli@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/307] net/sched: act_mirred: Move the recursion counter struct netdev_xmit
Date: Sun,  7 Jun 2026 11:57:52 +0200
Message-ID: <20260607095730.518453501@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 7fe70c06a182a140be9996b02256d907e114479a ]

mirred_nest_level is a per-CPU variable and relies on disabled BH for its
locking. Without per-CPU locking in local_bh_disable() on PREEMPT_RT
this data structure requires explicit locking.

Move mirred_nest_level to struct netdev_xmit as u8, provide wrappers.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://patch.msgid.link/20250512092736.229935-11-bigeasy@linutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: e80ad525fc7e ("net/sched: act_mirred: Fix return code in early mirred redirect error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice_xmit.h |  3 +++
 net/sched/act_mirred.c         | 28 +++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice_xmit.h b/include/linux/netdevice_xmit.h
index 38325e07029685..848735b3a7c02d 100644
--- a/include/linux/netdevice_xmit.h
+++ b/include/linux/netdevice_xmit.h
@@ -8,6 +8,9 @@ struct netdev_xmit {
 #ifdef CONFIG_NET_EGRESS
 	u8  skip_txqueue;
 #endif
+#if IS_ENABLED(CONFIG_NET_ACT_MIRRED)
+	u8 sched_mirred_nest;
+#endif
 };
 
 #endif
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index b1b0049d7a0e9d..18d9378a9c1134 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -30,7 +30,29 @@ static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
 
 #define MIRRED_NEST_LIMIT    4
-static DEFINE_PER_CPU(unsigned int, mirred_nest_level);
+
+#ifndef CONFIG_PREEMPT_RT
+static u8 tcf_mirred_nest_level_inc_return(void)
+{
+	return __this_cpu_inc_return(softnet_data.xmit.sched_mirred_nest);
+}
+
+static void tcf_mirred_nest_level_dec(void)
+{
+	__this_cpu_dec(softnet_data.xmit.sched_mirred_nest);
+}
+
+#else
+static u8 tcf_mirred_nest_level_inc_return(void)
+{
+	return current->net_xmit.sched_mirred_nest++;
+}
+
+static void tcf_mirred_nest_level_dec(void)
+{
+	current->net_xmit.sched_mirred_nest--;
+}
+#endif
 
 static bool tcf_mirred_is_act_redirect(int action)
 {
@@ -423,7 +445,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 	int m_eaction;
 	u32 blockid;
 
-	nest_level = __this_cpu_inc_return(mirred_nest_level);
+	nest_level = tcf_mirred_nest_level_inc_return();
 	if (unlikely(nest_level > MIRRED_NEST_LIMIT)) {
 		net_warn_ratelimited("Packet exceeded mirred recursion limit on dev %s\n",
 				     netdev_name(skb->dev));
@@ -454,7 +476,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 				   retval);
 
 dec_nest_level:
-	__this_cpu_dec(mirred_nest_level);
+	tcf_mirred_nest_level_dec();
 
 	return retval;
 }
-- 
2.53.0



