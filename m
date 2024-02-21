Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A7776C82;
	Wed, 21 Feb 2024 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523070; cv=none; b=Y2WCjK9JZa93Rht9cvsFEp6fvb/Xvth4s7aMpaG6wXmTNgNz6BcRLJOClzBjR4Q9SZ/n/L/91m8x6JFWIz1Jm+3rXoGyC2akq1zs4K3cyfSAmN7ttvEChBm5QXjffWZ+y6xkYcqBbPHig+RJHXgOkti7979txyiNhWtjaLZ3dO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523070; c=relaxed/simple;
	bh=VI0NGeM415lf/S5Gc+FhuDBxuZYBt9XNygm5FsN7YGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMgQFKY8/HWw6XVzvCs5h82teGYwOe8ARZVrHHKo5oZNwLcybKdLstx3/OYE3JqD++6VlHQPIIxPd7iWiN/ZcAzxsdjfhKHO7ie29Y9O9q++miqShpkJTruXOQEc/UOdxN9cezTyYB/Nn3I2eR9uZYJ028W6/ot9aocojQbMakE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtV94+df; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtV94+df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF65C43390;
	Wed, 21 Feb 2024 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523070;
	bh=VI0NGeM415lf/S5Gc+FhuDBxuZYBt9XNygm5FsN7YGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtV94+dfaL8nbqZ5n6rSLmbT7QkPDRCaKuRJmugKk1alKexC2rWbXeiT4P8BE+T05
	 VBF7OpuDtpjDX4E8LsYF5E4Hzbad5P0GhaKjwGMcaBhgBIrpD2PQU4Q2DVf2L4SDXN
	 ZTnZHEW1zUqd3ZSC0zMEFzAXP40mCd35IV3AZdCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/476] selftests: net: cut more slack for gro fwd tests.
Date: Wed, 21 Feb 2024 14:05:56 +0100
Message-ID: <20240221130019.277569510@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit cb9f4a30fb85e1f4f149ada595a67899adb3db19 ]

The udpgro_fwd.sh self-tests are somewhat unstable. There are
a few timing constraints the we struggle to meet on very slow
environments.

Instead of skipping the whole tests in such envs, increase the
test resilience WRT very slow hosts: increase the inter-packets
timeouts, avoid resetting the counters every second and finally
disable reduce the background traffic noise.

Tested with:

for I in $(seq 1 100); do
	./tools/testing/selftests/kselftest_install/run_kselftest.sh \
		-t net:udpgro_fwd.sh || exit -1
done

in a slow environment.

Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/f4b6b11064a0d39182a9ae6a853abae3e9b4426a.1706812005.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro_fwd.sh     | 14 ++++++++++++--
 tools/testing/selftests/net/udpgso_bench_rx.c |  2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 1bcd82e1f662..fa5aa588e53f 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -36,6 +36,10 @@ create_ns() {
 	for ns in $NS_SRC $NS_DST; do
 		ip netns add $ns
 		ip -n $ns link set dev lo up
+
+		# disable route solicitations to decrease 'noise' traffic
+		ip netns exec $ns sysctl -qw net.ipv6.conf.default.router_solicitations=0
+		ip netns exec $ns sysctl -qw net.ipv6.conf.all.router_solicitations=0
 	done
 
 	ip link add name veth$SRC type veth peer name veth$DST
@@ -77,6 +81,12 @@ create_vxlan_pair() {
 		create_vxlan_endpoint $BASE$ns veth$ns $BM_NET_V6$((3 - $ns)) vxlan6$ns 6
 		ip -n $BASE$ns addr add dev vxlan6$ns $OL_NET_V6$ns/24 nodad
 	done
+
+	# preload neighbur cache, do avoid some noisy traffic
+	local addr_dst=$(ip -j -n $BASE$DST link show dev vxlan6$DST  |jq -r '.[]["address"]')
+	local addr_src=$(ip -j -n $BASE$SRC link show dev vxlan6$SRC  |jq -r '.[]["address"]')
+	ip -n $BASE$DST neigh add dev vxlan6$DST lladdr $addr_src $OL_NET_V6$SRC
+	ip -n $BASE$SRC neigh add dev vxlan6$SRC lladdr $addr_dst $OL_NET_V6$DST
 }
 
 is_ipv6() {
@@ -116,7 +126,7 @@ run_test() {
 	# not enable GRO
 	ip netns exec $NS_DST $ipt -A INPUT -p udp --dport 4789
 	ip netns exec $NS_DST $ipt -A INPUT -p udp --dport 8000
-	ip netns exec $NS_DST ./udpgso_bench_rx -C 1000 -R 10 -n 10 -l 1300 $rx_args &
+	ip netns exec $NS_DST ./udpgso_bench_rx -C 2000 -R 100 -n 10 -l 1300 $rx_args &
 	local spid=$!
 	sleep 0.1
 	ip netns exec $NS_SRC ./udpgso_bench_tx $family -M 1 -s 13000 -S 1300 -D $dst
@@ -165,7 +175,7 @@ run_bench() {
 	# bind the sender and the receiver to different CPUs to try
 	# get reproducible results
 	ip netns exec $NS_DST bash -c "echo 2 > /sys/class/net/veth$DST/queues/rx-0/rps_cpus"
-	ip netns exec $NS_DST taskset 0x2 ./udpgso_bench_rx -C 1000 -R 10  &
+	ip netns exec $NS_DST taskset 0x2 ./udpgso_bench_rx -C 2000 -R 100  &
 	local spid=$!
 	sleep 0.1
 	ip netns exec $NS_SRC taskset 0x1 ./udpgso_bench_tx $family -l 3 -S 1300 -D $dst
diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index f35a924d4a30..1cbadd267c96 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -375,7 +375,7 @@ static void do_recv(void)
 			do_flush_udp(fd);
 
 		tnow = gettimeofday_ms();
-		if (tnow > treport) {
+		if (!cfg_expected_pkt_nr && tnow > treport) {
 			if (packets)
 				fprintf(stderr,
 					"%s rx: %6lu MB/s %8lu calls/s\n",
-- 
2.43.0



