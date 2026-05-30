Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016D9348C72;
	Sat, 30 May 2026 16:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158387; cv=none; b=QGUI7DwlaN6XAYeXRaUxurPwZrNrVLUyOAfSosi7hIjAuo+JtGbEQ3G0Ke/VAXPfnF355Vjq3ngUkoAcMQhe6FPUbq7vMD4hNzhA6/jA5Whz+WEpMcJ5Ngk4U+5d1/+68j6gEvdq8PVuz6sD3iLamFOCoDX8v+iG2VY/s9+nUrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158387; c=relaxed/simple;
	bh=PSzaLmU8aDzvHcLmTiwXtTNPD5v+eWi6ahTXDrCItHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKtB1iDpwK1wu5/pCUOIKnwWSUNPlV3gCaYtCyoI9jYujE6Smxx6Rx8zP++Kon3EO1IfvSMAVnCKFE0b0v93Er0ZmVw2rgqiT1WNKFt0zdPu1vKGdq5oK9m6qiiEpen9inTDjc3N56+Z8nv3PespIFxalE6YLFJxS7mibAiY+BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy7A+Q4x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy7A+Q4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C88D1F00898;
	Sat, 30 May 2026 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158385;
	bh=1XLoAhmb1plVWXir3nrjI1ghzNPJhhZhNIAAjSe7XUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hy7A+Q4x6k7iOmJ/n14ymIRHZ4Tu/Kazf3sDVSI/T6Y6CTlC+eNQeVikw3IjYbcZh
	 yMQ57OsbUdcuWE19DHkQn2AJHLvDj2vwXrqwJclNMg41bQo4MUXavfeM0W8AZIMkwZ
	 QzWND0eqpm1VuFIcMboAF9WnBtwVkaaBNWqocYgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/969] netfilter: nfnetlink_log: initialize nfgenmsg in NLMSG_DONE terminator
Date: Sat, 30 May 2026 17:52:49 +0200
Message-ID: <20260530160301.656766799@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 1f3083aec8836213da441270cdb1ab612dd82cf4 ]

When batching multiple NFLOG messages (inst->qlen > 1), __nfulnl_send()
appends an NLMSG_DONE terminator with sizeof(struct nfgenmsg) payload via
nlmsg_put(), but never initializes the nfgenmsg bytes. The nlmsg_put()
helper only zeroes alignment padding after the payload, not the payload
itself, so four bytes of stale kernel heap data are leaked to userspace
in the NLMSG_DONE message body.

Use nfnl_msg_put() to build the NLMSG_DONE terminator, which initializes
the nfgenmsg payload via nfnl_fill_hdr(), consistent with how
__build_packet_message() already constructs NFULNL_MSG_PACKET headers.

Fixes: 29c5d4afba51 ("[NETFILTER]: nfnetlink_log: fix sending of multipart messages")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_log.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 6bf7d7bea1fc2..b7528fa74f3af 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -351,10 +351,10 @@ static void
 __nfulnl_send(struct nfulnl_instance *inst)
 {
 	if (inst->qlen > 1) {
-		struct nlmsghdr *nlh = nlmsg_put(inst->skb, 0, 0,
-						 NLMSG_DONE,
-						 sizeof(struct nfgenmsg),
-						 0);
+		struct nlmsghdr *nlh = nfnl_msg_put(inst->skb, 0, 0,
+						    NLMSG_DONE, 0,
+						    AF_UNSPEC, NFNETLINK_V0,
+						    htons(inst->group_num));
 		if (WARN_ONCE(!nlh, "bad nlskb size: %u, tailroom %d\n",
 			      inst->skb->len, skb_tailroom(inst->skb))) {
 			kfree_skb(inst->skb);
-- 
2.53.0



