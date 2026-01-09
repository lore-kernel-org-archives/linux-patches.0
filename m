Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F081B33C53A;
	Fri,  9 Jan 2026 12:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962110; cv=none; b=DI9Chr9UOf7f6OGOoipZdAeLGasTwPnpzBkHBm43J/YDHhMo3FarKfu3RWSec6H56RxRKm+gMDdFbnR5q75dPxS4Rox9ABrUkAhoiwxEBiLvmxRwqDSMQ4OYuMLTaGHIKJEPTNerfWy3qYEP9kaJIoko7ZxHKHQ8neZK+WLhASg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962110; c=relaxed/simple;
	bh=7HzOkxB8LIa4FbaTNBWp89xmdIRnaB4yNOvBHzaL4Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXkcgOxI8EsPLDG+SK4ASz+huMUNitdKskkfR8MiXXnXRCLIkddu2uu+2eCbkVKQQ/XtQBzveEGPoyEWvuHpz/qG+7w0PQZdhgqAggtw05uhl+4yW4dLZfx4S3Lp/+Xd0sQSRn/nCA9kS/HOFiRgU/5TYorjGilbXzrIc/aqijU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fteLZLu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fteLZLu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40294C16AAE;
	Fri,  9 Jan 2026 12:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962109;
	bh=7HzOkxB8LIa4FbaTNBWp89xmdIRnaB4yNOvBHzaL4Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fteLZLu/T09AOnLf78k596egyTbw/Sn8k4xPijMKx4hLs3ZUXhler2jmXIlAbQI0H
	 iEU/GnLgmPN/F9EtfFSS0DAvzCva2prd8w/OJV7WD/lyNeVtkwb0oAyj5vp9SF3zJD
	 9tORfyFYAY3koG8Rh2o4G5BPiIaxU4IzlxRBvj4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Skorodumov <skorodumov.dmitry@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/634] ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2()
Date: Fri,  9 Jan 2026 12:38:48 +0100
Message-ID: <20260109112126.946498819@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Dmitry Skorodumov <skorodumov.dmitry@huawei.com>

[ Upstream commit 0c57ff008a11f24f7f05fa760222692a00465fec ]

Packets with pkt_type == PACKET_LOOPBACK are captured by
handle_frame() function, but they don't have L2 header.
We should not process them in handle_mode_l2().

This doesn't affect old L2 functionality, since handling
was anyway incorrect.

Handle them the same way as in br_handle_frame():
just pass the skb.

To observe invalid behaviour, just start "ping -b" on bcast address
of port-interface.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Signed-off-by: Dmitry Skorodumov <skorodumov.dmitry@huawei.com>
Link: https://patch.msgid.link/20251202103906.4087675-1-skorodumov.dmitry@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index eea81a7334052..a8017424ab538 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -738,6 +738,9 @@ static rx_handler_result_t ipvlan_handle_mode_l2(struct sk_buff **pskb,
 	struct ethhdr *eth = eth_hdr(skb);
 	rx_handler_result_t ret = RX_HANDLER_PASS;
 
+	if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
+		return RX_HANDLER_PASS;
+
 	if (is_multicast_ether_addr(eth->h_dest)) {
 		if (ipvlan_external_frame(skb, port)) {
 			struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
-- 
2.51.0



