Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D0547F78D;
	Thu, 20 Aug 2026 17:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247744; cv=none; b=cqgy3ptSe0mHdGZb/DKfnPzSM2urIUSlL8E9AzgxvvbQKXddgv4x/bogMHQZOcLfXwCHpCnr5xZzc/Iahwq+RTSGs00AKGxcfnaRIFToWkq1ENGBa5vBdDm8waZERI8/mWKYpODVgiHUQWKYnuMvDd2/aapT+ogFHN2gzkJ0CCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247744; c=relaxed/simple;
	bh=+qnDs/NSBPBrRjJ6XkW6FZZml0Mk0m64sjql43A0Lw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3OmxURxGsoNS2jgTJKmeNAuu6saf+yjvHU+Di1E08IjJWq4v5GghIQO4jpA/mVPG9z0VR8dXLwj/ASXiweXwEv6kx5mm0GF1qEF8y1+7GWPTJmGiVpW6sWiFj5QXAqDaEH5+dqKkHEblQqmsdL5NSel5A9k0QA/+GwADObRC+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWYU5HL7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWYU5HL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83141F000E9;
	Thu, 20 Aug 2026 17:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247742;
	bh=KkDdgJSz0mOZCVuUa376U/LDOIPgij3REYtPIBLzZak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWYU5HL79UrAYiFY91vti2RQOu2kxqF5QV9MD2w0O8OphEYFDZ4zg9KwqvixOYL58
	 lIKx/qxHDZlXu9q8g86QuHK1jedBYt5blStkVDzlcQVZOM+ahYVrdIgAgN1lP5sG13
	 PGp8IAJZ4OqmFVbilk1zeIWZnjxTkTRRwJAEYV8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@idosch.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/166] net, sched: Fix SKB_NOT_DROPPED_YET splat under debug config
Date: Thu, 20 Aug 2026 16:56:51 +0200
Message-ID: <20260820145215.741381289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 40cb2fdfed342e7e578d551a073687789f698d89 ]

Getting the following splat [1] with CONFIG_DEBUG_NET=y and this
reproducer [2]. Problem seems to be that classifiers clear 'struct
tcf_result::drop_reason', thereby triggering the warning in
__kfree_skb_reason() due to reason being 'SKB_NOT_DROPPED_YET' (0).

Fixed by disambiguating a legit error from a verdict with a bogus drop_reason

[1]
WARNING: CPU: 0 PID: 181 at net/core/skbuff.c:1082 kfree_skb_reason+0x38/0x130
Modules linked in:
CPU: 0 PID: 181 Comm: mausezahn Not tainted 6.6.0-rc6-custom-ge43e6d9582e0 #682
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
RIP: 0010:kfree_skb_reason+0x38/0x130
[...]
Call Trace:
 <IRQ>
 __netif_receive_skb_core.constprop.0+0x837/0xdb0
 __netif_receive_skb_one_core+0x3c/0x70
 process_backlog+0x95/0x130
 __napi_poll+0x25/0x1b0
 net_rx_action+0x29b/0x310
 __do_softirq+0xc0/0x29b
 do_softirq+0x43/0x60
 </IRQ>

[2]

ip link add name veth0 type veth peer name veth1
ip link set dev veth0 up
ip link set dev veth1 up
tc qdisc add dev veth1 clsact
tc filter add dev veth1 ingress pref 1 proto all flower dst_mac 00:11:22:33:44:55 action drop
mausezahn veth0 -a own -b 00:11:22:33:44:55 -q -c 1

Ido reported:

  [...] getting the following splat [1] with CONFIG_DEBUG_NET=y and this
  reproducer [2]. Problem seems to be that classifiers clear 'struct
  tcf_result::drop_reason', thereby triggering the warning in
  __kfree_skb_reason() due to reason being 'SKB_NOT_DROPPED_YET' (0). [...]

  [1]
  WARNING: CPU: 0 PID: 181 at net/core/skbuff.c:1082 kfree_skb_reason+0x38/0x130
  Modules linked in:
  CPU: 0 PID: 181 Comm: mausezahn Not tainted 6.6.0-rc6-custom-ge43e6d9582e0 #682
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
  RIP: 0010:kfree_skb_reason+0x38/0x130
  [...]
  Call Trace:
   <IRQ>
   __netif_receive_skb_core.constprop.0+0x837/0xdb0
   __netif_receive_skb_one_core+0x3c/0x70
   process_backlog+0x95/0x130
   __napi_poll+0x25/0x1b0
   net_rx_action+0x29b/0x310
   __do_softirq+0xc0/0x29b
   do_softirq+0x43/0x60
   </IRQ>

  [2]
  #!/bin/bash

  ip link add name veth0 type veth peer name veth1
  ip link set dev veth0 up
  ip link set dev veth1 up
  tc qdisc add dev veth1 clsact
  tc filter add dev veth1 ingress pref 1 proto all flower dst_mac 00:11:22:33:44:55 action drop
  mausezahn veth0 -a own -b 00:11:22:33:44:55 -q -c 1

What happens is that inside most classifiers the tcf_result is copied over
from a filter template e.g. *res = f->res which then implicitly overrides
the prior SKB_DROP_REASON_TC_{INGRESS,EGRESS} default drop code which was
set via sch_handle_{ingress,egress}() for kfree_skb_reason().

Commit text above copied verbatim from Daniel. The general idea of the patch
is not very different from what Ido originally posted but instead done at the
cls_api codepath.

Fixes: 54a59aed395c ("net, sched: Make tc-related drop reason more flexible")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/netdev/ZTjY959R+AFXf3Xy@shredder
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f60b396ee174 ("net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 2 +-
 net/sched/cls_api.c | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 3b7e5fcdd4ff2..4bf82e6d9d422 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1118,7 +1118,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 			}
 		} else if (TC_ACT_EXT_CMP(ret, TC_ACT_GOTO_CHAIN)) {
 			if (unlikely(!rcu_access_pointer(a->goto_chain))) {
-				net_warn_ratelimited("can't go to NULL chain!\n");
+				tcf_set_drop_reason(res, SKB_DROP_REASON_TC_ERROR);
 				return TC_ACT_SHOT;
 			}
 			tcf_action_goto_chain_exec(a, res);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c575b1fa30a71..3b545296d4482 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1708,6 +1708,7 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				 int act_index,
 				 u32 *last_executed_chain)
 {
+	u32 orig_reason = res->drop_reason;
 #ifdef CONFIG_NET_CLS_ACT
 	const int max_reclassify_loop = 16;
 	const struct tcf_proto *first_tp;
@@ -1762,8 +1763,14 @@ static inline int __tcf_classify(struct sk_buff *skb,
 			goto reset;
 		}
 #endif
-		if (err >= 0)
+		if (err >= 0) {
+			/* Policy drop or drop reason is over-written by
+			 * classifiers with a bogus value(0) */
+			if (err == TC_ACT_SHOT &&
+			    res->drop_reason == SKB_NOT_DROPPED_YET)
+				tcf_set_drop_reason(res, orig_reason);
 			return err;
+		}
 	}
 
 	if (unlikely(n)) {
-- 
2.53.0



