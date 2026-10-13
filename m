Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B78F364929;
	Tue, 13 Oct 2026 12:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894912; cv=none; b=O5KK3hOPXh93eHvGdxLwKlmJYVGavE0gx8Zpm94J8PfeHsSwdqzbKA/pufhBGatykBo3lDXE8LrMB+vl5XoXzQw06adT+WY/kn69ZIkR41Zwb0Vf5spfPYqptKBTYFRge2Z/7KRJjrOk5vIw+rWRm0pT5fC0pFXsvdXYLNFTvms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894912; c=relaxed/simple;
	bh=KTHTf9TPSpJxL30nhLwaDBp/hBfdLffQvVmi3ajKTQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeK2j6NjFge1wTWIHD/+tuJ1o1xOrFH09mzRdZHPKW/EsWpzknOD8c7WrgypJcZ5tv5JotWrXs1oCe+gNi1JdbeT1bEtsIgUa8qIlR1my7xnCqOOlWJnEhCQLpW2O+vKOqAcTkfUcWpRWQp63bi8T2BA48VbsBgLZ2IoKBsXZyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOLFWax1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOLFWax1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C6E1F000FF;
	Tue, 13 Oct 2026 12:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894911;
	bh=im5e6Yx4lW8fCoZvfKTgjWhBNGxOnoliJR6Bn6+HqVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOLFWax15k0FbpE/Xn9bzzqJXyNbly86hNZRi4IarU1oXGt7Nqdya0Io1kTcRak9j
	 sJi1vZNIyBBinFWYdOjFBYedBv5yK8G+qol92BmitOxsoVGXperIGUsty8fCKnoSqw
	 HyWPZkqutWg9zmTE+9P8SKJM581Mk3OUJDCCd0m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/497] netfilter: conntrack: remove skb argument from nf_ct_refresh
Date: Tue, 13 Oct 2026 13:34:26 +0200
Message-ID: <20261013112910.239933634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 31768596b15aa8c9c55f078acad29d0238c8269b ]

Its not used (and could be NULL), so remove it.
This allows to use nf_ct_refresh in places where we don't have
an skb without having to double-check that skb == NULL would be safe.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 7c549fb7eecd ("netfilter: flowtable: generalize pending status bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack.h   | 8 +++-----
 net/netfilter/nf_conntrack_amanda.c    | 2 +-
 net/netfilter/nf_conntrack_broadcast.c | 2 +-
 net/netfilter/nf_conntrack_core.c      | 7 +++----
 net/netfilter/nf_conntrack_h323_main.c | 4 ++--
 net/netfilter/nf_conntrack_sip.c       | 4 ++--
 net/netfilter/nft_ct.c                 | 2 +-
 7 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 3d938a19d332a..91599d3ecc8a8 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -209,8 +209,7 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 		       struct nf_conntrack_tuple *tuple);
 
 void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
-			  const struct sk_buff *skb,
-			  u32 extra_jiffies, bool do_acct);
+			  u32 extra_jiffies, unsigned int bytes);
 
 /* Refresh conntrack for this many jiffies and do accounting */
 static inline void nf_ct_refresh_acct(struct nf_conn *ct,
@@ -218,15 +217,14 @@ static inline void nf_ct_refresh_acct(struct nf_conn *ct,
 				      const struct sk_buff *skb,
 				      u32 extra_jiffies)
 {
-	__nf_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies, true);
+	__nf_ct_refresh_acct(ct, ctinfo, extra_jiffies, skb->len);
 }
 
 /* Refresh conntrack for this many jiffies */
 static inline void nf_ct_refresh(struct nf_conn *ct,
-				 const struct sk_buff *skb,
 				 u32 extra_jiffies)
 {
-	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, false);
+	__nf_ct_refresh_acct(ct, 0, extra_jiffies, 0);
 }
 
 /* kill conntrack and do accounting */
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index d011d2eb08486..7be4c35e4795e 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -106,7 +106,7 @@ static int amanda_help(struct sk_buff *skb,
 
 	/* increase the UDP timeout of the master connection as replies from
 	 * Amanda clients to the server can be quite delayed */
-	nf_ct_refresh(ct, skb, master_timeout * HZ);
+	nf_ct_refresh(ct, master_timeout * HZ);
 
 	/* No data? */
 	dataoff = protoff + sizeof(struct udphdr);
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 93c501d9d399c..75e53fde6b297 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -80,7 +80,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	nf_ct_expect_related(exp, 0);
 	nf_ct_expect_put(exp);
 
-	nf_ct_refresh(ct, skb, timeout * HZ);
+	nf_ct_refresh(ct, timeout * HZ);
 out:
 	return NF_ACCEPT;
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 77a445a59af3e..da9367047baf4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2065,9 +2065,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_in);
 /* Refresh conntrack for this many jiffies and do accounting if do_acct is 1 */
 void __nf_ct_refresh_acct(struct nf_conn *ct,
 			  enum ip_conntrack_info ctinfo,
-			  const struct sk_buff *skb,
 			  u32 extra_jiffies,
-			  bool do_acct)
+			  unsigned int bytes)
 {
 	/* Only update if this is not a fixed timeout */
 	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
@@ -2080,8 +2079,8 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 	if (READ_ONCE(ct->timeout) != extra_jiffies)
 		WRITE_ONCE(ct->timeout, extra_jiffies);
 acct:
-	if (do_acct)
-		nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), skb->len);
+	if (bytes)
+		nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), bytes);
 }
 EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index c42547284f351..a116c6629e2b8 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1385,7 +1385,7 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 	if (info->timeout > 0) {
 		pr_debug("nf_ct_ras: set RAS connection timeout to "
 			 "%u seconds\n", info->timeout);
-		nf_ct_refresh(ct, skb, info->timeout * HZ);
+		nf_ct_refresh(ct, info->timeout * HZ);
 
 		/* Set expect timeout */
 		spin_lock_bh(&nf_conntrack_expect_lock);
@@ -1433,7 +1433,7 @@ static int process_urq(struct sk_buff *skb, struct nf_conn *ct,
 	info->sig_port[!dir] = 0;
 
 	/* Give it 30 seconds for UCF or URJ */
-	nf_ct_refresh(ct, skb, 30 * HZ);
+	nf_ct_refresh(ct, 30 * HZ);
 
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 2b5f807436e2c..5b75e9bc99e9f 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1646,7 +1646,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 	if (dataoff >= skb->len)
 		return NF_ACCEPT;
 
-	nf_ct_refresh(ct, skb, sip_timeout * HZ);
+	nf_ct_refresh(ct, sip_timeout * HZ);
 
 	if (unlikely(skb_linearize(skb)))
 		return NF_DROP;
@@ -1720,7 +1720,7 @@ static int sip_help_udp(struct sk_buff *skb, unsigned int protoff,
 	if (dataoff >= skb->len)
 		return NF_ACCEPT;
 
-	nf_ct_refresh(ct, skb, sip_timeout * HZ);
+	nf_ct_refresh(ct, sip_timeout * HZ);
 
 	if (unlikely(skb_linearize(skb)))
 		return NF_DROP;
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 8feea8b2422b0..c238c97a90536 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -884,7 +884,7 @@ static void nft_ct_timeout_obj_eval(struct nft_object *obj,
 	 */
 	values = nf_ct_timeout_data(timeout);
 	if (values)
-		nf_ct_refresh(ct, pkt->skb, values[0]);
+		nf_ct_refresh(ct, values[0]);
 }
 
 static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
-- 
2.53.0



