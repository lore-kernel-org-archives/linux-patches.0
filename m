Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF933370E2;
	Fri, 17 Oct 2025 15:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714287; cv=none; b=YQrEfWSRZhewWECtZSFa0w7jMmG9axD31Ynm4jo26rqXgi9SrUiCAmP+Yp6N8zKQJTqezX7kxGR6PaK2OHwA6KysiKzrScSUPZ6m+VKjvrfb5DZXroINisbK0LRBq5Eqb7eOey6ahIPOwoLJ3/JyaA6e94mZBI3mBJfPZ25y9SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714287; c=relaxed/simple;
	bh=GzWurK5W9ttN1tBguc87W+9UCKiXWOGMDvXFJDUwbMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTOAHWC2Wc4VtKUJ0Wfapt6/8L4eTy0ry6s7Nr3mRFRQmiO4bc98Nd7tff/3HcI38MnkOAEyEnOl7T7qeUAMZfbkQIlRgOze0Ujc+UA0JY5ymjLfuNtIdwmtVSvG8X29mu+kntIilCxg/ZXlyjjqOUjZqs9ZEUhLKrgJMtQ/Qzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bH/qiJE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bH/qiJE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E896C4CEFE;
	Fri, 17 Oct 2025 15:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714287;
	bh=GzWurK5W9ttN1tBguc87W+9UCKiXWOGMDvXFJDUwbMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bH/qiJE1HOu5Df0V+2grXHCEiQoT0pBDwmP6k5PbnfZ7CLcH3T+hC8KeFmESIJxVr
	 s8VVtoNa7H1IiZyrqjD8L6b93euzfigYfmmdmWF4IgTU6+lx3M+fxHBR1youMG1ZQg
	 MUm9y6frlvxAzOHT4LM0qytnNx/OFJrEnOXXRF/c=
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
Subject: [PATCH 6.12 065/277] bpf: Fix metadata_dst leak __bpf_redirect_neigh_v{4,6}
Date: Fri, 17 Oct 2025 16:51:12 +0200
Message-ID: <20251017145149.516895036@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c850e5d6cbd87..fef4d85fee008 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2289,6 +2289,7 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
 		if (IS_ERR(dst))
 			goto out_drop;
 
+		skb_dst_drop(skb);
 		skb_dst_set(skb, dst);
 	} else if (nh->nh_family != AF_INET6) {
 		goto out_drop;
@@ -2397,6 +2398,7 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 			goto out_drop;
 		}
 
+		skb_dst_drop(skb);
 		skb_dst_set(skb, &rt->dst);
 	}
 
-- 
2.51.0



