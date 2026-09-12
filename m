Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A574A41D212;
	Sat, 12 Sep 2026 09:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204719; cv=none; b=F7L8NPyygIkOlVa1vT4wERqHZFEO7JjgkAeUidFovQ5TjpyWGQHbwWdw1jDpM2Jc+jOOv7BqTc/KZ/O0S1SKtz4EliITJEMKITCA7UEPjgpl1jQRsJWOklhoggLlufKoZCIL+7gzDg/NTO8ny47KFZ0oSPwY0iNyIsXs6LKU34w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204719; c=relaxed/simple;
	bh=WOTZ9lUU1sZTBR7nZaxO9Fhjf6Eb6dYidl9UItvT3i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTWZjw+2bJPddm82RPcaTMOzBY0karzV47q09o6u0Tl9b6gKlD02LfeCBWxOkUXCrfoUbu6EAmy6GtEeF8gUnqUH7zp6qYinrRaNDY2rUXPJTnEEVmHJnPHlGa9qRyEDbBemwU3IhC2FDM0K1XrcKXGdOMsKKKK41vLdPTwZs2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hjRBpiB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hjRBpiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3BF1F00893;
	Sat, 12 Sep 2026 09:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204717;
	bh=j4qNM1iKP/rJmBkI2eWytBX6Nq/J5KOw1N3GOSTh1yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1hjRBpiBIgSVyKfrm7SWNnsml7nVuoSdGCRvH22hD50UB2ZzgYrAV6bGpRlWsUwa/
	 DLIyP15yakwE2kvm9sug841shts1A66dN6iRpa8pPIYCLnBC3WJpI6v/m6BEWEKiDG
	 k5JsM+2e8AZP2L/KDJ2MRbygh9+yn0zcGVroRFDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Mika Westerberg <westeri@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1670/1815] net: thunderbolt: Count delivered packets in rx_packets and rx_bytes
Date: Sat, 12 Sep 2026 08:57:00 +0200
Message-ID: <20260912065728.195558459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2a1728621887a..82cef20092b8c 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -904,9 +904,11 @@ static int tbnet_poll(struct napi_struct *napi, int budget)
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
@@ -914,8 +916,6 @@ static int tbnet_poll(struct napi_struct *napi, int budget)
 		}
 	}
 
-	net->stats.rx_packets += rx_packets;
-
 	if (cleaned_count)
 		tbnet_alloc_rx_buffers(net, cleaned_count);
 
-- 
2.53.0



