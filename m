Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9983E35AC32
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302773; cv=none; b=t+80US+r2fVVyrITPd9b9l5yJYcerBpQ4Gp4w/Gm/UdRcOq/n+IvQNqtEWydpGlck9ZqUXQVl9MJmg/jJziSz3PWX0/akfmVJvawU7HMcIaQEBDRVTB3g5nZcrVF3IabJHExwQI8Xb3d1ymJACmv3AuI1OOfReNXjfMrzHV4oag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302773; c=relaxed/simple;
	bh=0/Cf+cRioKpy6Ig/di/lbbpExqb+0UAe4I9I5gg1cd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDMm96TRFZHCp+DDBSxWhLxAJZ7sepTcYvtMuql4XoV5oUKUaLwndkStBRUqCGN6JMN8p5Wsn5y/K32z1gRpaUMyDpUsnoCbxp7pv2WCaQAEX2ON7U3sKAPvKDa9gUJO3EkbzfDiOtEOU/8vl+6src9TmJyP619r4joCNFIbtIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ddy0aX/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ddy0aX/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7716C2BD01;
	Sat, 28 Feb 2026 18:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302773;
	bh=0/Cf+cRioKpy6Ig/di/lbbpExqb+0UAe4I9I5gg1cd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ddy0aX/bWK/E0xf4mstKUNU2t8mVUFwDkPjOPJYTpFotcLvS6akimM5Mmkt/OIxlP
	 SG0Y0tVbC+JdOTFwy74Pa3uNI6ZUGD3qdQKjdQ74QzkITlNLGQR0eRWvrsnD2bXXPx
	 IodY/I1U+oTfP6onak64lASVfowQmvjGsdkb0jNPywt2vqAUKr8rjp+lAFbwP0fl3u
	 QMAo4eNoiS+pRfgsJrApiLKMWVB35RUE1E2LWHYT1OxENN8ouU4l8Xwgmz0wKiHAsl
	 b06j+Xw6BbKtfB11XbmQqWYu1wLPB0BzMFeYy1YvKwWezRBfABMcH5a6/4VZ7TUjS6
	 ZjRZfDu2Uhesw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ido Schimmel <idosch@nvidia.com>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Petr Machata <petrm@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/147] selftests: forwarding: tc_actions: Use ncat instead of nc
Date: Sat, 28 Feb 2026 13:17:34 -0500
Message-ID: <20260228181736.1605592-146-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 5e8670610b93158ffacc3241f835454ff26a3469 ]

The test relies on 'nc' being the netcat version from the nmap project.
While this seems to be the case on Fedora, it is not the case on Ubuntu,
resulting in failures such as [1].

Fix by explicitly using the 'ncat' utility from the nmap project and the
skip the test in case it is not installed.

[1]
 # timeout set to 0
 # selftests: net/forwarding: tc_actions.sh
 # TEST: gact drop and ok (skip_hw)                                    [ OK ]
 # TEST: mirred egress flower redirect (skip_hw)                       [ OK ]
 # TEST: mirred egress flower mirror (skip_hw)                         [ OK ]
 # TEST: mirred egress matchall mirror (skip_hw)                       [ OK ]
 # TEST: mirred_egress_to_ingress (skip_hw)                            [ OK ]
 # nc: invalid option -- '-'
 # usage: nc [-46CDdFhklNnrStUuvZz] [-I length] [-i interval] [-M ttl]
 #         [-m minttl] [-O length] [-P proxy_username] [-p source_port]
 #         [-q seconds] [-s sourceaddr] [-T keyword] [-V rtable] [-W recvlimit]
 #         [-w timeout] [-X proxy_protocol] [-x proxy_address[:port]]
 #         [destination] [port]
 # nc: invalid option -- '-'
 # usage: nc [-46CDdFhklNnrStUuvZz] [-I length] [-i interval] [-M ttl]
 #         [-m minttl] [-O length] [-P proxy_username] [-p source_port]
 #         [-q seconds] [-s sourceaddr] [-T keyword] [-V rtable] [-W recvlimit]
 #         [-w timeout] [-X proxy_protocol] [-x proxy_address[:port]]
 #         [destination] [port]
 # TEST: mirred_egress_to_ingress_tcp (skip_hw)                        [FAIL]
 #       server output check failed
 # INFO: Could not test offloaded functionality
 not ok 80 selftests: net/forwarding: tc_actions.sh # exit=1

Fixes: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/netdev/adc5e40d-d040-a65e-eb26-edf47dac5b02@alu.unizg.hr/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20230808141503.4060661-12-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 32b70e62034a ("selftests: tc_actions: don't dump 2MB of \0 to stdout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/tc_actions.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index 9c2aca8a4b8de..dd02ed4cacacb 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -8,6 +8,8 @@ NUM_NETIFS=4
 source tc_common.sh
 source lib.sh
 
+require_command ncat
+
 tcflags="skip_hw"
 
 h1_create()
@@ -174,9 +176,9 @@ mirred_egress_to_ingress_tcp_test()
 		ip_proto icmp \
 			action drop
 
-	ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $mirred_e2i_tf2  &
+	ip vrf exec v$h1 ncat --recv-only -w10 -l -p 12345 -o $mirred_e2i_tf2 &
 	local rpid=$!
-	ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$mirred_e2i_tf1
+	ip vrf exec v$h1 ncat -w1 --send-only 192.0.2.2 12345 <$mirred_e2i_tf1
 	wait -n $rpid
 	cmp -s $mirred_e2i_tf1 $mirred_e2i_tf2
 	check_err $? "server output check failed"
-- 
2.51.0

