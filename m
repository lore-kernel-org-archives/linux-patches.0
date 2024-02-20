Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4DE152E03;
	Tue, 20 Feb 2024 21:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463403; cv=none; b=rm4XTTUMCZt1B5DsbAvfN5YqMgzqIVF9nH8QWyK+2QgMx5yqZyak9PmtNkLVEnGB6YaKsJg8qApg6iX74ybQFh00gOAOsssYpWvFZBv42f7vh0nP/Wtpe+FKSoI5pLLqtob69AdF7IkeH4uNEBmkApIhs2hYEUBASFxCsGA4DZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463403; c=relaxed/simple;
	bh=o9JtcOkiARIC84vDaakXUu5Al8fUvKcGlLREzslSKLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1Gx7rNNEWi2VHX8vnkyxJ79xElbWPMGGsvR2PiH/r0Ggj5MQhMcKkpTg+J0PnNxrBI2WI4mEvm9Eof9iGm9gzDLV3QiGJfkea+KhtupFpAU6i/P9FD8ZTD7tu3Ou3OE3Ak120kA03k8yxR+C/V05bFFpkwo9veXTfDvfNN158g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fb5lM9aY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fb5lM9aY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A01C433C7;
	Tue, 20 Feb 2024 21:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463402;
	bh=o9JtcOkiARIC84vDaakXUu5Al8fUvKcGlLREzslSKLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fb5lM9aYbGQBmO2flRyiMcgcKw9idXZVsX01hVi1m+mGU67LR6Z7Oeo0BatLB+1X6
	 oHPrNmhqsIvvPOtTHmx/JLjNWEhsZnTjHX/HDPyV8TtdkPQovFPA8t7vL8rKKTeUIS
	 2yM5lcQjZkwFjXsYMnNZhTKytgT0owGLR8lrLSL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/331] selftests: forwarding: Fix bridge MDB test flakiness
Date: Tue, 20 Feb 2024 21:52:29 +0100
Message-ID: <20240220205638.630824185@linuxfoundation.org>
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

[ Upstream commit 7399e2ce4d424f426417496eb289458780eea985 ]

After enabling a multicast querier on the bridge (like the test is
doing), the bridge will wait for the Max Response Delay before starting
to forward according to its MDB in order to let Membership Reports
enough time to be received and processed.

Currently, the test is waiting for exactly the default Max Response
Delay (10 seconds) which is racy and leads to failures [1].

Fix by reducing the Max Response Delay to 1 second.

[1]
 [...]
 # TEST: IPv4 host entries forwarding tests                            [FAIL]
 # Packet locally received after flood

Fixes: b6d00da08610 ("selftests: forwarding: Add bridge MDB test")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20240208155529.1199729-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/bridge_mdb.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index d0c6c499d5da..529a56adbb88 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -1102,14 +1102,17 @@ fwd_test()
 	echo
 	log_info "# Forwarding tests"
 
+	# Set the Max Response Delay to 100 centiseconds (1 second) so that the
+	# bridge will start forwarding according to its MDB soon after a
+	# multicast querier is enabled.
+	ip link set dev br0 type bridge mcast_query_response_interval 100
+
 	# Forwarding according to MDB entries only takes place when the bridge
 	# detects that there is a valid querier in the network. Set the bridge
 	# as the querier and assign it a valid IPv6 link-local address to be
 	# used as the source address for MLD queries.
 	ip -6 address add fe80::1/64 nodad dev br0
 	ip link set dev br0 type bridge mcast_querier 1
-	# Wait the default Query Response Interval (10 seconds) for the bridge
-	# to determine that there are no other queriers in the network.
 	sleep 10
 
 	fwd_test_host
@@ -1117,6 +1120,7 @@ fwd_test()
 
 	ip link set dev br0 type bridge mcast_querier 0
 	ip -6 address del fe80::1/64 dev br0
+	ip link set dev br0 type bridge mcast_query_response_interval 1000
 }
 
 ctrl_igmpv3_is_in_test()
-- 
2.43.0



