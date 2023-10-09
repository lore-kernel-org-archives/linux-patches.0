Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC33199B3
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fVZPeG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD44C433C9;
	Mon,  9 Oct 2023 13:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857982;
	bh=yzUPHzKXbBNSQEuqmpo+P4AZTLNOcBXZ0Qvm6J+44VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fVZPeG/zndMHGtHPISTpYPN4KTRcoN2Nq1818svBLJhN3a/ABkkLmvzFkgcsmCGB
	 JQ6iH1ZimNm85SKJHvakw428B5yAueOeFqrlRZfMuEVwwm6P+2IZcD+E2F2tCph1wc
	 4dS1qA58+q7T5ZlkGj7oWWIUk5LvYzV9LzDIoyfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 54/75] ipv4: Set offload_failed flag in fibmatch results
Date: Mon,  9 Oct 2023 15:02:16 +0200
Message-ID: <20231009130113.131156286@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit 0add5c597f3253a9c6108a0a81d57f44ab0d9d30 ]

Due to a small omission, the offload_failed flag is missing from ipv4
fibmatch results. Make sure it is set correctly.

The issue can be witnessed using the following commands:
echo "1 1" > /sys/bus/netdevsim/new_device
ip link add dummy1 up type dummy
ip route add 192.0.2.0/24 dev dummy1
echo 1 > /sys/kernel/debug/netdevsim/netdevsim1/fib/fail_route_offload
ip route add 198.51.100.0/24 dev dummy1
ip route
	# 192.168.15.0/24 has rt_trap
	# 198.51.100.0/24 has rt_offload_failed
ip route get 192.168.15.1 fibmatch
	# Result has rt_trap
ip route get 198.51.100.1 fibmatch
	# Result differs from the route shown by `ip route`, it is missing
	# rt_offload_failed
ip link del dev dummy1
echo 1 > /sys/bus/netdevsim/del_device

Fixes: 36c5100e859d ("IPv4: Add "offload failed" indication to routes")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230926182730.231208-1-bpoirier@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 968cc4aa6e96c..ea5329cb0fce2 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3430,6 +3430,8 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 				    fa->fa_type == fri.type) {
 					fri.offload = READ_ONCE(fa->offload);
 					fri.trap = READ_ONCE(fa->trap);
+					fri.offload_failed =
+						READ_ONCE(fa->offload_failed);
 					break;
 				}
 			}
-- 
2.40.1



