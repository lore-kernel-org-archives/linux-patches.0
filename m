Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08721C6AB;
	Mon,  4 Mar 2024 21:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589361; cv=none; b=qhDajvgKDB7PCYHZ023DU7vtLUoTXr6qxLwLUYF/b88nqHY1sxLhjGxw2W6asbhv6BZ49wfJZkn1w2bXmN/8jQnHDUixa9w7P5SqJIiIOHgFupN30nFrInIDQIDtJUihnLFBnP6xDfBPni3bZJMVLYzlpBFg9OyNh8eoYU1gOBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589361; c=relaxed/simple;
	bh=xmaoWrVr3G16JyImicCqrIOCyema01a3Fo6ZVLqLoaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y90SG4ccktcWU3ckR8l4u+3ypUcYwqjnTc92Rxgp6Q6e+5tiRnIODTzX7x3o5PCLHYHCa5ZdoVgjj1uMAlT5JM4pBApisNPupviu5Xq7YjaDGrsQY1Rxwrt3H/W6HSjlcowj0AA4mQP/ZzWP0MWWdpA7OOYf7ye13qe36OPBICk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYhgJ8Hq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYhgJ8Hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71346C433C7;
	Mon,  4 Mar 2024 21:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589360;
	bh=xmaoWrVr3G16JyImicCqrIOCyema01a3Fo6ZVLqLoaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYhgJ8HqLv93n6pLJKcKBa/81cuqvcwptbL5cI8JGtAKq1sJm34t+TRpCC7/PMG7h
	 bmQZjIdQHAItZX86nMASQgVUrbagmj+cr0Fkni+YRJoMo5RcuxjC1ptTHN7KwxqtKM
	 sAwpqqf0a5+1q8N0TXRgL4h6b2brSvOIW9PEL6lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis DeLosSantos <louis.delos.devel@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 80/84] bpf: Add table ID to bpf_fib_lookup BPF helper
Date: Mon,  4 Mar 2024 21:24:53 +0000
Message-ID: <20240304211545.082544823@linuxfoundation.org>
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
@@ -3011,6 +3011,10 @@ union bpf_attr {
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
@@ -6046,6 +6050,7 @@ enum {
 	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
 	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
+	BPF_FIB_LOOKUP_TBID    = (1U << 3),
 };
 
 enum {
@@ -6106,9 +6111,19 @@ struct bpf_fib_lookup {
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
@@ -5447,6 +5447,12 @@ static int bpf_ipv4_fib_lookup(struct ne
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
@@ -5580,6 +5586,12 @@ static int bpf_ipv6_fib_lookup(struct ne
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
@@ -5652,7 +5664,7 @@ set_fwd_params:
 #endif
 
 #define BPF_FIB_LOOKUP_MASK (BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT | \
-			     BPF_FIB_LOOKUP_SKIP_NEIGH)
+			     BPF_FIB_LOOKUP_SKIP_NEIGH | BPF_FIB_LOOKUP_TBID)
 
 BPF_CALL_4(bpf_xdp_fib_lookup, struct xdp_buff *, ctx,
 	   struct bpf_fib_lookup *, params, int, plen, u32, flags)
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3011,6 +3011,10 @@ union bpf_attr {
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
@@ -6046,6 +6050,7 @@ enum {
 	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
 	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
 	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
+	BPF_FIB_LOOKUP_TBID    = (1U << 3),
 };
 
 enum {
@@ -6106,9 +6111,19 @@ struct bpf_fib_lookup {
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


