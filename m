Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9276C37A498;
	Sat, 12 Sep 2026 11:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212066; cv=none; b=G6Zg1pnK0tXcjnNL8/2CqHYsrjsb9w6djE93Pd2f+NK5NNmr5aIVJetyb152/thYQxPEvLpe09j7qBSUwj8raWIZprZJXP/A69rk7JvzDvfb7QA+L9nfmcFgPJzh1G8faoYgEf7CkH7EbojS+ebjQ5p+EL040WwDj+kFLamMsLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212066; c=relaxed/simple;
	bh=mz9zIMGkTpCG9R9Av0CvLoLSq8rKkQrTP9z1RjEF2uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsxR8xd9Vniy5yogm6A9r9rUPQEWU0Gg6x9ZTBkZrtfOJTWYWB9hgIC7KJO8nC+i8AQK6KollffWato8iX3V1INU0mQ5H+CxdTFGDtOZ/Va+hqja/WQDa9wrvlSUJje0A4myWz8xueMH1iUTj2EVG2z2NAqdtP7RbfCIssq7pNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tq+SOxS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tq+SOxS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981731F0089C;
	Sat, 12 Sep 2026 11:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212065;
	bh=+Hb6gWG1mjFxiX2MepFGbkoffIuPt3yP08unmfEXkV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tq+SOxS4rS9/tLjn5Qp0wtZaxUrQfnEpVh1TRF84kuqVsY78M1xsWrhyA/nOcHMWP
	 U8kBZz4WUT1NMdyiPD2GUBHPuUiQ4qHnwS+id112B0UBolMPg9UfM5f1YpUiUu95zS
	 fbUPm6/LmRH+bY0yjNXkl2bhtxMWMhLPIcGAGaFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Mika Westerberg <westeri@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1333/1518] net: thunderbolt: Count delivered packets in rx_packets and rx_bytes
Date: Sat, 12 Sep 2026 08:58:22 +0200
Message-ID: <20260912065653.685320215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
 drivers/net/thunderbolt/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index 7bb9aa20fab9f..096f3ff36a437 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -907,9 +907,11 @@ static int tbnet_poll(struct napi_struct *napi, int budget)
 		       le32_to_cpu(net->rx_hdr.frame_count) - 1;
 
 		rx_packets++;
-		net->stats.rx_bytes += frame_size;
 
 		if (last) {
+			/* Before eth_type_trans() pulls the Ethernet header. */
+			net->stats.rx_packets++;
+			net->stats.rx_bytes += skb->len;
 			skb->protocol = eth_type_trans(skb, net->dev);
 			trace_tbnet_rx_skb(skb);
 			napi_gro_receive(&net->napi, skb);
@@ -917,8 +919,6 @@ static int tbnet_poll(struct napi_struct *napi, int budget)
 		}
 	}
 
-	net->stats.rx_packets += rx_packets;
-
 	if (cleaned_count)
 		tbnet_alloc_rx_buffers(net, cleaned_count);
 
-- 
2.53.0



