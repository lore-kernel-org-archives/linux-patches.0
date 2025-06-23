Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AEB222581;
	Mon, 23 Jun 2025 22:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717414; cv=none; b=qwbCZ8rSnwqy8ucOmShhtJlj61mQanPFJ0tXnFQ2VWFPjeikClqJAwfQKMkMAdSIzboBwNgbDSmw1fHXJkupgqoikasyEEMayXrnotrC7gMJsR78zOgLT547tntEnBhcI4nQh53ZCBNmvkw8m14wblZizqMZJorvkp/GciM2Bac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717414; c=relaxed/simple;
	bh=lL55cnOQX+R9AWpIF5GdAmoY6RpASWAfJ/HXD7I/lcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egAlp3abNSKUyWcEWiy7L61A1pit8eEiXpWCVjIMiCotcVDGPg04RLv8GjakX2Bcsrcr7bXNIGJj3lgxl3FCXeVL/9FOR+7moYsugI6k+JlDD2hUh9BB3JGOeThAIxKgpRNG/WwaZjm4njl2pc7luwD+WKHeYyMeZTy5Veni2rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsHHjaTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsHHjaTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A331BC4CEEA;
	Mon, 23 Jun 2025 22:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717414;
	bh=lL55cnOQX+R9AWpIF5GdAmoY6RpASWAfJ/HXD7I/lcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsHHjaTk6BukN5LL/BVA2Q9PtYLwHCkvG4KU2E+ZN3DIwJN84vS4dYRajBfwnc0Tu
	 iseBtPDZ8PJtGXlO8hN3yH6qmwQgJyA4sQq2SBej2GMyQJWhL/gnckQpbYFwfWHeov
	 Q/rk8fgdc+oxTU/A9SOgONEogoWdGn0JZD8YzcdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haixia Qu <hxqu@hillstonenet.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 383/414] tipc: fix null-ptr-deref when acquiring remote ip of ethernet bearer
Date: Mon, 23 Jun 2025 15:08:40 +0200
Message-ID: <20250623130651.527566684@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 108a4cc2e0010..258d6aa4f21ae 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -489,7 +489,7 @@ int tipc_udp_nl_dump_remoteip(struct sk_buff *skb, struct netlink_callback *cb)
 
 		rtnl_lock();
 		b = tipc_bearer_find(net, bname);
-		if (!b) {
+		if (!b || b->bcast_addr.media_id != TIPC_MEDIA_TYPE_UDP) {
 			rtnl_unlock();
 			return -EINVAL;
 		}
@@ -500,7 +500,7 @@ int tipc_udp_nl_dump_remoteip(struct sk_buff *skb, struct netlink_callback *cb)
 
 		rtnl_lock();
 		b = rtnl_dereference(tn->bearer_list[bid]);
-		if (!b) {
+		if (!b || b->bcast_addr.media_id != TIPC_MEDIA_TYPE_UDP) {
 			rtnl_unlock();
 			return -EINVAL;
 		}
-- 
2.39.5



