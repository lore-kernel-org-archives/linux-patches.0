Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B341151CED;
	Tue, 20 Feb 2024 21:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463396; cv=none; b=fmyDYiCtur1TxKzxK0JCQEd9q24RmXglz9Ce7RNYKroDaRATElUoI0t0+NKnxL+F5wW5RnShwC1sLsSIAoaBw6nUYoBg1U5F6Lvmul4R27ynvzXPOtMe2v61H4e813GxqHJRvLAaF4jeBtTQX3edA3eon2qgrfZenDdQG11Fgbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463396; c=relaxed/simple;
	bh=O1udH8h27BedeQ8P2CVqEBGsb+hCVrrSMQJn8jtmmiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZS4yGyDwxzdFVArLeRK/aiKtp3fzkU+jNki6GXy9StZRaNN3H9Jl6+Ge3AGdntr4Umb3btcyo+OZc61dZ8BfxCRWJpecnnWtIDUR0eTKb8tiuZXVDdnAxpNtzRt+zABAx58ZeAh7uIyXCodQkfafasW+uymqueHyPaTLSBiPF9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZkpiir9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZkpiir9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A537C433F1;
	Tue, 20 Feb 2024 21:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463395;
	bh=O1udH8h27BedeQ8P2CVqEBGsb+hCVrrSMQJn8jtmmiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZkpiir9Jbjx2nKAgFUwTt1MJXNdSRA1gwTVot2osv1Tyc0FqZxCLfOd59wgNdLAf
	 o7nlP6C/JB4uNoexQ0EYBg1p/tlz9q5Yos7dABeEuXxRmmf3xQciCOOobBdEpJnUFB
	 4/w2vPjokjhUlYXG/oKrXEss1wQsU4MvGEeEmXUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/331] selftests: net: Fix bridge backup port test flakiness
Date: Tue, 20 Feb 2024 21:52:27 +0100
Message-ID: <20240220205638.568521586@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 38ee0cb2a2e2ade077442085638eb181b0562971 ]

The test toggles the carrier of a bridge port in order to test the
bridge backup port feature.

Due to the linkwatch delayed work the carrier change is not always
reflected fast enough to the bridge driver and packets are not forwarded
as the test expects, resulting in failures [1].

Fix by busy waiting on the bridge port state until it changes to the
desired state following the carrier change.

[1]
 # Backup port
 # -----------
 [...]
 # TEST: swp1 carrier off                                              [ OK ]
 # TEST: No forwarding out of swp1                                     [FAIL]
 [  641.995910] br0: port 1(swp1) entered disabled state
 # TEST: No forwarding out of vx0                                      [ OK ]

Fixes: b408453053fb ("selftests: net: Add bridge backup port and backup nexthop ID test")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20240208123110.1063930-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/test_bridge_backup_port.sh  | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/net/test_bridge_backup_port.sh b/tools/testing/selftests/net/test_bridge_backup_port.sh
index 70a7d87ba2d2..1b3f89e2b86e 100755
--- a/tools/testing/selftests/net/test_bridge_backup_port.sh
+++ b/tools/testing/selftests/net/test_bridge_backup_port.sh
@@ -124,6 +124,16 @@ tc_check_packets()
 	[[ $pkts == $count ]]
 }
 
+bridge_link_check()
+{
+	local ns=$1; shift
+	local dev=$1; shift
+	local state=$1; shift
+
+	bridge -n $ns -d -j link show dev $dev | \
+		jq -e ".[][\"state\"] == \"$state\"" &> /dev/null
+}
+
 ################################################################################
 # Setup
 
@@ -259,6 +269,7 @@ backup_port()
 	log_test $? 0 "No forwarding out of vx0"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier off"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 disabled
 	log_test $? 0 "swp1 carrier off"
 
 	run_cmd "ip netns exec $sw1 mausezahn br0.10 -a $smac -b $dmac -A 198.51.100.1 -B 198.51.100.2 -t ip -p 100 -q -c 1"
@@ -268,6 +279,7 @@ backup_port()
 	log_test $? 0 "No forwarding out of vx0"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier on"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 forwarding
 	log_test $? 0 "swp1 carrier on"
 
 	# Configure vx0 as the backup port of swp1 and check that packets are
