Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF903E315C;
	Wed, 30 Sep 2026 19:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796956; cv=none; b=IvY+GtK+HFzi6JFbWtj4Jj8oj5to6enwxRkKec5sJBtV9un1jndHUZlYqRVb0OaIDDwNdMJBpC1naMbPqQnbyvDoZ46HHpgo/cGxoz5O+xVgE0U9dnM0U6CqMOdm9eNhScPvLQKgs31AIZIzT8pMbrioShpEp17c8gUWnc0KDc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796956; c=relaxed/simple;
	bh=q9u9iM3IaKx7xL2rHqA3RDrfwXgFvHyBX7Mbt9ZShws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzWjaNCsTg+CYGFXimIJLC7etEseH2647SLPu0XPejynTV/zeOuhgN/lP9S+C66jTOvUNTkRllNmQjTLn8J8+ZCkF7kaDnayMK8ZjuHc7B2Oa3V3FvcZP4sPVxInjH09EdsQs8k4CD2QLv8DK4D7IIrozrfiASrfnZzJw0zbmB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUT7gvV4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUT7gvV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0261F000FF;
	Wed, 30 Sep 2026 19:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796955;
	bh=K6WgDkC6E/54kDnZvHCTXBafH6rNmeiKddNDqQxx54M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUT7gvV4IFTrK0a9mw+uRrvrVs+EBiVyB5uWrrnTt0s+8Om+m+nVfaFZDj20/1M3S
	 gy9PcS0NOkAgK9mSV/CLqlMB0O/l4yQfce7j2iQpGzBpf6mJcP1LkWBUdxPEltmmQg
	 AWEK13K6HqoaGr/ckWVdWSiS9QD7w79HhHufVCZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	hybris <hybris@mojatatu.ai>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1051/1193] net/sched: act_gate: budget the per-entry list in get_fill_size
Date: Wed, 30 Sep 2026 17:28:55 +0200
Message-ID: <20260930152457.574307778@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit cfa165cbfbed9d0f4bbc22fef4309f595a3ab187 ]

tcf_gate_get_fill_size returns only the TCA_GATE_PARMS size, but
tcf_gate_dump also emits three 64-bit timestamps, the clock id, flags,
priority and the variable-length TCA_GATE_ENTRY_LIST nest. The per-entry
nest is unbounded: parse_gate_list places no cap on the number of
sched-entries, so a gate with many entries can push the real dump well
past the skb that tca_get_fill allocates from this size.

RTM_NEWACTION then fails the add-notify with -EINVAL while the action is
already committed to the IDR, and a subsequent RTM_GETACTION on the
installed gate also returns -EINVAL because its dump no longer fits.

Fix this by accounting for the missing fields in tcf_gate_get_fill_size
along with all elements in the entries list.

Note that sizing the reply from the action lets an oversized gate
install cleanly for the first time: with the input unbounded by
parse_gate_list, the sized skb can now grow well above
NLMSG_GOODSIZE per netlink request (a transient GFP_KERNEL allocation
reachable only with namespace-local CAP_NET_ADMIN). Overload from a
malicious netns admin is hardening material, not net, per the
discussion at
https://lore.kernel.org/netdev/20260914191108.55a1a4f1@kernel.org/;
a follow-up patch for net-next will cap the sched-entry count.

Fixes: 4e76e75d6aba ("net sched actions: calculate add/delete event message size")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260824153903.4143642-1-victor@mojatatu.com
Tested-by: hybris <hybris@mojatatu.ai>
Co-developed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/QDISC-3BLH.v1.20260914203033@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_gate.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index f385a8b647243..7c671e9884b08 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -686,7 +686,35 @@ static void tcf_gate_stats_update(struct tc_action *a, u64 bytes, u64 packets,
 
 static size_t tcf_gate_get_fill_size(const struct tc_action *act)
 {
-	return nla_total_size(sizeof(struct tc_gate));
+	struct tcf_gate *gact = to_gate(act);
+	const struct tcf_gate_params *p;
+	struct tcfg_gate_entry *entry;
+	size_t size = nla_total_size(sizeof(struct tc_gate)) /* TCA_GATE_PARMS */
+		+ 3 * nla_total_size_64bit(sizeof(u64)) /* TCA_GATE_BASE_TIME
+							 * TCA_GATE_CYCLE_TIME
+							 * TCA_GATE_CYCLE_TIME_EXT
+							 */
+		+ nla_total_size(sizeof(s32)) /* TCA_GATE_CLOCKID */
+		+ nla_total_size(sizeof(u32)) /* TCA_GATE_FLAGS */
+		+ nla_total_size(sizeof(s32)) /* TCA_GATE_PRIORITY */
+		+ nla_total_size(0); /* TCA_GATE_ENTRY_LIST */
+	/* TCA_GATE_TM is budgeted by tcf_action_shared_attrs_size() */
+
+	rcu_read_lock();
+	p = rcu_dereference(gact->param);
+	if (p) {
+		list_for_each_entry_rcu(entry, &p->entries, list)
+			/* TCA_GATE_ONE_ENTRY nest and its attributes */
+			size += nla_total_size(0)
+				+ nla_total_size(sizeof(u32)) /* TCA_GATE_ENTRY_INDEX */
+				+ nla_total_size(0) /* TCA_GATE_ENTRY_GATE */
+				+ nla_total_size(sizeof(u32)) /* TCA_GATE_ENTRY_INTERVAL */
+				+ nla_total_size(sizeof(s32)) /* TCA_GATE_ENTRY_MAX_OCTETS */
+				+ nla_total_size(sizeof(s32)); /* TCA_GATE_ENTRY_IPV */
+	}
+	rcu_read_unlock();
+
+	return size;
 }
 
 static void tcf_gate_entry_destructor(void *priv)
-- 
2.53.0



