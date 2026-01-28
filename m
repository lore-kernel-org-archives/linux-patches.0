Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474151E9B1A;
	Wed, 28 Jan 2026 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614387; cv=none; b=Tc1lSeGRkjHLdkDYp1SUCSNZLWkH3IXsu6akM4gYXbIIcndFqRc7aT1kRlehEB18lphN4YWHx679eclJgXrzE1KJv7/Vos+VaB7UhRSYuKrvGu0XpH7aR1HdaaFcYfqViuog6cQKjbcR4byvS19Bqej/Kbflk2aYpW3HkvtvT5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614387; c=relaxed/simple;
	bh=NdOXqBlxlyBbgYCnzwizihka61PnV6PRKNobQDA3cyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jfzjni3QBcWzSH4cqC0AYITQEMFSvtrGQWjXSnzonSxN/20g+aK7cxAG4xF1SzKAj83k1J04T2tfcLtdbe2m1H3jdslRLiCUQY1kYsBlkC/pQR/9m4utR0IdHgYNF1q7yu+gvbvga4qF4dHK95sMGmaUK49m6acefLZtpQkQsek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMkQ/3Lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMkQ/3Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA071C4CEF7;
	Wed, 28 Jan 2026 15:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614387;
	bh=NdOXqBlxlyBbgYCnzwizihka61PnV6PRKNobQDA3cyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMkQ/3LcC1NfC9DEydB5/32CR1/U16Al4bfAdfo0M5m7Ryv4nalYShyOFxuuMGVbe
	 QqcDdru+ddJEd4CKBd3gxBpelZgbODcodaq4oUFTdm7MX32HJeS4q6+Znu2eS3+FYM
	 T7w67J6awWcRZRGE7LXxfoBNx2ZL4rt9FRN/CQig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/254] selftests: net: fib-onlink-tests: Convert to use namespaces by default
Date: Wed, 28 Jan 2026 16:21:37 +0100
Message-ID: <20260128145349.177602137@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 4f5f148dd7c0459229d2ab9a769b2e820f9ee6a2 ]

Currently, the test breaks if the SUT already has a default route
configured for IPv6. Fix by avoiding the use of the default namespace.

Fixes: 4ed591c8ab44 ("net/ipv6: Allow onlink routes to have a device mismatch if it is the default route")
Suggested-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260113-selftests-net-fib-onlink-v2-1-89de2b931389@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/fib-onlink-tests.sh | 71 ++++++++-----------
 1 file changed, 30 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/net/fib-onlink-tests.sh b/tools/testing/selftests/net/fib-onlink-tests.sh
