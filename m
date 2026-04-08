Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7474357A20;
	Wed,  8 Apr 2026 18:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673013; cv=none; b=rBrcv15LIJrRuH8tnkY82OgcAV4q4Oz5XzRSBtkmarrWNPVG3b6MlWCPcwzXAmVlBN/j72+CjuVf9gVfksyMBVGgtvwHQg4oGFepBpMjZ1e/oeqC3zKMLSVrtJ/IN2It/klItuUHuKd5LNHTpOb2kd7gD81FyBm6yKnYNvxlHwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673013; c=relaxed/simple;
	bh=VwbFrJrlRn5oW8Q/TAoqHmuu2dQb4acWnPoWHjf36i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gqa+n2/uvZvV8RUBx4QvgxEhxlBTGtvdjSCaGyGQnL07aD/sBIV6lNDuscjATo5ruxU0VghHkGB82M/UB3xUPCPEMmeNd0nTroHwMPFmc//r6tkYVaZ9U0i8zbV7wtMzy7iT0Y47lNeGDLIX34sfCj0f/EXi9geHrhupP9DXhzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHcaTbOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHcaTbOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEBAC19421;
	Wed,  8 Apr 2026 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673013;
	bh=VwbFrJrlRn5oW8Q/TAoqHmuu2dQb4acWnPoWHjf36i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHcaTbOLbgarkGK4hHzF+Y3TForptBhjl2mZBCoUqyucr6Iwu8qK8OEmQ3SHljqqC
	 KScJw2N7n8DbDthrWZ1ZpttXf5uM7f9QjVJA7ZbEsKOFJCgPduNDIP1jdy9Oj9mJo2
	 iimp2CWAsmEknoY/RKo7HeOdHaf8GrsUWe9X92PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/277] netfilter: nfnetlink_log: account for netlink header size
Date: Wed,  8 Apr 2026 20:00:52 +0200
Message-ID: <20260408175936.362725811@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 27dd35224e629..dcd2493a9a404 100644
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



