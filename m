Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2C24E1D0;
	Tue, 23 Jan 2024 00:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970262; cv=none; b=J8GQWs8w/bwJQ5Y2vt6cDP+UKlDZ/xWvm+8ZXON6AOySnZW12ncY8sCnsAyjZz7+siC7x3G+KlLMTo8K8tbfWj0/+Y7tsF0j4HD2apeoN6ih7kDsh4DBLFETXemE7YSB4rDWBMTw4/oZ4N58IXMoqg1jMz+x+3HtmvZXO63y+Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970262; c=relaxed/simple;
	bh=rZNLVV1kC+EcnF+A9r927mwcXMwonbMfhqkDgGl+dcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtOI8VA9o1DMW8byBWEByktlOtT418VWTvNVHsEHzNKqv1+INteePw/S02oa4CpuJB5d1DDUhiLRXvj5AXwmUgMvsknl+bmuwlSqMQ0qhMZ5yXNshnXcnbY8TwaZWDNRR00qg0YHzF/OKeRYyQBfa5UxRUW7vSrIhRZZ/5deVWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzbS7QsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzbS7QsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76544C43394;
	Tue, 23 Jan 2024 00:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970262;
	bh=rZNLVV1kC+EcnF+A9r927mwcXMwonbMfhqkDgGl+dcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzbS7QsXL2ZHI+blx8KMdqHUWW4vNSTgtgZOjcyVAeXLa0bPRlkr4iMS/FRcFHic2
	 yKRDYztw34xeE0Os17a67HYbqFnYY02rsqaMFKuOM0F9h0rwTsNN5o6s+UtS0vr0BV
	 urE8Hbi0MfXaS3JQDAk/eeVQb8z/2AV6x+9Jv0pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 622/641] netfilter: nf_queue: remove excess nf_bridge variable
Date: Mon, 22 Jan 2024 15:58:46 -0800
Message-ID: <20240122235837.720150187@linuxfoundation.org>
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

[ Upstream commit aeaa44075f8e49e2e0ad4507d925e690b7950145 ]

We don't really need nf_bridge variable here. And nf_bridge_info_exists
is better replacement for nf_bridge_info_get in case we are only
checking for existence.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 9874808878d9 ("netfilter: bridge: replace physindev with physinif in nf_bridge_info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_queue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 63d1516816b1..3dfcb3ac5cb4 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -82,10 +82,8 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	const struct sk_buff *skb = entry->skb;
-	struct nf_bridge_info *nf_bridge;
 
-	nf_bridge = nf_bridge_info_get(skb);
-	if (nf_bridge) {
+	if (nf_bridge_info_exists(skb)) {
 		entry->physin = nf_bridge_get_physindev(skb);
 		entry->physout = nf_bridge_get_physoutdev(skb);
 	} else {
-- 
2.43.0



