Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52073F7887;
	Tue, 31 Mar 2026 16:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975052; cv=none; b=uhBLRwHD0DHJZYW7WXHptHUqQu/fPlPql5XO6qp5a6FhVPnhz5pOxtzzm89VZagX8kfEyrnUW8a/Ebw1pCcN87+XxctW3h9bkw9ZJSG/4TocnCwJNof1x1cwb53YjLgebClYLawbCE5XW56UH+QracX58WVwcUxGDKtOo5wa6Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975052; c=relaxed/simple;
	bh=lHN0an4lhVUDRqCIQUAPfDbrlGo6QF8+xqOeNtPEDW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5q1D+jQm7KudLup9CCU7t2/71/yQIpfu3xoNKHT6vPAuRkksXTPsfcyDB8TV2RfLrE+yGzuPYXeKTmdKLadUjwG0FfXvWRiFQuldBGx3og2BXXhEdaV2rXPw2thM8pS1xi7z1cgguvPrgK/bNxX+WgmhTSdw0uUc0RJ0yhi/N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFRGZS0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFRGZS0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6F8C19423;
	Tue, 31 Mar 2026 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975052;
	bh=lHN0an4lhVUDRqCIQUAPfDbrlGo6QF8+xqOeNtPEDW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFRGZS0TBlCnDVHKDGjYf71Gnf2ofpIdbCEvsVsbUo2loTGfScCjPP8TCMxpUoyrR
	 FQGShKDaI81mMu2vqhPtzAAsHKJ3YAW3EEfFNxcB8CnDg+yuX8FMYMZ+cunya7KjXm
	 DPPERZShDTGXJ7tOptGhzIOMRpka/ZXG1odHqIh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.19 145/342] netfilter: ctnetlink: use netlink policy range checks
Date: Tue, 31 Mar 2026 18:19:38 +0200
Message-ID: <20260331161804.342173413@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 8f15b5071b4548b0aafc03b366eb45c9c6566704 ]

Replace manual range and mask validations with netlink policy
annotations in ctnetlink code paths, so that the netlink core rejects
invalid values early and can generate extack errors.

- CTA_PROTOINFO_TCP_STATE: reject values > TCP_CONNTRACK_SYN_SENT2 at
  policy level, removing the manual >= TCP_CONNTRACK_MAX check.
- CTA_PROTOINFO_TCP_WSCALE_ORIGINAL/REPLY: reject values > TCP_MAX_WSCALE
  (14). The normal TCP option parsing path already clamps to this value,
  but the ctnetlink path accepted 0-255, causing undefined behavior when
  used as a u32 shift count.
- CTA_FILTER_ORIG_FLAGS/REPLY_FLAGS: use NLA_POLICY_MASK with
  CTA_FILTER_F_ALL, removing the manual mask checks.
- CTA_EXPECT_FLAGS: use NLA_POLICY_MASK with NF_CT_EXPECT_MASK, adding
  a new mask define grouping all valid expect flags.

Extracted from a broader nf-next patch by Florian Westphal, scoped to
ctnetlink for the fixes tree.

