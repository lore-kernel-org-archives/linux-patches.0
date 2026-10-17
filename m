Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F25E31B828;
	Sat, 17 Oct 2026 18:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260554; cv=none; b=m916y9GMiq9L8CRbOPmtNVfDYMYSm5tuJTnZF03osiKMSeotMdCBk64e4ta1MMxuquTXhRcdvozvcXcmt1UieuW1CWZPdYepoI7hqZHUUBsnbVkqeBMtQO3UQZD3OywLTP/7KT5bhoe2bAiMa18OaWoxIiX+8GB/orL3w0nl5Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260554; c=relaxed/simple;
	bh=1/XyAY65o7Ueipzw/rXWFlQsLfAyC1jAqzaErZv85ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpQvQ0/erhqmZTbl7krDTJQyAHdgczF388ViZ8NpO5QtEbITOoWnoLSTlkRtEDpwkdBJa/Xg0JtvI7R/zfNUNyh/vKXY2f9tvQbHxbNMtLFqg5QjuCitRnnnmEWC1fhHreprBcBZooLtnnvTIVLKJfht0rFJTdM+f2zZ7kcKJYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOq5mE+Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOq5mE+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E303A1F000C4;
	Sat, 17 Oct 2026 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260553;
	bh=A0xwudWM/xBzMNZvuWZpfuQ+A+TlbhHbe0/zfBTyRNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOq5mE+QIggtrZU7dRzpo08rSJdlfESjCD+NoZT1Vvm6tkjbwLc9L+FCueU06Vcgj
	 fyrwcfn8G3ZWCvyd9e1o70oFZcai0LxWC0HeAF9QWbNjWj3zUo4svy3AzD+DksdSDE
	 jqr/XJl8/SFD3fhad/w6YJlYakj7zhy5KRqKWhHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1581/1674] wifi: mt76: mt7996: validate RX band_idx before dereferencing phys[]
Date: Sat, 17 Oct 2026 18:04:13 +0200
Message-ID: <20261017160511.671788879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 2243778a5fae8329ab5f18e7adcd7e03b911a1b7 ]

band_idx comes from a 2-bit descriptor field (0-3) and was used directly
to index dev->mt76.phys[] (size __MT_MAX_BAND == 3) and dereference the
result. A corrupt or reserved descriptor value could index out of bounds
or hit a NULL phy on parts with fewer bands. Reject invalid band indices,
mirroring mt7996_rx_get_wcid().

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20260722082610.2699628-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 596ae2b6cbe98..14c84219ef750 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -479,7 +479,13 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, struct sk_buff *skb)
 	memset(status, 0, sizeof(*status));
 
 	band_idx = FIELD_GET(MT_RXD1_NORMAL_BAND_IDX, rxd1);
+	if (band_idx >= __MT_MAX_BAND)
+		return -EINVAL;
+
 	mphy = dev->mt76.phys[band_idx];
+	if (!mphy)
+		return -EINVAL;
+
 	phy = mphy->priv;
 	status->phy_idx = mphy->band_idx;
 
-- 
2.53.0



