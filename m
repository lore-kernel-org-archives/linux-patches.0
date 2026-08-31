Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A8E4BB7F6;
	Mon, 31 Aug 2026 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184899; cv=none; b=ic3B5lFj4hvsNpxhuiBO2tY14bdWCqUpvJxha/2Hfqcvx45do0wtIqBXkmsrZ612WKalVuPd6mF+YEOhdEehjenTgPcl1uvBglSWaCEGQFkrPMn3PUNwzrxmppKvNpMgn+plXpn3y7Jiiu+/NYCcHZhtai2AmxNm9Cjn5ODejxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184899; c=relaxed/simple;
	bh=IExD2/12duL3rwLIroBIP1R84WH5XqdX9h8pyAx3YW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sy4GEVEK5knvj0JMMmID8Aet72aTKwDxNKQcTqawvVCkKFVd19ChZCCnMgSyfIG1zVjlbzMequvGX+1MUARNUXaxvcBGYIdSgFIn0Sj7NZlCLv+TbjHbR0q8ntkNJiBOAaOYVAT1FhLysvH/DGdTDm6pGEibQ/He6THe4TVbNeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJT6tHYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJT6tHYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCF91F00A3E;
	Mon, 31 Aug 2026 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184896;
	bh=7ka9CdI2shov9qg1PyPOWC05yoKlX5ANm+zV47FTMjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJT6tHYV7zZqmO/YvvWufJ8tavJxjjLo5cstNQfI6/cud7iIeG4cx7aY8NZ0KxaIx
	 rCRfeyIC0ad48fgQPhGO4rta9yUEb+tD7DGAkUYt1JzbM8WX11abmcPtdLqdzheuCd
	 sj8D8j2q9aoRBcsRLJBMgbdJd87DOk790xib6OmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 76/92] net: bridge: mcast: fix use-after-free of a master VLANs multicast context
Date: Mon, 31 Aug 2026 15:35:14 +0200
Message-ID: <20260831133403.530102770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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
@@ -4139,8 +4139,8 @@ void br_multicast_toggle_one_vlan(struct
 	if (br_vlan_is_master(vlan)) {
 		br = vlan->br;
 
-		if (!br_vlan_is_brentry(vlan) ||
-		    (on &&
+		if (on &&
+		    (!br_vlan_is_brentry(vlan) ||
 		     br_multicast_ctx_vlan_global_disabled(&vlan->br_mcast_ctx)))
 			return;
 


