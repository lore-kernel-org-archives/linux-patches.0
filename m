Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35D723D297;
	Mon, 13 Apr 2026 16:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097963; cv=none; b=CNo4/hq9PN60Nvc805TFKKh4hx2qCmEr1zT8V+oUEFfr5kLYIuTeFhYzCqn61Bof1eC5cmhYWOF3+aQbUvYBccmG43weTXLxjqXd7/IGXwXtQEWDJhs9ahQ6Dbnu63L/zieyIAVXnhC5Wk3bwHqai824d43sn2iHnQjQKa4i0Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097963; c=relaxed/simple;
	bh=lS1RyJdeB+d6RobS1DNAqrJZIFKJheSRZ5ia5nqp6Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaN2tg7LnNfqZ4ie1TuQBc2idsom5uXu9IeqpLxi6xUEKrD6q78zTYLyL2RLf2DGWcNbWChVGk52bmXsSsA3/L3mUKAjAUH7EfeDM0kVA8mt30CWzACafUSmXr2Gq1dSUeJTcQehbFV7iw3pdpXnfHSmkeZmqAX6SBiH7ywmTPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=el7RdQyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="el7RdQyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C861C2BCAF;
	Mon, 13 Apr 2026 16:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097963;
	bh=lS1RyJdeB+d6RobS1DNAqrJZIFKJheSRZ5ia5nqp6Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=el7RdQyEfCT367qUzSBbLF/WAQi6LqSScyGrD+zrP7a7DUSImyHf6wtDR1JuNAr9s
	 bhJBj2TB/y7ZcSknowazARXtUlbiJu60J+7WZR94jOvRDp+UhOXsNwxbxU4zh3pVJV
	 djuBNebps3xpZ0MXgFKUgEcOeAWBzuTo2+hQVEhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/570] netlink: introduce bigendian integer types
Date: Mon, 13 Apr 2026 17:57:52 +0200
Message-ID: <20260413155843.265692520@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

[ Upstream commit ecaf75ffd5f5db320d8b1da0198eef5a5ce64a3f ]

Jakub reported that the addition of the "network_byte_order"
member in struct nla_policy increases size of 32bit platforms.

Instead of scraping the bit from elsewhere Johannes suggested
to add explicit NLA_BE types instead, so do this here.

NLA_POLICY_MAX_BE() macro is removed again, there is no need
for it: NLA_POLICY_MAX(NLA_BE.., ..) will do the right thing.

NLA_BE64 can be added later.

