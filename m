Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7E32472AE;
	Tue, 15 Jul 2025 13:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585511; cv=none; b=ZHYwMQzlqpv4Euy883Y68thaetRi9861yQKavzFYtdIflvwkTfjQnSniw3qphalenN8xTH2bOwXTJJq7gmW+PlV66jesJVx2MOyjYR1iI+gmmIGP5eOEgN+bqUs6bCP/IMKX5J12RDV0G3Gyjknx3XnHYuq72+5yIj23PM+zkVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585511; c=relaxed/simple;
	bh=5zDEnbQNzi3c44bVNuIShoUlRN56elzTXb0cwceIYFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUG8LeTX27pPTS9AVz+wneQ/lbF1BqXCXAuaZOgkzH22Z1prJOVBxDLlY1eNYkGqSVNy0uX7nCwK3bP5KwM14Fan6QMd4l7tbtGnsSkVHrsS8h52eTz9j+uMhTn5B+NWZbRkyR0GaTrBwidon2MeuK0IM/qQlegjEun2VO4c/wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRqBkBLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRqBkBLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58AAC4CEE3;
	Tue, 15 Jul 2025 13:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585511;
	bh=5zDEnbQNzi3c44bVNuIShoUlRN56elzTXb0cwceIYFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRqBkBLy2s/QpIcV7WKb0Va2uqiH838+601EVKF4Absjq9V/+4gAs/hiWeUBWQ4Xn
	 Oy868cX+u2FK4AFr0GSPC2esQMNsOxag/Aw9UH8szPTy/5idpvAhVuOMD9dKum2wZL
	 u435D//As37U7wnuhHgYwdBUJz26yzxUEMwMZIuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 068/163] wifi: mt76: mt7921: prevent decap offload config before STA initialization
Date: Tue, 15 Jul 2025 15:12:16 +0200
Message-ID: <20250715130811.471278926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1173,6 +1173,9 @@ static void mt7921_sta_set_decap_offload
 	struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 
+	if (!msta->deflink.wcid.sta)
+		return;
+
 	mt792x_mutex_acquire(dev);
 
 	if (enabled)


