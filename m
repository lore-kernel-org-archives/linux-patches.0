Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484401898ED;
	Tue, 30 Jul 2024 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358003; cv=none; b=NFV/md3477UmThIIDTxZZIeAH1QEoUUCMGphycXUeEq2yU0JtlDD90GVQQSedyfuNz/zEllGSqzIG8GMVy0XXzmuAMFjlBTPAxI2woY4tJAQtQTeO7pTisFm2XmzNsw0TL9958n9MllxKtKwKW8poSpO+arGERyHZcEXXiKt9Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358003; c=relaxed/simple;
	bh=m3lFJPOC1Te1iMHkZ6ayATaeoMGSiIkptyCxk6OynNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2UoL1iaYH0i4eyRXfbRUzD/PJkbJMOghKRavkOktSss4IAqngCJBfxFeel1LvxmrmWn9Oltlp41JwZLTC761vTRiIDYoWsnYLbkAUI3y/XQQf7fCpirwGfFN2lEQqi3jy0G8++Rv1++GEzCeYCQUztdF4H+w8HLuAk0ki1w1Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XuBq5zjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XuBq5zjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BA4C4AF0C;
	Tue, 30 Jul 2024 16:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358003;
	bh=m3lFJPOC1Te1iMHkZ6ayATaeoMGSiIkptyCxk6OynNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XuBq5zjmIioJ6duDCpTvEdXgINw39LePrssMSaG0ixrd8sJKWfS6IUZI94NPauuxX
	 M6GYSSIiFPemv4I6AdaUpSMjlPH/1qWflt/h0zGyW4A3N9LimGAkqu4O2qnCBprzpk
	 vosw5T5OiYC/i/6Jm+qOfd3XWWuoro4UHI75Do/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 316/568] ipv4: Fix incorrect TOS in fibmatch route get reply
Date: Tue, 30 Jul 2024 17:47:03 +0200
Message-ID: <20240730151652.222385988@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

[ Upstream commit f036e68212c11e5a7edbb59b5e25299341829485 ]

The TOS value that is returned to user space in the route get reply is
the one with which the lookup was performed ('fl4->flowi4_tos'). This is
fine when the matched route is configured with a TOS as it would not
match if its TOS value did not match the one with which the lookup was
performed.

However, matching on TOS is only performed when the route's TOS is not
zero. It is therefore possible to have the kernel incorrectly return a
non-zero TOS:

 # ip link add name dummy1 up type dummy
 # ip address add 192.0.2.1/24 dev dummy1
 # ip route get fibmatch 192.0.2.2 tos 0xfc
 192.0.2.0/24 tos 0x1c dev dummy1 proto kernel scope link src 192.0.2.1

Fix by instead returning the DSCP field from the FIB result structure
which was populated during the route lookup.

Output after the patch:

 # ip link add name dummy1 up type dummy
 # ip address add 192.0.2.1/24 dev dummy1
 # ip route get fibmatch 192.0.2.2 tos 0xfc
 192.0.2.0/24 dev dummy1 proto kernel scope link src 192.0.2.1

Extend the existing selftests to not only verify that the correct route
is returned, but that it is also returned with correct "tos" value (or
without it).

Fixes: b61798130f1b ("net: ipv4: RTM_GETROUTE: return matched fib result when requested")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c                         |  2 +-
 tools/testing/selftests/net/fib_tests.sh | 24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 810779d537bec..4d169573148f6 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3394,7 +3394,7 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		fri.tb_id = table_id;
 		fri.dst = res.prefix;
 		fri.dst_len = res.prefixlen;
-		fri.dscp = inet_dsfield_to_dscp(fl4.flowi4_tos);
+		fri.dscp = res.dscp;
 		fri.type = rt->rt_type;
 		fri.offload = 0;
 		fri.trap = 0;
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 66d0db7a2614d..ede2c0ec2a9dd 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1643,53 +1643,53 @@ ipv4_rt_dsfield()
 
 	# DSCP 0x10 should match the specific route, no matter the ECN bits
 	$IP route get fibmatch 172.16.102.1 dsfield 0x10 | \
