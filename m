Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDFB14AB3
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE06C433D2;
	Mon, 22 May 2023 19:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783796;
	bh=JIVqOOwSWuOCNO6WNW665Eu9nFgLFzCEUZ1bd9gn0gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMe9+DySyS1aZ14b99J2CFpMsyOETeP4YnAAvCYf8y6dhc+R5nFgeU/B9a6gbmys8
	 hXvEyrEIMlxloMHNcCvUHSc5dHIOaELP6Ko6mh7KeXOa32JMggTbXVkuTV3cSAjtg2
	 gmP4CQOWAZGwtG9BZ/szab7JbaLc+bDBNv2yBU40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/292] selftets: seg6: disable rp_filter by default in srv6_end_dt4_l3vpn_test
Date: Mon, 22 May 2023 20:08:42 +0100
Message-Id: <20230522190410.090447783@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit f97b8401e0deb46ad1e4245c21f651f64f55aaa6 ]

On some distributions, the rp_filter is automatically set (=1) by
default on a netdev basis (also on VRFs).
In an SRv6 End.DT4 behavior, decapsulated IPv4 packets are routed using
the table associated with the VRF bound to that tunnel. During lookup
operations, the rp_filter can lead to packet loss when activated on the
VRF.
Therefore, we chose to make this selftest more robust by explicitly
disabling the rp_filter during tests (as it is automatically set by some
Linux distributions).

Fixes: 2195444e09b4 ("selftests: add selftest for the SRv6 End.DT4 behavior")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/srv6_end_dt4_l3vpn_test.sh  | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh b/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
index 37f08d582d2fe..f962823628119 100755
--- a/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
+++ b/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
@@ -258,6 +258,12 @@ setup_hs()
 
 	# set the networking for the host
 	ip netns add ${hsname}
+
+	# disable the rp_filter otherwise the kernel gets confused about how
+	# to route decap ipv4 packets.
+	ip netns exec ${rtname} sysctl -wq net.ipv4.conf.all.rp_filter=0
+	ip netns exec ${rtname} sysctl -wq net.ipv4.conf.default.rp_filter=0
+
 	ip -netns ${hsname} link add veth0 type veth peer name ${rtveth}
 	ip -netns ${hsname} link set ${rtveth} netns ${rtname}
 	ip -netns ${hsname} addr add ${IPv4_HS_NETWORK}.${hs}/24 dev veth0
@@ -276,11 +282,6 @@ setup_hs()
 
 	ip netns exec ${rtname} sysctl -wq net.ipv4.conf.${rtveth}.proxy_arp=1
 
-	# disable the rp_filter otherwise the kernel gets confused about how
-	# to route decap ipv4 packets.
-	ip netns exec ${rtname} sysctl -wq net.ipv4.conf.all.rp_filter=0
-	ip netns exec ${rtname} sysctl -wq net.ipv4.conf.${rtveth}.rp_filter=0
-
 	ip netns exec ${rtname} sh -c "echo 1 > /proc/sys/net/vrf/strict_mode"
 }
 
-- 
2.39.2



