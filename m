Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F82F410D15;
	Tue, 10 Mar 2026 11:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142211; cv=none; b=ZMAUnAdx5JptrkWd9zyYxEgavTkzR2vbHoYo6F2lBePDrNTzT8OFkdt6QPqSs+g9/Wl6GRX614yqyCNdznamZVtFtn2WFbTt8WvJkw0s4vpVy0z2XC5ifRd/6M3x64ksQCA49YGvNVV/GJmAHJK5f3zPdm+Z18bIhnMjkD3nfKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142211; c=relaxed/simple;
	bh=WxpXT1tWEAb6K10l0yrPXrtyVFEs5RAIybYecO/Gvg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbcmauUfzL9K7jnQ8VJxo5C9oV79Xer0/UGsZuDiSClpSMiPVS7nBHCgJze3PDrrr+KQjti72OUl9tlfTMqlhnJ/Sjj27QKqDow0jQdaydtc8PW9ZrMop03GPdzgB2qrkd0McryzV1DYyb15btMBC9SBwEmIeiAy+fJhZUVEklQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUERbTkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUERbTkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E8BC2BCB0;
	Tue, 10 Mar 2026 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142211;
	bh=WxpXT1tWEAb6K10l0yrPXrtyVFEs5RAIybYecO/Gvg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUERbTkVdHZf5v/z4fclYHerc3gl+tPCwThG77aeWSsP3ZeZM7/G3Ay6z9ez1wEqR
	 iWEpbtUe+WJpF+CaEtquX3T9+z/bodibUEK/v2+qmwoWnacCRJLBVYONkE6aXmY/zY
	 Gu3QkOq7WEClQAfvCvckYPgsoYmp1cJdcL0jAbmRFTPCe2EO9xLJi/Vf21m6Lle+HE
	 NGgJ4coBJcO3Zmk/kZJuB07yNSEneWQY+PSeNPwzVSq3CHgNW0F/6c14o6R4SO93ov
	 gJf0G6gTHKmQ9To3w+1EmLOHS8AhlDHUCCrzgEWTAnZxE2FeMn1y5HaCbI6fZoO0u5
	 75GcgQ4bj9DDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/314] net: vxlan: fix nd_tbl NULL dereference when IPv6 is disabled
Date: Tue, 10 Mar 2026 07:19:20 -0400
Message-ID: <68349c4a662dbf22515e3521c6e33ee58243e0fe.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 168ff39e4758897d2eee4756977d036d52884c7e ]

When booting with the 'ipv6.disable=1' parameter, the nd_tbl is never
initialized because inet6_init() exits before ndisc_init() is called
which initializes it. If an IPv6 packet is injected into the interface,
route_shortcircuit() is called and a NULL pointer dereference happens on
neigh_lookup().

 BUG: kernel NULL pointer dereference, address: 0000000000000380
 Oops: Oops: 0000 [#1] SMP NOPTI
 [...]
 RIP: 0010:neigh_lookup+0x20/0x270
 [...]
 Call Trace:
  <TASK>
  vxlan_xmit+0x638/0x1ef0 [vxlan]
  dev_hard_start_xmit+0x9e/0x2e0
  __dev_queue_xmit+0xbee/0x14e0
  packet_sendmsg+0x116f/0x1930
  __sys_sendto+0x1f5/0x200
  __x64_sys_sendto+0x24/0x30
  do_syscall_64+0x12f/0x1590
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fix this by adding an early check on route_shortcircuit() when protocol
is ETH_P_IPV6. Note that ipv6_mod_enabled() cannot be used here because
VXLAN can be built-in even when IPv6 is built as a module.

Fixes: e15a00aafa4b ("vxlan: add ipv6 route short circuit support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260304120357.9778-2-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index e957aa12a8a44..2a140be86bafc 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2130,6 +2130,11 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 	{
 		struct ipv6hdr *pip6;
 
+		/* check if nd_tbl is not initiliazed due to
+		 * ipv6.disable=1 set during boot
+		 */
+		if (!ipv6_stub->nd_tbl)
+			return false;
 		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 			return false;
 		pip6 = ipv6_hdr(skb);
-- 
2.51.0

