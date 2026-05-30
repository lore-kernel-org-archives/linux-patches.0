Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C386344DB9;
	Sat, 30 May 2026 17:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162816; cv=none; b=MYW1Tjy3H7yxdYxyfEdCpfVV/KaB2TeYCTdTEDH2+SYHCpEh/ozVRjGm5Gz/+BNlD5nLMyLmRlRJa3oDvhm+RLo5wqwQjfGQHmmVDJ+o7wE0MX3/6+5J2Cdk+Tcsx48zgiiCDpG7HNkNFA2/+mB+K3WKCpT9S1A/6xChunXR8dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162816; c=relaxed/simple;
	bh=jK/IO2jeHF36cZLk+DkOgz86vV70usBAznlEgMxkapQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfrXu9qez9aRtaSjuFiQnFtArfI01hGJkWKtsl+1NuZ5eKOZzHxp9aE0w1J28PicCQpfGn2REKp8DKK8WocQZzM7thhMcmNM/DdmYEMw6tpJL4IgHghLmnmgLwWyB/mpzn9N+I7iPT6aKUSfrGNiIOLBs5q0dWS4dVbgi5bwTUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYbjDFKo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYbjDFKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7771F00893;
	Sat, 30 May 2026 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162815;
	bh=Td4mYUc+JPYmzyi8SfutpOqzY2/ss7sn7+TDnMBID8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYbjDFKo7sjrKEA5ItWJvIXrrDj3BvPOt7mu+bEVy5zhxzUlYMUglgpJQoJVfPVmu
	 uu7jmPzpCvrM1PoA8IRe3l7O6y5gmmkksVcetnwDJKqJn7ifXc6Hdb6NMeyo4PvpQU
	 IAxF1Q/AO0DX+QtpUQPj1nITkvpNfe2nvesiu+Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/776] netfilter: conntrack: add missing netlink policy validations
Date: Sat, 30 May 2026 17:55:56 +0200
Message-ID: <20260530160241.388771356@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f900e1d77ee0ef87bfb5ab3fe60f0b3d8ad5ba05 ]

Hyunwoo Kim reports out-of-bounds access in sctp and ctnetlink.

These attributes are used by the kernel without any validation.
Extend the netlink policies accordingly.

Quoting the reporter:
  nlattr_to_sctp() assigns the user-supplied CTA_PROTOINFO_SCTP_STATE
  value directly to ct->proto.sctp.state without checking that it is
  within the valid range. [..]

  and: ... with exp->dir = 100, the access at
  ct->master->tuplehash[100] reads 5600 bytes past the start of a
  320-byte nf_conn object, causing a slab-out-of-bounds read confirmed by
  UBSAN.

Fixes: 076a0ca02644 ("netfilter: ctnetlink: add NAT support for expectations")
Fixes: a258860e01b8 ("netfilter: ctnetlink: add full support for SCTP to ctnetlink")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c    | 2 +-
 net/netfilter/nf_conntrack_proto_sctp.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index def356f828cd8..da00a770ca6d6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3486,7 +3486,7 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x,
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
-	[CTA_EXPECT_NAT_DIR]	= { .type = NLA_U32 },
+	[CTA_EXPECT_NAT_DIR]	= NLA_POLICY_MAX(NLA_BE32, IP_CT_DIR_REPLY),
 	[CTA_EXPECT_NAT_TUPLE]	= { .type = NLA_NESTED },
 };
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7ffd698497f2a..90458799324ec 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -600,7 +600,8 @@ static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 }
 
 static const struct nla_policy sctp_nla_policy[CTA_PROTOINFO_SCTP_MAX+1] = {
-	[CTA_PROTOINFO_SCTP_STATE]	    = { .type = NLA_U8 },
+	[CTA_PROTOINFO_SCTP_STATE]	    = NLA_POLICY_MAX(NLA_U8,
+							 SCTP_CONNTRACK_HEARTBEAT_SENT),
 	[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL]  = { .type = NLA_U32 },
 	[CTA_PROTOINFO_SCTP_VTAG_REPLY]     = { .type = NLA_U32 },
 };
-- 
2.53.0



