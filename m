Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0731A00F0;
	Mon, 23 Mar 2026 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278023; cv=none; b=LVEL6eZ2AeNTogyNlUelZu3MSchO6+J4LmstaUOTYwmDoIvMWTW7fJU3Bh+EGA6XA6d3ZRVhuXDJmKMOofwDLdgSIvFDHEVnujZdGW4Dj0v4URZ0TdHch04XbAd0CqZxS5s1ucSWsCNYH3Szl1hwh5/3yi/Jg+iriwa+6SFyk6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278023; c=relaxed/simple;
	bh=WKARneBrtXUlbmhJFVRrtBV9uMC3uRVxfcH3w75H/bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMgmwQZRrZKMzp/sUq0Bm/40jHvR1wnRfcZi8ZbU/9EU0svSDqRNWI7MNjC+HFtbIdS7i1oxQlTdg/0rJrGd+4kQYMzEkiT0Hz7Y5GX+4zaiz/HTnAYBaFAvACL4lUG5dpQET33J++QqMlBqHtGw4664IfZcA8D8mHosW5gH/4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZasVAgk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZasVAgk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF77C4CEF7;
	Mon, 23 Mar 2026 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278022;
	bh=WKARneBrtXUlbmhJFVRrtBV9uMC3uRVxfcH3w75H/bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZasVAgk/0j1xmckCmDdbRpKSNjM5JLrWmrqQeWijYdF9cucG3xGXJHMIz7AeEvz6v
	 ycVEi4Gnf978nO1vKOcJqDlWCdOZjqcc82Yr1UgRi6NUmtQToay+7BzqFWgNQHzUE5
	 GPlO8HY/TQemkHpgzYmrUVXxZ8D4PWS1dS/WPpg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/567] net: vxlan: fix nd_tbl NULL dereference when IPv6 is disabled
Date: Mon, 23 Mar 2026 14:41:35 +0100
Message-ID: <20260323134538.168883611@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index 1b6b6acd34894..a862998fb3ba6 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2126,6 +2126,11 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
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



