Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F974E1D0;
	Tue, 23 Jan 2024 00:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970258; cv=none; b=AVcQBBrB4rSzWk9CP9pj/eu45B4I4EQai23x5OV4vfN0Jz14Iw0i/NI3vWpzxw9uSk9G5NacocqO4soRPlqL0QkoFK3n/4Cgu39FWeIcG6mAifIdwUCtup2M1teF9R+s7ZQyGEbsaPPu/cIe7LjReQeDdBh0v8q+GTiuwQMcE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970258; c=relaxed/simple;
	bh=tiuLIYSvF8khw55+qsnZh6oeq9ZanS0K1E4CyAE2U9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOlNB9uZ8hv8v/VH//Ivi39oNfuxgBJT7RQUa79wYVXTiIPFAePsUkfBZP7xh3DzOB/WVWe65sc2V5Usy57E9jz+2bzBmhE4wTtaSysgsu1vE0mGenUGHSs+7wdoe94x0y3G5pEFYyf4GQh+GyJ4Z1xLc/lzQ0fg+y1Za/cu6kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukbLMnsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukbLMnsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA76C433C7;
	Tue, 23 Jan 2024 00:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970257;
	bh=tiuLIYSvF8khw55+qsnZh6oeq9ZanS0K1E4CyAE2U9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukbLMnsUCMtSbc8LYJ6A/Q+jj4IldDrmNd82CfxJemZlDx7qklyamdFP0XczpxPwk
	 H2BAumZg06GdNbAdzVXltL5/EnC6K5jdlVNRf0SE7CJRzBuiOFCZLRCUhugzuIYOuG
	 veK97pBgAC4JhSDmKOnwI9ufG/TiDWzHUnilJG38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 621/641] netfilter: nfnetlink_log: use proper helper for fetching physinif
Date: Mon, 22 Jan 2024 15:58:45 -0800
Message-ID: <20240122235837.686269932@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index f03f4d4d7d88..134e05d31061 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -508,7 +508,7 @@ __build_packet_message(struct nfnl_log_net *log,
 					 htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
 				goto nla_put_failure;
 		} else {
-			struct net_device *physindev;
+			int physinif;
 
 			/* Case 2: indev is bridge group, we need to look for
 			 * physical device (when called from ipv4) */
@@ -516,10 +516,10 @@ __build_packet_message(struct nfnl_log_net *log,
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