index ec2d6ceb1f08d..c01be076b210d 100755
--- a/tools/testing/selftests/net/fib-onlink-tests.sh
+++ b/tools/testing/selftests/net/fib-onlink-tests.sh
@@ -120,7 +120,7 @@ log_subsection()
 
 run_cmd()
 {
-	local cmd="$*"
+	local cmd="$1"
 	local out
 	local rc
 
@@ -145,7 +145,7 @@ get_linklocal()
 	local pfx
 	local addr
 
-	addr=$(${pfx} ip -6 -br addr show dev ${dev} | \
+	addr=$(${pfx} ${IP} -6 -br addr show dev ${dev} | \
 	awk '{
 		for (i = 3; i <= NF; ++i) {
 			if ($i ~ /^fe80/)
@@ -173,58 +173,48 @@ setup()
 
 	set -e
 
-	# create namespace
-	setup_ns PEER_NS
+	# create namespaces
+	setup_ns ns1
+	IP="ip -netns $ns1"
+	setup_ns ns2
 
 	# add vrf table
-	ip li add ${VRF} type vrf table ${VRF_TABLE}
-	ip li set ${VRF} up
-	ip ro add table ${VRF_TABLE} unreachable default metric 8192
-	ip -6 ro add table ${VRF_TABLE} unreachable default metric 8192
+	${IP} li add ${VRF} type vrf table ${VRF_TABLE}
+	${IP} li set ${VRF} up
+	${IP} ro add table ${VRF_TABLE} unreachable default metric 8192
+	${IP} -6 ro add table ${VRF_TABLE} unreachable default metric 8192
 
 	# create test interfaces
-	ip li add ${NETIFS[p1]} type veth peer name ${NETIFS[p2]}
-	ip li add ${NETIFS[p3]} type veth peer name ${NETIFS[p4]}
-	ip li add ${NETIFS[p5]} type veth peer name ${NETIFS[p6]}
-	ip li add ${NETIFS[p7]} type veth peer name ${NETIFS[p8]}
+	${IP} li add ${NETIFS[p1]} type veth peer name ${NETIFS[p2]}
+	${IP} li add ${NETIFS[p3]} type veth peer name ${NETIFS[p4]}
+	${IP} li add ${NETIFS[p5]} type veth peer name ${NETIFS[p6]}
+	${IP} li add ${NETIFS[p7]} type veth peer name ${NETIFS[p8]}
 
 	# enslave vrf interfaces
 	for n in 5 7; do
-		ip li set ${NETIFS[p${n}]} vrf ${VRF}
+		${IP} li set ${NETIFS[p${n}]} vrf ${VRF}
 	done
 
 	# add addresses
 	for n in 1 3 5 7; do
-		ip li set ${NETIFS[p${n}]} up
-		ip addr add ${V4ADDRS[p${n}]}/24 dev ${NETIFS[p${n}]}
-		ip addr add ${V6ADDRS[p${n}]}/64 dev ${NETIFS[p${n}]} nodad
+		${IP} li set ${NETIFS[p${n}]} up
+		${IP} addr add ${V4ADDRS[p${n}]}/24 dev ${NETIFS[p${n}]}
+		${IP} addr add ${V6ADDRS[p${n}]}/64 dev ${NETIFS[p${n}]} nodad
 	done
 
 	# move peer interfaces to namespace and add addresses
 	for n in 2 4 6 8; do
-		ip li set ${NETIFS[p${n}]} netns ${PEER_NS} up
-		ip -netns ${PEER_NS} addr add ${V4ADDRS[p${n}]}/24 dev ${NETIFS[p${n}]}
-		ip -netns ${PEER_NS} addr add ${V6ADDRS[p${n}]}/64 dev ${NETIFS[p${n}]} nodad
+		${IP} li set ${NETIFS[p${n}]} netns ${ns2} up
+		ip -netns $ns2 addr add ${V4ADDRS[p${n}]}/24 dev ${NETIFS[p${n}]}
+		ip -netns $ns2 addr add ${V6ADDRS[p${n}]}/64 dev ${NETIFS[p${n}]} nodad
 	done
 
-	ip -6 ro add default via ${V6ADDRS[p3]/::[0-9]/::64}
-	ip -6 ro add table ${VRF_TABLE} default via ${V6ADDRS[p7]/::[0-9]/::64}
+	${IP} -6 ro add default via ${V6ADDRS[p3]/::[0-9]/::64}
+	${IP} -6 ro add table ${VRF_TABLE} default via ${V6ADDRS[p7]/::[0-9]/::64}
 
 	set +e
 }
 
-cleanup()
-{
-	# make sure we start from a clean slate
-	cleanup_ns ${PEER_NS} 2>/dev/null
-	for n in 1 3 5 7; do
-		ip link del ${NETIFS[p${n}]} 2>/dev/null
-	done
-	ip link del ${VRF} 2>/dev/null
-	ip ro flush table ${VRF_TABLE}
-	ip -6 ro flush table ${VRF_TABLE}
-}
-
 ################################################################################
 # IPv4 tests
 #
@@ -241,7 +231,7 @@ run_ip()
 	# dev arg may be empty
 	[ -n "${dev}" ] && dev="dev ${dev}"
 
-	run_cmd ip ro add table "${table}" "${prefix}"/32 via "${gw}" "${dev}" onlink
+	run_cmd "${IP} ro add table ${table} ${prefix}/32 via ${gw} ${dev} onlink"
 	log_test $? ${exp_rc} "${desc}"
 }
 
@@ -257,8 +247,8 @@ run_ip_mpath()
 	# dev arg may be empty
 	[ -n "${dev}" ] && dev="dev ${dev}"
 
-	run_cmd ip ro add table "${table}" "${prefix}"/32 \
-		nexthop via ${nh1} nexthop via ${nh2}
+	run_cmd "${IP} ro add table ${table} ${prefix}/32 \
+		nexthop via ${nh1} nexthop via ${nh2}"
 	log_test $? ${exp_rc} "${desc}"
 }
 
@@ -339,7 +329,7 @@ run_ip6()
 	# dev arg may be empty
 	[ -n "${dev}" ] && dev="dev ${dev}"
 
-	run_cmd ip -6 ro add table "${table}" "${prefix}"/128 via "${gw}" "${dev}" onlink
+	run_cmd "${IP} -6 ro add table ${table} ${prefix}/128 via ${gw} ${dev} onlink"
 	log_test $? ${exp_rc} "${desc}"
 }
 
@@ -353,8 +343,8 @@ run_ip6_mpath()
 	local exp_rc="$6"
 	local desc="$7"
 
-	run_cmd ip -6 ro add table "${table}" "${prefix}"/128 "${opts}" \
-		nexthop via ${nh1} nexthop via ${nh2}
+	run_cmd "${IP} -6 ro add table ${table} ${prefix}/128 ${opts} \
+		nexthop via ${nh1} nexthop via ${nh2}"
 	log_test $? ${exp_rc} "${desc}"
 }
 
@@ -491,10 +481,9 @@ do
 	esac
 done
 
-cleanup
 setup
 run_onlink_tests
-cleanup
+cleanup_ns ${ns1} ${ns2}
 
 if [ "$TESTS" != "none" ]; then
 	printf "\nTests passed: %3d\n" ${nsuccess}
-- 
2.51.0



