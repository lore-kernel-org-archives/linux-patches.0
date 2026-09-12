Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DFE388E61;
	Sat, 12 Sep 2026 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224459; cv=none; b=pxvtwVjj2qIhXPMJiTOrJkOefzx43yf3HhN2F6A10nmJewuYz63zF0lW9KmELLsXFuVEdyJQjXRdnaM0sA0CuTttJzbrO+J6yf+gCp3F3Li0zgB8/81mWvppwhxn0FXz8MU5G2dIVq/wMT1M0Hz5sky20hfOgq9Y+7TOLEetp3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224459; c=relaxed/simple;
	bh=xpUAzxvGHlUGrplXxkv2Q3/wPWLvEB3WOXHAvXZqPpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6Jl8htrl0WBT/mHe0t1HSBau9fMV7+F6pBJ455qsZHdIAggSG7MjBmsLgxDKa0BpLyqfClJKQTuFySr1sQnb6NUbkBMMdValzHh0wJY2BBAaGP870SF7ddJp1mkx3HBH5HL1Ld2V2SCBGKoWrqmqW05tfLsGLFngfUqrzXXW/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fb6K5j7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fb6K5j7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2631F000FF;
	Sat, 12 Sep 2026 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224458;
	bh=yEQ1MlvLylX5qOhRmr2BaeRrfIvw5GjyEhhL8gqjdNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fb6K5j7aT07bRvZGfxRVp1VLsAwbX6uJxYmqzHHTdTyg6n/ErqdN1zH7NC8xQAFFF
	 fze8/1IiZS2JRZ1m5Z5DTOj3kBdsx7AUp2EoyUUcIYrWk+jrKlZWVJYVXrDAWTYAfH
	 RoofgTPUnvKl6czyoBrA+kCx3K2gO6LeGVClryfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0995/1424] wifi: mt76: mt7915: unlink TWT flow if the MCU rejects the agreement
Date: Sat, 12 Sep 2026 08:57:07 +0200
Message-ID: <20260912065629.599100739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 16a04441eab0dcd4d7126a6f66b370adbf28f96d ]

The flow is added to dev->twt_list before sending the agreement to the
firmware, but the error path leaves it linked while flowid_mask is
never set. The flow slot can then be reused and memset while still on
the list, corrupting twt_list, and station removal leaves a dangling
entry behind that mt7915_mac_twt_sched_list_add() later walks.

Fixes: 3782b69d03e7 ("mt76: mt7915: introduce mt7915_mac_add_twt_setup routine")
Link: https://patch.msgid.link/20260724124813.3961474-17-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index ae91a9815fd22..875ce39089d88 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -2363,8 +2363,10 @@ void mt7915_mac_add_twt_setup(struct ieee80211_hw *hw,
 	}
 	flow->tsf = le64_to_cpu(twt_agrt->twt);
 
-	if (mt7915_mcu_twt_agrt_update(dev, msta->vif, flow, MCU_TWT_AGRT_ADD))
+	if (mt7915_mcu_twt_agrt_update(dev, msta->vif, flow, MCU_TWT_AGRT_ADD)) {
+		list_del(&flow->list);
 		goto unlock;
+	}
 
 	setup_cmd = TWT_SETUP_CMD_ACCEPT;
 	dev->twt.table_mask |= BIT(table_id);
-- 
2.53.0



