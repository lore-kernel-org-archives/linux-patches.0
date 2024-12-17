Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAA41F8927;
	Tue, 17 Dec 2024 17:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456681; cv=none; b=qJmgUSRVURyjqoRHbROiYQoxb3d9Msq0TO1qpDsLHMRBA+XPUU2fkkxsHec7zKPVledgNreY3VFsJcZpHRyTQ7vHiAkACil6VgXFHYPBxf8OTEHdRvrwI7SLssuEI/efFQFNd7uRnmrLTCHNuTp/uBeAzo5y7ibhvPng4BwEAsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456681; c=relaxed/simple;
	bh=66sTYsW7AL9o3YitKHafXmKX9trXH7QAR9BBx6W0E3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucYjUJFRbaJv9b5lmcpJzQy3QOQC0CHKL072FIBeEtPKzDY4hEYJlMOacxQi3w5COgCVD07cv6rSkzYuI63JmKafiwDMzGLDeuEV7Bo2uA4aJlN66cGr0Gvrph6HdfI3pF4VtsiqJwTxlYgGkpnL0zqzYhO4O5IHL+YCqcsXuOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp2EC+BG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp2EC+BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B20CC4CED3;
	Tue, 17 Dec 2024 17:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456681;
	bh=66sTYsW7AL9o3YitKHafXmKX9trXH7QAR9BBx6W0E3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp2EC+BGfuxt8R3ebJPRAgDGrVoNfAVp6TnWJlmX5v+MU5p4xlDEohkodg2GV/47u
	 41MmQT3cgz1u0CS55GwDPVe3MgMj1p1cIhmxdBtB6pkGa5qtDYwnTN19uanirfyWD+
	 jTc0dNgcCPzmdULihCabBY0uPkkTYZuhDO6lt5Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/172] selftests: netfilter: Stabilize rpath.sh
Date: Tue, 17 Dec 2024 18:08:09 +0100
Message-ID: <20241217170551.855032464@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit d92906fd1b940681b4509f7bb8ae737789fb4695 ]

On some systems, neighbor discoveries from ns1 for fec0:42::1 (i.e., the
martian trap address) would happen at the wrong time and cause
false-negative test result.

Problem analysis also discovered that IPv6 martian ping test was broken
in that sent neighbor discoveries, not echo requests were inadvertently
trapped

Avoid the race condition by introducing the neighbors to each other
upfront. Also pin down the firewall rules to matching on echo requests
only.

Fixes: efb056e5f1f0 ("netfilter: ip6t_rpfilter: Fix regression with VRF interfaces")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/netfilter/rpath.sh | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/rpath.sh b/tools/testing/selftests/net/netfilter/rpath.sh
index 4485fd7675ed..86ec4e68594d 100755
--- a/tools/testing/selftests/net/netfilter/rpath.sh
+++ b/tools/testing/selftests/net/netfilter/rpath.sh
@@ -61,9 +61,20 @@ ip -net "$ns2" a a 192.168.42.1/24 dev d0
 ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
 ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 
+# avoid neighbor lookups and enable martian IPv6 pings
+ns2_hwaddr=$(ip -net "$ns2" link show dev v0 | \
+	     sed -n 's, *link/ether \([^ ]*\) .*,\1,p')
+ns1_hwaddr=$(ip -net "$ns1" link show dev v0 | \
+	     sed -n 's, *link/ether \([^ ]*\) .*,\1,p')
+ip -net "$ns1" neigh add fec0:42::1 lladdr "$ns2_hwaddr" nud permanent dev v0
+ip -net "$ns1" neigh add fec0:23::1 lladdr "$ns2_hwaddr" nud permanent dev v0
+ip -net "$ns2" neigh add fec0:42::2 lladdr "$ns1_hwaddr" nud permanent dev d0
+ip -net "$ns2" neigh add fec0:23::2 lladdr "$ns1_hwaddr" nud permanent dev v0
+
 # firewall matches to test
 [ -n "$iptables" ] && {
 	common='-t raw -A PREROUTING -s 192.168.0.0/16'
+	common+=' -p icmp --icmp-type echo-request'
 	if ! ip netns exec "$ns2" "$iptables" $common -m rpfilter;then
 		echo "Cannot add rpfilter rule"
 		exit $ksft_skip
@@ -72,6 +83,7 @@ ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 }
 [ -n "$ip6tables" ] && {
 	common='-t raw -A PREROUTING -s fec0::/16'
+	common+=' -p icmpv6 --icmpv6-type echo-request'
 	if ! ip netns exec "$ns2" "$ip6tables" $common -m rpfilter;then
 		echo "Cannot add rpfilter rule"
 		exit $ksft_skip
@@ -82,8 +94,10 @@ ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 table inet t {
 	chain c {
 		type filter hook prerouting priority raw;
-		ip saddr 192.168.0.0/16 fib saddr . iif oif exists counter
-		ip6 saddr fec0::/16 fib saddr . iif oif exists counter
+		ip saddr 192.168.0.0/16 icmp type echo-request \
+			fib saddr . iif oif exists counter
+		ip6 saddr fec0::/16 icmpv6 type echo-request \
+			fib saddr . iif oif exists counter
 	}
 }
 EOF
-- 
2.39.5



