Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C2878C9C;
	Sat, 12 Sep 2026 15:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226071; cv=none; b=jPuaw798wd5GtKmvRAb3L5zHrmKvGpYrATq/uxj4JH4GC/Ry3e/zxkK3WFCK6fT5UEjHIdtM59euoIlVZlKAdqW1ufmGY0xTnJzC0SMSNksta1PtPy/EoY8inVWDOVa3X3adLXj1Jj4PuAxKL4AnI8JsEETd8KPXnTyaGYN/oHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226071; c=relaxed/simple;
	bh=LZHLxxq31wrpFOMW/RUY868micjYV9UgnHpahbyHUh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rybRti02BsPLDOj3dvaZtRhKcIFogmq5e+yOmcNnabpv/62/chZ/T7YAC5uzKF5xiwn/EKM1LW6FQQ0C/SrSPok2I9xLFOgirbTtsEFCpytzbJYyy3v1jDtBoqchxe16+ZL8JC+FpPjirAdxHYJqZGKjHQQxJ88p1jVCQZ2eMC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLJ9EkbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLJ9EkbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076F01F000FF;
	Sat, 12 Sep 2026 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226069;
	bh=regnIjrTbrQxZRISK2EU2/iwCgTbCqybKH7K92sLbvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLJ9EkbLW1LV8/lqLsm4Zxnl3+jMcJD5zRopEyuANphmdCoYd4T/LgYnJgyEhx6y2
	 6jItpWpCQy6qEEDEzNPNNjlAdA5nL0YUO1EQ52VMeLWYQEEf++QXFqJcGO3kpk4x/s
	 tN7Yz6qN6Q44UHexgvIUTlh8J7VXRds0/gFPC3yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Mika Westerberg <westeri@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1328/1424] net: thunderbolt: Count delivered packets in rx_packets and rx_bytes
Date: Sat, 12 Sep 2026 09:02:40 +0200
Message-ID: <20260912065636.998059570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



