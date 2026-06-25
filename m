Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E12D18FDBE;
	Thu, 25 Jun 2026 13:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392953; cv=none; b=k2HpcGGrQksj3+l7dnHxWTErcM3ypGbruY+JGCSBIRsWBuFNu7gmvSCckkFv5tzlcsXO9Y3gDINQ1WUgbWZVFTJg0Znr5TmunLpRHHT82ATPnFXHoU0ZG4qXSSr+CYOMQ/jLzoWMrHjModU/2SHsGz1yBaO+GFb3BWvUJL9jIkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392953; c=relaxed/simple;
	bh=D3G2oVUvfSiFxx40HPK8giim99TcGOfFJAT37yK7Pe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWu3vcvKGG7BzEf8XmJT7C74kiblAIvho4FYpcYCsz+TSlaaKdvLbhs5zKy8yKfCV3xHXgmL3f++XRGR3im3I5QodoLPHL/o7Y4v/h8akrRFxViGs8jBQhKo+FzyL46CGi1TEUuCJsFKHaSbjf+mippkWG9oRTaWnPJXwrE9Wt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsvVm3/r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsvVm3/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735421F000E9;
	Thu, 25 Jun 2026 13:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392952;
	bh=PVTGx0iK+gvXD3TEeGdCko/1HZM54XG4T0vdC04D+yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsvVm3/rubtm5hY9bzKeBkeDfudllGJgCww6W4yHtSTO9AHPkEmiAB5wcXMG/lKP1
	 XLvYQTvtvdYEL2eRtFFtQa6hoAz+SySNrQA+ki4xQuYaduvCVbjeISMzEWyzxwT/6U
	 KDjxB0fOHHP+ZPIlTDaBGuDBh8DUqd84Kxi5zz6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Amery Hung <ameryhung@gmail.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 7.0 12/49] bpf: Fix NULL pointer dereference in bpf_sk_storage_clone and diag paths
Date: Thu, 25 Jun 2026 14:03:24 +0100
Message-ID: <20260625125639.235482677@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 375e4e33c18dfa05c5dfd5f3dfffeb29343dd4c7 upstream.

bpf_selem_unlink_nofail() sets SDATA(selem)->smap to NULL before
removing the selem from the storage hlist. A concurrent RCU reader in
bpf_sk_storage_clone() can observe the selem still on the list with
smap already NULL, causing a NULL pointer dereference.

 general protection fault, probably for non-canonical address 0xdffffc000000000a:
 KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
 RIP: 0010:bpf_sk_storage_clone+0x1cd/0xaa0 net/core/bpf_sk_storage.c:174
 Call Trace:
  <IRQ>
  sk_clone+0xfed/0x1980 net/core/sock.c:2591
  inet_csk_clone_lock+0x30/0x760 net/ipv4/inet_connection_sock.c:1222
  tcp_create_openreq_child+0x35/0x2680 net/ipv4/tcp_minisocks.c:571
  tcp_v4_syn_recv_sock+0x123/0xf90 net/ipv4/tcp_ipv4.c:1729
  tcp_check_req+0x8e1/0x2580 include/net/tcp.h:855
  tcp_v4_rcv+0x1845/0x3b80 net/ipv4/tcp_ipv4.c:2347

Add a NULL check for smap in bpf_sk_storage_clone().

bpf_sk_storage_diag_put_all() has the same issue. Add a NULL check
and pass the validated smap directly to diag_get(), which is refactored
to take smap as a parameter instead of reading it internally.

bpf_sk_storage_diag_put() uses diag->maps[i] which is always valid
under its refcount, so diag->maps[i] is passed directly to diag_get().

Fixes: 5d800f87d0a5 ("bpf: Support lockless unlink when freeing map or local storage")
Reported-by: Xiang Mei <xmei5@asu.edu>
Acked-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20260422065411.1007737-2-bestswngs@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/bpf_sk_storage.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -172,7 +172,7 @@ int bpf_sk_storage_clone(const struct so
 		struct bpf_map *map;
 
 		smap = rcu_dereference(SDATA(selem)->smap);
-		if (!(smap->map.map_flags & BPF_F_CLONE))
+		if (!smap || !(smap->map.map_flags & BPF_F_CLONE))
 			continue;
 
 		/* Note that for lockless listeners adding new element
@@ -534,10 +534,10 @@ err_free:
 }
 EXPORT_SYMBOL_GPL(bpf_sk_storage_diag_alloc);
 
-static int diag_get(struct bpf_local_storage_data *sdata, struct sk_buff *skb)
+static int diag_get(struct bpf_local_storage_map *smap,
+		    struct bpf_local_storage_data *sdata, struct sk_buff *skb)
 {
 	struct nlattr *nla_stg, *nla_value;
-	struct bpf_local_storage_map *smap;
 
 	/* It cannot exceed max nlattr's payload */
 	BUILD_BUG_ON(U16_MAX - NLA_HDRLEN < BPF_LOCAL_STORAGE_MAX_VALUE_SIZE);
@@ -546,7 +546,6 @@ static int diag_get(struct bpf_local_sto
 	if (!nla_stg)
 		return -EMSGSIZE;
 
-	smap = rcu_dereference(sdata->smap);
 	if (nla_put_u32(skb, SK_DIAG_BPF_STORAGE_MAP_ID, smap->map.id))
 		goto errout;
 
@@ -599,9 +598,11 @@ static int bpf_sk_storage_diag_put_all(s
 	saved_len = skb->len;
 	hlist_for_each_entry_rcu(selem, &sk_storage->list, snode) {
 		smap = rcu_dereference(SDATA(selem)->smap);
+		if (!smap)
+			continue;
 		diag_size += nla_value_size(smap->map.value_size);
 
-		if (nla_stgs && diag_get(SDATA(selem), skb))
+		if (nla_stgs && diag_get(smap, SDATA(selem), skb))
 			/* Continue to learn diag_size */
 			err = -EMSGSIZE;
 	}
@@ -668,7 +669,7 @@ int bpf_sk_storage_diag_put(struct bpf_s
 
 		diag_size += nla_value_size(diag->maps[i]->value_size);
 
-		if (nla_stgs && diag_get(sdata, skb))
+		if (nla_stgs && diag_get((struct bpf_local_storage_map *)diag->maps[i], sdata, skb))
 			/* Continue to learn diag_size */
 			err = -EMSGSIZE;
 	}


