Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B57438D6A2;
	Sat, 12 Sep 2026 08:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201146; cv=none; b=Dd157xaw/5Sl9txOt8ue5OmBimWsyG2TCBVz2l2Twobo5ov6KjVmTTRwKSX85tOc0QVo+PadLVaCmVOoE0t/cYFGFaqINCXOfENbeVx8Ga1hYNADjs5KT1dB6rleEv5BLfQmu6Xc8svNbH/U3uzmBembfbWWgiTKaGR7GxH7YtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201146; c=relaxed/simple;
	bh=pWyxk+Bff3zSQxuX6Ne9y6df6wpkN+6aTvx0PU1QJos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZKsRaJ6IEpAbOYIRaMkr3Ox5gScT09XgL9+aCAEYlbDhPn3eX9P2+VXMyvAiSk7SuWrL7KMAO0P8HMZHIedBENVH1fx8E2Iq7/TOYXQ1TzDcHVekCfVA0y7erhBYNHLioOdvxx9ujOEoeQ3V6Di8Uvt/ntD9jSmceDiXBb9sLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eerVE7du; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eerVE7du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323B61F000FF;
	Sat, 12 Sep 2026 08:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201145;
	bh=95Pj15NS2VJ1HqoNusNhNi0mEjdzsZGbpmumLmBam0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eerVE7duRK9htV0iY5VUBswLRNQ7cumcmofaoGi8/uTuU8LUQiFyGdG285jPWGUCd
	 UJRWW9oG4q6Deu/LR84N7OhZymG04VX5rgml7Ky/HRBMC6a88FRtXpZCTPzM1d/a4G
	 z7lcINsaQ7pH84lAOmAj0gjmTvqdA0ak7oxsI/6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0936/1815] wifi: mt76: mt7996: wake MCU waiters before aborting scan in L1 SER
Date: Sat, 12 Sep 2026 08:44:46 +0200
Message-ID: <20260912065710.929223377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 6f8d8c458010b597bf4114e6fb3162bff7050041 ]

The L1 reset path calls mt76_abort_scan() between setting MT76_MCU_RESET
and waking mcu.wait. A scan work blocked on an in-flight MCU command
does not re-evaluate its wait condition until woken, so the
cancel_delayed_work_sync() inside the abort sleeps out the full MCU
timeout before recovery can proceed, adding several seconds of SER
latency. mt7996_mac_full_reset() and the mt7915 counterpart already
order the wake-up first.

Wake mcu.wait immediately after setting MT76_MCU_RESET so in-flight
commands bail out before the abort synchronises against them.

Fixes: b36d55610215 ("wifi: mt76: abort scan/roc on hw restart")
Link: https://patch.msgid.link/20260724124813.3961474-19-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 86120e3851bb9..3d11ce226e898 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2569,8 +2569,8 @@ void mt7996_mac_reset_work(struct work_struct *work)
 
 	set_bit(MT76_RESET, &dev->mphy.state);
 	set_bit(MT76_MCU_RESET, &dev->mphy.state);
-	mt76_abort_scan(&dev->mt76);
 	wake_up(&dev->mt76.mcu.wait);
+	mt76_abort_scan(&dev->mt76);
 
 	cancel_work_sync(&dev->wed_rro.work);
 	mt7996_for_each_phy(dev, phy) {
-- 
2.53.0



