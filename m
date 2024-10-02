Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECA91D04A5;
	Wed,  2 Oct 2024 13:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876960; cv=none; b=OiJ+1KP2Y6zQsUe3tfO73+c8AboV61BCkcyidgLJkcC0dnsdEqZGASskCA5PMxqE6vIIN3nPb381k9zJCv39tH4iOu1L0WkLdDrUBkVt6tYaJWfFavIt+wynZb1DQbZF2n+v6i8rJpaI1Em4nlOJGsVWLFtx5yGn5MB++4Ft1S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876960; c=relaxed/simple;
	bh=XktvzyGYpc7AWxQKydlT/6zsBEA3AiqII+YEZjxYLr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGTMU2OlieFWhF934rsexQL4jIhdQc2ixt77twWptTPEgrsUQYpm5MW7fkL67chxgbx4tOG8Qu8fs93yfErpX45cTW3wOPAHz+9RCSuu1zUre7P9mycbmiviW7sj0/gy8fotoEYTHSGtH8BEfePQq8EiwVuGuFPYj1cd3IKpV8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mA1NXNZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mA1NXNZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B82EC4CECD;
	Wed,  2 Oct 2024 13:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876960;
	bh=XktvzyGYpc7AWxQKydlT/6zsBEA3AiqII+YEZjxYLr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mA1NXNZGibsxXW4ImJVsoqxCXfu9goStZHEvPw6jOPnu+iPbPnMpGq4cESdxiig9a
	 gC4w5gs7DdvG5+sHW/bJAUJxMe2Pp8OBfbcF1cPfg6+16UhxcWCEVjm9hqDwcB+r+r
	 MxUPsGAnPxmTjq0ZXoBcAZ7l5fli3ZSITRTfi/oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.11 618/695] wifi: mt76: mt7925: fix a potential array-index-out-of-bounds issue for clc
Date: Wed,  2 Oct 2024 15:00:16 +0200
Message-ID: <20241002125847.181835087@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -638,6 +638,9 @@ static int mt7925_load_clc(struct mt792x
 	for (offset = 0; offset < len; offset += le32_to_cpu(clc->len)) {
 		clc = (const struct mt7925_clc *)(clc_base + offset);
 
+		if (clc->idx > ARRAY_SIZE(phy->clc))
+			break;
+
 		/* do not init buf again if chip reset triggered */
 		if (phy->clc[clc->idx])
 			continue;


