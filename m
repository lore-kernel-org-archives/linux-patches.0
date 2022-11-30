Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D7D79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390F5C433D6;
	Wed, 30 Nov 2022 18:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833946;
	bh=0K3AIHkB8kD0VAftsr2Eqscp76tLjsXPVX16DhrCo6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lz7s0cJddeTyDjJlbQW15TqUXQFJoC0NU3z42SEv2irscGPg72yl/uM1AMXWoZTId
	 O6DinZiDAfzrA3o5BQ6G+XbXYrxjCS9CYI/MWp3LCnTFpajWumqtP0lshF5oIm+EhO
	 AWEQ1UxAcsnfw9vixppK3ClXvLN3i+m9H/7N/bwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 072/289] selftests: mptcp: run mptcp_sockopt from a new netns
Date: Wed, 30 Nov 2022 19:20:57 +0100
Message-Id: <20221130180545.773342978@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit 7e68d31020f18f8d695d5f143fc16cdaa96166cb ]

Not running it from a new netns causes issues if some MPTCP settings are
modified, e.g. if MPTCP is disabled from the sysctl knob, if multiple
addresses are available and added to the MPTCP path-manager, etc.

In these cases, the created connection will not behave as expected, e.g.
unable to create an MPTCP socket, more than one subflow is seen, etc.

A new "sandbox" net namespace is now created and used to run
mptcp_sockopt from this controlled environment.

Fixes: ce9979129a0b ("selftests: mptcp: add mptcp getsockopt test cases")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
index 0879da915014..80d36f7cfee8 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -35,8 +35,9 @@ init()
 
 	ns1="ns1-$rndh"
 	ns2="ns2-$rndh"
+	ns_sbox="ns_sbox-$rndh"
 
-	for netns in "$ns1" "$ns2";do
+	for netns in "$ns1" "$ns2" "$ns_sbox";do
 		ip netns add $netns || exit $ksft_skip
 		ip -net $netns link set lo up
 		ip netns exec $netns sysctl -q net.mptcp.enabled=1
@@ -73,7 +74,7 @@ init()
 
 cleanup()
 {
-	for netns in "$ns1" "$ns2"; do
+	for netns in "$ns1" "$ns2" "$ns_sbox"; do
 		ip netns del $netns
 	done
 	rm -f "$cin" "$cout"
@@ -243,7 +244,7 @@ do_mptcp_sockopt_tests()
 {
 	local lret=0
 
-	./mptcp_sockopt
+	ip netns exec "$ns_sbox" ./mptcp_sockopt
 	lret=$?
 
 	if [ $lret -ne 0 ]; then
@@ -252,7 +253,7 @@ do_mptcp_sockopt_tests()
 		return
 	fi
 
-	./mptcp_sockopt -6
+	ip netns exec "$ns_sbox" ./mptcp_sockopt -6
 	lret=$?
 
 	if [ $lret -ne 0 ]; then
-- 
2.35.1



