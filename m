Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5622B156F45;
	Tue,  9 Jul 2024 11:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523640; cv=none; b=CAxVokOLiK39+susrHbBf6bQD5jl+xaEAVb3WWt48LQnxYUbnZy5jqKtNimxZvXBdsgVhSefi/Az6r4St3APw7b6BnadhPXD9yShQTqGMLEXuRyXd1YUR6rKcew8ayXlDLYUXgr7Q4PJ1Hy/BS50lEY50DbaGu88y/qUozd+Q9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523640; c=relaxed/simple;
	bh=nqlWonKP6mNK6+kDqF+A/RYjFI0qdvrjNNUAQNzoqsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpQGSkgQty40g1y5YVVCIJvmy4WokH8jErCqt5syYezUJFR4I7gZXau3QNbsFV16Ilz4xsv+cKiHT3k5juUCVLtY6Eg0W6/Tqd3eKgjS5j7f4LJ7gJIZCk5lW9X/caOzEMuFsYfFazAkiA1v5toCP/AV6Ns8cMEp1NbLfZ+3M3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/DRK5aY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/DRK5aY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBFBC3277B;
	Tue,  9 Jul 2024 11:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523640;
	bh=nqlWonKP6mNK6+kDqF+A/RYjFI0qdvrjNNUAQNzoqsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/DRK5aYKqwf60A0nxCE5v01ClFjqb9H3mkFxSi8Zx5oCDHLnWt++gSUNVUcbVZst
	 gGNOMUkWIWd4stYEhaV7xIrbciiBlC5AGQ/o2AA/5ln6SEIghR+hSMRCuFMvkt4HdX
	 +HSJYTT/qWWbClmVpVtqbCEoYf5AQ3gL2L+7+Hc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/139] mac802154: fix time calculation in ieee802154_configure_durations()
Date: Tue,  9 Jul 2024 13:09:21 +0200
Message-ID: <20240709110700.528263370@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 07aa33988ad92fef79056f5ec30b9a0e4364b616 ]

Since 'symbol_duration' of 'struct wpan_phy' is in nanoseconds but
'lifs_period' and 'sifs_period' are both in microseconds, fix time
calculation in 'ieee802154_configure_durations()' and use convenient
'NSEC_PER_USEC' in 'ieee802154_setup_wpan_phy_pib()' as well.
Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 781830c800dd ("net: mac802154: Set durations automatically")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
Message-ID: <20240508114010.219527-1-dmantipov@yandex.ru>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac802154/main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 357ece67432b1..3054da2aa9580 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -159,8 +159,10 @@ void ieee802154_configure_durations(struct wpan_phy *phy,
 	}
 
 	phy->symbol_duration = duration;
-	phy->lifs_period = (IEEE802154_LIFS_PERIOD * phy->symbol_duration) / NSEC_PER_SEC;
-	phy->sifs_period = (IEEE802154_SIFS_PERIOD * phy->symbol_duration) / NSEC_PER_SEC;
+	phy->lifs_period =
+		(IEEE802154_LIFS_PERIOD * phy->symbol_duration) / NSEC_PER_USEC;
+	phy->sifs_period =
+		(IEEE802154_SIFS_PERIOD * phy->symbol_duration) / NSEC_PER_USEC;
 }
 EXPORT_SYMBOL(ieee802154_configure_durations);
 
@@ -182,10 +184,10 @@ static void ieee802154_setup_wpan_phy_pib(struct wpan_phy *wpan_phy)
 	 * Should be done when all drivers sets this value.
 	 */
 
-	wpan_phy->lifs_period =
-		(IEEE802154_LIFS_PERIOD * wpan_phy->symbol_duration) / 1000;
-	wpan_phy->sifs_period =
-		(IEEE802154_SIFS_PERIOD * wpan_phy->symbol_duration) / 1000;
+	wpan_phy->lifs_period =	(IEEE802154_LIFS_PERIOD *
+				 wpan_phy->symbol_duration) / NSEC_PER_USEC;
+	wpan_phy->sifs_period =	(IEEE802154_SIFS_PERIOD *
+				 wpan_phy->symbol_duration) / NSEC_PER_USEC;
 }
 
 int ieee802154_register_hw(struct ieee802154_hw *hw)
-- 
2.43.0



