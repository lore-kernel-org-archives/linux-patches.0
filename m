Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32F84CEE53;
	Wed, 30 Sep 2026 18:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793264; cv=none; b=G0D4JUBP1yTI43VPBSsUTRdnraDYN4RON25fNSPFaRcGmwKVQdiOb8WFzxuqj2yRH12dGqvD2WJsWf//dvrrH0imUj9l6AlHYDz737EstZh5dEgFHD1maf61A1jQBUzKqvc1F3IT8/lQqc01/DsrTnAAeNNXhipKe756Jplqhdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793264; c=relaxed/simple;
	bh=DJvzUg572qwO42W3QWkdfyd0+1vS4ouX2A/JbeGi94s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+d1GKGQHDQOlapwvvlrttT6HT/3LCIby7oF9OgpHQntMtJ3/pLffrd/CMunLllhWakzU+CKm90qS9Xyt8B2grDQMXLufBnj48PMw7IAf0wqod+rBLBFxnk9p//drV9wlCvvRcmXPK9DUI9Y4DFsuu0xTN5LxmzSZdPRBOgVruQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMm7DHpm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMm7DHpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAE31F000FF;
	Wed, 30 Sep 2026 18:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793262;
	bh=ejI2H7AQLcKNvciEuHV6HEU87aUI33GKdb/FewB4+nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMm7DHpmPUztGpT4caWBN5Gi3jI2/WiE2NJyvuO4A3R2RiCmHGhWdIEyJcwRVtMRp
	 qP1mHfqNCS8aaR03D+OACI21LjdA+BFhqYLu2x0Or5vxdXL+euln/RAREw3xoL9GuJ
	 aZW/qOeEG8qLu1r/vhVUhLtz0O+KS8278DQn597U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	bridge@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/395] bridge: check llc_mac_hdr_init() return value in br_send_bpdu()
Date: Wed, 30 Sep 2026 17:27:35 +0200
Message-ID: <20260930152344.836053055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ac704ff08e511c87643799c385f55ecd69b85e03 ]

If llc_mac_hdr_init() fails (for instance if the port device type does
not support LLC or dev_hard_header() fails), br_send_bpdu() should drop
the skb instead of resetting the mac header to the LLC payload and
transmitting a malformed frame.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Closes: https://lore.kernel.org/netdev/179022851638.2160803.1808206741379444999@kernel.org/
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: bridge@lists.linux.dev
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260924082951.1599377-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_stp_bpdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 7895489ac6fe7..e44e448b1157b 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -52,7 +52,10 @@ static void br_send_bpdu(struct net_bridge_port *p,
 			    LLC_SAP_BSPAN, LLC_PDU_CMD);
 	llc_pdu_init_as_ui_cmd(skb);
 
-	llc_mac_hdr_init(skb, p->dev->dev_addr, p->br->group_addr);
+	if (llc_mac_hdr_init(skb, p->dev->dev_addr, p->br->group_addr)) {
+		kfree_skb(skb);
+		return;
+	}
 
 	skb_reset_mac_header(skb);
 
-- 
2.53.0