Fixes: c8e2078cfe41 ("[NETFILTER]: ctnetlink: add support for internal tcp connection tracking flags handling")
Signed-off-by: David Carlier <devnexen@gmail.com>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../uapi/linux/netfilter/nf_conntrack_common.h   |  4 ++++
 net/netfilter/nf_conntrack_netlink.c             | 16 +++++-----------
 net/netfilter/nf_conntrack_proto_tcp.c           | 10 +++-------
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 26071021e986f..56b6b60a814f5 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -159,5 +159,9 @@ enum ip_conntrack_expect_events {
 #define NF_CT_EXPECT_INACTIVE		0x2
 #define NF_CT_EXPECT_USERSPACE		0x4
 
+#ifdef __KERNEL__
+#define NF_CT_EXPECT_MASK	(NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE | \
+				 NF_CT_EXPECT_USERSPACE)
+#endif
 
 #endif /* _UAPI_NF_CONNTRACK_COMMON_H */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d9f33a6c807c8..fea750653e967 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -909,8 +909,8 @@ struct ctnetlink_filter {
 };
 
 static const struct nla_policy cta_filter_nla_policy[CTA_FILTER_MAX + 1] = {
-	[CTA_FILTER_ORIG_FLAGS]		= { .type = NLA_U32 },
-	[CTA_FILTER_REPLY_FLAGS]	= { .type = NLA_U32 },
+	[CTA_FILTER_ORIG_FLAGS]		= NLA_POLICY_MASK(NLA_U32, CTA_FILTER_F_ALL),
+	[CTA_FILTER_REPLY_FLAGS]	= NLA_POLICY_MASK(NLA_U32, CTA_FILTER_F_ALL),
 };
 
 static int ctnetlink_parse_filter(const struct nlattr *attr,
@@ -924,17 +924,11 @@ static int ctnetlink_parse_filter(const struct nlattr *attr,
 	if (ret)
 		return ret;
 
-	if (tb[CTA_FILTER_ORIG_FLAGS]) {
+	if (tb[CTA_FILTER_ORIG_FLAGS])
 		filter->orig_flags = nla_get_u32(tb[CTA_FILTER_ORIG_FLAGS]);
-		if (filter->orig_flags & ~CTA_FILTER_F_ALL)
-			return -EOPNOTSUPP;
-	}
 
-	if (tb[CTA_FILTER_REPLY_FLAGS]) {
+	if (tb[CTA_FILTER_REPLY_FLAGS])
 		filter->reply_flags = nla_get_u32(tb[CTA_FILTER_REPLY_FLAGS]);
-		if (filter->reply_flags & ~CTA_FILTER_F_ALL)
-			return -EOPNOTSUPP;
-	}
 
 	return 0;
 }
@@ -2633,7 +2627,7 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
 	[CTA_EXPECT_HELP_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = NF_CT_HELPER_NAME_LEN - 1 },
 	[CTA_EXPECT_ZONE]	= { .type = NLA_U16 },
-	[CTA_EXPECT_FLAGS]	= { .type = NLA_U32 },
+	[CTA_EXPECT_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NF_CT_EXPECT_MASK),
 	[CTA_EXPECT_CLASS]	= { .type = NLA_U32 },
 	[CTA_EXPECT_NAT]	= { .type = NLA_NESTED },
 	[CTA_EXPECT_FN]		= { .type = NLA_NUL_STRING },
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 0c1d086e96cb3..b67426c2189b2 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1385,9 +1385,9 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 }
 
 static const struct nla_policy tcp_nla_policy[CTA_PROTOINFO_TCP_MAX+1] = {
-	[CTA_PROTOINFO_TCP_STATE]	    = { .type = NLA_U8 },
-	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] = { .type = NLA_U8 },
-	[CTA_PROTOINFO_TCP_WSCALE_REPLY]    = { .type = NLA_U8 },
+	[CTA_PROTOINFO_TCP_STATE]	    = NLA_POLICY_MAX(NLA_U8, TCP_CONNTRACK_SYN_SENT2),
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] = NLA_POLICY_MAX(NLA_U8, TCP_MAX_WSCALE),
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY]    = NLA_POLICY_MAX(NLA_U8, TCP_MAX_WSCALE),
 	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]  = { .len = sizeof(struct nf_ct_tcp_flags) },
 	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = { .len = sizeof(struct nf_ct_tcp_flags) },
 };
@@ -1414,10 +1414,6 @@ static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 	if (err < 0)
 		return err;
 
-	if (tb[CTA_PROTOINFO_TCP_STATE] &&
-	    nla_get_u8(tb[CTA_PROTOINFO_TCP_STATE]) >= TCP_CONNTRACK_MAX)
-		return -EINVAL;
-
 	spin_lock_bh(&ct->lock);
 	if (tb[CTA_PROTOINFO_TCP_STATE])
 		ct->proto.tcp.state = nla_get_u8(tb[CTA_PROTOINFO_TCP_STATE]);
-- 
2.51.0



