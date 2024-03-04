Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE1C1C6AB;
	Mon,  4 Mar 2024 21:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589143; cv=none; b=SwW9J3CEdrDDWd5p3x5GftPdnbduZpgk2vBF7SogpEsR/bpTprx3bHvkXjTZU41CHkhYTymwbKEB1eXj9ZmkMPuOMuUKDeisPs1rCy9sCd28lh3qcqzFUPi7Y/NGLhxKWLFc0vWyZKjz90ufZSXojiIXKccMaU350S49l3k6FZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589143; c=relaxed/simple;
	bh=OZF6LD3usQ2OKU2ho360fAoTgOoR+vT1JDSHRg1jsF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOtWApGfbmHt+WkV7NSzC5yXyrsxm0m8C/AdAM6K6WLnlI4e/twudJ9HXMCmT44ms+561KV46AnsmJ7GIb7CJbHDyqKAACoxRc7nI6f9WepuR+YWazQ86Q7Ap7aPyA+2/2iINmwptpvt/CtVKCTlbu4hY8Xjstry9ob1RcjZ8lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkuApbcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkuApbcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E05EC433C7;
	Mon,  4 Mar 2024 21:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589142;
	bh=OZF6LD3usQ2OKU2ho360fAoTgOoR+vT1JDSHRg1jsF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkuApbcUxWZP/zLhyf3bvTR+wOTd9LvYlTDW62bIYqVyikfdiHo3mLG62zjFLzpKc
	 rQlQQQLIlMy7ctNJkCElD+6ceeLbSCOBVXBakZtbdquL/o17XqeZ5njByvemT18V6R
	 Q7ebR+f+cfmZbCCoXEKu+rrHmW9jyJsj0msakAlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis DeLosSantos <louis.delos.devel@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.1 212/215] bpf: Add table ID to bpf_fib_lookup BPF helper
Date: Mon,  4 Mar 2024 21:24:35 +0000
Message-ID: <20240304211603.711180329@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis DeLosSantos <louis.delos.devel@gmail.com>

commit 8ad77e72caae22a1ddcfd0c03f2884929e93b7a4 upstream.

Add ability to specify routing table ID to the `bpf_fib_lookup` BPF
helper.

A new field `tbid` is added to `struct bpf_fib_lookup` used as
parameters to the `bpf_fib_lookup` BPF helper.

When the helper is called with the `BPF_FIB_LOOKUP_DIRECT` and
`BPF_FIB_LOOKUP_TBID` flags the `tbid` field in `struct bpf_fib_lookup`
will be used as the table ID for the fib lookup.

If the `tbid` does not exist the fib lookup will fail with
`BPF_FIB_LKUP_RET_NOT_FWDED`.

The `tbid` field becomes a union over the vlan related output fields
in `struct bpf_fib_lookup` and will be zeroed immediately after usage.

This functionality is useful in containerized environments.

For instance, if a CNI wants to dictate the next-hop for traffic leaving
a container it can create a container-specific routing table and perform
a fib lookup against this table in a "host-net-namespace-side" TC program.

This functionality also allows `ip rule` like functionality at the TC
layer, allowing an eBPF program to pick a routing table based on some
aspect of the sk_buff.

As a concrete use case, this feature will be used in Cilium's SRv6 L3VPN
datapath.

When egress traffic leaves a Pod an eBPF program attached by Cilium will
determine which VRF the egress traffic should target, and then perform a
FIB lookup in a specific table representing this VRF's FIB.

Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230505-bpf-add-tbid-fib-lookup-v2-1-0a31c22c748c@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/bpf.h       |   21 ++++++++++++++++++---
 net/core/filter.c              |   14 +++++++++++++-
 tools/include/uapi/linux/bpf.h |   21 ++++++++++++++++++---
 3 files changed, 49 insertions(+), 7 deletions(-)

