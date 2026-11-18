Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018990;
	b=oDRTSptRUBJkNLMqbEP2pWDBgqLdiVxhrMQe7MroFWZev37issASffnEvhIq3muC+hv0
	 HEl36w8OkIsOhlL/IiM3ExCTQk3SUyYjr4tMeO1QlhsxstNBYAHvYkdBMGL5fy5QOhu4g
	 S8LYWRwqB6yarXig1jLIaAmo6oKOFikr2+PcJg57A1/viqKPN9nWmd00UTkzbHJN+4mzD
	 QyBVBNAy+ibcI2BSl/qlrVOf4BWqrE5hUTWrX4OQXye6XKz9P9t9x+ECKibXZZKbdoez0
	 GABu09icvjxQxGvNgPWfFWEmUHVR7FCGTxYRa/8o6PbKEfWuGjeCbrX9kGQ9fY5Gxqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1LWFr6/IKxEOcF+zrvCG/G/9H1EE2R7e2vV6+ZjcjfM=;
	b=iQaecSObRrjp6cdYlwtb1YnUOE5uy9d1noaQsiL0g3+MUx8vHXixAplXF13+Jmt3C2TF
	 /LhjkjGNeCSBESUes6t5u3z0qkLqk7eUNjj60pDEPIa8PjJvoHP4O3Dl5V6nifZHy2dBK
	 4gA2E/JqyDKa/Qc/Ee5RZOppw4adp1qqvFoVu33nO2WTCaCCjMnNpeQENjs0dQyh8THQf
	 x7yWp4HiukDkj+qlPMD34WRJuwwPneZxxjxxCw2ZVxvoGGD/NJt+ojsRqYzwHOUHnu2SK
	 Cv5EF2ihSi0GU30/0n8pWf4zUOlNs8j9nSjFSo3BhREgdBnhfRGge5Uoin7ezo64IpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2a5/iSgb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9105160A2602;
	Wed, 18 Nov 2026 16:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2a5/iSgb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29B21F000C5;
	Wed, 18 Nov 2026 16:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018990;
	bh=1LWFr6/IKxEOcF+zrvCG/G/9H1EE2R7e2vV6+ZjcjfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2a5/iSgbmaTwLvyvpApBmXrrt5J87anciAfHYdVFqZlhxWReATKOstRBd8xVGDkz8
	 kvTn7dBs+jdd5pZPxFzRX89AZ3i+adjpfJu6aiNY7t+Sy2DCw5EsRcfhtYL7eFQHbh
	 Nu2GH9+w7zKNyrByRZ/opLfaUvhgmZUV02jl+8bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1434/2651] wifi: mt76: mt7925: fix lock inversion between dev->mutex and iflist_mtx
Date: Wed, 18 Nov 2026 15:44:34 +0100
Message-ID: <20261118150339.677052380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 3208623121309a42f878364aff3c770f597d6a70 ]

mt7925_config() has the same inversion as mt7921_config(): it holds
dev->mutex across ieee80211_iterate_active_interfaces(), which takes
local->iflist_mtx, while mac80211 calls drv_unassign_vif_chanctx() with
iflist_mtx already held.

.config is only reached through drv_config(), which asserts the wiphy
mutex, so use ieee80211_iterate_active_interfaces_mtx() here too.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260810045338.118923-3-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index d71e60594ea51..53845857bed33 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -840,9 +840,9 @@ static int mt7925_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
-		ieee80211_iterate_active_interfaces(hw,
-						    IEEE80211_IFACE_ITER_RESUME_ALL,
-						    mt7925_sniffer_interface_iter, dev);
+		ieee80211_iterate_active_interfaces_mtx(hw,
+							IEEE80211_IFACE_ITER_RESUME_ALL,
+							mt7925_sniffer_interface_iter, dev);
 	}
 
 out:
-- 
2.53.0



