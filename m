Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ED5280331;
	Fri,  7 Aug 2026 15:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116638; cv=none; b=G1RpMxwK2/9lRkUT14dOikIHiN05k/HzYDnX1AJImoUD+gH6K1I6UPBxIgTXmAadFikoZhBt9oCcvPWl7eVm0AqkA5umBhQucNl7ehKmR8eRbXSz+afI2k72btDIc8PaQzTGtfMRm865QH9sqA3epxQgu6zsqhfMxdNHK194Hio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116638; c=relaxed/simple;
	bh=X1ybEMxy1W7xlyBQqJrCyUXbhzIBrEPw7YOJXqhQrxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eAMr8Y0K+BKIzUXpkUXkY0K7sSGvIBgoU+JA7oI74HfE0Os2yaR47dj/iNmUPU/fNPXaR1bqPw8hwZLMz8hXz0S7DmcQDoNkNq6FNTCzyCYR9OVicW1N6P7TdMU57cYUxJ9txFq0cy+HD5Y1R0g4PUUBal84vpU8MMoPfNJWi7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlQyS3IC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlQyS3IC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2321F000E9;
	Fri,  7 Aug 2026 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116637;
	bh=7Okx5YAAr6jeXzSKelQnsLpWjSBWVvm2z/UO9NI/Ois=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlQyS3ICkw4ujYhWnKZY/q8ESrqNdCF2cEC65IJ+/+OJ0wafbv6ORf28+heG6h5Tr
	 OWG1iOBeJGCj2rHe/IbsgDzJIYgeqqQ02ExwtagQn1r8kc0b80vV3d6aTM8zRurYi+
	 IQWHUoAwe0e7UicYXcKM22MZUe2hNLzku2CAPuN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 038/438] selftests: netfilter: nft_flowtable.sh: fix offload counter verification for tunnel tests
Date: Fri,  7 Aug 2026 16:33:54 +0200
Message-ID: <20260807143428.817069897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 1d6123f87eebb5148844cd43045c6e598799720b ]

The IPIP and IP6IP6 tunnel tests call check_counters() to verify
flowtable offloading occurred, but the flow-add rule only matches
meta oif "veth1". When traffic is routed through a tunnel device,
oif is the tunnel interface (tun0, tun6, etc.), not veth1, so
the flow-add rule never fires, no flowtable entry is created,
and counters stay at zero — producing a silent false pass.
Fix by adding tunnel-specific flow-add rules for each tunnel
interface. These match TCP dport 12345 traffic before the bare
accept rule, set ct mark, add the flow to the flowtable, and
increment routed_orig. The existing routed_repl rule on veth0
already handles the reply direction since decapsulated reply
packets exit through the physical interface.
Also add check_counters() for the IP6IP6 non-VLAN and
IP6IP6-over-VLAN tests which previously used a bare PASS message.

Fixes: fe8313316eaf ("selftests: netfilter: nft_flowtable.sh: Add IPIP flowtable selftest")
Fixes: 5e5180352193 ("selftests: netfilter: nft_flowtable.sh: Add IP6IP6 flowtable selftest")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/netfilter/nft_flowtable.sh       | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 08ad07500e8a7..d9a21ca8ed2cb 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -617,7 +617,11 @@ ip -6 -net "$nsr2" route add default via fee1:3::1
 ip -net "$ns2" route add default via 10.0.2.1
 ip -6 -net "$ns2" route add default via dead:2::1
 
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif tun0 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0 accept'
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif tun6 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun6 accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward \
 	'meta oif "veth0" tcp sport 12345 ct mark set 1 flow add @f1 counter name routed_repl accept'
@@ -629,7 +633,7 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel"; then
 fi
 
 if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
-	echo "PASS: flow offload for ns1/ns2 IP6IP6 tunnel"
+	check_counters "flow offload for ns1/ns2 IP6IP6 tunnel"
 else
 	echo "FAIL: flow offload for ns1/ns2 with IP6IP6 tunnel" 1>&2
 	ip netns exec "$nsr1" nft list ruleset
@@ -642,6 +646,8 @@ ip -net "$nsr1" link set veth1.10 up
 ip -net "$nsr1" addr add 192.168.20.1/24 dev veth1.10
 ip -net "$nsr1" addr add fee1:4::1/64 dev veth1.10 nodad
 ip netns exec "$nsr1" sysctl net.ipv4.conf.veth1/10.forwarding=1 > /dev/null
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif veth1.10 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif veth1.10 accept'
 
 ip -net "$nsr1" link add name tun0.10 type ipip local 192.168.20.1 remote 192.168.20.2
@@ -649,6 +655,8 @@ ip -net "$nsr1" link set tun0.10 up
 ip -net "$nsr1" addr add 192.168.200.1/24 dev tun0.10
 ip -net "$nsr1" route change default via 192.168.200.2
 ip netns exec "$nsr1" sysctl net.ipv4.conf.tun0/10.forwarding=1 > /dev/null
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif tun0.10 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0.10 accept'
 
 ip -net "$nsr1" link add name tun6.10 type ip6tnl local fee1:4::1 remote fee1:4::2 encaplimit none
@@ -656,6 +664,8 @@ ip -net "$nsr1" link set tun6.10 up
 ip -net "$nsr1" addr add fee1:5::1/64 dev tun6.10 nodad
 ip -6 -net "$nsr1" route delete default
 ip -6 -net "$nsr1" route add default via fee1:5::2
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif tun6.10 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun6.10 accept'
 
 ip -net "$nsr2" link add link veth0 name veth0.10 type vlan id 10
@@ -683,7 +693,7 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel over vlan"; then
 fi
 
 if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
-	echo "PASS: flow offload for ns1/ns2 IP6IP6 tunnel over vlan"
+	check_counters "flow offload for ns1/ns2 IP6IP6 tunnel over vlan"
 else
 	echo "FAIL: flow offload for ns1/ns2 with IP6IP6 tunnel over vlan" 1>&2
 	ip netns exec "$nsr1" nft list ruleset
-- 
2.53.0



