Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439562609FD;
	Wed, 20 May 2026 16:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294846; cv=none; b=rUy/qJL8LQy6YtJq2K4EyaoyTJhCp1zH+mBek18kx2aS6Tbdt7eNH72kUWiH+wodZmlI7rxCZflNXXvfbBnJJeTrDQjLtM20NTNvw4qGywz54SZkv9rZVkJjZJO/VXc4DNbcwySZbAwbErt8VjwgDIix4LMaJS4SKcVmZAzA0aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294846; c=relaxed/simple;
	bh=oTYrDsQlmP09ShACXbqkSzVSNO1sRgsZ3pdnZVkeBaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eu6BeuSY9aFgLnfIEHNYayA2TiUMjwtzllWwBgmWiu0RjHcvPagTh4wUDfqLK79z0wvui6DE1y1EyjwKnSyOXEaXHs7TLWT3roJ+S6AXV66xnDesOkToZK6QEgj/jgBLS+QiW2Plqr2AXa0ZPPXZRy8+rpJHJmW/cP/sDjR44Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PM0Y5mRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PM0Y5mRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A031F000E9;
	Wed, 20 May 2026 16:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294845;
	bh=4z8W85Y3TVqg+t0pIGg5xo9HLrbO8Kh3yOKvlq5EUOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PM0Y5mRaDWj2EGVcUPUwdeBOqxwJXlTdjwl6gJfIFT3aiducUBkEpuDalpKKh4FwX
	 M6cITLi8YmThyt7LZfUQcpynHJzS/WmrInqD79YO+WMyyzh0v2Ejqzcl8HHkeEwsck
	 QdYeGNlQVdekoIUeeCnyl5tCSqSSHSZWzhtGkAvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damilola Bello <damilola@aterlo.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0194/1146] net_sched: fix skb memory leak in deferred qdisc drops
Date: Wed, 20 May 2026 18:07:24 +0200
Message-ID: <20260520162152.665692824@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit a6bd339dbb3514bce690fdcf252e788dfab4ee76 ]

When the network stack cleans up the deferred list via qdisc_run_end(),
it operates on the root qdisc. If the root qdisc do not implement the
TCQ_F_DEQUEUE_DROPS flag the packets queue to free are never freed and
gets stranded on the child's local to_free list.

Fix this by making qdisc_dequeue_drop() aware of the root qdisc. It
fetches the root qdisc and check for the TCQ_F_DEQUEUE_DROPS flag. If
the flag is present, the packet is appended directly to the root's
to_free list. Otherwise, drop it directly as it was done before the
optimization was implemented.

Fixes: a6efc273ab82 ("net_sched: use qdisc_dequeue_drop() in cake, codel, fq_codel")
Reported-by: Damilola Bello <damilola@aterlo.com>
Closes: https://lore.kernel.org/netdev/CAPgFtOLaedBMU0f_BxV2bXftTJSmJr018Q5uozOo5vVo6b9tjw@mail.gmail.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260408100044.4530-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c3d657359a3d2..5fc0b1ebaf25c 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1170,12 +1170,22 @@ static inline void tcf_kfree_skb_list(struct sk_buff *skb)
 static inline void qdisc_dequeue_drop(struct Qdisc *q, struct sk_buff *skb,
 				      enum skb_drop_reason reason)
 {
+	struct Qdisc *root;
+
 	DEBUG_NET_WARN_ON_ONCE(!(q->flags & TCQ_F_DEQUEUE_DROPS));
 	DEBUG_NET_WARN_ON_ONCE(q->flags & TCQ_F_NOLOCK);
 
-	tcf_set_drop_reason(skb, reason);
-	skb->next = q->to_free;
-	q->to_free = skb;
+	rcu_read_lock();
+	root = qdisc_root_sleeping(q);
+
+	if (root->flags & TCQ_F_DEQUEUE_DROPS) {
+		tcf_set_drop_reason(skb, reason);
+		skb->next = root->to_free;
+		root->to_free = skb;
+	} else {
+		kfree_skb_reason(skb, reason);
+	}
+	rcu_read_unlock();
 }
 
 /* Instead of calling kfree_skb() while root qdisc lock is held,
-- 
2.53.0



