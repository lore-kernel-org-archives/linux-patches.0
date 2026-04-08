Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBA33D88FE;
	Wed,  8 Apr 2026 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671768; cv=none; b=YKaVisNHS+tUCG9N5Lm3LwgkKxVIk+qpHUdovndZp3YxoORUGand4D+oXMprYAoUiw1GnOPO/tSm4onmIFyUyP/kPtjC31mpoN4/+lk2piF2KEiPWVDQ59NTWXQjzaEXAgS/xdXcKK46vQM2XCHDMsgWgczLl03ZOgTaTCR0/t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671768; c=relaxed/simple;
	bh=v4D8hQ5ETDregDvu5cNNVJggUkS3JD8QUPh4mNr3Uis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r274vfMMEkU5vV1+1h5jMTfqcK3AsbZEICUf3vMRa5oDxrJ34cDS+66Le6O+rpPeHYTjLPVYL8bxFm/YNex0uNFmlea2HoJ8Ov5xLURjXBCKiIbL3I430UkjQlrLK8gz5aLG9Vt1aQeG+W+au30dL/gzgLMqZr8CDKdZuVfkUCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLCRcm3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLCRcm3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C27C19421;
	Wed,  8 Apr 2026 18:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671768;
	bh=v4D8hQ5ETDregDvu5cNNVJggUkS3JD8QUPh4mNr3Uis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLCRcm3rIDv/yFVxZyN29FaEQW6ZOvOVQfxrJqVmT7+6N4Z7DlrNzzU0MIOryn0Hf
	 Yd0QJRdZCaVvr21OddHi5/fzwhQXZGYkAr3MYmWtp3HIOWyMFTTal7uUMZ5iDEneYI
	 a7E3JfHEIivYbhv8B9H8wG3XcYVd9NPCASHh27fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/312] netlink: allow be16 and be32 types in all uint policy checks
Date: Wed,  8 Apr 2026 19:59:38 +0200
Message-ID: <20260408175936.016429967@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 5fac9b7c16c50c6c7699517f582b56e3743f453a ]

__NLA_IS_BEINT_TYPE(tp) isn't useful.  NLA_BE16/32 are identical to
NLA_U16/32, the only difference is that it tells the netlink validation
functions that byteorder conversion might be needed before comparing
the value to the policy min/max ones.

After this change all policy macros that can be used with UINT types,
such as NLA_POLICY_MASK() can also be used with NLA_BE16/32.

This will be used to validate nf_tables flag attributes which
are in bigendian byte order.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 8f15b5071b45 ("netfilter: ctnetlink: use netlink policy range checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netlink.h | 10 +++-------
 lib/nlattr.c          |  6 ++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 6e1e670e06bc4..df8012ef85f1d 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -374,12 +374,11 @@ struct nla_policy {
 #define NLA_POLICY_BITFIELD32(valid) \
 	{ .type = NLA_BITFIELD32, .bitfield32_valid = valid }
 
-#define __NLA_IS_UINT_TYPE(tp)						\
-	(tp == NLA_U8 || tp == NLA_U16 || tp == NLA_U32 || tp == NLA_U64)
+#define __NLA_IS_UINT_TYPE(tp)					\
+	(tp == NLA_U8 || tp == NLA_U16 || tp == NLA_U32 ||	\
+	 tp == NLA_U64 || tp == NLA_BE16 || tp == NLA_BE32)
 #define __NLA_IS_SINT_TYPE(tp)						\
 	(tp == NLA_S8 || tp == NLA_S16 || tp == NLA_S32 || tp == NLA_S64)
-#define __NLA_IS_BEINT_TYPE(tp)						\
-	(tp == NLA_BE16 || tp == NLA_BE32)
 
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
 #define NLA_ENSURE_UINT_TYPE(tp)			\
@@ -393,7 +392,6 @@ struct nla_policy {
 #define NLA_ENSURE_INT_OR_BINARY_TYPE(tp)		\
 	(__NLA_ENSURE(__NLA_IS_UINT_TYPE(tp) ||		\
 		      __NLA_IS_SINT_TYPE(tp) ||		\
-		      __NLA_IS_BEINT_TYPE(tp) ||	\
 		      tp == NLA_MSECS ||		\
 		      tp == NLA_BINARY) + tp)
 #define NLA_ENSURE_NO_VALIDATION_PTR(tp)		\
@@ -401,8 +399,6 @@ struct nla_policy {
 		      tp != NLA_REJECT &&		\
 		      tp != NLA_NESTED &&		\
 		      tp != NLA_NESTED_ARRAY) + tp)
-#define NLA_ENSURE_BEINT_TYPE(tp)			\
-	(__NLA_ENSURE(__NLA_IS_BEINT_TYPE(tp)) + tp)
 
 #define NLA_POLICY_RANGE(tp, _min, _max) {		\
 	.type = NLA_ENSURE_INT_OR_BINARY_TYPE(tp),	\
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 86344df0ccf7b..cf5f0dc3e47d6 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -359,6 +359,12 @@ static int nla_validate_mask(const struct nla_policy *pt,
 	case NLA_U64:
 		value = nla_get_u64(nla);
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
-- 
2.51.0