--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3109,6 +3109,10 @@ union bpf_attr {
  *		**BPF_FIB_LOOKUP_DIRECT**
  *			Do a direct table lookup vs full lookup using FIB
  *			rules.
+ *		**BPF_FIB_LOOKUP_TBID**
+ *			Used with BPF_FIB_LOOKUP_DIRECT.
+ *			Use the routing table ID present in *params*->tbid
+ *			for the fib lookup.
  *		**BPF_FIB_LOOKUP_OUTPUT**
  *			Perform lookup from an egress perspective (default is
  *			ingress).
@@ -6687,6 +6691,7 @@ enum {
 	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
 	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
+	BPF_FIB_LOOKUP_TBID    = (1U << 3),
 };
 
 enum {
@@ -6747,9 +6752,19 @@ struct bpf_fib_lookup {
 		__u32		ipv6_dst[4];  /* in6_addr; network order */
 	};
 
-	/* output */
-	__be16	h_vlan_proto;
-	__be16	h_vlan_TCI;
+	union {
+		struct {
+			/* output */
+			__be16	h_vlan_proto;
+			__be16	h_vlan_TCI;
+		};
+		/* input: when accompanied with the
+		 * 'BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_TBID` flags, a
+		 * specific routing table to use for the fib lookup.
+		 */
+		__u32	tbid;
+	};
+
 	__u8	smac[6];     /* ETH_ALEN */
 	__u8	dmac[6];     /* ETH_ALEN */
 };
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5752,6 +5752,12 @@ static int bpf_ipv4_fib_lookup(struct ne
 		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
 		struct fib_table *tb;
 
+		if (flags & BPF_FIB_LOOKUP_TBID) {
+			tbid = params->tbid;
+			/* zero out for vlan output */
+			params->tbid = 0;
+		}
+
 		tb = fib_get_table(net, tbid);
 		if (unlikely(!tb))
 			return BPF_FIB_LKUP_RET_NOT_FWDED;
@@ -5885,6 +5891,12 @@ static int bpf_ipv6_fib_lookup(struct ne
 		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
 		struct fib6_table *tb;
 
+		if (flags & BPF_FIB_LOOKUP_TBID) {
+			tbid = params->tbid;
+			/* zero out for vlan output */
+			params->tbid = 0;
+		}
+
 		tb = ipv6_stub->fib6_get_table(net, tbid);
 		if (unlikely(!tb))
 			return BPF_FIB_LKUP_RET_NOT_FWDED;
@@ -5957,7 +5969,7 @@ set_fwd_params:
 #endif
 
 #define BPF_FIB_LOOKUP_MASK (BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT | \
-			     BPF_FIB_LOOKUP_SKIP_NEIGH)
+			     BPF_FIB_LOOKUP_SKIP_NEIGH | BPF_FIB_LOOKUP_TBID)
 
 BPF_CALL_4(bpf_xdp_fib_lookup, struct xdp_buff *, ctx,
 	   struct bpf_fib_lookup *, params, int, plen, u32, flags)
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3109,6 +3109,10 @@ union bpf_attr {
  *		**BPF_FIB_LOOKUP_DIRECT**
  *			Do a direct table lookup vs full lookup using FIB
  *			rules.
+ *		**BPF_FIB_LOOKUP_TBID**
+ *			Used with BPF_FIB_LOOKUP_DIRECT.
+ *			Use the routing table ID present in *params*->tbid
+ *			for the fib lookup.
  *		**BPF_FIB_LOOKUP_OUTPUT**
  *			Perform lookup from an egress perspective (default is
  *			ingress).
@@ -6687,6 +6691,7 @@ enum {
 	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
 	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
+	BPF_FIB_LOOKUP_TBID    = (1U << 3),
 };
 
 enum {
@@ -6747,9 +6752,19 @@ struct bpf_fib_lookup {
 		__u32		ipv6_dst[4];  /* in6_addr; network order */
 	};
 
-	/* output */
-	__be16	h_vlan_proto;
-	__be16	h_vlan_TCI;
+	union {
+		struct {
+			/* output */
+			__be16	h_vlan_proto;
+			__be16	h_vlan_TCI;
+		};
+		/* input: when accompanied with the
+		 * 'BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_TBID` flags, a
+		 * specific routing table to use for the fib lookup.
+		 */
+		__u32	tbid;
+	};
+
 	__u8	smac[6];     /* ETH_ALEN */
 	__u8	dmac[6];     /* ETH_ALEN */
 };


