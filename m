Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00FB233D65;
	Mon, 10 Mar 2025 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628803; cv=none; b=tdXdlzRSuVWnglYDKpfrIwarg1ATzfjTnsmqzGMFVlcjfJYQkJXYvUXtx0C4eYCKAElbo7Fa6FIGxUJblr8ZV6tOjw88tHT2GVACftkwMU3XBy6cux/Ci7c/KZhu9akmpWEuog8O1qxL1Cz/81hxh24AMHsLpvthWuU0VFfhczA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628803; c=relaxed/simple;
	bh=gAZ9aPV937SxG/Yxdm3brbTKFz1OjUIqr/6GSrq69rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1qSD/g/Q6BpRB2uShyiIHNLNrAQw2ZFlsxbGKMp5cvpYTWIWOhsF/2/p4KwD9kRVo13geKs4MRvU4r8zhfW6cICZCC78//mnaMPhXaRAbW/8hkdABMj2NDkNxl4X5ix0zN+hn5nUHBLH2pVgzb7UcRFRLkfrgjhwU438xsjW7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeXwT8+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeXwT8+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48204C4CEE5;
	Mon, 10 Mar 2025 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628803;
	bh=gAZ9aPV937SxG/Yxdm3brbTKFz1OjUIqr/6GSrq69rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeXwT8+1hEZMGcN98S/qmxz39215XV0r2x2oyrOTMelOf1z56iyZ2Cm/yD7tCOzav
	 opPoqviShVT4DAhZXycdt+ko49/Vy04CQ2U+4+WTWqBzsswHLFv+f6OAiXWZ2IeYeL
	 FtMCTSbz/5AnsQc9W9iDEZQ7SyopM6z/MM/5+5mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/620] netfilter: nft_flow_offload: update tcp state flags under lock
Date: Mon, 10 Mar 2025 17:58:39 +0100
Message-ID: <20250310170548.459724346@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7a4b61406395291ffb7220a10e8951a9a8684819 ]

The conntrack entry is already public, there is a small chance that another
CPU is handling a packet in reply direction and racing with the tcp state
update.

Move this under ct spinlock.

This is done once, when ct is about to be offloaded, so this should
not result in a noticeable performance hit.

Fixes: 8437a6209f76 ("netfilter: nft_flow_offload: set liberal tracking mode for tcp")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index fbb9f3a6c8444..41d04fa12f67d 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -278,6 +278,15 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 	return false;
 }
 
+static void flow_offload_ct_tcp(struct nf_conn *ct)
+{
+	/* conntrack will not see all packets, disable tcp window validation. */
+	spin_lock_bh(&ct->lock);
+	ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+	ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+	spin_unlock_bh(&ct->lock);
+}
+
 static void nft_flow_offload_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
@@ -332,11 +341,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto err_flow_alloc;
 
 	flow_offload_route_init(flow, &route);
-
-	if (tcph) {
-		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-	}
+	if (tcph)
+		flow_offload_ct_tcp(ct);
 
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
-- 
2.39.5



