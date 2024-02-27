Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891AD14533E;
	Tue, 27 Feb 2024 13:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042276; cv=none; b=RyutAFwFWwn6XIFSiQUsU55k9ZDYNUPmqxcrb33ZRgvtvGSaCG/eNSphNmH0tg72KHW/A7xq3HdAxqpfMOwEaNjJrW/X6+kbIj9Yfk0YuqVTR8fwuEjvgyL9v3teg01mFWAyA9vBjp4hv0ylUcRhm+ba6kBUaokfLo9evhVPSvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042276; c=relaxed/simple;
	bh=YUQ7hXMBCSyZIV+J2HkJUlOr8etGc8Zix9G/fztVEik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVKSGX5VjYsnaDB482XXkPc/P/+kgtbUC7noc2nBEVlqcGuStYijZBBngOI1gqp2/dhTSazs540nNJ1XS0c+O4+uXkFH/wmxBOfeYXMBczyZe7SU3+lB5tm+yoLEzvHHjM7e9keCp66vE+nYBcOEVX9iJhZFA9kmoZC0AxaphK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6gmKrQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6gmKrQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13685C433F1;
	Tue, 27 Feb 2024 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042276;
	bh=YUQ7hXMBCSyZIV+J2HkJUlOr8etGc8Zix9G/fztVEik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6gmKrQtXIkocyj3mz/fDE2IT9SkE5rvbBT73MWBVsHadVUh+m59ktoLDdQ0edw9U
	 Rh2UzBWq0GtFUqqE/QgXhO88/NUwlRgacJ6Rg8JgqHM6JPvmco4DwWf/Cw6Yr2CJbo
	 sQ/WV9e3giUIInCsfd1jAIP/dU+Iz6ryRYV/dThs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/299] net/sched: act_mirred: dont override retval if we already lost the skb
Date: Tue, 27 Feb 2024 14:25:51 +0100
Message-ID: <20240227131633.459439496@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 166c2c8a6a4dc2e4ceba9e10cfe81c3e469e3210 ]

If we're redirecting the skb, and haven't called tcf_mirred_forward(),
yet, we need to tell the core to drop the skb by setting the retcode
to SHOT. If we have called tcf_mirred_forward(), however, the skb
is out of our hands and returning SHOT will lead to UaF.

Move the retval override to the error path which actually need it.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Fixes: e5cf1baf92cb ("act_mirred: use TC_ACT_REINSERT when possible")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index bab090bb5e80a..674f7ae356ca2 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -240,8 +240,7 @@ static int tcf_mirred_to_dev(struct sk_buff *skb, struct tcf_mirred *m,
 	if (unlikely(!(dev->flags & IFF_UP)) || !netif_carrier_ok(dev)) {
 		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
 				       dev->name);
-		err = -ENODEV;
-		goto out;
+		goto err_cant_do;
 	}
 
 	/* we could easily avoid the clone only if called by ingress and clsact;
@@ -253,10 +252,8 @@ static int tcf_mirred_to_dev(struct sk_buff *skb, struct tcf_mirred *m,
 		tcf_mirred_can_reinsert(retval);
 	if (!dont_clone) {
 		skb_to_send = skb_clone(skb, GFP_ATOMIC);
-		if (!skb_to_send) {
-			err =  -ENOMEM;
-			goto out;
-		}
+		if (!skb_to_send)
+			goto err_cant_do;
 	}
 
 	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
@@ -293,15 +290,16 @@ static int tcf_mirred_to_dev(struct sk_buff *skb, struct tcf_mirred *m,
 	} else {
 		err = tcf_mirred_forward(at_ingress, want_ingress, skb_to_send);
 	}
-
-	if (err) {
-out:
+	if (err)
 		tcf_action_inc_overlimit_qstats(&m->common);
-		if (is_redirect)
-			retval = TC_ACT_SHOT;
-	}
 
 	return retval;
+
+err_cant_do:
+	if (is_redirect)
+		retval = TC_ACT_SHOT;
+	tcf_action_inc_overlimit_qstats(&m->common);
+	return retval;
 }
 
 TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
-- 
2.43.0



