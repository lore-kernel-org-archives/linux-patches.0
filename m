Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D10FDF53
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E605EC433EF;
	Mon, 15 May 2023 16:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169375;
	bh=vYQUcLPMTRVFgU2TgOleFQK6YisZAf2Z3MsTK94EWuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zm8FNo6WYtLu+2KMDf+fmQNeZXSGkblwi5akwAUGfY3ZvodfeNJF1ykvT4jMQbsx7
	 Px/gnFM/VC0CS39gpykeUeamqVwwhQqrc4yViAmxoocvCHAJGvp3cjlaF7s94omtcL
	 lALMbODVYqIcn4U7AtNmLlSgOuteSg9Ukf5czwEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 038/246] selftests: srv6: make srv6_end_dt46_l3vpn_test more robust
Date: Mon, 15 May 2023 18:24:10 +0200
Message-Id: <20230515161723.740321724@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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

[ Upstream commit 46ef24c60f8ee70662968ac55325297ed4624d61 ]

On some distributions, the rp_filter is automatically set (=1) by
default on a netdev basis (also on VRFs).
In an SRv6 End.DT46 behavior, decapsulated IPv4 packets are routed using
the table associated with the VRF bound to that tunnel. During lookup
operations, the rp_filter can lead to packet loss when activated on the
VRF.
Therefore, we chose to make this selftest more robust by explicitly
disabling the rp_filter during tests (as it is automatically set by some
Linux distributions).

Fixes: 03a0b567a03d ("selftests: seg6: add selftest for SRv6 End.DT46 Behavior")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/srv6_end_dt46_l3vpn_test.sh  | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh b/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
index aebaab8ce44cb..441eededa0312 100755
--- a/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
+++ b/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
@@ -292,6 +292,11 @@ setup_hs()
 	ip netns exec ${hsname} sysctl -wq net.ipv6.conf.all.accept_dad=0
 	ip netns exec ${hsname} sysctl -wq net.ipv6.conf.default.accept_dad=0
 
+	# disable the rp_filter otherwise the kernel gets confused about how
+	# to route decap ipv4 packets.
+	ip netns exec ${rtname} sysctl -wq net.ipv4.conf.all.rp_filter=0
+	ip netns exec ${rtname} sysctl -wq net.ipv4.conf.default.rp_filter=0
+
 	ip -netns ${hsname} link add veth0 type veth peer name ${rtveth}
 	ip -netns ${hsname} link set ${rtveth} netns ${rtname}
 	ip -netns ${hsname} addr add ${IPv6_HS_NETWORK}::${hs}/64 dev veth0 nodad
@@ -316,11 +321,6 @@ setup_hs()
 	ip netns exec ${rtname} sysctl -wq net.ipv6.conf.${rtveth}.proxy_ndp=1
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



