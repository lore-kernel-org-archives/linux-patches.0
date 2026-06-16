Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEFA47799B;
	Tue, 16 Jun 2026 17:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629263; cv=none; b=D7wjU33qQvHWV/6sp1JqS3nIftZ4UxyNHDVatT3Uz9Chzm2kYxuyf9rPahruDlqmR6dps8A5Fmta5UBRDz5AopBOLmriJ2C+b1oWuZEB4jy8ZNknNjaHD5hTphop2HXBOadWMV8MwFDxU0nIR88Vgfjnsi+jJ0iUs4C/sJeCZDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629263; c=relaxed/simple;
	bh=9B45uVSrcfM3A61UEFnylhr7t/6sqdKMsFqIJ+NzQRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gsfgorz2Hm3qRwIdipflvj6z7GWprgwm70ShXCfxcZHQ6lITq5a0MQeziIIMcNBW1TYP5RfgevLAxzYR7KxYE2agRkUPVplSIBUsxorhwp3IVui3fE90XkUnQjQ3b6xeQ88c5QqJtM2PfFZ3lbXKUCnlv6rGmORFZ6dm73uSh8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JaBCOx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JaBCOx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752FA1F000E9;
	Tue, 16 Jun 2026 17:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629262;
	bh=O14JXKx7E77N3FduSLBxrv9vknf95Wr1gm36A9gSV/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2JaBCOx/zrfKPbV9Hc+gUz6B2lT2JCbYIBZp7DTVq9nK1UX69+fAzH6u01UWYGngR
	 IJeVM0r0eyosKI+SV6HeDfGNcOTiCXs1shPHzNXTre47TgM2t/BK3OznzXK4akfObt
	 u0Q5l3TRU/65zxJAke7zBri3qZ9oEtymyp9Hr7YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/452] netfilter: nft_ct: bail out on template ct in get eval
Date: Tue, 16 Jun 2026 20:27:26 +0530
Message-ID: <20260616145129.281062381@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 3027ecbdb5fdf9200251c21d4818e4c447ef78e1 ]

I noticed this issue while looking at a historic syzbot report [1].

A rule like the one below is enough to trigger the bug:

    table ip t {
        chain pre {
            type filter hook prerouting priority raw;
            ct zone set 1
            ct original saddr 1.2.3.4 accept
        }
    }

The first expression attaches a per-cpu template ct via
nft_ct_set_zone_eval() (nf_ct_tmpl_alloc -> kzalloc, tuple is all
zero, nf_ct_l3num(ct) == 0). The next expression then calls
nft_ct_get_eval() on the same skb, treats the template as a real ct
and hits the 16-byte memcpy path. With dreg at NFT_REG32_15 this
overflows past struct nft_regs on the kernel stack; with smaller
dreg values it silently clobbers adjacent registers.

Reject template ct at the eval entry and in nft_ct_get_fast_eval(),
mirroring the check nft_ct_set_eval() already has. Additionally,
bound the address copy in NFT_CT_SRC / NFT_CT_DST by priv->len
instead of by nf_ct_l3num(ct): nf_ct_get_tuple() zeroes the tuple
before pkt_to_tuple() fills in only the protocol-relevant leading
bytes, so the trailing bytes of tuple->{src,dst}.u3.all are
well-defined zero. priv->len is validated at rule load, so the
copy size is now bounded by the destination register rather than
by an untrusted field on the conntrack.

[1]: https://syzkaller.appspot.com/bug?id=389cf09cb72926114fce90dc85a2c3231dcb647c

Fixes: 45d9bcda21f4 ("netfilter: nf_tables: validate len in nft_validate_data_load()")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c      | 8 +++-----
 net/netfilter/nft_ct_fast.c | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 83c963e668ffe0..e83aa87a348e7d 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -78,7 +78,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	if (ct == NULL)
+	if (!ct || nf_ct_is_template(ct))
 		goto err;
 
 	switch (priv->key) {
@@ -180,12 +180,10 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	tuple = &ct->tuplehash[priv->dir].tuple;
 	switch (priv->key) {
 	case NFT_CT_SRC:
-		memcpy(dest, tuple->src.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		memcpy(dest, tuple->src.u3.all, priv->len);
 		return;
 	case NFT_CT_DST:
-		memcpy(dest, tuple->dst.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		memcpy(dest, tuple->dst.u3.all, priv->len);
 		return;
 	case NFT_CT_PROTO_SRC:
 		nft_reg_store16(dest, (__force u16)tuple->src.u.all);
diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
index e684c8a9184877..ecf7b3a404be26 100644
--- a/net/netfilter/nft_ct_fast.c
+++ b/net/netfilter/nft_ct_fast.c
@@ -30,7 +30,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	if (!ct) {
+	if (!ct || nf_ct_is_template(ct)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.53.0



