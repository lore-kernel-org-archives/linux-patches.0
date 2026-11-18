Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025751;
	b=LDbRHOZhSNDmyWS+HTXuR53z94ai0PwLHLHbIQLAwp1buRLc2oUTP2cltH3VsIEaA1Kr
	 AbNvLT2S8SqzX5tSo95JqAFvtNl0SuIorntLGdKzbiN3lmu6OL9Y3Y/srCNLvvnOI3fg+
	 t+BWxip5cVTybzpUn6KDNKGNqHHlZX5j195zNPzVnLZgE7iC3b/zDqcUuaSjcCScAkP/q
	 fdCNksuhoWicBUG/NG//sg73WFHkWBhFJ+jqd39c9sMpgnZQ12fY1ecrlhWL5lmflrTLW
	 XSs6kwy8unRfxgb+3ZmRjpZc9lGddFIEHymTjE5+naavSEWZKamWw0spOytoigFrPnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5L/VE0j0hAT5mFuQ9wTFVv71wjRdqD+UTNkHa96qZ8o=;
	b=W8p0olXfZYiCdo36Lg9X1WgdjTUBoJ5JZQZRBS06u9ImVf5U7M7VW0qdIYqfUfqtGvz5
	 UfHh8hf7b11yUeNbYHKKy6b2xRH7SMEgv7auzlp3yXdQ6nWZzcrMTpgo7LKwOmNPBgPsc
	 YWPG8C3Yz2Vk5j1M8ESWwttUgXaxfumi8EYqoy2Egx6a+Kn2IthkA3WQbQ0j/6LuP5dYY
	 3AKjfpTY+lRX3f93cyof0Z5+weNrffIvZsxh3gFvWVqqZywCudNZ4OTZjlI8GWDLrt7oZ
	 xXHW6xTIT1d/lE8Vs4byE3DVlmfOP4ZsU+8QJN0/3+OUQWkR9c5vrSWNAe5sljdETFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V76+Be8V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613A7606A320;
	Wed, 18 Nov 2026 18:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V76+Be8V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC491F000C4;
	Wed, 18 Nov 2026 18:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025751;
	bh=5L/VE0j0hAT5mFuQ9wTFVv71wjRdqD+UTNkHa96qZ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V76+Be8VYBQ13JgU3JbpqzzD778Agb7kw+46zhJwuIby93h8tWbXzOVmXhg5BNSIb
	 /61OKfiKd1E7G5e7VSHJgHNf45evlkeqMftMoCPmMIChlG/W5wR2VXoJjQZrn+cn4D
	 Q/h94xxDGIvducBVLE5hDt7gS8Fpi1wAVZCE2V2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1189/2151] wifi: mt76: add offchannel check to mt76_roc_complete
Date: Wed, 18 Nov 2026 15:48:44 +0100
Message-ID: <20261118150205.537312213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit ec0a9b01ef88b5f5bdf74140f8c987f7a96693af ]

mt76_roc_complete() unconditionally calls __mt76_set_channel() to
restore the operating channel. The scan equivalent mt76_scan_complete()
checks phy->offchannel first, skipping the restore if the phy is
already back on-channel.

Without this check, ROC completion performs a redundant full hardware
channel switch when something has already moved the phy back.

Link: https://patch.msgid.link/20260309060730.87840-3-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 3aaa4871006d ("wifi: mt76: clear offchannel state if a scan has no channel to restore")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 57ef35f683187..5aeaf964e67b1 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -330,7 +330,7 @@ void mt76_roc_complete(struct mt76_phy *phy)
 
 	if (mlink)
 		mlink->mvif->roc_phy = NULL;
-	if (phy->main_chandef.chan &&
+	if (phy->main_chandef.chan && phy->offchannel &&
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state))
 		__mt76_set_channel(phy, &phy->main_chandef, false);
 	mt76_put_vif_phy_link(phy, phy->roc_vif, phy->roc_link);
-- 
2.53.0



