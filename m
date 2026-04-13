Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372AD2E2850;
	Mon, 13 Apr 2026 16:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098689; cv=none; b=MW4ZjJJ1UvdkXGRwrcy1wZDtiMRFQRGQRMbnCuuA1XMFR7LtOY2F/vJidUMWCcsPY3GdK1aSxWCIjAN3A85blQK6bjQhgiB3Bl+UEh296Jx97gNLN2bYMYSRg932cLQpSTN+DggwDecpeMuHCofwY1eQdLpwPtMHjLoU0TmRnRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098689; c=relaxed/simple;
	bh=2TeWRJcuK86K4pwiuf8AbXTUnVAoB+WLLrHUIi7wbNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jraMx+y27S8sJ7ublEqGDCwvLwsv/Cf8SZQ/mF220LO4MmWeoPpKxS7wE4ZKS7hYhuUzySilrdtflGJjit94FsDMXtjw+8dU+FxkkfFKKFV5kCMI+nTG+C4wCRAKVMue1tengNzwXF2jN7alTmK/EHFGWpI14tAPJPi+WLeAEHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtCVGDB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtCVGDB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03ABC2BCAF;
	Mon, 13 Apr 2026 16:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098689;
	bh=2TeWRJcuK86K4pwiuf8AbXTUnVAoB+WLLrHUIi7wbNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtCVGDB3cE1MoQo7oqnNxJaX3dfoRIb3wT3x/K1AHqXaFavS5Bqxbu0qMTMAi+8I4
	 bhfrc69Yc/GFcfYf6AS2S9keqS34LLECHTr2DPiaxALn1so4NW418hN0zhVCB/VxAx
	 yvEzqKed6qzixTe7y3VrtFhfJ/A53jlOPRWitEag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/491] net: vxlan: fix nd_tbl NULL dereference when IPv6 is disabled
Date: Mon, 13 Apr 2026 17:54:56 +0200
Message-ID: <20260413155820.962212596@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7973d4070ee3b..c24535dc051c0 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2258,6 +2258,11 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
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