@@ -284,6 +296,7 @@ backup_port()
 	log_test $? 0 "No forwarding out of vx0"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier off"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 disabled
 	log_test $? 0 "swp1 carrier off"
 
 	run_cmd "ip netns exec $sw1 mausezahn br0.10 -a $smac -b $dmac -A 198.51.100.1 -B 198.51.100.2 -t ip -p 100 -q -c 1"
@@ -293,6 +306,7 @@ backup_port()
 	log_test $? 0 "Forwarding out of vx0"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier on"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 forwarding
 	log_test $? 0 "swp1 carrier on"
 
 	run_cmd "ip netns exec $sw1 mausezahn br0.10 -a $smac -b $dmac -A 198.51.100.1 -B 198.51.100.2 -t ip -p 100 -q -c 1"
@@ -314,6 +328,7 @@ backup_port()
 	log_test $? 0 "No forwarding out of vx0"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier off"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 disabled
 	log_test $? 0 "swp1 carrier off"
 
 	run_cmd "ip netns exec $sw1 mausezahn br0.10 -a $smac -b $dmac -A 198.51.100.1 -B 198.51.100.2 -t ip -p 100 -q -c 1"
@@ -369,6 +384,7 @@ backup_nhid()
 	log_test $? 0 "No forwarding out of vx0"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier off"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 disabled
 	log_test $? 0 "swp1 carrier off"
 
 	run_cmd "ip netns exec $sw1 mausezahn br0.10 -a $smac -b $dmac -A 198.51.100.1 -B 198.51.100.2 -t ip -p 100 -q -c 1"
@@ -382,6 +398,7 @@ backup_nhid()
 	log_test $? 0 "Forwarding using VXLAN FDB entry"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier on"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 forwarding
 	log_test $? 0 "swp1 carrier on"
 
 	# Configure nexthop ID 10 as the backup nexthop ID of swp1 and check
@@ -398,6 +415,7 @@ backup_nhid()
 	log_test $? 0 "No forwarding out of vx0"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier off"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 disabled
 	log_test $? 0 "swp1 carrier off"
 
 	run_cmd "ip netns exec $sw1 mausezahn br0.10 -a $smac -b $dmac -A 198.51.100.1 -B 198.51.100.2 -t ip -p 100 -q -c 1"
@@ -411,6 +429,7 @@ backup_nhid()
 	log_test $? 0 "No forwarding using VXLAN FDB entry"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier on"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 forwarding
 	log_test $? 0 "swp1 carrier on"
 
 	run_cmd "ip netns exec $sw1 mausezahn br0.10 -a $smac -b $dmac -A 198.51.100.1 -B 198.51.100.2 -t ip -p 100 -q -c 1"
@@ -441,6 +460,7 @@ backup_nhid()
 	log_test $? 0 "No forwarding using VXLAN FDB entry"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier off"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 disabled
 	log_test $? 0 "swp1 carrier off"
 
 	run_cmd "ip netns exec $sw1 mausezahn br0.10 -a $smac -b $dmac -A 198.51.100.1 -B 198.51.100.2 -t ip -p 100 -q -c 1"
@@ -497,6 +517,7 @@ backup_nhid_invalid()
 	log_test $? 0 "Valid nexthop as backup nexthop"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier off"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 disabled
 	log_test $? 0 "swp1 carrier off"
 
 	run_cmd "ip netns exec $sw1 mausezahn br0.10 -a $smac -b $dmac -A 198.51.100.1 -B 198.51.100.2 -t ip -p 100 -q -c 1"
@@ -604,7 +625,9 @@ backup_nhid_ping()
 	run_cmd "bridge -n $sw2 link set dev swp1 backup_nhid 10"
 
 	run_cmd "ip -n $sw1 link set dev swp1 carrier off"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw1 swp1 disabled
 	run_cmd "ip -n $sw2 link set dev swp1 carrier off"
+	busywait $BUSYWAIT_TIMEOUT bridge_link_check $sw2 swp1 disabled
 
 	run_cmd "ip netns exec $sw1 ping -i 0.1 -c 10 -w $PING_TIMEOUT 192.0.2.66"
 	log_test $? 0 "Ping with backup nexthop ID"
-- 
2.43.0



