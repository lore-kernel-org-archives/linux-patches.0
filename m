Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025852;
	b=znuks3/ipLj25DBgLkNVcYZLbCuP2IAyVXh6tGYUkT71xnS28legkWLG2DvCbisrrFE+
	 YhYAv2Aji9ke8AJDE6Ok3TVuJlWZ4wOGZmnYNCywWXDOaCfnUIeKkphZ42U646eiJXU81
	 nZeXPR8wJh8SLT91KNg6kMJ5mDllpKhP2/dXuN0y0vRP5GX8ty5AKUUNNnKtab+K4b3Xg
	 LHSVc8uxBDz7plVxxKeyzXwcc1iXuv/nHnXYQGEPwyKDUo6jKcTT9Vj9dGzYdQZH5Sm9f
	 0SQOOSLffnIibc52SQ7vEixaNweZyT2LphUarNj5NAdvKZBA1RN4lBBpttvcI1dM7/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BurP/x4J02tx2OfcKFiE12oWNIy49i62ZomJupOe7Ow=;
	b=AN+Pw+pOHopRdmj/hBojdlvh03wuzBG5RnEwtyZIre6q1fwzvEB6FIWOGbd7gJcs7Hjn
	 nPLGypXZIhJObI1fdrKu0j9wldyWbLJvbhtHN2YG8JnCRp58fUGJWD0fPL2DmoLkUbhyr
	 3ONObTqYlr53j1E5v5VL3Jd9Ebu8in6BOh+97ZJ6r1qWAGqh1U7IfVe7MfmRAss9czFez
	 eiPcUsW8/Rt070ffXL4CmyjWeXIQVJhnrmxBo2TbEfm9YsBHaFMXmSsa8Zf5FnTSj27IP
	 W/7Y8QibVpr2xVjbDnVMecc3QHYypy8/yUidHCB8c8CZbPFs2R+BoiWCv5b6UkIrH1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSF3oecE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568AC60A2600;
	Wed, 18 Nov 2026 18:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSF3oecE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570051F000D0;
	Wed, 18 Nov 2026 18:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025851;
	bh=BurP/x4J02tx2OfcKFiE12oWNIy49i62ZomJupOe7Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSF3oecE4fW6lWfQJWdjyaGGBZuehd7SCwWE2//SBO5WeqTnX38+ANDzu69jQ4dKH
	 ve6Y7G55K+EqkAEYLBPqApO7DGqtT5eWRvtyBZNWy5E4FefsRyMJiua1IOtqus+obi
	 QnnBYe04llujnNvcwv+5kyirKAAK+s1f5h6y9dvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1199/2151] wifi: mt76: mt7996: bound RRO session id before indexing addr_elem[]
Date: Wed, 18 Nov 2026 15:48:54 +0100
Message-ID: <20261118150205.884298005@linuxfoundation.org>
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

[ Upstream commit ec0889c74734131c6526493bd3134eea7de25bf8 ]

seq_id from the WED RRO indication is a 12-bit field (0-4095), but only
values up to MT7996_RRO_MAX_SESSION map into wed_rro.addr_elem[], which
has MT7996_RRO_ADDR_ELEM_LEN (128) entries. A larger session id computes
an out-of-bounds element index that is then read and, on a signature
mismatch, written. Reject an out-of-range session id.

Fixes: a09d2f9d69af ("wifi: mt76: Convert mt76_wed_rro_ind to LE")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 8730a1eeac389..c49e3eeb0856e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1973,6 +1973,9 @@ void mt7996_rro_rx_process(struct mt76_dev *mdev, void *data)
 	struct mt7996_msdu_page *p = NULL;
 	int i, seq_num = 0;
 
+	if (seq_id > MT7996_RRO_MAX_SESSION)
+		return;
+
 	for (i = 0; i < ind_count; i++) {
 		struct mt7996_wed_rro_addr *e;
 		struct mt76_rx_status *status;
-- 
2.53.0



