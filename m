Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7521814B080;
	Wed,  5 Feb 2025 14:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765452; cv=none; b=GspS3AbspI+X8xlPtztAb4bL+0nX6SAh00ZuxSQmH7vjwoIwqPy6hW7jjJ/lbmMqiU6R55sUDEHqiZ9/gDAS4IIZ6h2aoRGUkvb/VgRqVnGWc89HlWruOHu/uT8p2Bc+P841hFMVfHUvdt3VQyrEEgRF52iSo/X1h7tScOoqtTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765452; c=relaxed/simple;
	bh=pjkuBPFoi6NmzA+pKgEDqy9D9KYLAe0j8cSiVjSeiPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZdUFiEfGuNN2UN8RKDqWiN5vYnADmhx/eneaXFR88auLD4kPUWd3xX32k3StxJ4+aLzKiSSjtysYC7i4n8LmiCNz5eUOs1BSfwQa5C8TMdEzdlCLncI0oDTl8RiEVfWna/pO5EoKB4f4j2SalDyDM7PupJeJf70L7x8q1mKc+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dK2kykwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dK2kykwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AB9C4CED1;
	Wed,  5 Feb 2025 14:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765452;
	bh=pjkuBPFoi6NmzA+pKgEDqy9D9KYLAe0j8cSiVjSeiPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dK2kykwKkZcVOJCDhUKA/r6vYOe/FiCFzaIC2LN7aBBgJwaYd44ryNFgEGh+TBIsM
	 Y5Iyisei1ZWFypeR0grmm/wm/GlxmqylBKrP83kwUs6TkzndsFsGAVM6rdDXKEQrVT
	 Pj9FBq86slYjuw5HxXoy/WDyI3EQD5UCqJNgU3BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	David Ruth <druth@chromium.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 179/623] wifi: mt76: mt7921: fix using incorrect group cipher after disconnection.
Date: Wed,  5 Feb 2025 14:38:41 +0100
Message-ID: <20250205134503.081692668@linuxfoundation.org>
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

From: Michael Lo <michael.lo@mediatek.com>

[ Upstream commit aa566ac6b7272e7ea5359cb682bdca36d2fc7e73 ]

To avoid incorrect cipher after disconnection, we should
do the key deletion process in this case.

Fixes: e6db67fa871d ("wifi: mt76: ignore key disable commands")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Tested-by: David Ruth <druth@chromium.org>
Reviewed-by: David Ruth <druth@chromium.org>
Link: https://patch.msgid.link/20240801024335.12981-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index a7f5bfbc02ed1..0641538968e6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -531,7 +531,13 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	} else {
 		if (idx == *wcid_keyidx)
 			*wcid_keyidx = -1;
-		goto out;
+
+		/* For security issue we don't trigger the key deletion when
+		 * reassociating. But we should trigger the deletion process
+		 * to avoid using incorrect cipher after disconnection,
+		 */
+		if (vif->type != NL80211_IFTYPE_STATION || vif->cfg.assoc)
+			goto out;
 	}
 
 	mt76_wcid_key_setup(&dev->mt76, wcid, key);
-- 
2.39.5