Fixes: 08724ef69907 ("netlink: introduce NLA_POLICY_MAX_BE")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20221031123407.9158-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8f15b5071b45 ("netfilter: ctnetlink: use netlink policy range checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netlink.h       | 19 +++++++++--------
 lib/nlattr.c                | 41 ++++++++++++++-----------------------
 net/netfilter/nft_payload.c |  6 +++---
 3 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 8c67db47556e2..356b805f50151 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -181,6 +181,8 @@ enum {
 	NLA_S64,
 	NLA_BITFIELD32,
 	NLA_REJECT,
+	NLA_BE16,
+	NLA_BE32,
 	__NLA_TYPE_MAX,
 };
 
@@ -231,6 +233,7 @@ enum nla_policy_validation {
  *    NLA_U32, NLA_U64,
  *    NLA_S8, NLA_S16,
  *    NLA_S32, NLA_S64,
+ *    NLA_BE16, NLA_BE32,
  *    NLA_MSECS            Leaving the length field zero will verify the
  *                         given type fits, using it verifies minimum length
  *                         just like "All other"
@@ -261,6 +264,8 @@ enum nla_policy_validation {
  *    NLA_U16,
  *    NLA_U32,
  *    NLA_U64,
+ *    NLA_BE16,
+ *    NLA_BE32,
  *    NLA_S8,
  *    NLA_S16,
  *    NLA_S32,
@@ -349,7 +354,6 @@ struct nla_policy {
 		struct netlink_range_validation_signed *range_signed;
 		struct {
 			s16 min, max;
-			u8 network_byte_order:1;
 		};
 		int (*validate)(const struct nlattr *attr,
 				struct netlink_ext_ack *extack);
@@ -374,6 +378,8 @@ struct nla_policy {
 	(tp == NLA_U8 || tp == NLA_U16 || tp == NLA_U32 || tp == NLA_U64)
 #define __NLA_IS_SINT_TYPE(tp)						\
 	(tp == NLA_S8 || tp == NLA_S16 || tp == NLA_S32 || tp == NLA_S64)
+#define __NLA_IS_BEINT_TYPE(tp)						\
+	(tp == NLA_BE16 || tp == NLA_BE32)
 
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
 #define NLA_ENSURE_UINT_TYPE(tp)			\
@@ -387,6 +393,7 @@ struct nla_policy {
 #define NLA_ENSURE_INT_OR_BINARY_TYPE(tp)		\
 	(__NLA_ENSURE(__NLA_IS_UINT_TYPE(tp) ||		\
 		      __NLA_IS_SINT_TYPE(tp) ||		\
+		      __NLA_IS_BEINT_TYPE(tp) ||	\
 		      tp == NLA_MSECS ||		\
 		      tp == NLA_BINARY) + tp)
 #define NLA_ENSURE_NO_VALIDATION_PTR(tp)		\
@@ -394,6 +401,8 @@ struct nla_policy {
 		      tp != NLA_REJECT &&		\
 		      tp != NLA_NESTED &&		\
 		      tp != NLA_NESTED_ARRAY) + tp)
+#define NLA_ENSURE_BEINT_TYPE(tp)			\
+	(__NLA_ENSURE(__NLA_IS_BEINT_TYPE(tp)) + tp)
 
 #define NLA_POLICY_RANGE(tp, _min, _max) {		\
 	.type = NLA_ENSURE_INT_OR_BINARY_TYPE(tp),	\
@@ -424,14 +433,6 @@ struct nla_policy {
 	.type = NLA_ENSURE_INT_OR_BINARY_TYPE(tp),	\
 	.validation_type = NLA_VALIDATE_MAX,		\
 	.max = _max,					\
-	.network_byte_order = 0,			\
-}
-
-#define NLA_POLICY_MAX_BE(tp, _max) {			\
-	.type = NLA_ENSURE_UINT_TYPE(tp),		\
-	.validation_type = NLA_VALIDATE_MAX,		\
-	.max = _max,					\
-	.network_byte_order = 1,			\
 }
 
 #define NLA_POLICY_MASK(tp, _mask) {			\
diff --git a/lib/nlattr.c b/lib/nlattr.c
index a0c80fbf71895..dffd60e4065fd 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -125,10 +125,12 @@ void nla_get_range_unsigned(const struct nla_policy *pt,
 		range->max = U8_MAX;
 		break;
 	case NLA_U16:
+	case NLA_BE16:
 	case NLA_BINARY:
 		range->max = U16_MAX;
 		break;
 	case NLA_U32:
+	case NLA_BE32:
 		range->max = U32_MAX;
 		break;
 	case NLA_U64:
@@ -160,31 +162,6 @@ void nla_get_range_unsigned(const struct nla_policy *pt,
 	}
 }
 
-static u64 nla_get_attr_bo(const struct nla_policy *pt,
-			   const struct nlattr *nla)
-{
-	switch (pt->type) {
-	case NLA_U16:
-		if (pt->network_byte_order)
-			return ntohs(nla_get_be16(nla));
-
-		return nla_get_u16(nla);
-	case NLA_U32:
-		if (pt->network_byte_order)
-			return ntohl(nla_get_be32(nla));
-
-		return nla_get_u32(nla);
-	case NLA_U64:
-		if (pt->network_byte_order)
-			return be64_to_cpu(nla_get_be64(nla));
-
-		return nla_get_u64(nla);
-	}
-
-	WARN_ON_ONCE(1);
-	return 0;
-}
-
 static int nla_validate_range_unsigned(const struct nla_policy *pt,
 				       const struct nlattr *nla,
 				       struct netlink_ext_ack *extack,
@@ -198,9 +175,13 @@ static int nla_validate_range_unsigned(const struct nla_policy *pt,
 		value = nla_get_u8(nla);
 		break;
 	case NLA_U16:
+		value = nla_get_u16(nla);
+		break;
 	case NLA_U32:
+		value = nla_get_u32(nla);
+		break;
 	case NLA_U64:
-		value = nla_get_attr_bo(pt, nla);
+		value = nla_get_u64(nla);
 		break;
 	case NLA_MSECS:
 		value = nla_get_u64(nla);
@@ -208,6 +189,12 @@ static int nla_validate_range_unsigned(const struct nla_policy *pt,
 	case NLA_BINARY:
 		value = nla_len(nla);
 		break;
+	case NLA_BE16:
+		value = ntohs(nla_get_be16(nla));
+		break;
+	case NLA_BE32:
+		value = ntohl(nla_get_be32(nla));
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -335,6 +322,8 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 	case NLA_U64:
 	case NLA_MSECS:
 	case NLA_BINARY:
+	case NLA_BE16:
+	case NLA_BE32:
 		return nla_validate_range_unsigned(pt, nla, extack, validate);
 	case NLA_S8:
 	case NLA_S16:
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index cb6ee00bbc09b..dbafb964bd706 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -176,10 +176,10 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
 	[NFTA_PAYLOAD_SREG]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_OFFSET]		= NLA_POLICY_MAX_BE(NLA_U32, 255),
-	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX_BE(NLA_U32, 255),
+	[NFTA_PAYLOAD_OFFSET]		= NLA_POLICY_MAX(NLA_BE32, 255),
+	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_CSUM_OFFSET]	= NLA_POLICY_MAX_BE(NLA_U32, 255),
+	[NFTA_PAYLOAD_CSUM_OFFSET]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_PAYLOAD_CSUM_FLAGS]	= { .type = NLA_U32 },
 };
 
-- 
2.51.0



