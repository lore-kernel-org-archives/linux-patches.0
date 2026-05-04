Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D161A6827;
	Mon,  4 May 2026 14:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904316; cv=none; b=hPnBzhdyE3Jfx61codZB06D0FsgVCHRqjJUiR6JAa4iH/B54Bhxkx5qvT9Oz3ledtKFWsCXn4jj6bIP52RshvSLXzURzSzCut8vmVJ5cRn4r6NaSsCbnY2psxfJUp6afXbpSv4GMbml1iJYxK5BP/t4CSF+rDoXdFQrp01EF7VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904316; c=relaxed/simple;
	bh=UX5uAaauRmUy1vm6UA0qBr1/nJphZtgF20B/fVGEIsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qG3s6b/0Zgua5VWPD0g/evpLoXt5Xk5Y8K2y36xRKlbv/OhsbAL2gSjv8JYD9lSBnKNbBuadce8dU4ioNx/ZAejibAWsjFcHD8L0QDb/QAOYXH5huvBYRY1GbaSIvanDNU82elfErBHtXgZAOKb/S0fT1R4A5bom6LwfYTVlMNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kulVvjTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kulVvjTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8D7C2BCB8;
	Mon,  4 May 2026 14:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904316;
	bh=UX5uAaauRmUy1vm6UA0qBr1/nJphZtgF20B/fVGEIsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kulVvjTOwUuwTNUD/yPYMpP1/aYwI9kZdiQxAvMFmTja58K/EGbK96hRDr9Q3nNUo
	 YBogje1ldmXOEQZ90kkp2HnGWWmW2Q1bmFY/tngzRXlKp1ULu12uHzf3Cmyg7b5p81
	 SDMcS/gNXqXX76qKoXT31uH07c/XAHyZFP4Vkoas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 235/275] gtp: disable BH before calling udp_tunnel_xmit_skb()
Date: Mon,  4 May 2026 15:52:55 +0200
Message-ID: <20260504135151.780491113@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


