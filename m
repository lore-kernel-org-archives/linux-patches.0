Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A4A51C058;
	Wed, 30 Sep 2026 18:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792742; cv=none; b=Y/QCkd2ByscBGJ4tKyYijKaKiYJtiS7Te2LQg1Dwq+A6FPMlRU9PoyCQrdfuurq1ZLlwzFLtyPz8PIiQ3Lox8twxXkFzFiQwCmpAsgzK7FSBpyoNE51eBQ/9f5HA1c5p+Ay+yEi4f2ltyinDiLLsM2+0yLAAyDMImOg1qjrTVsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792742; c=relaxed/simple;
	bh=r4nKeukdMq2aismpCwDtuVmmdtGeIMzTwQI8jcinKjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMvuBgoIlrdRMhLk4xk72hNaFyZAEUk04l5cS8MJKqDVrLoP8120qvOJn7xsAu6nvR2EPa7U7mSFx1U+oC+8Bcdt4e2umPn7BhEnvNn3xMYFbYjV+eKwIXk/EIt3fWcGH43xAO50CH+LhSrvqktqB+BAluYhl7rQh2B3GBfw+Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bo8x/2N+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo8x/2N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606001F000FF;
	Wed, 30 Sep 2026 18:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792740;
	bh=KPXYbuY52Jj/QZOOGogfzItIZGVtgEjvy9HW/vvCMdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bo8x/2N+JAwAB1BHzXLFnwYrcGlmKSWCFuYR9udplYz92oCfhraMh39XlaCSkVK7x
	 bjnxfzlNYsXrjoQ+PACm4WAOVTN1dNEDZZqjDbASXIREEol++Yb45WnCd+NAwDy0YB
	 P4LbCLQGh2kgLktmt6DWKrtLYRvNLhuDbThNh6yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Hadlaw <tom.hadlaw@isovalent.com>,
	Yusuke Suzuki <yusuke.suzuki@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/395] bpf: Fix bpf_skb_change_tail wrt csum partial skbs
Date: Wed, 30 Sep 2026 17:24:32 +0200
Message-ID: <20260930152340.838461169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3b55f350c68a0aceff108f47f9d31f47ebffaf7b ]

Cilium generates ICMP "frag needed" replies from BPF when a LB DSR
packet exceeds the egress MTU. The reply is built by first trimming the
packet down to target size via bpf_skb_change_tail(), and then pushing
the ICMP error headers in front of it.

The trim is rejected for skbs which carry a checksum offload, e.g. TCP
packets aggregated by GRO on ingress where tcp_gro_complete() leaves
the skb as CHECKSUM_PARTIAL. __bpf_skb_min_len() raises the minimum
length to the end of the L4 checksum field, so a trim to 42 bytes bails
out with -EINVAL given a min_len of 52 in this case, and due to that
the ICMP generator fails. This is not the case if GRO is turned off.

Fix this bpf_skb_change_tail() restriction and drop the checksum offload
when the new length no longer covers the checksum field. The BPF program
rewrites the skb into an ICMP error and computes the checksum itself
anyway.

Fixes: 5293efe62df8 ("bpf: add bpf_skb_change_tail helper")
Reported-by: Tom Hadlaw <tom.hadlaw@isovalent.com>
Reported-by: Yusuke Suzuki <yusuke.suzuki@isovalent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260907121025.1923656-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 35427793ddb7e..42f5688dc1fab 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3825,12 +3825,6 @@ static u32 __bpf_skb_min_len(const struct sk_buff *skb)
 		if (offset > 0)
 			min_len = offset;
 	}
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		offset = skb_checksum_start_offset(skb) +
-			 skb->csum_offset + sizeof(__sum16);
-		if (offset > 0)
-			min_len = offset;
-	}
 	return min_len;
 }
 
@@ -3847,6 +3841,11 @@ static int bpf_skb_grow_rcsum(struct sk_buff *skb, unsigned int new_len)
 
 static int bpf_skb_trim_rcsum(struct sk_buff *skb, unsigned int new_len)
 {
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    new_len < skb_checksum_start_offset(skb) + skb->csum_offset +
+		      sizeof(__sum16))
+		skb->ip_summed = CHECKSUM_NONE;
+
 	return __skb_trim_rcsum(skb, new_len);
 }
 
-- 
2.53.0



