Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C142E2665;
	Mon, 20 Apr 2026 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700944; cv=none; b=V83D77hOyHJY3EaWMZsK0OhP9r9b1W+C0LqcX5kWT5KOpLMfPat4NGQTbRWLYCNg0LbkeC6LDj+VYdWsjvS1WIQanMEO/CkzGqIbuH3LFP8nuw2V/aD8Yf4bD+fNa9dj2IyCFYfNAZGeMZwMo74i8dR7xFb+O+cZRi2adOIRY2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700944; c=relaxed/simple;
	bh=Lmbr6p2HslNUC6aYSfxbuYOC88JQtR3+E7SjPM1RUAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apNIW23BXh2QX6EfP+LQQM42Dsfl5nZG/t0HxZQZ/jHIh6DGoD2FlZmOqHwh6EMfTvFsr3vb+sCTZyi1lzPgAetRzKRVVPT9s54OYOfL36WIjLLcgKc2nGNdgJXAB1RYJFriRpDtw20O2kOUAtwOdVGTqIKeAHNKHVTuzVcFXtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeRzxjY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeRzxjY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75FFC19425;
	Mon, 20 Apr 2026 16:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700944;
	bh=Lmbr6p2HslNUC6aYSfxbuYOC88JQtR3+E7SjPM1RUAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeRzxjY8WSmo/UAVd0UsNbj2j9NtfVbYrjFDhOt/x5IQQkyj3smAi9xXA/StIeed3
	 mIFPKV2eQsGOyyVBGk4ScISKLpmlerHVIqxlLdfe4IqO2sIreA9iLbDC68lB445m7L
	 DqwC3MBhg8cw3AzR0KOjN9pvP+3tAuX92Vj5XUX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/198] netfilter: conntrack: add missing netlink policy validations
Date: Mon, 20 Apr 2026 17:41:40 +0200
Message-ID: <20260420153939.962712088@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
index becffc15e7579..fbe9e3f1036f8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3475,7 +3475,7 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x,
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
-	[CTA_EXPECT_NAT_DIR]	= { .type = NLA_U32 },
+	[CTA_EXPECT_NAT_DIR]	= NLA_POLICY_MAX(NLA_BE32, IP_CT_DIR_REPLY),
 	[CTA_EXPECT_NAT_TUPLE]	= { .type = NLA_NESTED },
 };
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7c6f7c9f73320..645d2c43ebf7a 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -582,7 +582,8 @@ static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
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



