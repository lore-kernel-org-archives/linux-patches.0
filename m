Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1486A1C6AB;
	Mon,  4 Mar 2024 21:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589392; cv=none; b=Bpl0ojOdWVPH3hPTkmb+XYcnYkqbPUB+HfTudgN5959uDuajbIZ9sYoAQpD7VVln0eVMAA698ObAeEY1azvByIwZ1AIbiiQhwRg2QduJz5ZgdYC3XFNLDTsa0y8h1ywdFk9EtR3s/WorQTgTiZRfiAflDTkqv6ew+OItSITxg84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589392; c=relaxed/simple;
	bh=on07wjX4iqPfMb2dJzaif7ZBTWUJ5lOdHr0XELItaX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONvwPWsw2OcvDdJVszixfd5Gi6c+qnOgEfclRJJsCsM8pFIRkDxLgN5LrfK+hvHHZdNoMukf6DPNNE1f7wVD5uDoXPHpX5ho5B75uRPciFZrQcVzTubFNGhMM2WizYJ+owC+stczP1fIO4kBv47YWSrMnZIiwfXuxUjaEFvdoeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ponQrsd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ponQrsd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93176C433F1;
	Mon,  4 Mar 2024 21:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589391;
	bh=on07wjX4iqPfMb2dJzaif7ZBTWUJ5lOdHr0XELItaX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ponQrsd8jPYa6jcKjdY9sSnis01waVqwcEhm0hjVeU5SsU1on4K9HpbMMYKXyp6+F
	 ufqlkm+LMvGBLeYgERoS7mx0hDy1WSjN1nzRdDS72LR8CW9r39drciCeM4DGq5JCqv
	 2GtppOufNXxASSwe4WiVIaeOTlYj0XUK8uxhb5EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 79/84] bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for bpf_fib_lookup
Date: Mon,  4 Mar 2024 21:24:52 +0000
Message-ID: <20240304211545.041914351@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Martin KaFai Lau <martin.lau@kernel.org>

commit 31de4105f00d64570139bc5494a201b0bd57349f upstream.

The bpf_fib_lookup() also looks up the neigh table.
This was done before bpf_redirect_neigh() was added.

In the use case that does not manage the neigh table
and requires bpf_fib_lookup() to lookup a fib to
decide if it needs to redirect or not, the bpf prog can
depend only on using bpf_redirect_neigh() to lookup the
neigh. It also keeps the neigh entries fresh and connected.

This patch adds a bpf_fib_lookup flag, SKIP_NEIGH, to avoid
the double neigh lookup when the bpf prog always call
bpf_redirect_neigh() to do the neigh lookup. The params->smac
output is skipped together when SKIP_NEIGH is set because
bpf_redirect_neigh() will figure out the smac also.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230217205515.3583372-1-martin.lau@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/bpf.h       |    6 ++++++
 net/core/filter.c              |   39 ++++++++++++++++++++++++++-------------
 tools/include/uapi/linux/bpf.h |    6 ++++++
 3 files changed, 38 insertions(+), 13 deletions(-)

