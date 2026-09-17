Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959AC59E329;
	Thu, 17 Sep 2026 15:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659554; cv=none; b=oat/3aXplp/SlCpcNKM/Pozk31yqmwardo3SYAJQOdWJ1V+k89sz2cKr5UppsxENNrmDim2dJb5W4IqfvUtFNSKzo6Ci2Bvf+m5vJfMU4nOv4PRcy9za/CsDYuA64UXYfjyJ3A85yKEpx5l3uedSXYAVrKnhZ+ZM5ol/HEb1KPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659554; c=relaxed/simple;
	bh=vW1ax3c/0ewFET6wXvoOXBOK4XUkB27Kt/Uy7BEBUXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrAWKFMHjgzzPIxwxxCE+slP695M1qOt3SEoW5oOxBLz2VkqrWfenX9dBLOTYErg8p5ww07JZc9xxuGVgYfTKWTCU0OkpXk0jXbs0XokBpwgZZQmEA8tRYODHFkNd6nKuQE/XgQPjnX+kNqQy+Oi01Nf4MrT64pMDvPT+9ijwtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhSXlS9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhSXlS9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BDE1F00899;
	Thu, 17 Sep 2026 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659546;
	bh=v7i6BJVXSDzlvTqpBMtrJYAgDJO3RIBIa09S6uSaFWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhSXlS9wl4mSDLzpdvrWqYOw03vfcWNKDe5iFleiDRlH4e2ZitL0KElGKeD32w6ca
	 52qUziG/ygJr6HxpeOi+ZMmzITer8ireFQJ+G+OOTGbLF+zqQaPq0m7KE+8n6U2HYW
	 f3/MljX3OGuKEmQiMnH1P/O5l/jUH08makXBZjw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 286/733] net: reject oversized tx_queue_len at netlink parse time
Date: Thu, 17 Sep 2026 16:09:54 +0100
Message-ID: <20260917151358.520270602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 1aa9e143bf51405665a793d4cc925e1c4f0c5922 ]

rtnl_create_link() assigns IFLA_TXQLEN directly to dev->tx_queue_len
without going through netif_change_tx_queue_len(), so a device created
with "ip link add ... txqueuelen 500000" bypasses the S16_MAX cap and
still triggers the oversized ring allocations in pfifo_fast, tun and
tap. The veth peer nest (rtnl_nla_parse_ifinfomsg()) and the
RTM_NEWLINK-on-existing-device path reach the same sinks.

Enforce the cap in ifla_policy instead: IFLA_TXQLEN becomes
NLA_POLICY_FULL_RANGE(NLA_U32, &txqlen_range) with
txqlen_range = { .min = 0, .max = S16_MAX }. All netlink consumers
parse against this policy - rtnl_setlink(), rtnl_newlink() (create
and change), and the veth peer nest - so every netlink path is capped
at parse time and rejects the attribute with -ERANGE plus a proper
"integer out of range" extack message before any device state is
modified (the RTM_SETLINK half-application wart is gone with it).

Document the bound in the rt-link.yaml netlink spec.

Conditions to recreate the bug:
- CONFIG_NET_SCHED=y, CONFIG_VETH=y, CONFIG_USER_NS=y, CONFIG_NET_NS=y.
- Unprivileged user in a fresh user+net namespace (unshare -Urn):
  ip link add v0 txqueuelen 500000 type veth peer name v1
  -> on the fixed kernel this is rejected with -ERANGE ("integer out
  of range" extack) instead of installing an oversized tx_queue_len
  that later inflates pfifo_fast/tun/tap ring allocations.
- ip link set v0 txqueuelen 500000 is likewise rejected at parse time.

Fixes: 38f7b870d4a6 ("[RTNETLINK]: Link creation API")
Reported-by: Vega <vega@nebusec.ai>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-2899.v2.20260901233641@mojatatu.com.2
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt-link.yaml | 2 ++
 net/core/rtnetlink.c                     | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/rt-link.yaml b/Documentation/netlink/specs/rt-link.yaml
index 68c26a70bb649..c75731ecbe1af 100644
--- a/Documentation/netlink/specs/rt-link.yaml
+++ b/Documentation/netlink/specs/rt-link.yaml
@@ -898,6 +898,8 @@ attribute-sets:
       -
         name: txqlen
         type: u32
+        checks:
+          max: 32767
       -
         name: map
         type: binary
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 12aa3aa1688b1..73101ec65c9af 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2236,6 +2236,11 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static const struct netlink_range_validation txqlen_range = {
+	.min = 0,
+	.max = S16_MAX,
+};
+
 static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_UNSPEC]		= { .strict_start_type = IFLA_DPLL_PIN },
 	[IFLA_IFNAME]		= { .type = NLA_STRING, .len = IFNAMSIZ-1 },
@@ -2246,7 +2251,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_LINK]		= { .type = NLA_U32 },
 	[IFLA_MASTER]		= { .type = NLA_U32 },
 	[IFLA_CARRIER]		= { .type = NLA_U8 },
-	[IFLA_TXQLEN]		= { .type = NLA_U32 },
+	[IFLA_TXQLEN]		= NLA_POLICY_FULL_RANGE(NLA_U32, &txqlen_range),
 	[IFLA_WEIGHT]		= { .type = NLA_U32 },
 	[IFLA_OPERSTATE]	= { .type = NLA_U8 },
 	[IFLA_LINKMODE]		= { .type = NLA_U8 },
-- 
2.53.0



