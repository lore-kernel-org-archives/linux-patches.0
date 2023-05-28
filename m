Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63453611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36D8C433EF;
	Sun, 28 May 2023 19:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303124;
	bh=W1wk4Ew5cEj8hZ0gA1oqChuF8tUcSWMo9U9eEELS84c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/whAc942a97+YcG5s/RCzLlwUFfaCwh731mJ/gwLCZZFb8x5Qu/MKYAcRQ2ON9af
	 2c7Zj45MEQNcXCHBViC/8IlyUTZqlsqZI04HsRJP0i0WcXF/eaMAoN7trXyfTXj/pI
	 XF5I9Os8sfYSMuNGRupbgHep4HgqrJe1vPg3mkvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Dragos-Marian Panait <dragos.panait@windriver.com>
Subject: [PATCH 5.10 163/211] net/sched: act_mirred: better wording on protection against excessive stack growth
Date: Sun, 28 May 2023 20:11:24 +0100
Message-Id: <20230528190847.550884967@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 78dcdffe0418ac8f3f057f26fe71ccf4d8ed851f ]

with commit e2ca070f89ec ("net: sched: protect against stack overflow in
TC act_mirred"), act_mirred protected itself against excessive stack growth
using per_cpu counter of nested calls to tcf_mirred_act(), and capping it
to MIRRED_RECURSION_LIMIT. However, such protection does not detect
recursion/loops in case the packet is enqueued to the backlog (for example,
when the mirred target device has RPS or skb timestamping enabled). Change
the wording from "recursion" to "nesting" to make it more clear to readers.

CC: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_mirred.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -28,8 +28,8 @@
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
 
-#define MIRRED_RECURSION_LIMIT    4
-static DEFINE_PER_CPU(unsigned int, mirred_rec_level);
+#define MIRRED_NEST_LIMIT    4
+static DEFINE_PER_CPU(unsigned int, mirred_nest_level);
 
 static bool tcf_mirred_is_act_redirect(int action)
 {
@@ -225,7 +225,7 @@ static int tcf_mirred_act(struct sk_buff
 	struct sk_buff *skb2 = skb;
 	bool m_mac_header_xmit;
 	struct net_device *dev;
-	unsigned int rec_level;
+	unsigned int nest_level;
 	int retval, err = 0;
 	bool use_reinsert;
 	bool want_ingress;
@@ -236,11 +236,11 @@ static int tcf_mirred_act(struct sk_buff
 	int mac_len;
 	bool at_nh;
 
-	rec_level = __this_cpu_inc_return(mirred_rec_level);
-	if (unlikely(rec_level > MIRRED_RECURSION_LIMIT)) {
+	nest_level = __this_cpu_inc_return(mirred_nest_level);
+	if (unlikely(nest_level > MIRRED_NEST_LIMIT)) {
 		net_warn_ratelimited("Packet exceeded mirred recursion limit on dev %s\n",
 				     netdev_name(skb->dev));
-		__this_cpu_dec(mirred_rec_level);
+		__this_cpu_dec(mirred_nest_level);
 		return TC_ACT_SHOT;
 	}
 
@@ -310,7 +310,7 @@ static int tcf_mirred_act(struct sk_buff
 			err = tcf_mirred_forward(res->ingress, skb);
 			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
-			__this_cpu_dec(mirred_rec_level);
+			__this_cpu_dec(mirred_nest_level);
 			return TC_ACT_CONSUMED;
 		}
 	}
@@ -322,7 +322,7 @@ out:
 		if (tcf_mirred_is_act_redirect(m_eaction))
 			retval = TC_ACT_SHOT;
 	}
-	__this_cpu_dec(mirred_rec_level);
+	__this_cpu_dec(mirred_nest_level);
 
 	return retval;
 }


