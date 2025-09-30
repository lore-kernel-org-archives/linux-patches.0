Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F60E304989;
	Tue, 30 Sep 2025 14:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244352; cv=none; b=KegVwYPvXm2W0S7VgFYoiZcB3/qK2NpneL2c+X/EAj+qhuDy1VoLeOaMS2Wuf9yXamEw/3Bbw6FW5qNcVLOFyM9cKdV95akQV8q2wqZ02Ir9sat57NUNw6vRWASH9S2iJ1XCZJXj/6Td/CCWR32Uc1AQItpIfbdu7BwzcXTQLjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244352; c=relaxed/simple;
	bh=alUXn9vCW/+9oQSq9sm4QIoPzwil4DT41kOXy6zXDCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIhRxbZ34NC95/LYnoZHIV4qrrXr0o9MirO+BbTLWIuTNKhDGpjl0L3Rkzo7r3nzlkrWhn5E6+ciVpUS/FiBX0WKcriXfNHaoYUbqYhzkGG/PmLnjyv9A5oHY3rVshGsEXQw3Xyw1zE4xKBR1WkR+aKfioa/rI+kANOO6l14lxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZKcfC83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZKcfC83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7041C4CEF0;
	Tue, 30 Sep 2025 14:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244352;
	bh=alUXn9vCW/+9oQSq9sm4QIoPzwil4DT41kOXy6zXDCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZKcfC83DV37ZIfWBYvA1TnEd4P1ZoZM3YS0It0taxfVZxSNd/UAKGFHr+479QpbD
	 PZvziGiy8c95AL9xm0VQjPtXyiZJVYDANHkDyJ622pedBxTkbTgkIYW1n5ACjpuiH6
	 Ry3IuHStq5QHzVkXE3zR3uBk4LOCu1YEci23EPN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/122] rtnetlink: Add RTNH_F_TRAP flag
Date: Tue, 30 Sep 2025 16:47:14 +0200
Message-ID: <20250930143827.198113809@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 968a83f8cf6fd5a107289c57ee3197a52c72f02c ]

The flag indicates to user space that the nexthop is not programmed to
forward packets in hardware, but rather to trap them to the CPU. This is
needed, for example, when the MAC of the nexthop neighbour is not
resolved and packets should reach the CPU to trigger neighbour
resolution.

The flag will be used in subsequent patches by netdevsim to test nexthop
objects programming to device drivers and in the future by mlxsw as
well.

Changes since RFC:
* Reword commit message

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 390b3a300d78 ("nexthop: Forbid FDB status change while nexthop is in a group")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/rtnetlink.h | 6 ++++--
 net/ipv4/fib_semantics.c       | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 31be7345e0c2e..5fb40c0c57ffd 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -396,11 +396,13 @@ struct rtnexthop {
 #define RTNH_F_DEAD		1	/* Nexthop is dead (used by multipath)	*/
 #define RTNH_F_PERVASIVE	2	/* Do recursive gateway lookup	*/
 #define RTNH_F_ONLINK		4	/* Gateway is forced on link	*/
-#define RTNH_F_OFFLOAD		8	/* offloaded route */
+#define RTNH_F_OFFLOAD		8	/* Nexthop is offloaded */
 #define RTNH_F_LINKDOWN		16	/* carrier-down on nexthop */
 #define RTNH_F_UNRESOLVED	32	/* The entry is unresolved (ipmr) */
+#define RTNH_F_TRAP		64	/* Nexthop is trapping packets */
 
-#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | RTNH_F_OFFLOAD)
+#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
+				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
 
 /* Macros to handle hexthops */
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index a308d3f0f845c..48516a403a9bb 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1705,6 +1705,8 @@ int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nhc,
 	*flags |= (nhc->nhc_flags & RTNH_F_ONLINK);
 	if (nhc->nhc_flags & RTNH_F_OFFLOAD)
 		*flags |= RTNH_F_OFFLOAD;
+	if (nhc->nhc_flags & RTNH_F_TRAP)
+		*flags |= RTNH_F_TRAP;
 
 	if (!skip_oif && nhc->nhc_dev &&
 	    nla_put_u32(skb, RTA_OIF, nhc->nhc_dev->ifindex))
-- 
2.51.0



