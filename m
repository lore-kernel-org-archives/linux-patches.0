Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774E841169F;
	Sat, 12 Sep 2026 16:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231837; cv=none; b=JnjT9jCmaUaZ8nEcvcmsBkI7SGpFoGfg1HO4dultQ33YsGAVvCj3VTD4jpQpvsaRehJt6XXXYt6N92Iae8UyajPmfgeVt/xfT/R9HbOYVi+568MBSmAMITqhBzvgqmgo+hKYXsfHbjXHFGU5uiYD26Nt8ecbsLTfWvIYp60woRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231837; c=relaxed/simple;
	bh=MrT6+RMDHusI1+1tvHhNwtV0TpzNCHsSvT39IPnUn5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKKd9n8O0rrQl0IvCzXnAhgj9onETFn7KJOp4WNZ7bBoz3MEOhSc4isohiEXinWeBLH7Nvl3CakPI/OmAP3oQGjmNjZAHsZ6lsVmxcdNDyXbEUSAqTxqSLmQEUBU76wgLoURCk5yJjHre+S7rKGZKdmB7xYVCgQAnXHZJwJFg5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGVwJjcc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGVwJjcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AC01F000FF;
	Sat, 12 Sep 2026 16:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231836;
	bh=pu8qlLGE8pwAn3k35oamqiZZeiSn4Dbuwur0uqncii4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGVwJjccH2VdQbet6HlnX1SyVxevt+J2rEyPbxmnDIoPaOY9JtzyOA8NVN0ZKiNok
	 Jl87y/P+Hi8LV5WLM/cfmcM3AZxmUh10FbXLj8HC69q/voL7DN8mseQujQRc4pZ0GF
	 3NrSu+gKjL86Q9107v74KBMtzGmAM8YHydAXA5dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Mika Westerberg <westeri@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1080/1191] net: thunderbolt: Count delivered packets in rx_packets and rx_bytes
Date: Sat, 12 Sep 2026 09:03:28 +0200
Message-ID: <20260912065612.426368362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Fan Ye <fy15309206903@gmail.com>

[ Upstream commit c5ae83ee02c04487b1be1d143b791ec2caca888e ]

tbnet_poll() increments rx_packets once per received frame because that is
the NAPI work unit, and then adds the same number to stats.rx_packets. An
skb is handed to the stack only when the last frame of a packet arrives,
so once the MTU exceeds TBNET_MAX_PAYLOAD_SIZE the statistic reports
frames. tx_packets is bumped once per skb, so the two ends of a link
disagree: at MTU 65330 the receiver reports 16 times the packets its
sender sent.

rx_bytes has the matching problem: frames of a packet that is later
dropped mid-assembly are already accounted, so it does not correspond to
rx_packets as documented. Account for both where the packet is completed,
and leave the NAPI work counter alone.

Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
Signed-off-by: Fan Ye <fy15309206903@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Mika Westerberg <westeri@kernel.org>
Link: https://patch.msgid.link/20260815-tbnet-rx-stats-v1-1-8da375c2cd09@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/thunderbolt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 7a448a6bd3374..f044a65f5e23a 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -856,17 +856,17 @@ static int tbnet_poll(struct napi_struct *napi, int budget)
 		last = net->rx_hdr.frame_index == net->rx_hdr.frame_count - 1;
 
 		rx_packets++;
-		net->stats.rx_bytes += frame_size;
 
 		if (last) {
+			/* Before eth_type_trans() pulls the Ethernet header. */
+			net->stats.rx_packets++;
+			net->stats.rx_bytes += skb->len;
 			skb->protocol = eth_type_trans(skb, net->dev);
 			napi_gro_receive(&net->napi, skb);
 			net->skb = NULL;
 		}
 	}
 
-	net->stats.rx_packets += rx_packets;
-
 	if (cleaned_count)
 		tbnet_alloc_rx_buffers(net, cleaned_count);
 
-- 
2.53.0



