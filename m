Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F69423645D;
	Fri, 24 Apr 2026 13:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037826; cv=none; b=RMbZR9gbjsbzhZHgnFHvlxp7oK2C82gejAP0EIJowKx85bp/y4+MwJ/TVX6XICfFyvLUC9RfqRAPzFvLp6AlsoFw7ICdsz5hK+7+yxgUuRbYHCczr6W+Tqvkj7cyy4p3pH+OPSN/SYgOd5+EDrTtWeccAE1Qo+mwFxUesDcY+XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037826; c=relaxed/simple;
	bh=tAnEn2VsGs/MA0dp42APPbaAIxCcBA4rHnwbYCFFWEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCK6xEKKdeN4DqCgtnsTozNXiz2V/zhVWmAmzdqH2bW5s64FpwGXxXWmsl+fbdWin+WjbbPAbCNgriXoZEavbhGXLUIdAWOPEJxe+7RLPAc1AhZr5E0NkSemxDybUmoKdFiwHaCshWeoakl4qxDnKgv9+VkPkb8BZ/zeHY6nsrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLl8l8uZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLl8l8uZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1638BC19425;
	Fri, 24 Apr 2026 13:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037826;
	bh=tAnEn2VsGs/MA0dp42APPbaAIxCcBA4rHnwbYCFFWEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLl8l8uZpP/4sfGULYiobdJ4QZ/0XnTdfSQ7uyjpkHuQj7cebaY7BT93eL3qHjENZ
	 VrFHN/rOyeI5MVy8B4nfaqA0s+POxqPwDZt5rPby95J4+gjrQeoo/Rl8rrFshl3q8S
	 rbAxY/93BS4UwKDiEmAcb1c7ANNaso1NnRbcvMdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/166] netfilter: nfnetlink_log: initialize nfgenmsg in NLMSG_DONE terminator
Date: Fri, 24 Apr 2026 15:29:26 +0200
Message-ID: <20260424132543.705606386@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f96421ad14afb..3da32d2f68e09 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -361,10 +361,10 @@ static void
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



