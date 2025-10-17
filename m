Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B7F32E14F;
	Fri, 17 Oct 2025 15:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713688; cv=none; b=VAG9uMwupNpuRuIgYlPHRc0r0wn/fB5xQ40tJB3trc9F/DdieLcm5cjs1Rg4G2fGva76cnfczgjuk9atCh5uAS+fTZmYE9PFwjuoASr+B62FrgkKNd5KXLRwxQNFMLgoens6fOxPLEUsTSE0w9BBnxlDSIeVCRYhoblzvAsc7kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713688; c=relaxed/simple;
	bh=Iwv6qradxyLqU/p6IbgDgiR60ynA0hYbbmT5V9czOTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBMY3IUAakwzUiVDQly41Z5n+zB9MopRUTKhm+72VzrXkTS+dM7UB8lVWW8mGDmV0GJS26wF3enQGdIl9WftladbBJot1zUvS95HTpkeqCiSZ8V9VEC59sjnfIAjntV1yUgc1AP00TtWysZNuBM/ilx/AyG25/7foVy9Hx4hPU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcji2Mgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcji2Mgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64D2C4CEF9;
	Fri, 17 Oct 2025 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713687;
	bh=Iwv6qradxyLqU/p6IbgDgiR60ynA0hYbbmT5V9czOTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcji2Mgqni7m8pp7PgvO4EQUm2Iu6G9cqxig41Uy2GFKs4K3NeSQfGQsGGGQGWVxv
	 EvSEsME2TiWT+ZVhM1qzS81mgoiDtzE6r02OOxoB6Rim9BFpud7VPlDEtIt/QBdMN2
	 nGLSlKOoGHuJ9/NbQ8zSwX2VDZGyC2kLYFBGtLUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/201] bridge: br_vlan_fill_forward_path_pvid: use br_vlan_group_rcu()
Date: Fri, 17 Oct 2025 16:51:52 +0200
Message-ID: <20251017145136.619664443@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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
index a1c22eab71ffe..cc54b8267bcc7 100644
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



