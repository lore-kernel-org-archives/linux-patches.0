Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF24A3208;
	Fri, 17 Oct 2025 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713622; cv=none; b=Di/bBYDU+EcTSkMgFm5qbmZ0X1NYpAF4Hu3BVSyg1b9YkuVJTbh6GqMsnHYI93fYnPlNOkvy/C4RoxX8aixrSqqxs/OjTKXQGiwDXFYoMzHM15126R9KE4Sf1eZLDRA1ZqWpfrUU/QoNQkSwZij4XPsjSaKU+yPxFj7UL+ayBPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713622; c=relaxed/simple;
	bh=yXb/BSDe4yBwg21WWsS7bnInceZUudNj2w5v4K5ZkDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/Tb/0S9nG3QdPBzBa8ONiVs3hpwkHLbifN+ehkQSlo6d+zYfN4210xiWuyvc9PgJrzHsgoFO602Ym7J+d52sXCbxUd2Qh8iAU70XLAx/3izEJBIBJrPcrML1//tpYfUeYBXZiwPdBLo6T26iaRyw0fbUXxs4u61N6RVyLv0X28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZV3cgwPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZV3cgwPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D772C4CEE7;
	Fri, 17 Oct 2025 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713621;
	bh=yXb/BSDe4yBwg21WWsS7bnInceZUudNj2w5v4K5ZkDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZV3cgwPugVPecarL+6zD0Aj8ocNK3DZl7mCBr8m7tCHwpxmpBCcZDA22Rh8JgeJkw
	 J+wl+sqQVdpREihcbSazIxrHpR/tbOZ+14F19e7oHtkP0XAMerG7cDPDDY6Bm9/oZ+
	 IeTwy8qnzonNwNp9b4p56HGIgGwYFEzmwPDcZMjI=
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
Subject: [PATCH 6.6 044/201] bpf: Fix metadata_dst leak __bpf_redirect_neigh_v{4,6}
Date: Fri, 17 Oct 2025 16:51:45 +0200
Message-ID: <20251017145136.365862500@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b6dbcef649654..c2e888ea54abb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2273,6 +2273,7 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
 		if (IS_ERR(dst))
 			goto out_drop;
 
+		skb_dst_drop(skb);
 		skb_dst_set(skb, dst);
 	} else if (nh->nh_family != AF_INET6) {
 		goto out_drop;
@@ -2382,6 +2383,7 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 			goto out_drop;
 		}
 
+		skb_dst_drop(skb);
 		skb_dst_set(skb, &rt->dst);
 	}
 
-- 
2.51.0



