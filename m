Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214392222B2;
	Mon, 23 Jun 2025 22:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717639; cv=none; b=DYEfpHBLUt8oKfUzL+sz2QfP9WzVAap+oTgI+8HuCNfDqvFOLJEv4gnrBQvlA2DuAtyYY+n1aDeOdWNrEx8rU5XQlaShP8UE1rNV6l85X3Hh/aLHDdAsYGIcrQPXfGE6cCZKv1bn2EIEgrE0ZaoINeYxdCheBeJfORq6+IydnDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717639; c=relaxed/simple;
	bh=ykPFD3Wj3gAdVcA1X1l/X0AMtr74pmDWbbRDprma2GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaoIBbfAP/c8W8wLX3/O0Ow994jBW2/uhZPkZa+PZVnkFf07JW32z61+t6JaH714uHkpVuyXxKV2UdPxp0t7lnm5olKYq8ngC5ecE8rSfKCZUu1GMnJk4LjbQB3kPKNyHacxPCN1rJIXw/upi8jhEUHZkYKHw7itQ1w6/sZssos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5f3sHJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5f3sHJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD58C4CEEA;
	Mon, 23 Jun 2025 22:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717639;
	bh=ykPFD3Wj3gAdVcA1X1l/X0AMtr74pmDWbbRDprma2GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5f3sHJhckJH77ygR29vhtgsYs9vHTtijqAsOWOHv1CnwskPqufcFUtIaNq5NK1fW
	 FR7cjJfpB4ON8SXqZCTFNSwitXcPc/zKYf7grVWkLunDSqboJGTabze8KO5EEgn4SU
	 62TOupSfJ436Y5SmrTOGVTvq/8MTMpNaTY99u09s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haixia Qu <hxqu@hillstonenet.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 485/508] tipc: fix null-ptr-deref when acquiring remote ip of ethernet bearer
Date: Mon, 23 Jun 2025 15:08:50 +0200
Message-ID: <20250623130656.989031119@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f5bd75d931c1b..e1305d159834b 100644
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



