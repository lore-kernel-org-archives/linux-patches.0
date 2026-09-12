Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F6429CD3;
	Sat, 12 Sep 2026 10:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209282; cv=none; b=b//UW3UuXul1GgZjOgLmlT4laApHGaf1Rj6uMKzzPQkcOSiooxXOGsl893rjdcXed8YjAWzJnBhgHubd6OscEFVIsR9pIaFKxMKVO42qaYH5bsYl8XNWksSfK+cRXAM2izIEMyPvZy18YelgekNL6aD6Di3H3RHEXAwoE+7MXqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209282; c=relaxed/simple;
	bh=VRhpSjrt2DEXsMumq5ASmwj42ftDSqAwrZ25kKl9HDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwobAaA1S2MQA3HuXc/AyqrnOI0ANDfEKMtJk8tV0IHjlQNo1ozyg2Sgysj6OXwos0GLSAyIcBrZTYeq43O/PFQrZ56wDnKWeEnK6gvIh/yTmyQwMcvHCCQvlbrKbFFOVFm/1XN9ugMs2b3w7xkJInFM0+qdIKP/Npc9Uqn4HCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nD7BeO9l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nD7BeO9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9291F000FF;
	Sat, 12 Sep 2026 10:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209280;
	bh=ztGzFYQ5wjjr/M+u4wp/N5dnR0B/QbkDvZ+uz6Cr7bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nD7BeO9lXG32CQCk8khKo+CPSV7NNt+54XOn5GK2pNiqU2xazyo2sCKSqtPyoP2Rg
	 6jaY+Yk8ANNKV3i3+1eFlwdOkHYSZNQx5VmL9uOu1phTSiRQJ+t7jM10rX/H6NnZC3
	 1zsBR4r7ajXkBAMMDVSJJ2L1kPd3ivIywRl7N5xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0790/1518] wifi: mt76: mt7996: wake MCU waiters before aborting scan in L1 SER
Date: Sat, 12 Sep 2026 08:49:19 +0200
Message-ID: <20260912065641.305192877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index cafdbd27f1e48..35a34fc346eb7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2620,8 +2620,8 @@ void mt7996_mac_reset_work(struct work_struct *work)
 
 	set_bit(MT76_RESET, &dev->mphy.state);
 	set_bit(MT76_MCU_RESET, &dev->mphy.state);
-	mt76_abort_scan(&dev->mt76);
 	wake_up(&dev->mt76.mcu.wait);
+	mt76_abort_scan(&dev->mt76);
 
 	cancel_work_sync(&dev->wed_rro.work);
 	mt7996_for_each_phy(dev, phy) {
-- 
2.53.0



