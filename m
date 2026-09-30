Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3F037A825;
	Wed, 30 Sep 2026 18:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791827; cv=none; b=Km3tSdLQwit9G3uvHC2FmVJiA78d3WwBT6Gti7Kd1pTdVyFmPrNQoAQKDfgbxzzt6VPMtoB0hHoS6Y+0ymlPeGPl7YSihxjC8CDCSoDSGK98PZQdNtDn07B4RaVNy3QUz38kS+Eb8QYVgSkwCdUssC/GID8S1ONWun0QksARFKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791827; c=relaxed/simple;
	bh=mF7MLsZCqvGGLRsf+pUFLbHArQz83Y+YcBWGJ8rCkgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1RPj2Fn5fGSTL7wBx2TqR7uuPralx0/ZVqiY/vdqlu5Xp6YoMkQboJQc+s7FmJJTrUKL6QMm3vSYSc1xqG+QStcsXp7r87g4vFUAlazC/Zs8n7SHoaV8rg4JYgNhYytQvvRMszol1KRtgXZ7xtEOFWwn7UKHJ27fJcJLNYrMuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqXBVSa9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqXBVSa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267B31F000FF;
	Wed, 30 Sep 2026 18:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791825;
	bh=XMxdwMeavQurs3uE7xbGe/m51kCveGMyk8eYWdGtBhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqXBVSa9cuTy3pmSDaE+Dd09hyja5iUanx5XSQFX3m+0TxfgWSk8k/EQq7MGmgcwj
	 6fBqTJYTeEzUw/vDQhVIa5MnkRUNevCuMqmmCKFlj2vK6d6FJlfkNNBPp1s1f6NAl4
	 KZALIqLG9U3/qT+0bfovsyVymGkG44FrESARrGhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 439/752] xfrm: add extack support to verify_newsa_info
Date: Wed, 30 Sep 2026 17:25:09 +0200
Message-ID: <20260930152407.784855696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 6999aae17a7b66c56e6cc8e05b3cd51718c3bfe3 ]

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: d1ebd9081879 ("xfrm: fix compat ALLOCSPI request use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 90 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 69 insertions(+), 21 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 419e70b887512..64d7469d62230 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -148,7 +148,8 @@ static inline int verify_replay(struct xfrm_usersa_info *p,
 }
 
 static int verify_newsa_info(struct xfrm_usersa_info *p,
-			     struct nlattr **attrs)
+			     struct nlattr **attrs,
+			     struct netlink_ext_ack *extack)
 {
 	int err;
 	u16 family = p->sel.family;
@@ -163,10 +164,12 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		break;
 #else
 		err = -EAFNOSUPPORT;
+		NL_SET_ERR_MSG(extack, "IPv6 support disabled");
 		goto out;
 #endif
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid address family");
 		goto out;
 	}
 
@@ -178,65 +181,98 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		break;
 
 	case AF_INET:
-		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
+		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32) {
+			NL_SET_ERR_MSG(extack, "Invalid prefix length in selector (must be <= 32 for IPv4)");
 			goto out;
+		}
 
 		break;
 
 	case AF_INET6:
 #if IS_ENABLED(CONFIG_IPV6)
-		if (p->sel.prefixlen_d > 128 || p->sel.prefixlen_s > 128)
+		if (p->sel.prefixlen_d > 128 || p->sel.prefixlen_s > 128) {
+			NL_SET_ERR_MSG(extack, "Invalid prefix length in selector (must be <= 128 for IPv6)");
 			goto out;
+		}
 
 		break;
 #else
+		NL_SET_ERR_MSG(extack, "IPv6 support disabled");
 		err = -EAFNOSUPPORT;
 		goto out;
 #endif
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid address family in selector");
 		goto out;
 	}
 
 	err = -EINVAL;
 	switch (p->id.proto) {
 	case IPPROTO_AH:
-		if ((!attrs[XFRMA_ALG_AUTH]	&&
-		     !attrs[XFRMA_ALG_AUTH_TRUNC]) ||
-		    attrs[XFRMA_ALG_AEAD]	||
+		if (!attrs[XFRMA_ALG_AUTH]	&&
+		    !attrs[XFRMA_ALG_AUTH_TRUNC]) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute for AH: AUTH_TRUNC or AUTH");
+			goto out;
+		}
+
+		if (attrs[XFRMA_ALG_AEAD]	||
 		    attrs[XFRMA_ALG_CRYPT]	||
 		    attrs[XFRMA_ALG_COMP]	||
-		    attrs[XFRMA_TFCPAD])
+		    attrs[XFRMA_TFCPAD]) {
+			NL_SET_ERR_MSG(extack, "Invalid attributes for AH: AEAD, CRYPT, COMP, TFCPAD");
 			goto out;
+		}
 		break;
 
 	case IPPROTO_ESP:
