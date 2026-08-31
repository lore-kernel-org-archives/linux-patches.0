Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AF243B6EC;
	Mon, 31 Aug 2026 13:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184633; cv=none; b=quOz8eablNiLmTX7fRHzWaj9w1yB0vvL/QLaUXb0ZQKxatuyXkZq+Kl7seEw47j/l5piy9wRCa0+LsqFlqbntJc7naE0CroulDFx6q7TDVPeU1wbY6jpeYE7HSkTFVWbfPvSUffejUuSAhQjjrfpBWtD+Y/csEDT7b9ESmaiXU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184633; c=relaxed/simple;
	bh=k5CLLhItNyQDlhrYmbXwg5+AjUEFGOqelRS5HgkUewk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DU5/WvqkuUywRTkU27hEksf944JA+iRukfsVOq6c8EoAhXZZDbgYWeDn2dxO+LYKUQdsmak+ETYqDPf1oEsaycJfrgfRoeV5HV+1uaCeHwpdRwoRwm4cwiwCeyJ13uOvh7hjRffFl1RGQcUVb5n8Q5O7bnUv75Py973jRuCyvXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDALxojq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDALxojq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCBE1F000E9;
	Mon, 31 Aug 2026 13:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184632;
	bh=RPNhqbohfipzSrxm8kKgQHQzddMBkpaqMh5F/uCUCus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDALxojqNFnoGTDWCPdzMmzGxDiCSHSLW5FUmd4wxdfJv/ti8HIilKe4atr9rsK5p
	 URAh9WRoktUEN7uVpB84EOZOMAkasXo/zvb9OBpxRMBhLoOgSmD3jDb0v1EyFtRW6Q
	 JDrLxM2nbzB2+Z+o+5XFbV/dcIIXwKME9Fl/GR2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 76/91] net: bridge: mcast: fix use-after-free of a master VLANs multicast context
Date: Mon, 31 Aug 2026 15:35:04 +0200
Message-ID: <20260831133403.548370597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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
 


