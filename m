Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDFA35F15
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jwepakzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7422C433C7;
	Wed, 15 Nov 2023 22:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085737;
	bh=Y6PnkdqmDSktNslY9H7ou//xwBdNgrCzOkFNMiuEHFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jwepakzc/db5UNTfjgfQ/oRhUExelk5QxqQLdaH8h59iLU44h2o+aa8rQIuiVTFQ6
	 h6M4/fT/X0bqAGk+LIZwxpMcQVR2/gkg6NEniwDykxMXjEEwZ4fdm2F2ofvH5LaJjg
	 OBVZRvkKSgRGKsouTwYSmHMsFrVzLBLU/0MvDcEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wragg <dwragg@cloudflare.com>,
	Yan Zhai <yan@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/119] ipv6: avoid atomic fragment on GSO packets
Date: Wed, 15 Nov 2023 17:00:10 -0500
Message-ID: <20231115220133.240679153@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yan Zhai <yan@cloudflare.com>

[ Upstream commit 03d6c848bfb406e9ef6d9846d759e97beaeea113 ]

When the ipv6 stack output a GSO packet, if its gso_size is larger than
dst MTU, then all segments would be fragmented. However, it is possible
for a GSO packet to have a trailing segment with smaller actual size
than both gso_size as well as the MTU, which leads to an "atomic
fragment". Atomic fragments are considered harmful in RFC-8021. An
Existing report from APNIC also shows that atomic fragments are more
likely to be dropped even it is equivalent to a no-op [1].

Add an extra check in the GSO slow output path. For each segment from
the original over-sized packet, if it fits with the path MTU, then avoid
generating an atomic fragment.

Link: https://www.potaroo.net/presentations/2022-03-01-ipv6-frag.pdf [1]
Fixes: b210de4f8c97 ("net: ipv6: Validate GSO SKB before finish IPv6 processing")
Reported-by: David Wragg <dwragg@cloudflare.com>
Signed-off-by: Yan Zhai <yan@cloudflare.com>
Link: https://lore.kernel.org/r/90912e3503a242dca0bc36958b11ed03a2696e5e.1698156966.git.yan@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 816275b2135fe..d3455585e6a8c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -177,7 +177,13 @@ ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
 		int err;
 
 		skb_mark_not_on_list(segs);
-		err = ip6_fragment(net, sk, segs, ip6_finish_output2);
+		/* Last GSO segment can be smaller than gso_size (and MTU).
+		 * Adding a fragment header would produce an "atomic fragment",
+		 * which is considered harmful (RFC-8021). Avoid that.
+		 */
+		err = segs->len > mtu ?
+			ip6_fragment(net, sk, segs, ip6_finish_output2) :
+			ip6_finish_output2(net, sk, segs);
 		if (err && ret == 0)
 			ret = err;
 	}
-- 
2.42.0



