Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A92BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90B6C433D2;
	Tue,  7 Mar 2023 18:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212316;
	bh=2kBylMgMgKoqEmKniVaPExKAEBUFzeLAHLD3hLpmDWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDO2NE9viIDYnZSK+qTPPrJASWIDNmlbTSdRRY++r0QAWd3RUXopuaJ3MUpBBHegp
	 HgEB3m6kKNIp6NEPE3e8rXurfWya/7IE/vaE0nt9Jr46Klfh/2N1TBY+jFgUfszlnT
	 BOfKlfq0JAWRoA2iXFXFUTxWJe60LxRlZYBOPFZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/885] wifi: mt76: fix coverity uninit_use_in_call in mt76_connac2_reverse_frag0_hdr_trans()
Date: Tue,  7 Mar 2023 17:50:50 +0100
Message-Id: <20230307170006.911846223@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 0ffcb2a68b15bd63d5555a923ae7dfe8bfdb14a7 ]

The default case for frame_contorl is invalid. We should always
assign addr3 of this frame properly.

Coverity error message:
if (ieee80211_has_a4(hdr.frame_control))
(19) Event uninit_use_in_call:	Using uninitialized value "hdr".
Field "hdr.addr3" is uninitialized when calling "memcpy".
	memcpy(skb_push(skb, sizeof(hdr)), &hdr, sizeof(hdr));
else
	memcpy(skb_push(skb, sizeof(hdr) - 6), &hdr, sizeof(hdr) - 6);

Fixes: 0880d40871d1 ("mt76: connac: move mt76_connac2_reverse_frag0_hdr_trans in mt76-connac module")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 34ac3d81a5102..46ede1b72bbee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -921,7 +921,7 @@ int mt76_connac2_reverse_frag0_hdr_trans(struct ieee80211_vif *vif,
 		ether_addr_copy(hdr.addr4, eth_hdr->h_source);
 		break;
 	default:
-		break;
+		return -EINVAL;
 	}
 
 	skb_pull(skb, hdr_offset + sizeof(struct ethhdr) - 2);
-- 
2.39.2



