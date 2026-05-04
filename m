Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5572D3A7F4C;
	Mon,  4 May 2026 14:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903647; cv=none; b=DowW7wqhbAlWVZvhJO6v0JpZTm1TiGMCmB1JJ8Ufg8CKjJPIoPTsJd78SNigLwgOKAYysKcjt/Ziki6nqrFqe70+WYprGzhOkx106yHe/FMOOw8IAq41RObAeWNx4GCiqJ93VTHH6B95k3QNmWcDGu8WbCPpi36QITjnyjesgwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903647; c=relaxed/simple;
	bh=hs/aZODCIhrsT3NUCIjOzrRJKhlCTR6S65/syp3nfZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l4D8wtD6KcOoReBmwE9dvoahya3p0NXS+w7vxlGZ6+uPsj3eiXO9CceHeXdoz9zU2G4ytYtmovnuSK3WS4v+9OKJDt4Bf105zR40BgG29WoiyYJhC0BX9LKx4mmCkYnfAKl7wKX1gbfZe0DxXEUhkDrjGOqDy+q06XWUmFbNWrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mdiaivgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mdiaivgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E069FC2BCB8;
	Mon,  4 May 2026 14:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903647;
	bh=hs/aZODCIhrsT3NUCIjOzrRJKhlCTR6S65/syp3nfZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdiaivglD2LDU2UPEoFezIaO3bVmDNTyOFMx+0sVKEq1Nspw2fQa2IgCQ6Iaf0yf+
	 2MVguvnsU4aZjdE91hVpmz1OxU87hG87vu7zOYAfKJgbDK5HQYdvaqPqadlJMpYAaP
	 i+IHcsxjnaT3xIOAiJ/iNcsx+zrzNskxyLdJN3kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 274/307] gtp: disable BH before calling udp_tunnel_xmit_skb()
Date: Mon,  4 May 2026 15:52:39 +0200
Message-ID: <20260504135153.111692350@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 5638504a2aa9e1b9d72af9060df1a160cce2d379 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -2400,6 +2400,7 @@ static int gtp_genl_send_echo_req(struct
 		return -ENODEV;
 	}
 
+	local_bh_disable();
 	udp_tunnel_xmit_skb(rt, sk, skb_to_send,
 			    fl4.saddr, fl4.daddr,
 			    inet_dscp_to_dsfield(fl4.flowi4_dscp),
@@ -2409,6 +2410,7 @@ static int gtp_genl_send_echo_req(struct
 			    !net_eq(sock_net(sk),
 				    dev_net(gtp->dev)),
 			    false, 0);
+	local_bh_enable();
 	return 0;
 }
 


