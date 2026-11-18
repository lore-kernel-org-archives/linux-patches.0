Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031143;
	b=Hb8VjtAmjordV5j0alQD8aQxcgFtsblkysTzAauWeKd1agNbs87DFFCrWrSTHnzd3BhW
	 xtfEWddLG/QFONnPe5ttmVBAOKwL12uDuvrcgQBB6rQGqKEBZVX87m/wNA+JU2NL+5Y06
	 GUOEkCajHkH0pu/jOg0MCFLzMJJ7R2JzDAHBAy8vsVqpdSlU2XRowdN2FO4XeDMjVabTc
	 PHoiX4YlqPlWSI/Y7AuUW7LPbcDHIq2CRCHugNBky8amrHae44RBpyyrGYmwZjWxenjjr
	 MD553HQCY32Sd3O/iOcnErPpHmXDzUKYUFODvDnOS2zYdFdoYopqRJAc4r7b509xHew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EkRWkC+Iu3OJ3QrL2Qq+LprAPQ54fIegqJG4JQhYoPc=;
	b=DDuHK1xAm58ZI8geMhSuuiTIEPCN922RTykaxoAGvbvNESFszPSUw72fGnD6jiQHSreb
	 6WQACRCYfiH2eQJl+HcSLT/VtwZWGz5DbQMWVPHhsnCDodZhKL2na/ZYTKO4NW14Pymnw
	 Fm37fTxCiwBBD7qB7pApkiRSd0ys3lEyZq+5UnEopeIpgA+EFgCXlAK/PK67dK+GQRcBi
	 TXZ2op0+tntm2irJtwnLXj7vLeYY86gtzScVqW5O8QE9yJz8jJoN8ZS2Z0St8XHm8hf+i
	 9b5WVcewccJ2oSqHSkla1VONNolJ2PC7ZKoL/czUyK0rKogC56Xai1MVB8fUqvck0Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xrU+wrem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EE9606A32A;
	Wed, 18 Nov 2026 19:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xrU+wrem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A189C1F000C5;
	Wed, 18 Nov 2026 19:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031143;
	bh=EkRWkC+Iu3OJ3QrL2Qq+LprAPQ54fIegqJG4JQhYoPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xrU+wrem+VtJuPoPZcDSrKc4b6IMmyZCiUgrLmdsK8p/xbAIK+hwOYYQODdjg0Seu
	 jm27M99MJFz7w+1Hn20RRZ0C6VhFWMYNiy+yksH1yYyS7d7BHm4728bDfvp2cTSzyv
	 NJ9D1lmZyzVZEAVOZruuUThTE6UeI0PfOEnYC9u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0953/1756] wifi: mt76: mt7925: fix lock inversion between dev->mutex and iflist_mtx
Date: Wed, 18 Nov 2026 15:51:20 +0100
Message-ID: <20261118150048.015425681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dba0f48922072..7cf75e1422637 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -792,9 +792,9 @@ static int mt7925_config(struct ieee80211_hw *hw, u32 changed)
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



