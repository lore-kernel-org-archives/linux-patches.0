Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ECF3CC303;
	Tue, 16 Jun 2026 18:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636177; cv=none; b=Z/ERKCNRf/xoo7uI7G7ahbf4B+Ah1vYxaeVACG+sbMxQkkqdEQ8ogalD9q22NBP26dImf74rfBQ08Pfh0Ln3IiOPi4GcykkDk/3IYb4yrsky89JMirW6sVfFu2/4J73aPM207S+ZsoFXLf6HkBnpbRdFX/g1DnH1ECrwuvl1bI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636177; c=relaxed/simple;
	bh=MYWtaAG87XhY6wzlU/62yvnIDUS91Rl79+igeIHYpa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sibfUz0wf8cZJ7xkWsR5CWE3mNuPTnZHV/K2vQYhJUYK5Do4k62PdYeepn6gc324NWp4RZFKCtIhoNHaLWJ5IccGRurn5yT7EIzqThRKI2FxyDOe2Pquc4CT0nIKCawVSlkLn0zlUCEQHLriVy617DXErsZJKlA26BHPmGh2z64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHwhEHrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHwhEHrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF2A1F000E9;
	Tue, 16 Jun 2026 18:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636176;
	bh=I+gPakh/VFI6OKQp1i/zFE0AQ8Ek8piIhy6EDy5ft7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHwhEHrPtJvU8TgcCpD+1fbQTw1rPd3xlkUXrjkIm9fVZ82F5m+AEGAJqYe2pOjyJ
	 tCMD80byjs67SH9neHFM7NhMF0pI4Y3PncmqzTVqRb5IFIoKawrqYZ0MZGIAt5QMqX
	 lY3ppHPQMT+6sBcObkWxoqetr+BL57gDJdEE1H6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/342] netlabel: validate unlabeled address and mask attribute lengths
Date: Tue, 16 Jun 2026 20:27:42 +0530
Message-ID: <20260616145055.923871108@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 9772589b57e44aedc240211c5c3f7a684a034d3a ]

netlbl_unlabel_addrinfo_get() used the address attribute length to
determine whether the attribute data could be read as an IPv4 or IPv6
address, but did not independently validate the corresponding mask
attribute length.  A crafted Generic Netlink request could therefore
provide a valid IPv4/IPv6 address attribute with a shorter mask
attribute, which would later be read as a full struct in_addr or
struct in6_addr.

NLA_BINARY policy lengths are maximum lengths by default, so use
NLA_POLICY_EXACT_LEN() for the unlabeled IPv4/IPv6 address and mask
attributes.  This rejects short attributes during policy validation and
also exposes the exact length requirements through policy introspection.

Fixes: 8cc44579d1bd ("NetLabel: Introduce static network labels for unlabeled connections")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_unlabeled.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 3049fff0b7f864..7bfccedbffe5aa 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -114,14 +114,14 @@ static struct genl_family netlbl_unlabel_gnl_family;
 /* NetLabel Netlink attribute policy */
 static const struct nla_policy netlbl_unlabel_genl_policy[NLBL_UNLABEL_A_MAX + 1] = {
 	[NLBL_UNLABEL_A_ACPTFLG] = { .type = NLA_U8 },
-	[NLBL_UNLABEL_A_IPV6ADDR] = { .type = NLA_BINARY,
-				      .len = sizeof(struct in6_addr) },
-	[NLBL_UNLABEL_A_IPV6MASK] = { .type = NLA_BINARY,
-				      .len = sizeof(struct in6_addr) },
-	[NLBL_UNLABEL_A_IPV4ADDR] = { .type = NLA_BINARY,
-				      .len = sizeof(struct in_addr) },
-	[NLBL_UNLABEL_A_IPV4MASK] = { .type = NLA_BINARY,
-				      .len = sizeof(struct in_addr) },
+	[NLBL_UNLABEL_A_IPV6ADDR] =
+		NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
+	[NLBL_UNLABEL_A_IPV6MASK] =
+		NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
+	[NLBL_UNLABEL_A_IPV4ADDR] =
+		NLA_POLICY_EXACT_LEN(sizeof(struct in_addr)),
+	[NLBL_UNLABEL_A_IPV4MASK] =
+		NLA_POLICY_EXACT_LEN(sizeof(struct in_addr)),
 	[NLBL_UNLABEL_A_IFACE] = { .type = NLA_NUL_STRING,
 				   .len = IFNAMSIZ - 1 },
 	[NLBL_UNLABEL_A_SECCTX] = { .type = NLA_BINARY }
@@ -766,24 +766,14 @@ static int netlbl_unlabel_addrinfo_get(struct genl_info *info,
 				       void **mask,
 				       u32 *len)
 {
-	u32 addr_len;
-
 	if (info->attrs[NLBL_UNLABEL_A_IPV4ADDR] &&
 	    info->attrs[NLBL_UNLABEL_A_IPV4MASK]) {
-		addr_len = nla_len(info->attrs[NLBL_UNLABEL_A_IPV4ADDR]);
-		if (addr_len != sizeof(struct in_addr) &&
-		    addr_len != nla_len(info->attrs[NLBL_UNLABEL_A_IPV4MASK]))
-			return -EINVAL;
-		*len = addr_len;
+		*len = sizeof(struct in_addr);
 		*addr = nla_data(info->attrs[NLBL_UNLABEL_A_IPV4ADDR]);
 		*mask = nla_data(info->attrs[NLBL_UNLABEL_A_IPV4MASK]);
 		return 0;
 	} else if (info->attrs[NLBL_UNLABEL_A_IPV6ADDR]) {
-		addr_len = nla_len(info->attrs[NLBL_UNLABEL_A_IPV6ADDR]);
-		if (addr_len != sizeof(struct in6_addr) &&
-		    addr_len != nla_len(info->attrs[NLBL_UNLABEL_A_IPV6MASK]))
-			return -EINVAL;
-		*len = addr_len;
+		*len = sizeof(struct in6_addr);
 		*addr = nla_data(info->attrs[NLBL_UNLABEL_A_IPV6ADDR]);
 		*mask = nla_data(info->attrs[NLBL_UNLABEL_A_IPV6MASK]);
 		return 0;
-- 
2.53.0



