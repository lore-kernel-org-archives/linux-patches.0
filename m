Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3C0329C45;
	Mon, 27 Oct 2025 18:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591327; cv=none; b=VVa733FK/xY6WuK/x9York3eKDLofS/ZtveXaFKXKuwDRJ/bxpvCHQOhuYtL54XkT4Ku3AcZJO7BNtSgjbkDxs/nFoDpXRWS0KR4Kx4rFALy+rlGTTSqEzxVOhhSxNeMaKVDDzBagx90uUt+9B5lpIoxNjA1K6bUh8zVgh3ZnKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591327; c=relaxed/simple;
	bh=qUO+zv1/vVL/l3GKzJ4QiM+7Val9Ho/VMBbBO+Rq2JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wb5bWRtj/ecMvVQk0/qikn9ShRtT9KdT07VKR6JaWFy3TXDt30Vy943tHHqLFIVKUAkM1HmR4zR9RXqU9ddKY3DGgVA+cSLAXEJumNhuMrsy2HhUF9pJktNz59ypF4dDvC11zRJ5EkEFaYu6vww8ozaTG7NlohqGTTDHpqT8ShU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZO2Zjwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZO2Zjwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9E2C113D0;
	Mon, 27 Oct 2025 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591327;
	bh=qUO+zv1/vVL/l3GKzJ4QiM+7Val9Ho/VMBbBO+Rq2JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZO2Zjwe8zXH2Tdt+y7CdPy7G5OceJRvuH24WAL+u1jMlNeqCzZe/l3170jhuliE2
	 x2mGLm64nP8iCkDTvWBZFt1alpg7lAi8Il4IVf73958+NIc6bE0gVPZHROMZ7VPxmc
	 MCSVMq8O6HfAxeGIIUMgKXfkfffgLvXwUAL9X7IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yusuke Suzuki <yusuke.suzuki@isovalent.com>,
	Julian Wiedmann <jwi@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jordan Rife <jrife@google.com>,
	Simon Horman <horms@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/332] bpf: Fix metadata_dst leak __bpf_redirect_neigh_v{4,6}
Date: Mon, 27 Oct 2025 19:32:51 +0100
Message-ID: <20251027183527.729241076@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 23f3770e1a53e6c7a553135011f547209e141e72 ]

Cilium has a BPF egress gateway feature which forces outgoing K8s Pod
traffic to pass through dedicated egress gateways which then SNAT the
traffic in order to interact with stable IPs outside the cluster.

The traffic is directed to the gateway via vxlan tunnel in collect md
mode. A recent BPF change utilized the bpf_redirect_neigh() helper to
forward packets after the arrival and decap on vxlan, which turned out
over time that the kmalloc-256 slab usage in kernel was ever-increasing.

The issue was that vxlan allocates the metadata_dst object and attaches
it through a fake dst entry to the skb. The latter was never released
though given bpf_redirect_neigh() was merely setting the new dst entry
via skb_dst_set() without dropping an existing one first.

Fixes: b4ab31414970 ("bpf: Add redirect_neigh helper as redirect drop-in")
Reported-by: Yusuke Suzuki <yusuke.suzuki@isovalent.com>
Reported-by: Julian Wiedmann <jwi@isovalent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jordan Rife <jrife@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jordan Rife <jrife@google.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20251003073418.291171-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index e7d3398c4d23b..1d1d4e92cb662 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2268,6 +2268,7 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
 		if (IS_ERR(dst))
 			goto out_drop;
 
+		skb_dst_drop(skb);
 		skb_dst_set(skb, dst);
 	} else if (nh->nh_family != AF_INET6) {
 		goto out_drop;
@@ -2383,6 +2384,7 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 			goto out_drop;
 		}
 
+		skb_dst_drop(skb);
 		skb_dst_set(skb, &rt->dst);
 	}
 
-- 
2.51.0



