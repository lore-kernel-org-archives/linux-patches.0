Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B886547D46A;
	Thu, 20 Aug 2026 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243425; cv=none; b=rYHB6fAa0Lx7hkaNQ7LSqU4mQuRDLRkOD12r9ZGDOMx8JNFBHSNxekx687Qx7hMTmZcLFmlTYCmkBaEn5AVzq2Me+elwz6Kl2C8FtmFIE1WIQXYQFoUsNmNA5Q/aYKYluiILBWx1pFvR23wuaH8dAH2QT0Qf/i/W5wua/3+Ct/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243425; c=relaxed/simple;
	bh=A3dDCuoOAwewOBvu+uypjMzljz6XHfemkprXJFvPEPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2usnPyIEy+xLvK5LvToHMCuPLa3gIInJOuQcKxUSV/MHjp5203QynGTTeF33wHtLFCq6sNXdZNzV6JXJj84ePMo1hseOUVjPM9vym3OaWMG5EoSQsedxfPtuapU6AYetaDnbQr17QSQRYyPIiwKM+RzfR4ues7ZvftWwPM60zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lev+71TK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lev+71TK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA011F000E9;
	Thu, 20 Aug 2026 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243424;
	bh=y1X2RBpCDamUAFv1hqI4s4hXT/riJ5+Z3G4TO32dQnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lev+71TKOyPBJ1z0mEueIKYvTjeTw8MqRDkeW8Jh6TOVaB3cdPMgDeR8ShUz3zIEX
	 rkymeEpNFYbXWa/N/5TI/b4RTBTMh25kzi70lzWP2I0eHRzq22LkYqopHN/qgFhnch
	 B9sPWyDh7SlZTUdR/Ix+TuD6BPkrxO5JgR3h8ruA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/272] netfilter: nft_set_pipapo: move prove_locking helper around
Date: Thu, 20 Aug 2026 16:54:35 +0200
Message-ID: <20260820145234.003655884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

[ Upstream commit a590f4760922acaa2d2b55a88004a38eecdd6412 ]

Preparation patch, the helper will soon get called from insert
function too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 47e65eff5069 ("netfilter: nft_set_pipapo: don't leak bad clone into future transaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1190,6 +1190,17 @@ static int pipapo_realloc_scratch(struct
 	return 0;
 }
 
+static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
+{
+#ifdef CONFIG_PROVE_LOCKING
+	const struct net *net = read_pnet(&set->net);
+
+	return lockdep_is_held(&nft_pernet(net)->commit_mutex);
+#else
+	return true;
+#endif
+}
+
 /**
  * nft_pipapo_insert() - Validate and insert ranged elements
  * @net:	Network namespace
@@ -1774,17 +1785,6 @@ static void nft_pipapo_commit(struct nft
 	pipapo_gc_queue(set);
 }
 
-static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
-{
-#ifdef CONFIG_PROVE_LOCKING
-	const struct net *net = read_pnet(&set->net);
-
-	return lockdep_is_held(&nft_pernet(net)->commit_mutex);
-#else
-	return true;
-#endif
-}
-
 static void nft_pipapo_abort(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);


