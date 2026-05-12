Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72B03002A9;
	Tue, 12 May 2026 17:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608252; cv=none; b=OvA3YwU0lWWeNKAy32cR+Vel3DqwwSLp6sWj2eMAy813yutFV4BBIAXyocIChs49CYaQ8Qpq5qgahrFPT4agAuFcpvAecqxeVD8wum/iycOItmvmNrSCP4bIJJx1Ix9YEpwS+8gNEpn4ijM5UosqxW7YuP2CMzZeKLXuICmJ3wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608252; c=relaxed/simple;
	bh=v0W4w2KA51UhdNP1B0n/L9T5/ENRUlebrQB03IeETzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvKYvmKAqkJjfJcna7ffa4KpeDE8XQzciMdaZ9OxHG4v53VCCqa1a62tyvxR7gkp34ZggrNwz3dp+CrY6usR0/8mk+IDWvWfYPf17zNmygHWIwVFpMO1jLCqm7ieRnQ/DAJt91HoGrUHirrrrsUG+tsPRy/pz58EHipnHCI4t6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4lyflkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4lyflkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC91C2BCB0;
	Tue, 12 May 2026 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608252;
	bh=v0W4w2KA51UhdNP1B0n/L9T5/ENRUlebrQB03IeETzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4lyflkppPTf6C8dSftMBT+Hz8WUnsamzvOLvzTLfa4Gy9zxnyjVd5b2ZUuHdo8NS
	 zHKpkyfMkht50LrxaF8uFoUqqCLY23Zu3V5WgBxucXkACWtYQ5HXqO+5KzedLvW4hi
	 JULPkeOr1Z+DnOnwzz/lbd5ltGF53cujBdNABIZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/206] gtp: disable BH before calling udp_tunnel_xmit_skb()
Date: Tue, 12 May 2026 19:40:47 +0200
Message-ID: <20260512173937.001054450@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 5638504a2aa9e1b9d72af9060df1a160cce2d379 ]

gtp_genl_send_echo_req() runs as a generic netlink doit handler in
process context with BH not disabled. It calls udp_tunnel_xmit_skb(),
which eventually invokes iptunnel_xmit() — that uses __this_cpu_inc/dec
on softnet_data.xmit.recursion to track the tunnel xmit recursion level.

Without local_bh_disable(), the task may migrate between
dev_xmit_recursion_inc() and dev_xmit_recursion_dec(), breaking the
per-CPU counter pairing. The result is stale or negative recursion
levels that can later produce false-positive
SKB_DROP_REASON_RECURSION_LIMIT drops on either CPU.

The other udp_tunnel_xmit_skb() call sites in gtp.c are unaffected:
the data path runs under ndo_start_xmit and the echo response handlers
run from the UDP encap rx softirq, both with BH already disabled.

Fix it by disabling BH around the udp_tunnel_xmit_skb() call, mirroring
commit 2cd7e6971fc2 ("sctp: disable BH before calling
udp_tunnel_xmit_skb()").

Fixes: 6f1a9140ecda ("net: add xmit recursion limit to tunnel xmit functions")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260417055408.4667-1-devnexen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -2401,6 +2401,7 @@ static int gtp_genl_send_echo_req(struct
 		return -ENODEV;
 	}
 
+	local_bh_disable();
 	udp_tunnel_xmit_skb(rt, sk, skb_to_send,
 			    fl4.saddr, fl4.daddr,
 			    fl4.flowi4_tos,
@@ -2410,6 +2411,7 @@ static int gtp_genl_send_echo_req(struct
 			    !net_eq(sock_net(sk),
 				    dev_net(gtp->dev)),
 			    false);
+	local_bh_enable();
 	return 0;
 }
 


