Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F1A151CEC;
	Tue, 20 Feb 2024 21:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463399; cv=none; b=aj2F/+cK5U7oPsTw49ZzDNDNepoLdivoVRoJSNAh9ICCttlazxamRle89Fy+3nGk6KzNgB+ebvz8UHwE+QT2yltNGgD4CKe5EM9NL3p9QZCGLaoTdtqk4V+K5VwVtlEqAr0/pFHZI9Y9zQYNE4f3u5qk7JK7qucN+jFPsFDohbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463399; c=relaxed/simple;
	bh=oigOUb3Ck98+ypeMqofQNLsMTcFB56YIdi+V8rat4Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvLblohrlSmUHOrLWoboJlMvMGI2F8a2t3bUE7pykNeexWU9wAes6DW5UPgSsbjUTKNzWJbxPxl7Cp4w7ECW9176B2kYoGlc0Ccry98vWGnZSZMD0ELQVtNNbkOoJSxLzj0o9xVCYgMl4BLpwgFW6hCNDUpu8sZGbdVIGr1CHsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLHMVGUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLHMVGUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE1FC43390;
	Tue, 20 Feb 2024 21:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463399;
	bh=oigOUb3Ck98+ypeMqofQNLsMTcFB56YIdi+V8rat4Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLHMVGUXpZHMM6JkM4TveOTobwMaVo2OOr271eRkGxnKGzS3D7BhzRJ5pCU2b9y24
	 X0AFcrg60pqXIS9XqSq1qoTlO0qm9eikxuyG0z18S3iNPcdvBWVi8Vpr3GH5j4dlJ0
	 oz2NfQUyYDyYBUNvvQkv5aIyURhZRDE2nZpQS/Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/331] selftests: forwarding: Fix layer 2 miss test flakiness
Date: Tue, 20 Feb 2024 21:52:28 +0100
Message-ID: <20240220205638.601770245@linuxfoundation.org>
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