-		grep -q "via 172.16.103.2"
+		grep -q "172.16.102.0/24 tos 0x10 via 172.16.103.2"
 	log_test $? 0 "IPv4 route with DSCP and ECN:Not-ECT"
 
 	$IP route get fibmatch 172.16.102.1 dsfield 0x11 | \
-		grep -q "via 172.16.103.2"
+		grep -q "172.16.102.0/24 tos 0x10 via 172.16.103.2"
 	log_test $? 0 "IPv4 route with DSCP and ECN:ECT(1)"
 
 	$IP route get fibmatch 172.16.102.1 dsfield 0x12 | \
-		grep -q "via 172.16.103.2"
+		grep -q "172.16.102.0/24 tos 0x10 via 172.16.103.2"
 	log_test $? 0 "IPv4 route with DSCP and ECN:ECT(0)"
 
 	$IP route get fibmatch 172.16.102.1 dsfield 0x13 | \
-		grep -q "via 172.16.103.2"
+		grep -q "172.16.102.0/24 tos 0x10 via 172.16.103.2"
 	log_test $? 0 "IPv4 route with DSCP and ECN:CE"
 
 	# Unknown DSCP should match the generic route, no matter the ECN bits
 	$IP route get fibmatch 172.16.102.1 dsfield 0x14 | \
-		grep -q "via 172.16.101.2"
+		grep -q "172.16.102.0/24 via 172.16.101.2"
 	log_test $? 0 "IPv4 route with unknown DSCP and ECN:Not-ECT"
 
 	$IP route get fibmatch 172.16.102.1 dsfield 0x15 | \
-		grep -q "via 172.16.101.2"
+		grep -q "172.16.102.0/24 via 172.16.101.2"
 	log_test $? 0 "IPv4 route with unknown DSCP and ECN:ECT(1)"
 
 	$IP route get fibmatch 172.16.102.1 dsfield 0x16 | \
-		grep -q "via 172.16.101.2"
+		grep -q "172.16.102.0/24 via 172.16.101.2"
 	log_test $? 0 "IPv4 route with unknown DSCP and ECN:ECT(0)"
 
 	$IP route get fibmatch 172.16.102.1 dsfield 0x17 | \
-		grep -q "via 172.16.101.2"
+		grep -q "172.16.102.0/24 via 172.16.101.2"
 	log_test $? 0 "IPv4 route with unknown DSCP and ECN:CE"
 
 	# Null DSCP should match the generic route, no matter the ECN bits
 	$IP route get fibmatch 172.16.102.1 dsfield 0x00 | \
-		grep -q "via 172.16.101.2"
+		grep -q "172.16.102.0/24 via 172.16.101.2"
 	log_test $? 0 "IPv4 route with no DSCP and ECN:Not-ECT"
 
 	$IP route get fibmatch 172.16.102.1 dsfield 0x01 | \
-		grep -q "via 172.16.101.2"
+		grep -q "172.16.102.0/24 via 172.16.101.2"
 	log_test $? 0 "IPv4 route with no DSCP and ECN:ECT(1)"
 
 	$IP route get fibmatch 172.16.102.1 dsfield 0x02 | \
-		grep -q "via 172.16.101.2"
+		grep -q "172.16.102.0/24 via 172.16.101.2"
 	log_test $? 0 "IPv4 route with no DSCP and ECN:ECT(0)"
 
 	$IP route get fibmatch 172.16.102.1 dsfield 0x03 | \
-		grep -q "via 172.16.101.2"
+		grep -q "172.16.102.0/24 via 172.16.101.2"
 	log_test $? 0 "IPv4 route with no DSCP and ECN:CE"
 }
 
-- 
2.43.0



