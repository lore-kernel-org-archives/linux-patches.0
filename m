Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA98F3E315F;
	Wed, 30 Sep 2026 19:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796673; cv=none; b=p0niWEnuY8CEdhzCrS/lrFRNKVXr/l5ts67sObR6oQ8R02r74P23tvWnTVWqc6mmw8FHri2NJh6tqGdiO/Z1TETizgaM6NJdwSeiePOp/QlHiyxO2YOVUKuSTg416O2nJRvFvY5Ns5Fc0ujr9fUh6qjfpkWKXAbf8nUYVqD31DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796673; c=relaxed/simple;
	bh=7njXo439cp4qD2hM5V2+6+i8AFQMgurGb8+zc2B7z6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWC8gDuVQoqIVU39o0VM1hzp1U+iHN5zhyHVDsWuSeb4xJGuioUWC5ruVamyHswEPsBBUPJujBEimkYzi8Oh/XfpxhUsKnV7CFsj+qAWgtiwoclw7CmoeXY1fpvB4+7Lh9cQ4DHvWhqfI/u5fnLnJ4FjiM/lGg/8fJVlgVJw/C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUIh4/fo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUIh4/fo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8B01F000FF;
	Wed, 30 Sep 2026 19:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796672;
	bh=VSvRwifViW5BwUQDNuwumS2gPTivA/7qzlO1g82ZF1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUIh4/foHVwd1EQHz6/vGkT9fEKKWOkEdIn8u8elJW/LQ8HSCDkNq0lYYn+TjgWrU
	 5rVDvckWFcdDuRzfyXwPUcCc1c//BgchMqHAkvc/bRFwTMsVE3Omleyx1dG6ixP/C6
	 Qxe0yVEt1KIiYQNxtUun8pTN4UHGnbt3gdZXiX5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0994/1193] netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
Date: Wed, 30 Sep 2026 17:27:58 +0200
Message-ID: <20260930152456.324963450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9461613afc59acef44a0071b0dd5075f6e993ffe ]

We must serialize the release notifier and the config netlink function.
A concurrent thread can issue close() which can call the release function
while unrelated socket processes UNBIND request for same portid:

Oops: general protection fault, [..]
RIP: 0010:__instance_destroy+0x60/0x210 [nfnetlink_queue]
Call Trace:
 nfqnl_recv_config+0x9b0/0xdc0 [nfnetlink_queue]
 nfnetlink_rcv_msg+0x7c2/0xeb0
 ? __pfx_nfnetlink_rcv_msg+0x10/0x10

After this, parallel UNBIND and URELEASE events are impossible.

This change isn't nice, but its the shortest fix given instances
are not refcounted and the nfnetlink config callback drops the
rcu read lock early due to need for sleeping allocations.

Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index cd6cd258754d9..2237dd0939358 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1055,6 +1055,7 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
 	if (event == NETLINK_URELEASE && n->protocol == NETLINK_NETFILTER) {
 		int i;
 
+		nfnl_lock(NFNL_SUBSYS_QUEUE);
 		/* destroy all instances for this portid */
 		spin_lock(&q->instances_lock);
 		for (i = 0; i < INSTANCE_BUCKETS; i++) {
@@ -1068,6 +1069,7 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
 			}
 		}
 		spin_unlock(&q->instances_lock);
+		nfnl_unlock(NFNL_SUBSYS_QUEUE);
 	}
 	return NOTIFY_DONE;
 }
@@ -1389,9 +1391,9 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 
 	/* Lookup queue under RCU. After peer_portid check (or for new queue
 	 * in BIND case), the queue is owned by the socket sending this message.
-	 * A socket cannot simultaneously send a message and close, so while
-	 * processing this CONFIG message, nfqnl_rcv_nl_event() (triggered by
-	 * socket close) cannot destroy this queue. Safe to use without RCU.
+	 * nfqnl_rcv_nl_event() will block on the nfnl subsys mutex that is
+	 * held by the caller, so the queue cannot be destroyed in parallel,
+	 * even after we drop the RCU read lock.
 	 */
 	rcu_read_lock();
 	queue = instance_lookup(q, queue_num);
-- 
2.53.0



