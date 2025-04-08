Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA5D264FB6;
	Tue,  8 Apr 2025 10:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109669; cv=none; b=iurVv5f/xADz4ApnihJpi2TyPu6d/FvjR4SmNSnqvvU8SFJJf49fIPrRloQ4m/iKPlQ+jksrqxc8jqUveoac87RIyzibnRQX6L+dTDWPlTr5XF/nM6P2pq9BhvdMooft/NlbGtsRnMs/IaZm8yRfT0TJfl2iAmXSyUUraUDUW6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109669; c=relaxed/simple;
	bh=vjS18xhvJFnp1OkDXIqmgyOYc4ehhHy6rcBhRgD7p7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxTI7nRfbDgDW0WbJVV5YPvbdNYptKyR2F795wrhq0aNEC9435W/C1ORfTRlMNkVZ4plNd2b0nIL7S3dD8LghW66JNd2sQHu79jC8lxwD7YW2e1zwvXnXI5h4ehWTAFCQ3wwBdh2qUaAKN7Pf/z9aRhFc9m8oKdq6uECcv5Q2xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzE9Z8Ym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzE9Z8Ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BC0C4CEF1;
	Tue,  8 Apr 2025 10:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109668;
	bh=vjS18xhvJFnp1OkDXIqmgyOYc4ehhHy6rcBhRgD7p7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzE9Z8YmCtjySjgNwBVgsORj/uHQp0g5SHVjCcsJyI8m2/Sud4vHqOl2c4uqsWdAw
	 1JnEJQoDnUMXXvU7gwtlxkaeDtSNTRGH5MD0wrIqparioBk7DOzv+LPYKbC74Ox4cY
	 1QmF21aQgNJ+a6csUg4e2TbmbG4om5CltJFS3jks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/227] netfilter: nft_ct: fix use after free when attaching zone template
Date: Tue,  8 Apr 2025 12:46:28 +0200
Message-ID: <20250408104820.699516904@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 34243b9ec856309339172b1507379074156947e8 ]

The conversion erroneously removed the refcount increment.
In case we can use the percpu template, we need to increment
the refcount, else it will be released when the skb gets freed.

In case the slowpath is taken, the new template already has a
refcount of 1.

Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 5cfe5612ca95 ("netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 78631804e5c53..4b75c7113de4d 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -260,9 +260,12 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
 	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
+		refcount_inc(&ct->ct_general.use);
 		nf_ct_zone_add(ct, &zone);
 	} else {
-		/* previous skb got queued to userspace */
+		/* previous skb got queued to userspace, allocate temporary
+		 * one until percpu template can be reused.
+		 */
 		ct = nf_ct_tmpl_alloc(nft_net(pkt), &zone, GFP_ATOMIC);
 		if (!ct) {
 			regs->verdict.code = NF_DROP;
-- 
2.39.5



