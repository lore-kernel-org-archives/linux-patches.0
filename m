Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039C0330B25;
	Mon, 29 Dec 2025 16:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025107; cv=none; b=b1HxykxjZrNiVRofcKIRjF2CEVM7F3pRNBa8Zdp//VJoRMGGkXUO7FbZ1IeUcdJnJ8FAWQPmBFR2NjyNT8OeLL+2HYd4se6upZ6NCLcdN4eky95+sriTY9oac3ZLEd684RQPXe7+tXc8Q5E4I8YKLt94vU0oxvK1GDKFzrFe23I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025107; c=relaxed/simple;
	bh=d+xvMrZDc2VZJu33yYB9wkiEeoe7A1s3Ad/SUwZdtzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwoRu/5as0byNP5QY5kLzciPp9yjD8+KWMpg5MO7VQt8LUZn0JxXeMMGs5zrOsDY7eV6Ev6NSPGaYKzT5RmQQ1k0Pf6sb0xJvKsIOjLJvo3JZDVRKF7go4Wv5MEvMD2s7NLUaiYyeL9pVx25XICq9HZWacqLidNI1c3/eNJvfvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HL8kpGYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HL8kpGYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77974C4CEF7;
	Mon, 29 Dec 2025 16:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025106;
	bh=d+xvMrZDc2VZJu33yYB9wkiEeoe7A1s3Ad/SUwZdtzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HL8kpGYY4yQbvZtBXYDsCiRZRYBsepF8aq7Uard6NoDIly2Vi+AH8sLKbOhzb3oZw
	 mdeMGAIH13spD3NfRYZXti0enkPTFuzRYBXWPdnkRX/l/OoeA76T26OAARPq4Fa0Wi
	 7YW5DhtISXa5ZUpUSTHoIs+XZsyWVEIQLSz563kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Skorodumov <skorodumov.dmitry@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/430] ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2()
Date: Mon, 29 Dec 2025 17:07:46 +0100
Message-ID: <20251229160726.721772022@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d7e3ddbcab6f4..baf2ef3bcd54b 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -737,6 +737,9 @@ static rx_handler_result_t ipvlan_handle_mode_l2(struct sk_buff **pskb,
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



