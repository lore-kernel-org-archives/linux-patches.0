Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3412E2253B0;
	Mon, 23 Jun 2025 21:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715995; cv=none; b=ijDIR95w96TRnhFSdeiR7sqYYVHBDasiUMZPrDw/OPID6w3eCYvhOPxBFPamSF0BjuHW5EsFhVQ0X5EXKKN8qoqso6RQsvRmoa2eXoN65WOxRoPF3Wc1mFjm8JYTDrWhwQ5p92+HJDONBsQvBz3ndvS4Yx326b+rvfhbJWcO2fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715995; c=relaxed/simple;
	bh=Re1gODyhEOoOGQtZLlRrr/5kGcnqEhO3C3/wAiNhAlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gX+JDsyBquL1jEIGqvJPQ/yTN3qnCtJ0KcecRGmWaF6Cj31Bwv0eN6HLrxf1xj4bz3Iqi2LhN7v5GRkzhzamrfCcsZ8e6Kw3UhNZw85DWKbweZ/p+x/ObGE04LqDYMarz/W4ynjJVMAJX2ahV/LgUrl8YeeQ1BCSP1EOYCcuADM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2A6IXbhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2A6IXbhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1448C4CEEA;
	Mon, 23 Jun 2025 21:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715995;
	bh=Re1gODyhEOoOGQtZLlRrr/5kGcnqEhO3C3/wAiNhAlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2A6IXbhzcJfxS/yzunIq8z+yTzZY6sZXp3N+Ghs2gy/8dzfc9AEKXoc23A10dY76I
	 P+j7ZHmlP2GwPMYOz+5vSOxuj3I4uj0nK4hq4SW/K5PsCG1MmmmIr/pON8MFTaSOF2
	 fsxnytmcB9/ozf1dCQERI0Qt4yfnCXjRMNdsCvjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haixia Qu <hxqu@hillstonenet.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/355] tipc: fix null-ptr-deref when acquiring remote ip of ethernet bearer
Date: Mon, 23 Jun 2025 15:08:35 +0200
Message-ID: <20250623130636.217851845@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haixia Qu <hxqu@hillstonenet.com>

[ Upstream commit f82727adcf2992822e12198792af450a76ebd5ef ]

The reproduction steps:
1. create a tun interface
2. enable l2 bearer
3. TIPC_NL_UDP_GET_REMOTEIP with media name set to tun

tipc: Started in network mode
tipc: Node identity 8af312d38a21, cluster identity 4711
tipc: Enabled bearer <eth:syz_tun>, priority 1
Oops: general protection fault
KASAN: null-ptr-deref in range
CPU: 1 UID: 1000 PID: 559 Comm: poc Not tainted 6.16.0-rc1+ #117 PREEMPT
Hardware name: QEMU Ubuntu 24.04 PC
RIP: 0010:tipc_udp_nl_dump_remoteip+0x4a4/0x8f0

the ub was in fact a struct dev.

when bid != 0 && skip_cnt != 0, bearer_list[bid] may be NULL or
other media when other thread changes it.

fix this by checking media_id.

Fixes: 832629ca5c313 ("tipc: add UDP remoteip dump to netlink API")
Signed-off-by: Haixia Qu <hxqu@hillstonenet.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20250617055624.2680-1-hxqu@hillstonenet.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/udp_media.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 25e733919131c..881f4c160dbf5 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -481,7 +481,7 @@ int tipc_udp_nl_dump_remoteip(struct sk_buff *skb, struct netlink_callback *cb)
 
 		rtnl_lock();
 		b = tipc_bearer_find(net, bname);
-		if (!b) {
+		if (!b || b->bcast_addr.media_id != TIPC_MEDIA_TYPE_UDP) {
 			rtnl_unlock();
 			return -EINVAL;
 		}
@@ -492,7 +492,7 @@ int tipc_udp_nl_dump_remoteip(struct sk_buff *skb, struct netlink_callback *cb)
 
 		rtnl_lock();
 		b = rtnl_dereference(tn->bearer_list[bid]);
-		if (!b) {
+		if (!b || b->bcast_addr.media_id != TIPC_MEDIA_TYPE_UDP) {
 			rtnl_unlock();
 			return -EINVAL;
 		}
-- 
2.39.5



