Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457962E041E;
	Tue, 15 Jul 2025 13:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586866; cv=none; b=ButwetEfuZ5hkN2vFEIEusZGWxX1wnXJK1LJAJE7xIu6vCIrhVg6i3rO16C580fuDZ9646Z3RZVCxo/qJB/zJa24hU0eHxk2h9o1FN/7FI1IDlegFlH5gE0B/it6pZerdOh9eT90Bp5VUxaFEw5nokzTPWVrOsRu+mlHMYlnWMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586866; c=relaxed/simple;
	bh=4J1IrSBXAgEEJU1CbufoUqEiDonGxsYcrHSkyYkPHZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/ryWLXLThJE9ZaGEqqdhquk6eY3PSFrK7mqPwL+mdUAAWv9kffaSTVz8JMwXy6rYXw2dEnvX025XNUEQyyvB8JPNOz2bxxa8SwtVpNQPWsUpB7bVWze71qdfSzwtxH7PDfJWThEQyi4tTzUfrJ2WVaJQULn76pUvNI8z7Rjs0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMiMTFu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMiMTFu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F427C4CEE3;
	Tue, 15 Jul 2025 13:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586864;
	bh=4J1IrSBXAgEEJU1CbufoUqEiDonGxsYcrHSkyYkPHZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMiMTFu58hHzQkPqUPIx/Koog3An9072WdHfIW1csW478aYSAPm/2LRt5G/1CDCTG
	 GAgGMi73/1Hl47Yk6PN8Ot/YxTYKbjsU1xwxonu1avSLEwEDxxr4IJRoJ1FkI9vCh7
	 AzEx7IGe+dojSSJPuJlrDO8W0KLA5ZV5I7E9dClA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.15 077/192] wifi: mt76: mt7921: prevent decap offload config before STA initialization
Date: Tue, 15 Jul 2025 15:12:52 +0200
Message-ID: <20250715130818.017544126@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deren Wu <deren.wu@mediatek.com>

commit 7035a082348acf1d43ffb9ff735899f8e3863f8f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1180,6 +1180,9 @@ static void mt7921_sta_set_decap_offload
 	struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 
+	if (!msta->deflink.wcid.sta)
+		return;
+
 	mt792x_mutex_acquire(dev);
 
 	if (enabled)


