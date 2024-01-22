Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411D1141981;
	Tue, 23 Jan 2024 01:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972059; cv=none; b=RyW0fMTGh4hlLYTvQlUQGxtCgSdQynoGRYoZsZ+N2AlVPkQCL9tK5laWMFmg7ap7Bz8JiN+0ZAHw1CmSCfHeNNuQKNxkxZspF/GZ2W3P3Kyog6cNMOhj14eIkAa8dXDPJ1zVbv7szVDawqmtQZaNuNuq2qJB6XEJRJn7lQzfHbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972059; c=relaxed/simple;
	bh=FDWtFTpHNwMqimopcYOw2+asdZtPfu2mDaTzQiXzWdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQMdowQpxpkPQ4B2qRaLzqvkguBeLSkSwPmUY6SwCM9EeQKEy67/djzABR0bbsOAUCKEITVIvAtyfEvxrglYSRy80AfSY2k7Z6PjpmcD54pICx7qC9/Ta/RpVdq/wNmrF2/7lnd549StsQ0TmzPt7Xs3iPrn7MEyKUvJu+cL200=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mssQG+nH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mssQG+nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57E1C43390;
	Tue, 23 Jan 2024 01:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972059;
	bh=FDWtFTpHNwMqimopcYOw2+asdZtPfu2mDaTzQiXzWdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mssQG+nH1wQzHHCCcTbeLZXWW/LUQx7AIg5UqbHcAve/N/pW7Wf/gFjI86ki0o6mS
	 Wur6Nk9QDlzjzk+aKbpFCD3ac7hd1SgMnlyWley6xXIUrq8uVLqjqdswKNbNCcrcKO
	 eCRdXEg1lPCZa1O3T5UU4FXj5ZeVxJgFiO+QJ1yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 400/417] netfilter: nfnetlink_log: use proper helper for fetching physinif
Date: Mon, 22 Jan 2024 15:59:28 -0800
Message-ID: <20240122235805.584163670@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

[ Upstream commit c3f9fd54cd87233f53bdf0e191a86b3a5e960e02 ]

We don't use physindev in __build_packet_message except for getting
physinif from it. So let's switch to nf_bridge_get_physinif to get what
we want directly.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 9874808878d9 ("netfilter: bridge: replace physindev with physinif in nf_bridge_info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_log.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index c5ff699e3046..200a82a8f943 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -499,7 +499,7 @@ __build_packet_message(struct nfnl_log_net *log,
 					 htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
 				goto nla_put_failure;
 		} else {
-			struct net_device *physindev;
+			int physinif;
 
 			/* Case 2: indev is bridge group, we need to look for
 			 * physical device (when called from ipv4) */
@@ -507,10 +507,10 @@ __build_packet_message(struct nfnl_log_net *log,
 					 htonl(indev->ifindex)))
 				goto nla_put_failure;
 
-			physindev = nf_bridge_get_physindev(skb);
-			if (physindev &&
+			physinif = nf_bridge_get_physinif(skb);
+			if (physinif &&
 			    nla_put_be32(inst->skb, NFULA_IFINDEX_PHYSINDEV,
-					 htonl(physindev->ifindex)))
+					 htonl(physinif)))
 				goto nla_put_failure;
 		}
 #endif
-- 
2.43.0



