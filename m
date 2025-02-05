Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A1D1459F6;
	Wed,  5 Feb 2025 14:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765498; cv=none; b=hpOT2yS6d8EdSDgKcQjTqd6awirynqxbvHS3wgxuT8QuK7YjfzjTkOTor2YW8Cm7UxCBuB8Yln7Z9ypg0EFta1g/x7S0t26WQxv8QpzAUanQ6c+4M9iNTmWnQybF9LGZBc3d9y7D4ShSPznxAzslnmZd2GUN9/d9RPyqBaaVZic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765498; c=relaxed/simple;
	bh=/scvCWlPz2t7GHHN2rZoApfftTQ2giIUI3TkU4k1rG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSrgoFkDhpL4j9WqreyMy4TIAnFBG59cEf5jMhnuoRpBhdyTloipdhCmxrfmDVxELHoIfrKNvgxVycEekq3fARxTGoAIrcxJTQIViICxi9C08GMFLSJRpvEH4/PLtVUPHyQkOc7y56uFgOh8iQWodCjsoGFBdh54UgISbwt1DsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3kMVdAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3kMVdAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D785C4CED1;
	Wed,  5 Feb 2025 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765497;
	bh=/scvCWlPz2t7GHHN2rZoApfftTQ2giIUI3TkU4k1rG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3kMVdAI58g+XlyVhuUjGafK27gstblb7xUW1RIhCvpE8SIfbUHvv8xZRwg8rwAsF
	 g3hEmUHBw0xaUDdGblwehA6MrdIPN69Na9UHlSKnENC4PDYlJVqkJ9RXbYEHBn1eVN
	 RrnDLRnXY7vB8j9CZLJKDog8CFKkVOxI/866GUJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 183/623] wifi: mt76: mt7925: fix get wrong chip cap from incorrect pointer
Date: Wed,  5 Feb 2025 14:38:45 +0100
Message-ID: <20250205134503.237674031@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 4d264f31b3074d361f65702dd7969861bcf1c158 ]

Use tlv instead of skb, because using skb will get valid data
with wrong offset.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20241104051447.4286-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index a78883d4d6df0..b43617dbd5fde 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -823,7 +823,7 @@ mt7925_mcu_get_nic_capability(struct mt792x_dev *dev)
 			mt7925_mcu_parse_phy_cap(dev, tlv->data);
 			break;
 		case MT_NIC_CAP_CHIP_CAP:
-			memcpy(&dev->phy.chip_cap, (void *)skb->data, sizeof(u64));
+			dev->phy.chip_cap = le64_to_cpu(*(__le64 *)tlv->data);
 			break;
 		case MT_NIC_CAP_EML_CAP:
 			mt7925_mcu_parse_eml_cap(dev, tlv->data);
-- 
2.39.5



