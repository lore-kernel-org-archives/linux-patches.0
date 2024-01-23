Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D865823CA;
	Tue, 23 Jan 2024 02:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975779; cv=none; b=QnkgQ+tTPDYWqeX1fGUdk7Wmk0yLRYHKuqpQbhJWKPcIEcUYr2bTClYu1p2l7zuCLYGvW+93kDxcejg5AKxxohD1EZwHMr4ENaZ4LIcE9oWAWU9bDH2POyvhswL19psjD8WbpI6gY9UejwaNxfJqY5gWvr4nMyJeHkJ0ANJE6iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975779; c=relaxed/simple;
	bh=nKUh8jelO/JGTdISYsgqzYsWrFdV8NYNysDn2y2Uwyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfDL5M1avNIsrPzS0H0bWSsbxynyQenzgoinQ2v9N/mfhBPBHiRvYklG2TnAlB3FJAEh2FBS2+s/EfjscxqdeRuRL4fgGVFgrqKcWYWLx3tKs61IdniupY4F7jdwy0QVHtN5HhSipbHn9phipRzg+BSoRCg5MDCTo9YXt4kHMmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQvWNu71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQvWNu71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF14C433F1;
	Tue, 23 Jan 2024 02:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975779;
	bh=nKUh8jelO/JGTdISYsgqzYsWrFdV8NYNysDn2y2Uwyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQvWNu71wVh11IR+S1400WVMcyfDHJyYjJ7Yjlf4ZIpHazgRicLcb2tdvkQCg6h5C
	 +YmO/scvZoKXxnu/YkAKslAuMlnrM14k14+/s+FW2HhkF/YdXpO/hPc9bUoJqP16yn
	 UStstE+YIv+h/QHvYCpCzgcUMVh5J+NI4jaB8avI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 562/583] netfilter: nfnetlink_log: use proper helper for fetching physinif
Date: Mon, 22 Jan 2024 16:00:13 -0800
Message-ID: <20240122235829.366210865@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



