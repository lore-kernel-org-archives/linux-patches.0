Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021EF317153;
	Mon, 13 Apr 2026 16:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099269; cv=none; b=WQ9r+SNkF0/wHlrAauW1TIRpaSZqL93mb2h8JMpvh9jqvATFTYkJVDHgVDvc3F89CRZOTmwf8ZFtkRHV96PgSNrcgY1g5g6F0dfLD7BZ/rxXzVnNIqDSxBPK/FuJu2YstTFdMh9fuzM5LEr7oLRhmKHxD6X52QSGYwBWBFVIRvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099269; c=relaxed/simple;
	bh=tFINk0l43J9lg1nARBYT4FrP1nX8ZCXaDyD4H8owdws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lv19PSiINf6bgjtVS+zc5B3vo368EV+zzWWyhxaFMbhqlfyIj4BJdei3n5g+3zchqkv3QShltsx6SzuphRjod+8cA+UNdWD4f/Y8t1xZyiMUWzhwjjq5tLKT9/YatkyH79pUbAgoDsaoYcvAU1BMSYhnZo+mzlY/xBITWY2pTCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmGQb3yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmGQb3yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8A0C2BCAF;
	Mon, 13 Apr 2026 16:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099268;
	bh=tFINk0l43J9lg1nARBYT4FrP1nX8ZCXaDyD4H8owdws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmGQb3ygtcMmxGInFFaFlGzTi/CLOOd5PONd6RdHkyJWN4/WznVjlGfp9OKycLBxC
	 cYvY3AiK7NPnHed83hWaz/+Qy9RN+M2ltiXrk7fmOp2X7LMRMFir+UqMECWxcJS5Le
	 e7hEWySgcSJrh+c10Ddvbbc0nLxldUsOn1+A9Gvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/491] netlink: introduce bigendian integer types
Date: Mon, 13 Apr 2026 17:58:39 +0200
Message-ID: <20260413155829.305817387@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9d5d6aa690c56..fed93bd3424ff 100644
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
index 8825ad4f45bfe..440beb1626be3 100644
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
index f59ad5fb42575..ae0c4cd2dd1c5 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -119,10 +119,10 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
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



