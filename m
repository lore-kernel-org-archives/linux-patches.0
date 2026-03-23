Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE253C0627;
	Mon, 23 Mar 2026 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282647; cv=none; b=MDQZ0ccKpA4/qT3bHJz9U/Ro4AlikDORGowYI431wv78TWP2LavXnKmZXSdl4dLkLQ0CRh8FwbQHU7Ux4kj/g8yycydW2Dk9b9IWEeaNxXQ51nCJuxljoPReqkpoCAE5Ei/jBbUoOp3SyxzpCXKgo93yIlpxo8R1hguKTsiJ7TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282647; c=relaxed/simple;
	bh=7qAwizbVzaH/aJ9J/spVfXF6NuRnkagjs82dizC2P44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W7ejapsQM+MF5ZmoSu2NJ5x79altIaX2Sk+k8D6ju+XHowsyA+VwFzCCyq9rcavHI+OcEqcE69T1UGhMRUgJiK2mh3d4i2EEU6xrIKmerT8qgntUKk2+W11OfbD0ddLtDSdgpIktv85/+6TKhxQqzbWx7pqQDpMY9BcWpPS1olw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOoazuaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOoazuaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A58FC4CEF7;
	Mon, 23 Mar 2026 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282646;
	bh=7qAwizbVzaH/aJ9J/spVfXF6NuRnkagjs82dizC2P44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOoazuaAbBe9UeGBD27HKADfogU1Grv8JsXYrtpJhCCmEK+yFoQcAkj8dZJXjMdb7
	 h+He/2Fi5/whtWwa+aHGn2s5z1QdTH7aTdu48CjTyL6Xx0gKuTiqkaAAFFqne8mcS+
	 hpPPdGVI7CAHD/wbLvQAz4a7OpE9awrhVQkcmr4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/481] net: bonding: Fix nd_tbl NULL dereference when IPv6 is disabled
Date: Mon, 23 Mar 2026 14:42:53 +0100
Message-ID: <20260323134529.850448524@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 30021e969d48e5819d5ae56936c2f34c0f7ce997 ]

When booting with the 'ipv6.disable=1' parameter, the nd_tbl is never
initialized because inet6_init() exits before ndisc_init() is called
which initializes it. If bonding ARP/NS validation is enabled, an IPv6
NS/NA packet received on a slave can reach bond_validate_na(), which
calls bond_has_this_ip6(). That path calls ipv6_chk_addr() and can
crash in __ipv6_chk_addr_and_flags().

 BUG: kernel NULL pointer dereference, address: 00000000000005d8
 Oops: Oops: 0000 [#1] SMP NOPTI
 RIP: 0010:__ipv6_chk_addr_and_flags+0x69/0x170
 Call Trace:
  <IRQ>
  ipv6_chk_addr+0x1f/0x30
  bond_validate_na+0x12e/0x1d0 [bonding]
  ? __pfx_bond_handle_frame+0x10/0x10 [bonding]
  bond_rcv_validate+0x1a0/0x450 [bonding]
  bond_handle_frame+0x5e/0x290 [bonding]
  ? srso_alias_return_thunk+0x5/0xfbef5
  __netif_receive_skb_core.constprop.0+0x3e8/0xe50
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? update_cfs_rq_load_avg+0x1a/0x240
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __enqueue_entity+0x5e/0x240
  __netif_receive_skb_one_core+0x39/0xa0
  process_backlog+0x9c/0x150
  __napi_poll+0x30/0x200
  ? srso_alias_return_thunk+0x5/0xfbef5
  net_rx_action+0x338/0x3b0
  handle_softirqs+0xc9/0x2a0
  do_softirq+0x42/0x60
  </IRQ>
  <TASK>
  __local_bh_enable_ip+0x62/0x70
  __dev_queue_xmit+0x2d3/0x1000
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? packet_parse_headers+0x10a/0x1a0
  packet_sendmsg+0x10da/0x1700
  ? kick_pool+0x5f/0x140
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __queue_work+0x12d/0x4f0
  __sys_sendto+0x1f3/0x220
  __x64_sys_sendto+0x24/0x30
  do_syscall_64+0x101/0xf80
  ? exc_page_fault+0x6e/0x170
  ? srso_alias_return_thunk+0x5/0xfbef5
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  </TASK>

Fix this by checking ipv6_mod_enabled() before dispatching IPv6 packets to
bond_na_rcv(). If IPv6 is disabled, return early from bond_rcv_validate()
and avoid the path to ipv6_chk_addr().

Suggested-by: Fernando Fernandez Mancera <fmancera@suse.de>
Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20260307-net-nd_tbl_fixes-v4-2-e2677e85628c@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2296ca9003016..7fe7485fbb160 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3387,7 +3387,7 @@ int bond_rcv_validate(const struct sk_buff *skb, struct bonding *bond,
 	} else if (is_arp) {
 		return bond_arp_rcv(skb, bond, slave);
 #if IS_ENABLED(CONFIG_IPV6)
-	} else if (is_ipv6) {
+	} else if (is_ipv6 && likely(ipv6_mod_enabled())) {
 		return bond_na_rcv(skb, bond, slave);
 #endif
 	} else {
-- 
2.51.0



