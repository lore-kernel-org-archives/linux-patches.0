Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADF24FDE56;
	Tue, 13 Oct 2026 12:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893463; cv=none; b=kVshj3ChE3dJ9hR7ICjTtBF0d2hufk4qCmySoOXa32D36S4TGIY6Cw4NNINTjSTzv33euZdM6nmkwi8Haye2ySu3aLJruacjkIgvmELgiriA3BIbo2BPV257lAFBYST32nk9tbnX+SstPeLOXgTcPm3dEF5okG6VJ6/jnQXj5gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893463; c=relaxed/simple;
	bh=gp9YKR5Ffank944Qbl/YQ1f3bO8lrZdVlbqyKGACJRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vai3LP1cdEqawsRTCyxslJNfpY966pUd181UYENcZXydafOxakOmWMXbkJTLweL7+doCetaF8N5wDrNMdLI2F9wB2WRhZPKRXwYrg7U+/ldPKdMusVTJ6SJYxQVzLxWjpu1FLwzz7bef4WETV4wePQhVh0JqZtSBmCBNFak8pwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3pSxhYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3pSxhYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD141F000FF;
	Tue, 13 Oct 2026 12:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893462;
	bh=FOl4Rce9aa2KEBvehoiLW7hbIIJXjMfmVszbEwYifok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3pSxhYCsVtjZMSagR43SfQY4fY4S/3sqLIr4q9nopBryLMyCl5HpAUmrjQqv16O2
	 QzPOAgASoltNPlTnCE+UVHnSL7Zcuq8EKUB9UlYl3StSuSrYGxile5YS7O7w4nR5rU
	 O67IEbJmkko7Cv/F/wE9MLWp8kz6xj3b9oDEMnvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 233/621] net: Introduce skb tc depth field to track packet loops
Date: Tue, 13 Oct 2026 13:33:48 +0200
Message-ID: <20261013112926.389101041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 9552b11e3eda ("net/sched: fix packet loop on netem when duplicate is on")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 237e8b0cb08ab..5af1127dd870c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -821,6 +821,7 @@ enum skb_tstamp_type {
  *	@_sk_redir: socket redirection information for skmsg
  *	@_nfct: Associated connection, if any (with nfctinfo bits)
  *	@skb_iif: ifindex of device we arrived on
+ *	@tc_depth: counter for packet duplication
  *	@tc_index: Traffic control index
  *	@hash: the packet hash
  *	@queue_mapping: Queue mapping for multiqueue devices
@@ -1030,6 +1031,7 @@ struct sk_buff {
 	__u8			csum_not_inet:1;
 #endif
 	__u8			unreadable:1;
+	__u8			tc_depth:2;
 #if defined(CONFIG_NET_SCHED) || defined(CONFIG_NET_XGRESS)
 	__u16			tc_index;	/* traffic control index */
 #endif
-- 
2.53.0



