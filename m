Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E3E2BEFFF;
	Wed,  8 Apr 2026 18:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673845; cv=none; b=DKvHeRd6XtrolhIPadjnYu8RVWsZPMFhZ+I4E2bPEMZ+M3Zrf5e4bPIyAng6MMMen2dy9JhLzINjF16Jk1jmb3Avh82rwzQTH7kdUAujCGHt9xfQJeMPa+yMeBnuKZUAPKwmlpC9Dyxs9hyVAYyhgWGe3C1hZVu3wCqNn0yKUro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673845; c=relaxed/simple;
	bh=BcW8o95v93zZOIkFUXiQwevzTsfErh8FRIwkgIQOu/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dceq3dr8+rxQnZnIhi0Nd4pdLDQTmuxwAoSmDMIKD5FVidLJcm77+YwNg5OWJY9iUJqFrKHmG8M8bWejKogsbMyrwSIEQ1nQhB2X5TYecp8zjC/yiQeulR1l4lFlk8Cz2RauE4BPIiQuJgoPwyb/eztGZil2A0cb1e8tEnDhscQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNJBTDMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNJBTDMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB524C19421;
	Wed,  8 Apr 2026 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673845;
	bh=BcW8o95v93zZOIkFUXiQwevzTsfErh8FRIwkgIQOu/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNJBTDMrKJZU5aQXo0Ds8Xit9PUUcflphAaLBg7gbQLPMofRYqJfIu+Vt531xFqGK
	 8eK2xR8EpVrzeuHW3NMMc6xWlXnRQyEKnxnbr/xp0X1pvh+jH8wL1Uxzt5f3VPhNI4
	 FT99dLYWhJxIT13HhYzB2jRBUwZwWX67iiY4g2vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/242] netfilter: nfnetlink_log: account for netlink header size
Date: Wed,  8 Apr 2026 20:01:49 +0200
Message-ID: <20260408175929.666639350@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6d52a4a0520a6696bdde51caa11f2d6821cd0c01 ]

This is a followup to an old bug fix: NLMSG_DONE needs to account
for the netlink header size, not just the attribute size.

This can result in a WARN splat + drop of the netlink message,
but other than this there are no ill effects.

Fixes: 9dfa1dfe4d5e ("netfilter: nf_log: account for size of NLMSG_DONE attribute")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index aa5fc9bffef0c..f96421ad14afb 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -726,7 +726,7 @@ nfulnl_log_packet(struct net *net,
 		+ nla_total_size(plen)			/* prefix */
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
-		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
+		+ nlmsg_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
 		size += nla_total_size(skb->dev->hard_header_len)
-- 
2.53.0



