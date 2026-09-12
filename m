Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4739A3CDBB5;
	Sat, 12 Sep 2026 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228787; cv=none; b=ecIcB5BqOIEzt0lxCgQh9AU3Um9u1v9paDw8vPmAV/AjPLdf3u+Py3x3f2jnkZ3en15UG7bmbveoOuprBYqyoFnE7H4g/h9dzMNHNUY8/r0x9YMAZnteeax7y4rs7XM8gPFLGHeJgRymhvZopQt+KuS+CImE257XAsGrG4JmGdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228787; c=relaxed/simple;
	bh=uH0fqpGcpSKPUxUBvEn4pBFzfefOCtOScj/mjvUI1Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8Hj4fqoWOkau1XfAsE13yexdAoT82nGN+ZUGymaEod76szMF3S4auzBGlMvFn/GndCct3IcqfU+QTmXXU4RKeuc/94CMqx93iQ9EHqHjBS5hZNR258tF3IbOMwH+p8TH5ObN6XeflooXN1qe4VAzecbVxVW89xxiojaEeuj/iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nm7C3yUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nm7C3yUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853261F00893;
	Sat, 12 Sep 2026 15:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228779;
	bh=Hn9JhG60VE4Aj+apMK2FktqLShivho6/iPRwmGFGyNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nm7C3yUJ7La+K6dft3gsMPK/0Zcih5G+PGadMsiRHZAwDzl1cu3z6HygQX4LpJt/s
	 NSt7cLHneWEcAtXJpn/p/XA+WMx/TayoCfDbxZ7YHCXMmBsbajpJO8r9gXpvjVyCdz
	 xpCEvogxrXIpf/ZypZhqmmHeVzUvbw7GiMPM7i6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Xiao Liu <lx24@stu.ynu.edu.cn>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0454/1191] net: af_key: zero aligned sockaddr tail in PF_KEY exports
Date: Sat, 12 Sep 2026 08:53:02 +0200
Message-ID: <20260912065558.433436829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Zhengchuan Liang <zcliangcn@gmail.com>

[ Upstream commit 426c355742f02cf743b347d9d7dbdc1bfbfa31ef ]

PF_KEY export paths use `pfkey_sockaddr_size()` when reserving sockaddr
payload space, so IPv6 addresses occupy 32 bytes on the wire. However,
`pfkey_sockaddr_fill()` initializes only the first 28 bytes of
`struct sockaddr_in6`, leaving the final 4 aligned bytes uninitialized.

Not every PF_KEY message is affected. The state and policy dump builders
already zero the whole message buffer before filling the sockaddr
payloads. Keep the fix to the export paths that still append aligned
sockaddr payloads with plain `skb_put()`:

  - `SADB_ACQUIRE`
  - `SADB_X_NAT_T_NEW_MAPPING`
  - `SADB_X_MIGRATE`

Fix those paths by clearing only the aligned sockaddr tail after
`pfkey_sockaddr_fill()`.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 08de61beab8a ("[PFKEYV2]: Extension for dynamic update of endpoint address(es)")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Xiao Liu <lx24@stu.ynu.edu.cn>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 52 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 3e6aec499c248..619bb192cca08 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -757,6 +757,22 @@ static unsigned int pfkey_sockaddr_fill(const xfrm_address_t *xaddr, __be16 port
 	return 0;
 }
 
+static unsigned int pfkey_sockaddr_fill_zero_tail(const xfrm_address_t *xaddr,
+						  __be16 port,
+						  struct sockaddr *sa,
+						  unsigned short family)
+{
+	unsigned int prefixlen;
+	int sockaddr_len = pfkey_sockaddr_len(family);
+	int sockaddr_size = pfkey_sockaddr_size(family);
+
+	prefixlen = pfkey_sockaddr_fill(xaddr, port, sa, family);
+	if (sockaddr_size > sockaddr_len)
+		memset((u8 *)sa + sockaddr_len, 0, sockaddr_size - sockaddr_len);
+
+	return prefixlen;
+}
+
 static struct sk_buff *__pfkey_xfrm_state2msg(const struct xfrm_state *x,
 					      int add_keys, int hsc)
 {
@@ -3207,9 +3223,9 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	addr->sadb_address_proto = 0;
 	addr->sadb_address_reserved = 0;
 	addr->sadb_address_prefixlen =
-		pfkey_sockaddr_fill(&x->props.saddr, 0,
-				    (struct sockaddr *) (addr + 1),
-				    x->props.family);
+		pfkey_sockaddr_fill_zero_tail(&x->props.saddr, 0,
+					      (struct sockaddr *)(addr + 1),
+					      x->props.family);
 	if (!addr->sadb_address_prefixlen)
 		BUG();
 
@@ -3222,9 +3238,9 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	addr->sadb_address_proto = 0;
 	addr->sadb_address_reserved = 0;
 	addr->sadb_address_prefixlen =
-		pfkey_sockaddr_fill(&x->id.daddr, 0,
-				    (struct sockaddr *) (addr + 1),
-				    x->props.family);
+		pfkey_sockaddr_fill_zero_tail(&x->id.daddr, 0,
+					      (struct sockaddr *)(addr + 1),
+					      x->props.family);
 	if (!addr->sadb_address_prefixlen)
 		BUG();
 
@@ -3422,9 +3438,9 @@ static int pfkey_send_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr,
 	addr->sadb_address_proto = 0;
 	addr->sadb_address_reserved = 0;
 	addr->sadb_address_prefixlen =
-		pfkey_sockaddr_fill(&x->props.saddr, 0,
-				    (struct sockaddr *) (addr + 1),
-				    x->props.family);
+		pfkey_sockaddr_fill_zero_tail(&x->props.saddr, 0,
+					      (struct sockaddr *)(addr + 1),
+					      x->props.family);
 	if (!addr->sadb_address_prefixlen)
 		BUG();
 
@@ -3444,9 +3460,9 @@ static int pfkey_send_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr,
 	addr->sadb_address_proto = 0;
 	addr->sadb_address_reserved = 0;
 	addr->sadb_address_prefixlen =
-		pfkey_sockaddr_fill(ipaddr, 0,
-				    (struct sockaddr *) (addr + 1),
-				    x->props.family);
+		pfkey_sockaddr_fill_zero_tail(ipaddr, 0,
+					      (struct sockaddr *)(addr + 1),
+					      x->props.family);
 	if (!addr->sadb_address_prefixlen)
 		BUG();
 
@@ -3475,15 +3491,15 @@ static int set_sadb_address(struct sk_buff *skb, int sasize, int type,
 	switch (type) {
 	case SADB_EXT_ADDRESS_SRC:
 		addr->sadb_address_prefixlen = sel->prefixlen_s;
-		pfkey_sockaddr_fill(&sel->saddr, 0,
-				    (struct sockaddr *)(addr + 1),
-				    sel->family);
+		pfkey_sockaddr_fill_zero_tail(&sel->saddr, 0,
+					      (struct sockaddr *)(addr + 1),
+					      sel->family);
 		break;
 	case SADB_EXT_ADDRESS_DST:
 		addr->sadb_address_prefixlen = sel->prefixlen_d;
-		pfkey_sockaddr_fill(&sel->daddr, 0,
-				    (struct sockaddr *)(addr + 1),
-				    sel->family);
+		pfkey_sockaddr_fill_zero_tail(&sel->daddr, 0,
+					      (struct sockaddr *)(addr + 1),
+					      sel->family);
 		break;
 	default:
 		return -EINVAL;
-- 
2.53.0



