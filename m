Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642654CB5B;
	Sun,  7 Jun 2026 10:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827669; cv=none; b=HJlDaRskmAdjWFS6kcjUZdYM4tdPW4dK4K5YIQOKpiPbwLQZg+dPc+IhAvoUdyeUobxYBPzRhrOq9Rz3S5tmv+Gd3KGHpo55i1kw5hJz5XAFT7m4/kwHGUJYRfosSDxva7Gft4RlcAupfOmD8DDzgthuT8sfawQxxJBYuG/MHmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827669; c=relaxed/simple;
	bh=TjrvFXsBhLj5o6SZhTj3ljS8q6GyLoPTJGk9b7Y62Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNp8JVEv2c/rQKdlzjSQrM4hyRiLLdHD++Htp7ZeBXhQw6sIr2blnJUxbu3LKuVx+l8dcMGeg0QtZsDsn2bIjxU5sqU00ItzHqaSZHeO48Q2O5r2v3W7kOBxtWtBE8SHZmiq9zO4pazuqv8AGaMyRwXFLJwupoSJx84neT26LkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUplrpnt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUplrpnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4591F00893;
	Sun,  7 Jun 2026 10:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827668;
	bh=Lw8/kaSg+hLHEoDkLeJno+9bmmRmBj5TrtVjmM5NLy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUplrpntLzbgEdVzx3XuYIuruShuYhkWSXfqAM3GvT+gDHuKDQ02puT3U7+yuF/F4
	 sJh9AfpDjS0iOFZZPwDp4FFpHR539WD9UF1YZKNlU/016+MLhxSL8bRjm1+LmH3mvM
	 uQ60lAsJsNbq8H3RR/hUo0FSTGbGKVbCIdxg+fW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/307] net: Introduce skb tc depth field to track packet loops
Date: Sun,  7 Jun 2026 11:57:54 +0200
Message-ID: <20260607095730.594975098@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 98b34f3e8c3492cfc89ff943c9d92b4d52863d1d ]

Add a 2-bit per-skb tc depth field to track packet loops across the stack.

The previous per-CPU loop counters like MIRRED_NEST_LIMIT
assume a single call stack and lose state in two cases:
1) When a packet is queued and reprocessed later (e.g., egress->ingress
   via backlog), the per-cpu state is gone by the time it is dequeued.
2) With XPS/RPS a packet may arrive on one CPU and be processed on
   another.

A per-skb field solves both by travelling with the packet itself.

The field fits in existing padding, using 2 bits that were previously a
hole:

pahole before(-) and after (+) diff looks like:
   __u8       slow_gro:1;           /*   132: 3  1 */
   __u8       csum_not_inet:1;      /*   132: 4  1 */
   __u8       unreadable:1;         /*   132: 5  1 */
 + __u8       tc_depth:2;           /*   132: 6  1 */

 - /* XXX 2 bits hole, try to pack */
   /* XXX 1 byte hole, try to pack */

   __u16      tc_index;             /*   134     2 */

There used to be a ttl field which was removed as part of tc_verd in commit
aec745e2c520 ("net-tc: remove unused tc_verd fields").  It was already
unused by that time, due to remove earlier in commit c19ae86a510c ("tc: remove
unused redirect ttl").

The first user of this field is netem, which increments tc_depth on
duplicated packets before re-enqueueing them at the root qdisc.  On
re-entry, netem skips duplication for any skb with tc_depth already set,
bounding recursion to a single level regardless of tree topology.

The other user is mirred which increments it on each pass
and limits to depth to MIRRED_DEFER_LIMIT (3).

The new field was called ttl in earlier versions of this patch
but renamed to tc_depth to avoid confusion with IP ttl.

Note (looking at you Sashiko! Dont ignore me and continue bringing this up):
1. Since both mirred and netem utilize the same 2-bit tc_depth field it is
   possible when netem and mirred are used together that netem qdisc to skip
   the duplication step. This is a known trade-off, as a 2-bit field cannot
   independently track both features' recursion depths and it is not considered
   sane to have a setup that addresses both features on at the same time.

2. skb_scrub_packet does not clear tc_depth. This means a packet's loop history
  is preserved even across namespaces. While this might be restrictive for
  some topologies, it is also design intent to provide robustness against loops
  across namespaces.

Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260525122556.973584-2-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: e80ad525fc7e ("net/sched: act_mirred: Fix return code in early mirred redirect error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4344724a978212..107a8c3ff07fa2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -802,6 +802,7 @@ enum skb_tstamp_type {
  *	@_sk_redir: socket redirection information for skmsg
  *	@_nfct: Associated connection, if any (with nfctinfo bits)
  *	@skb_iif: ifindex of device we arrived on
+ *	@tc_depth: counter for packet duplication
  *	@tc_index: Traffic control index
  *	@hash: the packet hash
  *	@queue_mapping: Queue mapping for multiqueue devices
@@ -1011,6 +1012,7 @@ struct sk_buff {
 	__u8			csum_not_inet:1;
 #endif
 	__u8			unreadable:1;
+	__u8			tc_depth:2;
 #if defined(CONFIG_NET_SCHED) || defined(CONFIG_NET_XGRESS)
 	__u16			tc_index;	/* traffic control index */
 #endif
-- 
2.53.0



