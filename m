Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B9726FD9B;
	Tue, 17 Mar 2026 17:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767489; cv=none; b=WyZleL4KfJhmcfukQUxxg2UjMOL5O0dQCwGgVbLJcb2B+gvt/oqm9AYnkF2w5i1fPYY/0+Qjs7MkHxV0ouZ2vhdsOWLBHCEknq+YgLb18RP7JwBeEE3VCDA3vgTlzNn1cShQWGBMOJpraL2UD6SUwSfgjA1pRUbqyi0kPKGmZ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767489; c=relaxed/simple;
	bh=YSS+Nz4cxgTk5Ym+arzawnrVxshK4sG7gjfBBsrkKK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyINpsQtQiHAAFCTzp9vs0raPXzrXy2djEOWVxym+iUYE6jFkwMI+hZE1Fok1DjM3YEcUR2qh4RmjOP9u25/qFstmmwDCt9r5ILsja+mlv0TYoyp4O8bPOeP4fthNTm1rhjTVO2Z7fcbtA+1sTMdiTi3M4R/z+D3vHjFNKM/11c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGj5gwrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGj5gwrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DCDC4CEF7;
	Tue, 17 Mar 2026 17:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767489;
	bh=YSS+Nz4cxgTk5Ym+arzawnrVxshK4sG7gjfBBsrkKK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGj5gwrCZ6iGGtiCqXqpyEwY5bS2P3Tc1D/HszU8U45SaYISMl+n6UDvyJBc1DNRu
	 e4BKPPKyVvl3BYDyCi/r8l8ToKUj/pC2HMIELUyKMHwGUJYAaQ9C38lsvKXdij1sNT
	 ige32CswWq8P0U9UBOUGg4an6zt5kTZZur4HtJlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Dull <monderasdor@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/333] netfilter: nfnetlink_queue: fix entry leak in bridge verdict error path
Date: Tue, 17 Mar 2026 17:31:39 +0100
Message-ID: <20260317163001.972740664@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit f1ba83755d81c6fc66ac7acd723d238f974091e9 ]

nfqnl_recv_verdict() calls find_dequeue_entry() to remove the queue
entry from the queue data structures, taking ownership of the entry.
For PF_BRIDGE packets, it then calls nfqa_parse_bridge() to parse VLAN
attributes.  If nfqa_parse_bridge() returns an error (e.g. NFQA_VLAN
present but NFQA_VLAN_TCI missing), the function returns immediately
without freeing the dequeued entry or its sk_buff.

This leaks the nf_queue_entry, its associated sk_buff, and all held
references (net_device refcounts, struct net refcount).  Repeated
triggering exhausts kernel memory.

Fix this by dropping the entry via nfqnl_reinject() with NF_DROP verdict
on the error path, consistent with other error handling in this file.

Fixes: 8d45ff22f1b4 ("netfilter: bridge: nf queue verdict to use NFQA_VLAN and NFQA_L2HDR")
Reviewed-by: David Dull <monderasdor@gmail.com>
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 34548213f2f14..0b96d20bacb73 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1549,8 +1549,10 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (entry->state.pf == PF_BRIDGE) {
 		err = nfqa_parse_bridge(entry, nfqa);
-		if (err < 0)
+		if (err < 0) {
+			nfqnl_reinject(entry, NF_DROP);
 			return err;
+		}
 	}
 
 	if (nfqa[NFQA_PAYLOAD]) {
-- 
2.51.0



