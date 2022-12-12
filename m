Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21E228ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261A2C433D2;
	Mon, 12 Dec 2022 13:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852600;
	bh=ADnUcgiewbUqgvENjk2ha+VRg18Ar4WqgK8wWdryF+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAiX3wJw+x95antrouPEOFpup13uDL5B/6FRrygTD9HWxTZhfaqA29uEwjdIERBsb
	 Xuq1VP4fw6T9DG6AZwpknOsMocji4Up5wfuTOVohVK9iIbkNVJYZ80wsmdzLgqiXyL
	 QdL34tteC3Y/O8oZNg0Ka1Q0owrM2+1TigU62w4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 113/157] net: dsa: sja1105: Check return value
Date: Mon, 12 Dec 2022 14:17:41 +0100
Message-Id: <20221212130939.390289540@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit 8948876335b1752176afdff8e704099a3ea0f6e6 ]

Return NULL if we got unexpected value from skb_trim_rcsum() in
sja1110_rcv_inband_control_extension()

Fixes: 4913b8ebf8a9 ("net: dsa: add support for the SJA1110 native tagging protocol")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221201140032.26746-3-artem.chernyshev@red-soft.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_sja1105.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 83e4136516b0..1a85125bda6d 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -665,7 +665,8 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 		 * padding and trailer we need to account for the fact that
 		 * skb->data points to skb_mac_header(skb) + ETH_HLEN.
 		 */
-		pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN);
+		if (pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN))
+			return NULL;
 	/* Trap-to-host frame, no timestamp trailer */
 	} else {
 		*source_port = SJA1110_RX_HEADER_SRC_PORT(rx_header);
-- 
2.35.1



