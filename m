Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7553955D7;
	Tue, 12 May 2026 17:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608304; cv=none; b=iVOOX/NkwP73H49n5k5Z/RUqVgQxeDiiMrrYbphu/2NuY0EWMj/v2vZVC9BZfE3p/sigOdIAsmhul+vdTwPRL8vLow0ewIhyu6cyXQ1ZFyD78ucOviQK3i0Vt1BYDuHDx9A14o+C4sDg3KtlnL0Fc0Rnscyiz7HoCPw3O+i0k7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608304; c=relaxed/simple;
	bh=0HM44PPxkFzGxcR5sIuYaRUl+FLirjHaEa1e/TlH9d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XggyMGm48aRYY5Kq3uKH5EFZGuq+NvfZuwzLgmTRHyL8pc6Q/LywvM+OFzhQJtZAd4vLtqExAQHLMFEQ1XjfEtb29mw0E4RtXAusXQ5+QSTz0sFzAXc3QRKh6XDO+q0hB4QVZolg5ynv7Pkbgdw3fNum6gSH6hDVSvFr1GZtRsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6IgO+Bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6IgO+Bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B18DC2BCB0;
	Tue, 12 May 2026 17:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608304;
	bh=0HM44PPxkFzGxcR5sIuYaRUl+FLirjHaEa1e/TlH9d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6IgO+BpNIlH6/TPXa3azlAdWl6YN8t5dMAO9z9l858oXmeRnZQFyDlKEeK4SJ1LF
	 R4eSj31zi7/7Pj2SDsBoBhCYB0FidFr1zmxrIdH2WrQb1j0MrW2HuU6K6L6KxBVX2V
	 Lw7hq1EDZwwwsGgw8ShVyNSiftc8Qy5oBNlAS/RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 027/270] wifi: mt76: mt7925: fix incorrect length field in txpower command
Date: Tue, 12 May 2026 19:37:08 +0200
Message-ID: <20260512173939.029435352@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit ccb186326bb6b7f20d77982f855568e7087ad0d7 upstream.

Set `tx_power_tlv->len` to `msg_len` instead of `sizeof(*tx_power_tlv)`
to ensure the correct message length is sent to firmware.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250908072526.1833938-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3673,7 +3673,7 @@ mt7925_mcu_rate_txpower_band(struct mt76
 		memcpy(tx_power_tlv->alpha2, dev->alpha2, sizeof(dev->alpha2));
 		tx_power_tlv->n_chan = num_ch;
 		tx_power_tlv->tag = cpu_to_le16(0x1);
-		tx_power_tlv->len = cpu_to_le16(sizeof(*tx_power_tlv));
+		tx_power_tlv->len = cpu_to_le16(msg_len);
 
 		switch (band) {
 		case NL80211_BAND_2GHZ:


