Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEEA2D0602;
	Thu, 30 Jul 2026 16:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428292; cv=none; b=lBP73FoQdzHZWUuk7aEIrK9YNEZbctwogih6I+9UOgCq4cZpB+N0e6hvy82oOgV6lX8pfEkcCdERLR3L1NZpcDD6zLP0XMl4sBbgmYYxaBl7RDJd2aDvrOahx/APhP8qQ/8aKVANnhKPb5dhCUTrKY84LOScVo06w/hpmJNUND0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428292; c=relaxed/simple;
	bh=ma6W7WPvg7OtAsBEdaHO4uHf7QCPjb/q7ENJ/6x2oYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lp73FIGcrf5XhZ//hSFusd7JikkNAOsfACGbps87J+6yMntwX/eF7//K5v2M2dXyLomRx+lkNVJMTcPQbE/6P4lzgUSGEMhp7AmRjna30I8K5Yemq3Iv7RXb10tI6Orwa+sju0JjqPIPuUzV486UN0TbPXWPDnm6ebfivnyS0pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2Nqp7qe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2Nqp7qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E9F1F000E9;
	Thu, 30 Jul 2026 16:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428290;
	bh=v1SQqJEvti8dq1cGrSx/ggCizet7JCA5uun4zEF3PH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2Nqp7qeURxW3U5kn6wBu6+vx1qLAf2hLRsX90FRha8J4EaK/hhFuV66jz+biEfAn
	 EYaKT8+G6JsdxFO218kl42YQsT35adDho4PpU3sHYBOfM27WFbBHLP6Cfhfs/G8OFO
	 xmDjjME0cwlRV0FdvO6JAiYabHW1Sz17C9D20X6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 415/484] netfilter: nf_conntrack_sip: remove net variable shadowing
Date: Thu, 30 Jul 2026 16:15:12 +0200
Message-ID: <20260730141432.492428572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7970d6aaf710db166de98c5356a260089896fae5 ]

net is already set, derived from nf_conn.
I don't see how the device could be living in a different netns
than the conntrack entry.

Remove the extra variable and re-use existing one.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: e5e24a365a5e ("netfilter: nf_conntrack_sip: validate skb_dst() before accessing it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_sip.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -948,9 +948,8 @@ static int set_expected_rtp_rtcp(struct
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 	} else if (sip_external_media) {
 		struct net_device *dev = skb_dst(skb)->dev;
-		struct net *net = dev_net(dev);
-		struct flowi fl;
 		struct dst_entry *dst = NULL;
+		struct flowi fl;
 
 		memset(&fl, 0, sizeof(fl));
 


