Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9601565192;
	Wed, 30 Sep 2026 18:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791830; cv=none; b=VOiCg78CXxP1I7usYwvJMD+ATFJgRJrRKgY88SwwcxbRGIqHvSjw7FGCsdWvE6DdANmqBrld7F/NZ6HHmdBmabY/wBH2flo4pRsRKw7MaFibtTCZA/4WBqr7VEFk5VLJGMj8/+1vlrDSCVHeMugBb7VX885wirXd9JtFDadE0M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791830; c=relaxed/simple;
	bh=nXDjnypceykfeaaFUnXxgmS13ppel3rtnn7apInkkHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6z3dS2Qme9zmdmdvVmkYBIEfil2hl5T6r5YQKMCJtE8WDDwmj0hlnsVURkb8XpUdLz6HdmGO5MnRtiyWbNih01JL33bSHcQtR+xDO8DyQgwOdMgjueBlPPmBVWYJioRYw4BWmNQ5BWtNtlixDh10Uph+4HAZP7gr5RQQmZfle0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRPEUdI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRPEUdI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BDE1F000FF;
	Wed, 30 Sep 2026 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791828;
	bh=3jhlpObDfdQsyBhke+F3mFW4I+h9bXkMJlspDp+xnMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRPEUdI6isBDyfGuFoRxrys6iwSX0twTBqSS4Uu5sxvKo8MIs2Jsd5yDbORiDPzXT
	 Nvw/eCeGe+1UylL/LW2gJKodGG3AbVqtrUAa1dw/pN3B1RsMyfSy8i1CLAUAu60lA7
	 194RUtxe62nOb4Rz7qHhwBD0TOXzrDWQIY5FWQTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/752] xfrm: add extack to verify_one_alg, verify_auth_trunc, verify_aead
Date: Wed, 30 Sep 2026 17:25:10 +0200
Message-ID: <20260930152407.805722117@linuxfoundation.org>
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

[ Upstream commit 1fc8fde553917bca7c9b65fafb045a2a5c97e683 ]

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: d1ebd9081879 ("xfrm: fix compat ALLOCSPI request use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 64d7469d62230..82578cb1933e6 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -34,7 +34,8 @@
 #endif
 #include <asm/unaligned.h>
 
-static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type)
+static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type,
+			  struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[type];
 	struct xfrm_algo *algp;
@@ -43,8 +44,10 @@ static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type)
 		return 0;
 
 	algp = nla_data(rt);
-	if (nla_len(rt) < (int)xfrm_alg_len(algp))
+	if (nla_len(rt) < (int)xfrm_alg_len(algp)) {
+		NL_SET_ERR_MSG(extack, "Invalid AUTH/CRYPT/COMP attribute length");
 		return -EINVAL;
+	}
 
 	switch (type) {
 	case XFRMA_ALG_AUTH:
@@ -53,6 +56,7 @@ static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type)
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid algorithm attribute type");
 		return -EINVAL;
 	}
 
@@ -60,7 +64,8 @@ static int verify_one_alg(struct nlattr **attrs, enum xfrm_attr_type_t type)
 	return 0;
 }
 
-static int verify_auth_trunc(struct nlattr **attrs)
+static int verify_auth_trunc(struct nlattr **attrs,
+			     struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_ALG_AUTH_TRUNC];
 	struct xfrm_algo_auth *algp;
@@ -69,14 +74,16 @@ static int verify_auth_trunc(struct nlattr **attrs)
 		return 0;
 
 	algp = nla_data(rt);
-	if (nla_len(rt) < (int)xfrm_alg_auth_len(algp))
+	if (nla_len(rt) < (int)xfrm_alg_auth_len(algp)) {
+		NL_SET_ERR_MSG(extack, "Invalid AUTH_TRUNC attribute length");
 		return -EINVAL;
+	}
 
 	algp->alg_name[sizeof(algp->alg_name) - 1] = '\0';
 	return 0;
 }
 
-static int verify_aead(struct nlattr **attrs)
+static int verify_aead(struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_ALG_AEAD];
 	struct xfrm_algo_aead *algp;
@@ -85,8 +92,10 @@ static int verify_aead(struct nlattr **attrs)
 		return 0;
 
 	algp = nla_data(rt);
-	if (nla_len(rt) < (int)aead_len(algp))
+	if (nla_len(rt) < (int)aead_len(algp)) {
+		NL_SET_ERR_MSG(extack, "Invalid AEAD attribute length");
 		return -EINVAL;
+	}
 
 	algp->alg_name[sizeof(algp->alg_name) - 1] = '\0';
 	return 0;
@@ -302,15 +311,15 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	}
 
-	if ((err = verify_aead(attrs)))
+	if ((err = verify_aead(attrs, extack)))
 		goto out;
-	if ((err = verify_auth_trunc(attrs)))
+	if ((err = verify_auth_trunc(attrs, extack)))
 		goto out;
-	if ((err = verify_one_alg(attrs, XFRMA_ALG_AUTH)))
+	if ((err = verify_one_alg(attrs, XFRMA_ALG_AUTH, extack)))
 		goto out;
-	if ((err = verify_one_alg(attrs, XFRMA_ALG_CRYPT)))
+	if ((err = verify_one_alg(attrs, XFRMA_ALG_CRYPT, extack)))
 		goto out;
-	if ((err = verify_one_alg(attrs, XFRMA_ALG_COMP)))
+	if ((err = verify_one_alg(attrs, XFRMA_ALG_COMP, extack)))
 		goto out;
 	if ((err = verify_sec_ctx_len(attrs, extack)))
 		goto out;
-- 
2.53.0



