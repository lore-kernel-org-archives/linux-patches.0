Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EDE1D0E24;
	Wed,  2 Oct 2024 14:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878841; cv=none; b=I9Ta9HGs9dkR0yEGB3dayFTJZfb72g2bgp/hJGK9gwRrXllz/jN/ZBoWp093HoFRVPWaYEkP1K2Ai16s8Pjd09GN9PRvud2zJTEFoYIuwI97uXfoBTwpSbhL7nrZeYwOPZkd5UlI+XBHfIve8+sf/W2Vrr6U9l6O4V+cgZmeejY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878841; c=relaxed/simple;
	bh=GUUGqf/QBtjOfqicBZoqQokDbo0muPNKX26WKQa36L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrAuoC/BWjENX79sKRt3iMZtIGQioAsnpJDd/YhOyyD9Gh3yH7EN7AgrqxLgQXxVSVeDUuigvo3i1bTj3P9vmjBifpSaAlUu8ZvtfWhue5HBFTlSVmIIZMGR5MzZ+wkx1fgiH0J6jLdJcD/RfbuvynucqCzFHAfpLeS5EU3KVgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z25jTyxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z25jTyxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8859CC4CEC5;
	Wed,  2 Oct 2024 14:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878840;
	bh=GUUGqf/QBtjOfqicBZoqQokDbo0muPNKX26WKQa36L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z25jTyxRw47U4dLE05beLK7EN+XKuK5F4AnI1d/vf9JLvk+Gi8CWseks7E8OdZaGy
	 GsgFeYCUhYttSA6dSsvEgvXPYV7+XpsmEYK22bXKSd0v+vLXGfgQdUZC/+dqICL4QP
	 GOyU1Q60/xLYI2lfCZrFkcQylgwHeZmnynaQo/oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.10 551/634] wifi: mt76: mt7925: fix a potential array-index-out-of-bounds issue for clc
Date: Wed,  2 Oct 2024 15:00:51 +0200
Message-ID: <20241002125832.859356309@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 9679ca7326e52282cc923c4d71d81c999cb6cd55 upstream.

Due to the lack of checks on the clc array, if the firmware supports
more clc configuration, it will cause illegal memory access.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20240819015334.14580-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -613,6 +613,9 @@ static int mt7925_load_clc(struct mt792x
 	for (offset = 0; offset < len; offset += le32_to_cpu(clc->len)) {
 		clc = (const struct mt7925_clc *)(clc_base + offset);
 
+		if (clc->idx > ARRAY_SIZE(phy->clc))
+			break;
+
 		/* do not init buf again if chip reset triggered */
 		if (phy->clc[clc->idx])
 			continue;


