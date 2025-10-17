Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF7B2F12BE;
	Fri, 17 Oct 2025 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713094; cv=none; b=UO7vss8IVBD5B/WP9122ZknhX5rG7JcNMgQpPzlHwzbD98eaveZtiA51XcAaeHa9eN26imMMfEXylLBff5hvOLRihWHiu2ld83aTk6MaIVimmXvGtOwlsb6VKAs5A3oS+SK+kuVQ3TFp6dEGar4A4X5Tmm40hL3ZsB/AgS8adwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713094; c=relaxed/simple;
	bh=VDB+gY3HOyo00Lo56l2R3vp/bQkTGSqJ2rFFNdHLKFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG2RXtibaZ0BwoGr9qzRilwad+QuO8ISft5SS6aLgORdC9eyQJp331ote/91mwfzs4Tp31G9baPuFrVwS69+QFAOuOwizL2X4J3si0wbX70IQZS2T2SBTLjnpw46hfHb78XINbXDOW4fKEE4hCiQfv4Tvu6wMUM0rbJnrcyfZ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mj/s8K9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mj/s8K9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B273C4CEE7;
	Fri, 17 Oct 2025 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713093;
	bh=VDB+gY3HOyo00Lo56l2R3vp/bQkTGSqJ2rFFNdHLKFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mj/s8K9SpyIfE3uC1G9fVayiIH4f53rnoOZkQoGOvvdUFetwgDzuOon18PZf3N4qU
	 tSEHOTGlAS3LyOWB2fDvO2v5J8BBE05G4TI3ehRkreCzMhE+8fFvdKoAOYj70SrHGK
	 y6VvILh9FTohjOmz56BEAsQEQM1BPTHpWCCIi9qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/168] bridge: br_vlan_fill_forward_path_pvid: use br_vlan_group_rcu()
Date: Fri, 17 Oct 2025 16:52:04 +0200
Message-ID: <20251017145130.678386929@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

From: Eric Woudstra <ericwouds@gmail.com>

[ Upstream commit bbf0c98b3ad9edaea1f982de6c199cc11d3b7705 ]

net/bridge/br_private.h:1627 suspicious rcu_dereference_protected() usage!
other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
7 locks held by socat/410:
 #0: ffff88800d7a9c90 (sk_lock-AF_INET){+.+.}-{0:0}, at: inet_stream_connect+0x43/0xa0
 #1: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: __ip_queue_xmit+0x62/0x1830
 [..]
 #6: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: nf_hook.constprop.0+0x8a/0x440

Call Trace:
 lockdep_rcu_suspicious.cold+0x4f/0xb1
 br_vlan_fill_forward_path_pvid+0x32c/0x410 [bridge]
 br_fill_forward_path+0x7a/0x4d0 [bridge]

Use to correct helper, non _rcu variant requires RTNL mutex.

Fixes: bcf2766b1377 ("net: bridge: resolve forwarding path for VLAN tag actions in bridge devices")
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 23a82567fe624..54b0f24eb08ff 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1455,7 +1455,7 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
 	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
 		return;
 
-	vg = br_vlan_group(br);
+	vg = br_vlan_group_rcu(br);
 
 	if (idx >= 0 &&
 	    ctx->vlan[idx].proto == br->vlan_proto) {
-- 
2.51.0



