Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB8C326D44;
	Mon, 13 Apr 2026 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099432; cv=none; b=jmbnSQWccp88gAs5Kkff/B9XJtR2l5Yxuy9wF73ddJkWlhLm0e5CvgurF9kFAu1sexjX93eyoAlalq8S79rRqf0w0m5kLgyQh9ZxB3WHw4iY+GmOneVCkKec9IcmUH5+VhdZ6tKHOIaYWTmEcV/YCiPEDaMaWENN129xSk1CQy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099432; c=relaxed/simple;
	bh=G+I72l8HsFzSH/NCi312oowCwmBPzsCHRd6llc9Wr+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYjfrzD3DpYq/KK8OvuTyg3QFN+xdULhxEc7uSui7Ju5MNrYuFH7CTHi7/uHGRgIRC1tsjt8OgSLIkyfZ/TWnTWTkyXvq+vQ7npL0ztQWOmsjTLKQwbzK68BBnZwseIAHJq7i7APUZQYqsDf0WB/i1WbN+J1RWQifq9DBRhgQXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVacpXZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVacpXZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5141C2BCAF;
	Mon, 13 Apr 2026 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099432;
	bh=G+I72l8HsFzSH/NCi312oowCwmBPzsCHRd6llc9Wr+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVacpXZ7n8FBmvWqXMhfvkEpEhfgsDDNJM0yyDYqzrrum85rtn2bOsfad62DHaVUg
	 gXYPzb7xyxuIAEzQ69io//XTSpNyWoS0WgSopV1xPwyy5RP4rvn7rDMwZhtvq/5wDe
	 XId8DN3Bo6T4oqANRKsj7Ir8qxyKw0lNcosxHel8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 337/491] netfilter: nfnetlink_log: account for netlink header size
Date: Mon, 13 Apr 2026 17:59:42 +0200
Message-ID: <20260413155831.656907152@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3a71ba47224c4..d41560d4812d0 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -711,7 +711,7 @@ nfulnl_log_packet(struct net *net,
 		+ nla_total_size(plen)			/* prefix */
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
-		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
+		+ nlmsg_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
 		size += nla_total_size(skb->dev->hard_header_len)
-- 
2.53.0



