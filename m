Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0393E9580;
	Mon, 17 Aug 2026 14:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977720; cv=none; b=iKsGdm69gHxyyA+Yfy53aNxmc+bndUpRtq7z+68Y3FeceHQycCaQBvZzOtjiqHggWYbgoO4+jq4+cMfdqdEMeEfZeLsIP6CoKC746E/c2WCBgJd7+il5z9FOsuRPCd8TUs0NzyDxvE6HaDUkWfbPiSQrVO1QxAjZJTtNJ0unl7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977720; c=relaxed/simple;
	bh=cHIKd3rCSR6zgOzlp+l+fPFrA8jdhFWCYzoHrYSWGjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLQHtolOsJVB5uyVty0vp1yT+HMYs9koRhG3nTGyPVO5Go++lvLCtRIwzF8FLtj0gF1LN/+Qj8Q2FOTRvb23zwPQSWYXEzDxPbYMbD49fep+Y1rTYV4SEMAfNPbIP/N1QKjsc1nJNUUsAmArxS0bLjjCLeWCseUoEFhWVuKTulo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djWEjH8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djWEjH8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849371F000E9;
	Mon, 17 Aug 2026 14:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977719;
	bh=jewkzkLBT1ST7lCXTWcVtGRa2P8MwtcJv4C1qKIJrkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djWEjH8uapRNygm/Lvtuo/r1bUXk7UfTRixctubQ9Dn8aw+toB5+WzwAHyhp+Ifvv
	 G4uY9V7LgqTzSXDhNRfl8ddB2CaNBafJPesZcS5/c5wYzu/2nLBlTForUQK+lOdDRO
	 Aypc2Rw8djJQwp58HPSj1oqS9YzDWS04iV7OzNEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 425/456] ipv4: Fix fib_nlmsg_size() for RTA_VIA nexthops
Date: Mon, 17 Aug 2026 15:33:35 +0200
Message-ID: <20260817132555.801777220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

commit 4ff9548d84945d2cbf9e4c207288063a200ea397 upstream.

fib_nlmsg_size() still estimates nexthop space as if every gateway is
encoded as an IPv4 RTA_GATEWAY attribute. IPv4 routes can also carry an
IPv6 gateway, which fib_nexthop_info() dumps as RTA_VIA.

As a result, route notifications can allocate an skb that is too small.
fib_dump_info() then fails with -EMSGSIZE and rtmsg_fib() hits the
WARN_ON() that marks such failures as a fib_nlmsg_size() bug. With
panic_on_warn set, this becomes a kernel panic.

Mirror the actual nexthop dump layout in fib_nlmsg_size(): account for
IPv6 nexthop gateways dumped as RTA_VIA, for the no-header rtnexthop
layout used inside RTA_MULTIPATH, and for RTA_FLOW only when it is
actually present.

Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/6f53fa797fcaeb26966432ed7ae9bb87c4961f37.1785411220.git.zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |   67 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 18 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -460,6 +460,34 @@ int ip_fib_check_default(__be32 gw, stru
 	return -1;
 }
 
+static size_t fib_nexthop_nlmsg_size(const struct fib_nh_common *nhc,
+				     bool skip_oif)
+{
+	size_t nhsize = 0;
+
+	switch (nhc->nhc_gw_family) {
+	case AF_INET:
+		nhsize += nla_total_size(4); /* RTA_GATEWAY */
+		break;
+	case AF_INET6:
+		nhsize += nla_total_size(sizeof(struct rtvia) +
+					 sizeof(struct in6_addr));
+		break;
+	}
+
+	if (!skip_oif && nhc->nhc_dev)
+		nhsize += nla_total_size(4); /* RTA_OIF */
+
+	if (nhc->nhc_lwtstate) {
+		/* RTA_ENCAP */
+		nhsize += lwtunnel_get_encap_size(nhc->nhc_lwtstate);
+		/* RTA_ENCAP_TYPE */
+		nhsize += nla_total_size(2);
+	}
+
+	return nhsize;
+}
+
 size_t fib_nlmsg_size(struct fib_info *fi)
 {
 	size_t payload = NLMSG_ALIGN(sizeof(struct rtmsg))
@@ -477,32 +505,35 @@ size_t fib_nlmsg_size(struct fib_info *f
 		payload += nla_total_size(4); /* RTA_NH_ID */
 
 	if (nhs) {
-		size_t nh_encapsize = 0;
-		/* Also handles the special case nhs == 1 */
-
-		/* each nexthop is packed in an attribute */
-		size_t nhsize = nla_total_size(sizeof(struct rtnexthop));
+		size_t mpsize = 0;
 		unsigned int i;
 
-		/* may contain flow and gateway attribute */
-		nhsize += 2 * nla_total_size(4);
-
-		/* grab encap info */
 		for (i = 0; i < fib_info_num_path(fi); i++) {
 			struct fib_nh_common *nhc = fib_info_nhc(fi, i);
+			size_t nhsize;
+
+			nhsize = fib_nexthop_nlmsg_size(nhc, nhs != 1);
 
-			if (nhc->nhc_lwtstate) {
-				/* RTA_ENCAP_TYPE */
-				nh_encapsize += lwtunnel_get_encap_size(
-						nhc->nhc_lwtstate);
-				/* RTA_ENCAP */
-				nh_encapsize +=  nla_total_size(2);
+			if (nhs != 1)
+				nhsize += NLA_ALIGN(sizeof(struct rtnexthop));
+
+#ifdef CONFIG_IP_ROUTE_CLASSID
+			if (nhc->nhc_family == AF_INET) {
+				struct fib_nh *nh;
+
+				nh = container_of(nhc, struct fib_nh, nh_common);
+				if (nh->nh_tclassid)
+					nhsize += nla_total_size(4);
 			}
+#endif
+			if (nhs == 1)
+				payload += nhsize;
+			else
+				mpsize += nhsize;
 		}
 
-		/* all nexthops are packed in a nested attribute */
-		payload += nla_total_size((nhs * nhsize) + nh_encapsize);
-
+		if (nhs != 1)
+			payload += nla_total_size(mpsize);
 	}
 
 	return payload;


