Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC7E157E6B;
	Wed, 30 Jul 2025 09:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868502; cv=none; b=GPFOR+okwg7xOMlCxhNqStbJ4SSN6Mp1cCrNH3J30jL7hL2Y9bqp9HECq28DSf8ihp6Pd3e+Uqwzf6PLdwjPLVE/bs3wQmPm/PcUEsFcbExO1Nw0XKi2OCeuCNG1YuWkk43criw/PQMgGy0r9vISk14cXbmXB5WSPyKbI3JTYCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868502; c=relaxed/simple;
	bh=2BijxAJMxJts9p2bjBBi3zViZfDORRfsffptu7gCybI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gON5AMyW32rRKwMkF3Mzv0h6hUoADbrU0lv5H/A2LbSInX2Cn/u+bFaipqPhxUR6JRNvfoqherI4h/guGC/KYGETN6agnNFlyE7m4BaHWJvwJHB2+lF9RykD7Hnb7jBT1HauCAnNl1+Dl1aAO+Y03CTfop2/bJRpEF+Dc5/Dv6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odXiz61W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odXiz61W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F517C4CEE7;
	Wed, 30 Jul 2025 09:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868502;
	bh=2BijxAJMxJts9p2bjBBi3zViZfDORRfsffptu7gCybI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odXiz61WLJdSn4MMK0QtWhqKky1QnpnXLRZSvu6aSspoo6MHrn9qAqE+HoL66bZGR
	 izcl2BvGMn6m3EBxn7YQF5RkLYckgQcvlOGdz4oT5PVb9+LZBVaD/gqBrKKoZIJgrF
	 1aAllz2MK6Q63lUcvkwstE3OR51a/cVrOL3nG80I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 67/76] wifi: mt76: mt7921: prevent decap offload config before STA initialization
Date: Wed, 30 Jul 2025 11:36:00 +0200
Message-ID: <20250730093229.467458106@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 7035a082348acf1d43ffb9ff735899f8e3863f8f ]

The decap offload configuration should only be applied after the STA has
been successfully initialized. Attempting to configure it earlier can lead
to corruption of the MAC configuration in the chip's hardware state.

Add an early check for `msta->deflink.wcid.sta` to ensure the station peer
is properly initialized before proceeding with decapsulation offload
configuration.

Cc: stable@vger.kernel.org
Fixes: 24299fc869f7 ("mt76: mt7921: enable rx header traslation offload")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Link: https://patch.msgid.link/f23a72ba7a3c1ad38ba9e13bb54ef21d6ef44ffb.1748149855.git.deren.wu@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[ Changed msta->deflink.wcid.sta to msta->wcid.sta ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1087,6 +1087,9 @@ static void mt7921_sta_set_decap_offload
 	struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 
+	if (!msta->wcid.sta)
+		return;
+
 	mt792x_mutex_acquire(dev);
 
 	if (enabled)


