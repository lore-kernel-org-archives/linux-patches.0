Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD253A7580;
	Sat, 12 Sep 2026 20:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243417; cv=none; b=Su52IeDS9JgC8VDOo8M+0WO2tlgbdSXoQNXDVAj4K+oY0Xd/Z27Tt2NEuOM0lufOMKeGyAuE0sGwjTA42rDvH5yWK9vYu5dEbUhDRH00CiEwpxdm25sukEx7KBWWKKdEolhoMKc1Z3EgVc+ihkXJYx5Gdt3L/wQmVC4C1pcIJzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243417; c=relaxed/simple;
	bh=7xvrvjOrzqP1z9jT2UwUwM2KDi6ZsjjaAFhbZlU2Xus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdxoyYtBl/FybrKL2j1mow0hI0sa+j4Y7LHM062+WaCk0ISULAZfvDkEnosZuc5E2ZpGLioskw5wjfBleUIH7B4PZQ57MByTVIS+UfmVxnSEFfuGPSjl2BFCcQwoTt1AaW82ZJQjZHvMdGA+hnGjiPeGOPWAy+oFY/KGIhOapzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaegcPt6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaegcPt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634971F000FF;
	Sat, 12 Sep 2026 20:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243415;
	bh=lojuNq/xEEmetWN7ecN3HTdUUS1TsYlHDZ7t8AZQsjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JaegcPt6VyrEI04q0ut15HZrrXo4sY35/PpNausU8uPX8QPHygn/FKI/LcFFGErNX
	 lRqVpUCPdTy6+oHk//3zCml1XeSNqSE7xVdNyJCY2BttdYggpw8ssG4tMNqDDzTTMt
	 nGlDgJpJb309Q99BYGr+uPnWpi26UbyDpCGAbYJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Mika Westerberg <westeri@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 741/798] net: thunderbolt: Count delivered packets in rx_packets and rx_bytes
Date: Sat, 12 Sep 2026 09:06:09 +0200
Message-ID: <20260912065534.057648182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index d2457d799759a..6ae7211d72678 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -818,17 +818,17 @@ static int tbnet_poll(struct napi_struct *napi, int budget)
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