-		if (attrs[XFRMA_ALG_COMP])
+		if (attrs[XFRMA_ALG_COMP]) {
+			NL_SET_ERR_MSG(extack, "Invalid attribute for ESP: COMP");
 			goto out;
+		}
+
 		if (!attrs[XFRMA_ALG_AUTH] &&
 		    !attrs[XFRMA_ALG_AUTH_TRUNC] &&
 		    !attrs[XFRMA_ALG_CRYPT] &&
-		    !attrs[XFRMA_ALG_AEAD])
+		    !attrs[XFRMA_ALG_AEAD]) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute for ESP: at least one of AUTH, AUTH_TRUNC, CRYPT, AEAD");
 			goto out;
+		}
+
 		if ((attrs[XFRMA_ALG_AUTH] ||
 		     attrs[XFRMA_ALG_AUTH_TRUNC] ||
 		     attrs[XFRMA_ALG_CRYPT]) &&
-		    attrs[XFRMA_ALG_AEAD])
+		    attrs[XFRMA_ALG_AEAD]) {
+			NL_SET_ERR_MSG(extack, "Invalid attribute combination for ESP: AEAD can't be used with AUTH, AUTH_TRUNC, CRYPT");
 			goto out;
+		}
+
 		if (attrs[XFRMA_TFCPAD] &&
-		    p->mode != XFRM_MODE_TUNNEL)
+		    p->mode != XFRM_MODE_TUNNEL) {
+			NL_SET_ERR_MSG(extack, "TFC padding can only be used in tunnel mode");
 			goto out;
+		}
 		break;
 
 	case IPPROTO_COMP:
-		if (!attrs[XFRMA_ALG_COMP]	||
-		    attrs[XFRMA_ALG_AEAD]	||
+		if (!attrs[XFRMA_ALG_COMP]) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute for COMP: COMP");
+			goto out;
+		}
+
+		if (attrs[XFRMA_ALG_AEAD]	||
 		    attrs[XFRMA_ALG_AUTH]	||
 		    attrs[XFRMA_ALG_AUTH_TRUNC]	||
 		    attrs[XFRMA_ALG_CRYPT]	||
-		    attrs[XFRMA_TFCPAD]		||
-		    (ntohl(p->id.spi) >= 0x10000))
+		    attrs[XFRMA_TFCPAD]) {
+			NL_SET_ERR_MSG(extack, "Invalid attributes for COMP: AEAD, AUTH, AUTH_TRUNC, CRYPT, TFCPAD");
+			goto out;
+		}
+
+		if (ntohl(p->id.spi) >= 0x10000) {
+			NL_SET_ERR_MSG(extack, "SPI is too large for COMP (must be < 0x10000)");
 			goto out;
+		}
 		break;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -249,13 +285,20 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		    attrs[XFRMA_ALG_CRYPT]	||
 		    attrs[XFRMA_ENCAP]		||
 		    attrs[XFRMA_SEC_CTX]	||
-		    attrs[XFRMA_TFCPAD]		||
-		    !attrs[XFRMA_COADDR])
+		    attrs[XFRMA_TFCPAD]) {
+			NL_SET_ERR_MSG(extack, "Invalid attributes for DSTOPTS/ROUTING");
+			goto out;
+		}
+
+		if (!attrs[XFRMA_COADDR]) {
+			NL_SET_ERR_MSG(extack, "Missing required COADDR attribute for DSTOPTS/ROUTING");
 			goto out;
+		}
 		break;
 #endif
 
 	default:
+		NL_SET_ERR_MSG(extack, "Unsupported protocol");
 		goto out;
 	}
 
@@ -269,7 +312,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	if ((err = verify_one_alg(attrs, XFRMA_ALG_COMP)))
 		goto out;
-	if ((err = verify_sec_ctx_len(attrs, NULL)))
+	if ((err = verify_sec_ctx_len(attrs, extack)))
 		goto out;
 	if ((err = verify_replay(p, attrs)))
 		goto out;
@@ -283,14 +326,19 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Unsupported mode");
 		goto out;
 	}
 
 	err = 0;
 
-	if (attrs[XFRMA_MTIMER_THRESH])
-		if (!attrs[XFRMA_ENCAP])
+	if (attrs[XFRMA_MTIMER_THRESH]) {
+		if (!attrs[XFRMA_ENCAP]) {
+			NL_SET_ERR_MSG(extack, "MTIMER_THRESH attribute can only be set on ENCAP states");
 			err = -EINVAL;
+			goto out;
+		}
+	}
 
 out:
 	return err;
@@ -691,7 +739,7 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int err;
 	struct km_event c;
 
-	err = verify_newsa_info(p, attrs);
+	err = verify_newsa_info(p, attrs, extack);
 	if (err)
 		return err;
 
-- 
2.53.0



