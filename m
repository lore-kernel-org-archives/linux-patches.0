Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216546;
	b=3WTksjg7soLMm3hLT1viAi2mxlgOhLFUAHeW3BlSuhfEcSwAHP90ttrArwIBCQGznZiV
	 XLoB0GdgswdvMda0OqWzk7X0X0d7vDBo8sPdSii306mxbL6/pqU/UlA2IPZBevwUKMsnm
	 kr62gUrT4mu/vlCe6gfjNEqIGCyQ2gJRALu45fKLRtnw/JvLrnNi2rDnevK9cD+BLSdIn
	 FdKDP08ROtd4r73b7DhqbWKVNg7novCt0lFUTW3TVPsxHCaUyILf6ZRRhrPiAOj4ziFZJ
	 spCy6RF4AAgnjT/CQh7FHifWiarh7MXHx0sOWIPpM2oP3HfdKzLPdUzbKu7xhONew/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jzySy0RfMoskprO8EVdcJU5yo5szUQh4ZDlUfxQjUZo=;
	b=T4c4Rruz/7F407rSu8RcnSKkM9emDILklpQyVVbrCld6SitTk17997lCSNG78pHAHrQ6
	 7iE0a5B2lJ3Qvc+e0j/qHUjr/9ogwVhl3Mu66+VwuXccOvf0R1XX0P3oTO21GRTBoMtIi
	 myjF2HznBo03VYrQFdODvR1f2vxDSFewvm88MgumoKoAzs4ePnuQJteBhlZMcrnRW0bnG
	 vN+Rdw+Q18+bGTP95hv8ozmticFBVwRqyo+z1f8lDmuIDGfkBfYZFvm5IDLDbmAm3weoM
	 FXw2X+9YZzeToBnqT6thgTcA/+DocGABP4LhhY0XAGrX0hTYhTRYVLCrUlkIsMTxdZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zz5Igvlq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1711C606A31C;
	Wed, 28 Oct 2026 19:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zz5Igvlq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664FD1F01829;
	Wed, 28 Oct 2026 19:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216545;
	bh=jzySy0RfMoskprO8EVdcJU5yo5szUQh4ZDlUfxQjUZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zz5IgvlqvirlguEGN2kPVqbwhi6R+H/8+JhYilECnsS4eTFrbexr9Kp6cEpvYxoEy
	 YYdRo5Vm7/WAZMv713NuO9Lxb3tomYAg4FtA3NyMB7GAMLFma5oOeMfy7nmPufrxBm
	 DFa/wboMXJfVee09QjGw0mRoJ/wR/8+t/uFlxWhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1592/1887] wifi: mt76: cancel reset and rc work on device unregister
Date: Wed, 28 Oct 2026 18:01:28 +0100
Message-ID: <20261028170535.698808999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit e995d3dccc9d980af13a60ad37409ed1561f9eeb ]

Both drivers cancelled dump_work on unregister but left reset_work and
rc_work to be flushed only by destroy_workqueue() in mt76_free_device(),
which runs after the hw is unregistered and the hardware stopped. A
reset_work that fires in that window calls ieee80211_restart_hw() and
re-arms mac_work on an unregistered hw, and rc_work touches station state
being torn down. Cancel both up front, alongside dump_work.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20260724124813.3961474-10-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 782ce83bdab96..35a8052cf1e31 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1152,6 +1152,8 @@ int mt7915_register_device(struct mt7915_dev *dev)
 void mt7915_unregister_device(struct mt7915_dev *dev)
 {
 	cancel_work_sync(&dev->dump_work);
+	cancel_work_sync(&dev->reset_work);
+	cancel_work_sync(&dev->rc_work);
 	mt7915_unregister_ext_phy(dev);
 	mt7915_coredump_unregister(dev);
 	mt7915_unregister_thermal(&dev->phy);
-- 
2.53.0



