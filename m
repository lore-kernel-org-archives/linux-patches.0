Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1689B8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8CFC433AE;
	Fri, 10 Mar 2023 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457336;
	bh=72tda5Bq54i/bgcXazaNCif40nUS7+6vbhfS2PnsuSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yggj0QQuUkmBFaXPcAZuil6piZQt5IL0wQcupF4avdOFW73YYpsAFJmwbYdKf0OtG
	 /m0+gJI0NTNfaj3AoMs3kYJag/ZN1/gJDi2tYZJn48KOSTFkK1s6BAD13iW4mDY7Bp
	 6T99BxLTHksD/O1B8oh82cgNvl87L3gCCL0haIM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/200] netfilter: ip6t_rpfilter: Fix regression with VRF interfaces
Date: Fri, 10 Mar 2023 14:37:49 +0100
Message-Id: <20230310133719.031268160@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit efb056e5f1f0036179b2f92c1c15f5ea7a891d70 ]

When calling ip6_route_lookup() for the packet arriving on the VRF
interface, the result is always the real (slave) interface. Expect this
when validating the result.

Fixes: acc641ab95b66 ("netfilter: rpfilter/fib: Populate flowic_l3mdev field")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6t_rpfilter.c         |  4 ++-
 tools/testing/selftests/netfilter/rpath.sh | 32 ++++++++++++++++++----
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index a01d9b842bd07..67c87a88cde4f 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -72,7 +72,9 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev ||
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
+	    (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);
diff --git a/tools/testing/selftests/netfilter/rpath.sh b/tools/testing/selftests/netfilter/rpath.sh
index f7311e66d2193..5289c8447a419 100755
--- a/tools/testing/selftests/netfilter/rpath.sh
+++ b/tools/testing/selftests/netfilter/rpath.sh
@@ -62,10 +62,16 @@ ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
 ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 
 # firewall matches to test
-[ -n "$iptables" ] && ip netns exec "$ns2" \
-	"$iptables" -t raw -A PREROUTING -s 192.168.0.0/16 -m rpfilter
-[ -n "$ip6tables" ] && ip netns exec "$ns2" \
-	"$ip6tables" -t raw -A PREROUTING -s fec0::/16 -m rpfilter
+[ -n "$iptables" ] && {
+	common='-t raw -A PREROUTING -s 192.168.0.0/16'
+	ip netns exec "$ns2" "$iptables" $common -m rpfilter
+	ip netns exec "$ns2" "$iptables" $common -m rpfilter --invert
+}
+[ -n "$ip6tables" ] && {
+	common='-t raw -A PREROUTING -s fec0::/16'
+	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter
+	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter --invert
+}
 [ -n "$nft" ] && ip netns exec "$ns2" $nft -f - <<EOF
 table inet t {
 	chain c {
@@ -89,6 +95,11 @@ ipt_zero_rule() { # (command)
 	[ -n "$1" ] || return 0
 	ip netns exec "$ns2" "$1" -t raw -vS | grep -q -- "-m rpfilter -c 0 0"
 }
+ipt_zero_reverse_rule() { # (command)
+	[ -n "$1" ] || return 0
+	ip netns exec "$ns2" "$1" -t raw -vS | \
+		grep -q -- "-m rpfilter --invert -c 0 0"
+}
 nft_zero_rule() { # (family)
 	[ -n "$nft" ] || return 0
 	ip netns exec "$ns2" "$nft" list chain inet t c | \
@@ -101,8 +112,7 @@ netns_ping() { # (netns, args...)
 	ip netns exec "$netns" ping -q -c 1 -W 1 "$@" >/dev/null
 }
 
-testrun() {
-	# clear counters first
+clear_counters() {
 	[ -n "$iptables" ] && ip netns exec "$ns2" "$iptables" -t raw -Z
 	[ -n "$ip6tables" ] && ip netns exec "$ns2" "$ip6tables" -t raw -Z
 	if [ -n "$nft" ]; then
@@ -111,6 +121,10 @@ testrun() {
 			ip netns exec "$ns2" $nft -s list table inet t;
 		) | ip netns exec "$ns2" $nft -f -
 	fi
+}
+
+testrun() {
+	clear_counters
 
 	# test 1: martian traffic should fail rpfilter matches
 	netns_ping "$ns1" -I v0 192.168.42.1 && \
@@ -120,9 +134,13 @@ testrun() {
 
 	ipt_zero_rule "$iptables" || die "iptables matched martian"
 	ipt_zero_rule "$ip6tables" || die "ip6tables matched martian"
+	ipt_zero_reverse_rule "$iptables" && die "iptables not matched martian"
+	ipt_zero_reverse_rule "$ip6tables" && die "ip6tables not matched martian"
 	nft_zero_rule ip || die "nft IPv4 matched martian"
 	nft_zero_rule ip6 || die "nft IPv6 matched martian"
 
+	clear_counters
+
 	# test 2: rpfilter match should pass for regular traffic
 	netns_ping "$ns1" 192.168.23.1 || \
 		die "regular ping 192.168.23.1 failed"
@@ -131,6 +149,8 @@ testrun() {
 
 	ipt_zero_rule "$iptables" && die "iptables match not effective"
 	ipt_zero_rule "$ip6tables" && die "ip6tables match not effective"
+	ipt_zero_reverse_rule "$iptables" || die "iptables match over-effective"
+	ipt_zero_reverse_rule "$ip6tables" || die "ip6tables match over-effective"
 	nft_zero_rule ip && die "nft IPv4 match not effective"
 	nft_zero_rule ip6 && die "nft IPv6 match not effective"
 
-- 
2.39.2



