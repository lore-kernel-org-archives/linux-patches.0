Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216557;
	b=vRMJyqVE882fJxMxSJjLv2BKrUhiLJuM/vSGq1eMZIL4/h6/YY/J7h2YbetcfQmXbNsk
	 tGMEfWwr1I/UQeNqViMiUkubnIxuObSo6TPvdfIqxiPPJe+GVEBZYAibiW3LdSSH/3oTg
	 VdFPaR7yEDcZttDc+GeI65vgAMYG79txUU+SaO84FCSK4SN5MxCQJ/HgT9VD1J5Dh54rs
	 WqVxJPSmzaX/C5Ek6UmGk9m+YesRzQJqXp8f13HRaVorZuZqAK2H/zCrbFEgNGV8MHyks
	 XMMI1uJsjibBZfTrBGYOs9Srqw9a8WCd/CciN1ZphFJmRUNRFGgZt00TT6heKUKqmcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tWCe9G1oOKxLE9zOsnx6a/Y0GQ9BEzXKwGR01EyVheI=;
	b=RwbUQ0q0KZi7CyhO3BMhSxFn252714on6UBfklruMaR/Jfgq3CMZQ0byatAcEU3LVKlW
	 rqdU1xBMyMuuZNkyUTcu91CEnbiIUex66f4KNMu1BEI4RQ8i9BJ25yxwpAhlH/FdwxpRB
	 b29osgjEHPyiJyJp06MiMUErzdtqwyhgWP7hTmEQ434i6LjJ6l01N0114YJhMWmOwETPg
	 8Dore0bRsikJ1/gCLk3RxYkMoePEF4Kv1OUD2b1wtct65pNoKCVhQh2r/zLH2kE8wDvj6
	 WcbEtLIDE101y00E/XTo1kQTpM0Hf7rPpg5Ajw4IB3Z6eYCakow8gXLNz3QLL8n84Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XVFjrMWz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF47606A31A;
	Wed, 28 Oct 2026 19:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XVFjrMWz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6121F01825;
	Wed, 28 Oct 2026 19:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216557;
	bh=tWCe9G1oOKxLE9zOsnx6a/Y0GQ9BEzXKwGR01EyVheI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVFjrMWzQURF8IrE0cQkZxyFalqgc/plphd74LTK9DEDzNtIbapbsy6RBWqPDSJC3
	 D33RDx24Fj1NTPeDhJDqP/8+d1y1gHIu68Gtv3TQgD1OJsLjrXYUnx3ga2db9aYIRZ
	 gEndqZ1fT7sFI9dIVaMpGS9kD8V46sZ9ddU70EcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1596/1887] wifi: mt76: fix non-AQL packet accounting for MLO stations
Date: Wed, 28 Oct 2026 18:01:32 +0100
Message-ID: <20261028170535.789536082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael-CY Lee <michael-cy.lee@mediatek.com>

[ Upstream commit 8ae659743ba936b22ecb4620815887728e2820d6 ]

__mt76_tx_queue_skb() overrides the wcid passed by the driver with
sta->drv_priv, so the wcid might incorrectly be changed after TX,
causing wcid->non_aql_packets to be counted on the wrong wcid. For
example, on the AP side, if a station's setup link is the 5G link and
the station uses 2G to transmit a frame, the value of non_aql_packets
is increased on the 5G wcid but decreased on the 2G wcid. Once the
inflated counter exceeds MT_MAX_NON_AQL_PKT, the TX scheduler
permanently refuses to service the station.

Drop the reassignment and account on the wcid used for transmission.
This also records the actual wcid in the queue entry.

Fixes: e1378e5228aa ("mt76: rely on AQL for burst size limits on tx queueing")
Signed-off-by: Michael-CY Lee <michael-cy.lee@mediatek.com>
Link: https://patch.msgid.link/20260722082610.2699628-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 4482e4ff78044..3551a013208d3 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -298,7 +298,6 @@ __mt76_tx_queue_skb(struct mt76_phy *phy, int qid, struct sk_buff *skb,
 	if (idx < 0 || !sta)
 		return idx;
 
-	wcid = (struct mt76_wcid *)sta->drv_priv;
 	q->entry[idx].wcid = wcid->idx;
 
 	if (!non_aql)
-- 
2.53.0



