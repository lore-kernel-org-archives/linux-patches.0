Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC0C49CF27;
	Mon, 31 Aug 2026 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183613; cv=none; b=iVceoQ+mqDvabtzqajMmLcty1+SP7lycaT5byxL0RRW1MGU28FZI+L0Rbjn+BFsBVBcYSLuWKLwVnOTeIXLXYo/M/ttXmW/kuNnzsjeFZYdRlZ61w2BDrwDgcL5j1xOX9N6pIL1ciXUr+MFuN2Qdn4lc7GAua8mCJoB29EUiZMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183613; c=relaxed/simple;
	bh=2YBzlC4JB4P8ODYIzSV2P5wSOVlBTAG+nOeBxnH8gxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6IycfNifi4HWDZaGOwWleFfi4zuj670KgCcl2iX/8QuyeDbOnZSUwRYQm7TLmER9OyPtZR67pvUQLu7U1q8fpnn1FVzUFCw3vNmSwDKLsLhPxILvQ72gqeXq10zpoobwlDDPogLN546e13PvL8tSBgKrVP4+gfGDaNzNeBVHqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2edm9E4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2edm9E4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4F51F00A3D;
	Mon, 31 Aug 2026 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183612;
	bh=cQBMK+vdG9mbZ86tjjmqpNVywZCNebOms4jt8/YzBvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2edm9E4X43jwnNFx1DvZitK3HwW46D/yoh+yd6xw4CLcFDj5CmxgIBZd6PO+dVVF
	 LMavWf0u0zzb/I1/cdTRHX1EwPRZqfgw95eNloNfzXJswRlKGTsODCX4qbQXerl9U3
	 Hwqw/ILeVNZPIbO27W8qH75eqPdzRZgHVXu3yBNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 39/71] net: bridge: mcast: fix use-after-free of a master VLANs multicast context
Date: Mon, 31 Aug 2026 15:34:04 +0200
Message-ID: <20260831133401.204468135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit 50e5c6605cc9c2dd57bd2d1b3459674d19738983 upstream.

br_multicast_toggle_one_vlan() clears BR_VLFLAG_MCAST_ENABLED under
br->multicast_lock before stopping a VLAN's multicast context.  That is
the teardown handshake: lockless readers gate on the flag through
br_multicast_ctx_should_use() -> br_multicast_ctx_vlan_disabled(), so
once it is cleared under the lock no reader can arm the context again.

For a master VLAN the handshake never runs.  __vlan_del() clears
BRIDGE_VLAN_INFO_BRENTRY before calling br_vlan_put_master(), so
br_multicast_toggle_one_vlan(masterv, false) returns early on
!br_vlan_is_brentry(vlan): the flag stays set and br->multicast_lock is
never taken.  br_vlan_put_master() then drains the context in
br_multicast_ctx_deinit() and frees the VLAN through call_rcu(), while a
reader still inside rcu_read_lock() sees the context as enabled and
re-arms it.  The port and port-VLAN branch of the function has no
br_vlan_is_brentry() test and flips the flag under br->multicast_lock,
so it is not affected.

The reader is the bridge transmit path.  For a master VLAN
br_multicast_rcv() selects brmctx = &vlan->br_mcast_ctx with
pmctx = NULL, so IGMP sent to the bridge device re-arms the context's
timers after br_multicast_ctx_deinit() has already stopped them.

  BUG: KASAN: slab-use-after-free in detach_if_pending+0x412/0x4a0
  Write of size 8 at addr ffff88810ac39918 by task brmc/601
   __mod_timer+0x51a/0xc50
   br_multicast_host_join+0x25b/0x390
   __br_multicast_add_group+0x468/0x530
   br_ip4_multicast_add_group+0x1a0/0x260
   br_multicast_rcv+0x2cda/0x61e0
   br_dev_xmit+0x6c4/0x1540
  Allocated by task 610:
   br_vlan_add+0x111/0xb40
   br_vlan_info+0x370/0x3e0
  Freed by task 0:
   kfree+0x1a7/0x4f0
   rcu_core+0x7dc/0x10a0

Only test br_vlan_is_brentry() when enabling, like the
br_multicast_ctx_vlan_global_disabled() test next to it.  Disabling then
always clears BR_VLFLAG_MCAST_ENABLED under br->multicast_lock before
br_multicast_ctx_deinit() drains the context.

Fixes: 7b54aaaf53cb ("net: bridge: multicast: add vlan state initialization and control")
Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/D400F6C7-543A-4B79-9E5B-D1D8974DE5C9@doyensec.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4312,8 +4312,8 @@ void br_multicast_toggle_one_vlan(struct
 	if (br_vlan_is_master(vlan)) {
 		br = vlan->br;
 
-		if (!br_vlan_is_brentry(vlan) ||
-		    (on &&
+		if (on &&
+		    (!br_vlan_is_brentry(vlan) ||
 		     br_multicast_ctx_vlan_global_disabled(&vlan->br_mcast_ctx)))
 			return;
 


