Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563F030BF6F;
	Mon, 13 Apr 2026 16:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097355; cv=none; b=pYh+TeRc0Wk66oYeQPK43OPllkBXT7TJwC7JfgUFHuK9FF2y79dAJGoqcMkwaDK8o2GYz0sZvCnPARp/FEm3sBtnm0WHUEDa8qFGs+cmM735c4uIymfD1B4lSGWuuwa85w4XU5Q+aw6q2cto7zgn0OLAkj/C2bX0sAnNi2FKABU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097355; c=relaxed/simple;
	bh=kBh/ceDHh5Y94o5lLm/oCBPBd1OrTHilB6EadaCTdZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuZ40n5GSOazzNygfxFtZ11vqO+KwWnJIjmMsS6woBL09Vva82h4DeF47YRnOjCdwzw1/MW9xaVpBwaRTQJ98LoqCB0/1BXjmygGG0x2S3PgLv/LYlLs0FO8qB7L4ZYeFu6MaCcmVp0qm82Jlk4kXgPPMTdqC2a1Wh7gud6vyxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDYIhGnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDYIhGnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5987C2BCAF;
	Mon, 13 Apr 2026 16:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097355;
	bh=kBh/ceDHh5Y94o5lLm/oCBPBd1OrTHilB6EadaCTdZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDYIhGnm1smlNR8eJROX+q7tQiavyF87jyvqL2eZ5gCQvClD6RBQGnyzgmWrp2sY4
	 we/aNXBjj6EF7PPiD+XwXX+5kZQG6unMNphwPemthtzhVxrh6jw7zlooeyrw9cqYZc
	 GwTjRK/tzND7vqazgp0qCvclBIVwXK60DQ2PNXHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/570] net: vxlan: fix nd_tbl NULL dereference when IPv6 is disabled
Date: Mon, 13 Apr 2026 17:53:38 +0200
Message-ID: <20260413155833.703871207@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 91122d4d404b7..934a2f02a6c6a 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2259,6 +2259,11 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
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



