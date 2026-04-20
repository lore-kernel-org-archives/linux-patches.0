Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BC22BD11;
	Mon, 20 Apr 2026 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701327; cv=none; b=EuEJUshYTkd/ZpxOWp5Z6aVwSQV02i9rG7/lCWHQYeT0z1YtEtMFKOkfloLRQeNzcpwKk2weTYccRGxMXsyDgz2RVAEyariZtGGky/waBRtMEzQxwxQ9rR9AnZi4SriEOGHNJW8Y6haQ4qlsqnuIkLGAdiu8/7lGwL7uOAdMMJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701327; c=relaxed/simple;
	bh=R6q9EtXCgC13p5ehgCVF8a+Ins2/cyeDydn2hAX+dQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKZjTA/fUCeRuP9cWMglpG6obOmGWffaGnmKSzXJjlYAuaabOsuhWD8IqdWZTOCe8TrSINl1nnFHR5Df9kaZZWUTZOljDSBKj7FD9nSSGJyHE0tbYJ01c4Vsad6PBxz4puxw+cQTrT1u5M0gQqKO76JdberPfpJtGGF1fXpQits=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcjGll0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcjGll0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED6DC19425;
	Mon, 20 Apr 2026 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701327;
	bh=R6q9EtXCgC13p5ehgCVF8a+Ins2/cyeDydn2hAX+dQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcjGll0Wl21yzKkvaTy0NY4dt4lUxKcgViI8q4thioLy/SazdcShycrryg+dfyh6q
	 rFAft9rgFDyWSjDHAu5M2QtTPgNizdEKsJfVrUbk9Fv2ZrXPEtrwSNp7BXp6d1eYaA
	 iEL9tatamqpmT2JNWogYX2P+usRHKUm6qIjLNFrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/162] netfilter: nfnetlink_log: initialize nfgenmsg in NLMSG_DONE terminator
Date: Mon, 20 Apr 2026 17:41:42 +0200
Message-ID: <20260420153929.572749204@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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



