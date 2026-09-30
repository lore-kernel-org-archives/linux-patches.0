Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF5C4DAF8A;
	Wed, 30 Sep 2026 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783299; cv=none; b=SCgBooE2ajayp/dnN7Km1dTyM0emF/UnMqatOvs7yOxk88As1T0AY4S9iTdiEzRejFkIu+950kmhJp5N/0eQOiGqWYTVkHoMtYXJgUpGH1ZPqqut+YuOaMFvWsTo9oHiXocv8rcep+YkNrve2hDpFRyIVLUOj0vFruiyxRO2xW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783299; c=relaxed/simple;
	bh=qY+migbqZwvezOlpLJ/oUVlUaOlQuWyGDEUulIzhcCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tK9BvAMc/wPrsal+uc+uxOGlZNUwphwdZ0aLSXrhCBhGFsgU+s6Bib2hTID7T5gansQICvbInD3EPqjbn/7jzoS5p5NtGrioaaKjRFhqdwBQyzL4MCjlZ5qHJx5ogOTvYc5zIBTkMbW+TOAQolYTNcOtr+//kEX0h6y54tpw83c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auC5cP8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auC5cP8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC481F00893;
	Wed, 30 Sep 2026 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783296;
	bh=OmPydsVPJVtWobedO2l3RhWVyOCmUzOn027fzVUxEjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=auC5cP8JxSdOV35C6+FRp400SMMTPKK47wTgAmPo/0K7nRQ6r9kiJt8wSK9Wh4zqm
	 Ewj3u3/SbginK5LAGZYuKwECb0+idy+3wGH9L09DDBG9mZShN3VjL8HmIeBliDHk9J
	 Qmu87ljHN4M/YsrhwG6beDS98sCEqm+IUJBwuyeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/595] xfrm: add extack support to verify_newsa_info
Date: Wed, 30 Sep 2026 17:24:00 +0200
Message-ID: <20260930152355.142403848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index d0f68609b6952..972320c2f64a1 100644
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



