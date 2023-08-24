Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30711119B
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434EFC433C8;
	Thu, 24 Aug 2023 14:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888707;
	bh=PldhRRoP8qHsc0YlCqNd67rjCBUAlYf1Ytt3SFRgVNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZZtRJ8RRwx7VXQ6XwiN5YUjylowEprvt2UQeJcTJWivUuHMn3o6XFWg4ZDTQ6N2u
	 tFRpkeQVc3FXCyVVotNbJhMm+OsTzk0wHMqGv7yRYHUtHTCVqEkGjw4ochZPO1Nson
	 zLPwlCahLK2p403u/OV6l8SkJnwbzerEJibxRkbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/139] selftests: forwarding: tc_actions: cleanup temporary files when test is aborted
Date: Thu, 24 Aug 2023 16:48:45 +0200
Message-ID: <20230824145023.675190635@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit f58531716ced8975a4ade108ef4af35f98722af7 ]

remove temporary files created by 'mirred_egress_to_ingress_tcp' test
in the cleanup() handler. Also, change variable names to avoid clashing
with globals from lib.sh.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/r/091649045a017fc00095ecbb75884e5681f7025f.1676368027.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5e8670610b93 ("selftests: forwarding: tc_actions: Use ncat instead of nc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/forwarding/tc_actions.sh       | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index 1e27031288c81..9c2aca8a4b8de 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -155,10 +155,10 @@ gact_trap_test()
 
 mirred_egress_to_ingress_tcp_test()
 {
-	local tmpfile=$(mktemp) tmpfile1=$(mktemp)
+	mirred_e2i_tf1=$(mktemp) mirred_e2i_tf2=$(mktemp)
 
 	RET=0
-	dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$tmpfile
+	dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$mirred_e2i_tf1
 	tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
 		$tcflags ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
 			action ct commit nat src addr 192.0.2.2 pipe \
@@ -174,11 +174,11 @@ mirred_egress_to_ingress_tcp_test()
 		ip_proto icmp \
 			action drop
 
-	ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $tmpfile1  &
+	ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $mirred_e2i_tf2  &
 	local rpid=$!
-	ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$tmpfile
+	ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$mirred_e2i_tf1
 	wait -n $rpid
-	cmp -s $tmpfile $tmpfile1
+	cmp -s $mirred_e2i_tf1 $mirred_e2i_tf2
 	check_err $? "server output check failed"
 
 	$MZ $h1 -c 10 -p 64 -a $h1mac -b $h1mac -A 192.0.2.1 -B 192.0.2.1 \
@@ -195,7 +195,7 @@ mirred_egress_to_ingress_tcp_test()
 	tc filter del dev $h1 egress protocol ip pref 101 handle 101 flower
 	tc filter del dev $h1 ingress protocol ip pref 102 handle 102 flower
 
-	rm -f $tmpfile $tmpfile1
+	rm -f $mirred_e2i_tf1 $mirred_e2i_tf2
 	log_test "mirred_egress_to_ingress_tcp ($tcflags)"
 }
 
@@ -224,6 +224,8 @@ setup_prepare()
 
 cleanup()
 {
+	local tf
+
 	pre_cleanup
 
 	switch_destroy
@@ -234,6 +236,8 @@ cleanup()
 
 	ip link set $swp2 address $swp2origmac
 	ip link set $swp1 address $swp1origmac
+
+	for tf in $mirred_e2i_tf1 $mirred_e2i_tf2; do rm -f $tf; done
 }
 
 mirred_egress_redirect_test()
-- 
2.40.1



