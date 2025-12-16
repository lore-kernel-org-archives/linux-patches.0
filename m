Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBB9345CCB;
	Tue, 16 Dec 2025 11:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886095; cv=none; b=ShO5U2AK6sHfTN9d5fr4GnmRFZW9j+6+l4MwwJkGLK9/uLpGrUit6igz/Oe8AVdKks3ElqiZ4jTtW9pUcD+f7pKeoXUEYCZrgK8T/anL37GpZItCfvPxkZ6FtCKEjo9edKfMtDExcTTieBXVp86ADMPLTzOzsm3+tF0/Gi2FG20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886095; c=relaxed/simple;
	bh=Vox0+3yn1+b/itjMQEzv3uaow+fg/tzExicVLD9HpYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLhMXR+8CU94l5LBSXD7l75DvECaPKWf9i1OcZx8ZiB6/2QDEMAD1jkkoU2TBJwhJCEOE+U9SkH0JqWgIkh92nyinJ3a8+YoWh4KDZV7/h/dM9JFCttQRfEaywKr5PghsXjVtpg8nGRaNRVA/jVkdziTLdaO9g2YYUQy1V7NTR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5NyeBma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5NyeBma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A3FC4CEF1;
	Tue, 16 Dec 2025 11:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886095;
	bh=Vox0+3yn1+b/itjMQEzv3uaow+fg/tzExicVLD9HpYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5NyeBmaA++qyV23+VJDmQqdVcEjp56FYnXEATR1d/y7TvR5Q5hXipyHPcY926Kej
	 Wzg7yl2mIWWsShv/MtDLE8Q/Ya6hFfvhs+OcWDbgE+ni79zR7J76XIwYeuh5hHMfPR
	 5Bw/RNxpBAlkFguTw1L1XvQRbrfvNAbhnGeo6t2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 336/507] wifi: mt76: mt7996: Add missing locking in mt7996_mac_sta_rc_work()
Date: Tue, 16 Dec 2025 12:12:57 +0100
Message-ID: <20251216111357.636215935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 7545551631fa63101f97974f49ac0b564814f703 ]

Grab the mt76 mutex running mt7996_mac_sta_rc_work() since it is
required by mt7996_mcu_add_rate_ctrl routine.

Fixes: 28d519d0d493a ("wifi: mt76: Move RCU section in mt7996_mcu_add_rate_ctrl_fixed()")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251118-mt7996-rc-work-missing-mtx-v1-1-0739c493a6cb@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index b0092794f37c9..4662111ad064d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2338,6 +2338,8 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 	LIST_HEAD(list);
 	u32 changed;
 
+	mutex_lock(&dev->mt76.mutex);
+
 	spin_lock_bh(&dev->mt76.sta_poll_lock);
 	list_splice_init(&dev->sta_rc_list, &list);
 
@@ -2370,6 +2372,8 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 	}
 
 	spin_unlock_bh(&dev->mt76.sta_poll_lock);
+
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 void mt7996_mac_work(struct work_struct *work)
-- 
2.51.0



