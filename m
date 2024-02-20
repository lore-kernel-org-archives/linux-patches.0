Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AFD152DEB;
	Tue, 20 Feb 2024 21:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464487; cv=none; b=p2YFibi8FDe38Jv0TOWMZebWVPMDoGsjT7kyAhJgQ2ylH2InDR/KTgXmUNH0C1bY+TsC/pa6zxsKuXZFzTLghnNkiIBc5zRD7L992FI21UOztGxbL+aEfXAsEHrxc4oHGiVgrZ2/tDcwYOspGygRO/h33/et2qKijROnhj3Fqho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464487; c=relaxed/simple;
	bh=tLfv8xjr4pUgwsm54Hj5srkx45MUQ4K5JPobYMivpmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxOQY0fzYxTKGGresRJC/v0mWaLkN1NUTTj+YnYch3YSToYdv0YLJTHJC8jYj0/RLNttqPxgrZvuvoOIRPrEeOFmSWbR6JXTNGNm6MmZS95BNYcb85VIDGZ4WovVja4tKTQ1vfhz4oH5Vx+EYrbSCqy01uOZzhwEm5nyhLPQFwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sI8ek79R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sI8ek79R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA99BC43390;
	Tue, 20 Feb 2024 21:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464487;
	bh=tLfv8xjr4pUgwsm54Hj5srkx45MUQ4K5JPobYMivpmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sI8ek79RAFIXWqBEwYjpjqEeGNjx6iMQ8nJM84u/u4+X+TxQwz/tNwQQKA37fFQA6
	 e6g+BOoBFkV8932uBxY18ngr11ksMxXE5q4jfrzMb7Bf/m/e3+RyPkGzzrdH7wGi/n
	 rKLl4nHsMh/nNe2X/AKh31f9D2en/b8wKz+bEKdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 041/309] selftests: forwarding: Fix layer 2 miss test flakiness
Date: Tue, 20 Feb 2024 21:53:20 +0100
Message-ID: <20240220205634.474654948@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 93590849a05edffaefa11695fab98f621259ded2 ]

After enabling a multicast querier on the bridge (like the test is
doing), the bridge will wait for the Max Response Delay before starting
to forward according to its MDB in order to let Membership Reports
enough time to be received and processed.

Currently, the test is waiting for exactly the default Max Response
Delay (10 seconds) which is racy and leads to failures [1].

Fix by reducing the Max Response Delay to 1 second.

[1]
 [...]
 # TEST: L2 miss - Multicast (IPv4)                                    [FAIL]
 # Unregistered multicast filter was hit after adding MDB entry

Fixes: 8c33266ae26a ("selftests: forwarding: Add layer 2 miss test cases")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20240208155529.1199729-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/forwarding/tc_flower_l2_miss.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh b/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh
index 20a7cb7222b8..c2420bb72c12 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh
@@ -209,14 +209,17 @@ test_l2_miss_multicast()
 	# both registered and unregistered multicast traffic.
 	bridge link set dev $swp2 mcast_router 2
 
+	# Set the Max Response Delay to 100 centiseconds (1 second) so that the
+	# bridge will start forwarding according to its MDB soon after a
+	# multicast querier is enabled.
+	ip link set dev br1 type bridge mcast_query_response_interval 100
+
 	# Forwarding according to MDB entries only takes place when the bridge
 	# detects that there is a valid querier in the network. Set the bridge
 	# as the querier and assign it a valid IPv6 link-local address to be
 	# used as the source address for MLD queries.
 	ip link set dev br1 type bridge mcast_querier 1
 	ip -6 address add fe80::1/64 nodad dev br1
-	# Wait the default Query Response Interval (10 seconds) for the bridge
-	# to determine that there are no other queriers in the network.
 	sleep 10
 
 	test_l2_miss_multicast_ipv4
@@ -224,6 +227,7 @@ test_l2_miss_multicast()
 
 	ip -6 address del fe80::1/64 dev br1
 	ip link set dev br1 type bridge mcast_querier 0
+	ip link set dev br1 type bridge mcast_query_response_interval 1000
 	bridge link set dev $swp2 mcast_router 1
 }
 
-- 
2.43.0



