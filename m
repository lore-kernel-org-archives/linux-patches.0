Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B9F46A612;
	Tue, 21 Jul 2026 15:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649224; cv=none; b=Oa9erjrRUqGwbkeotY2y9Ix1NGHL8eciz4yWM0Mz5F1Q4fgyzcp5p2sFQ+erOLFqYChKWD3enshF82ysXXu82hEq6yZCfg4MURDPIkCwm2JsoxqUgaCi3Gj/jdAnswC43r6dr109rtHsS5jM8NtOukaOV1qR3WNLnesfIptbJXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649224; c=relaxed/simple;
	bh=ZdGeikeaw8qYD10iAeYXmTNu15fqxnu5MT9VF9iDMn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhFCgVv6VqFihlpqQ6ndXm2WOqbLZLzDmoakLDfnPjGQduOHjyrGBIS0FAk0nkszGybYedVv9+kgnJ5n4WThhgyIXeTMqgd62kNGtlWDrZHhw1RAVX1ruLzwm10L45jRckDoOSrDZqbiBe57HX7c2kDcnaiis0U+dvK/g7qSqu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhJwUWx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhJwUWx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CF91F000E9;
	Tue, 21 Jul 2026 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649223;
	bh=qE4aVYae1/21dRy4MScEnPAx2fHcEIi2OZ9WUMfHlsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qhJwUWx28ukBff3E2AVSSlxHrKwMarBrgELCFP4/JaxVby0yK/hzm2G+sGaJitJaZ
	 lwW50iHixFiJ2rj6QO+9fDA0eMaRBp9tgerY/mqTJOJ42yEJnszJnH2YF7pz9ctp1U
	 TZX8NuqTQRsIeYJdykBiNwqr4oeb6fgW/KUjAUxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0495/2077] netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp
Date: Tue, 21 Jul 2026 17:02:48 +0200
Message-ID: <20260721152604.488125853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b0f02608fbcd607b5131cceb91fc0a035264e61c ]

For GRE flows, validate that the ct master helper (if any) is pptp
before calling nf_ct_gre_keymap_destroy(), so the helper data area
can be accessed safely. Note that only the pptp helper provides a
.destroy callback.

Fixes: e56894356f60 ("netfilter: conntrack: remove l4proto destroy hook")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d46faf2d7b9ae6..75c91636bf6194 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -562,9 +562,23 @@ static void destroy_gre_conntrack(struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	struct nf_conn *master = ct->master;
+	struct nf_conn_help *help;
+
+	if (!master)
+		return;
+
+	help = nfct_help(master);
+	if (help) {
+		struct nf_conntrack_helper *helper;
 
-	if (master)
-		nf_ct_gre_keymap_destroy(master);
+		rcu_read_lock();
+		helper = rcu_dereference(help->helper);
+		/* Only pptp helper has a destroy callback. */
+		if (helper && helper->destroy)
+			nf_ct_gre_keymap_destroy(master);
+
+		rcu_read_unlock();
+	}
 #endif
 }
 
-- 
2.53.0