--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3014,6 +3014,11 @@ union bpf_attr {
  *		**BPF_FIB_LOOKUP_OUTPUT**
  *			Perform lookup from an egress perspective (default is
  *			ingress).
+ *		**BPF_FIB_LOOKUP_SKIP_NEIGH**
+ *			Skip the neighbour table lookup. *params*->dmac
+ *			and *params*->smac will not be set as output. A common
+ *			use case is to call **bpf_redirect_neigh**\ () after
+ *			doing **bpf_fib_lookup**\ ().
  *
  *		*ctx* is either **struct xdp_md** for XDP programs or
  *		**struct sk_buff** tc cls_act programs.
@@ -6040,6 +6045,7 @@ struct bpf_raw_tracepoint_args {
 enum {
 	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
+	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
 };
 
 enum {
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5392,12 +5392,8 @@ static const struct bpf_func_proto bpf_s
 #endif
 
 #if IS_ENABLED(CONFIG_INET) || IS_ENABLED(CONFIG_IPV6)
-static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params,
-				  const struct neighbour *neigh,
-				  const struct net_device *dev, u32 mtu)
+static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params, u32 mtu)
 {
-	memcpy(params->dmac, neigh->ha, ETH_ALEN);
-	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 	params->h_vlan_TCI = 0;
 	params->h_vlan_proto = 0;
 	if (mtu)
@@ -5508,21 +5504,29 @@ static int bpf_ipv4_fib_lookup(struct ne
 	if (likely(nhc->nhc_gw_family != AF_INET6)) {
 		if (nhc->nhc_gw_family)
 			params->ipv4_dst = nhc->nhc_gw.ipv4;
-
-		neigh = __ipv4_neigh_lookup_noref(dev,
-						 (__force u32)params->ipv4_dst);
 	} else {
 		struct in6_addr *dst = (struct in6_addr *)params->ipv6_dst;
 
 		params->family = AF_INET6;
 		*dst = nhc->nhc_gw.ipv6;
-		neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
 	}
 
+	if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
+		goto set_fwd_params;
+
+	if (likely(nhc->nhc_gw_family != AF_INET6))
+		neigh = __ipv4_neigh_lookup_noref(dev,
+						  (__force u32)params->ipv4_dst);
+	else
+		neigh = __ipv6_neigh_lookup_noref_stub(dev, params->ipv6_dst);
+
 	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
+	memcpy(params->dmac, neigh->ha, ETH_ALEN);
+	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 
-	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
+set_fwd_params:
+	return bpf_fib_set_fwd_params(params, mtu);
 }
 #endif
 
@@ -5630,24 +5634,33 @@ static int bpf_ipv6_fib_lookup(struct ne
 	params->rt_metric = res.f6i->fib6_metric;
 	params->ifindex = dev->ifindex;
 
+	if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
+		goto set_fwd_params;
+
 	/* xdp and cls_bpf programs are run in RCU-bh so rcu_read_lock_bh is
 	 * not needed here.
 	 */
 	neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
 	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
+	memcpy(params->dmac, neigh->ha, ETH_ALEN);
+	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 
-	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
+set_fwd_params:
+	return bpf_fib_set_fwd_params(params, mtu);
 }
 #endif
 
+#define BPF_FIB_LOOKUP_MASK (BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT | \
+			     BPF_FIB_LOOKUP_SKIP_NEIGH)
+
 BPF_CALL_4(bpf_xdp_fib_lookup, struct xdp_buff *, ctx,
 	   struct bpf_fib_lookup *, params, int, plen, u32, flags)
 {
 	if (plen < sizeof(*params))
 		return -EINVAL;
 
-	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
+	if (flags & ~BPF_FIB_LOOKUP_MASK)
 		return -EINVAL;
 
 	switch (params->family) {
@@ -5685,7 +5698,7 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk
 	if (plen < sizeof(*params))
 		return -EINVAL;
 
-	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
+	if (flags & ~BPF_FIB_LOOKUP_MASK)
 		return -EINVAL;
 
 	if (params->tot_len)
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3014,6 +3014,11 @@ union bpf_attr {
  *		**BPF_FIB_LOOKUP_OUTPUT**
  *			Perform lookup from an egress perspective (default is
  *			ingress).
+ *		**BPF_FIB_LOOKUP_SKIP_NEIGH**
+ *			Skip the neighbour table lookup. *params*->dmac
+ *			and *params*->smac will not be set as output. A common
+ *			use case is to call **bpf_redirect_neigh**\ () after
+ *			doing **bpf_fib_lookup**\ ().
  *
  *		*ctx* is either **struct xdp_md** for XDP programs or
  *		**struct sk_buff** tc cls_act programs.
@@ -6040,6 +6045,7 @@ struct bpf_raw_tracepoint_args {
 enum {
 	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
+	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
 };
 
 enum {


