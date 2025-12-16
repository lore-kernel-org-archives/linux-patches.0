Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA68036CE14;
	Tue, 16 Dec 2025 12:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887999; cv=none; b=RXSzD4DwG3tFjKgX6qTWpjS1D6X4D522eSy3Ntw3gyIIKRDiTqlr6r1a7PnLbyM3jDgTLX79Oka4X+GtPbbl+GRs44rFiBQ+bf/aD+PCq6bLVNcSVCQfxoDKTAE/ugvUZQY0FtfZa+8w3yGM8d7UbtWVBcjzPAU9kKRVbNaf8hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887999; c=relaxed/simple;
	bh=S/Vux1qXzOQZ5STfgPojaQkWuCYGswkg44OJ25xdLTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrCLX20LotytfpKeo+4j4vwb4y+Ddbxp64TsXpTZGxNr3tJ/IqeCNH5XZxFXPkU3w0skaHAPxOBUKyROLHTKWaN29p3bZ0P6JxdspC+6E1RNcSy0PmVSuXVvNRxORDMwi6EsTCh/iQLvkzRqR8gF+Dxvts9M9EqfO01XaYK6Msc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9Ohy1UE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9Ohy1UE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A642C4CEF1;
	Tue, 16 Dec 2025 12:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887999;
	bh=S/Vux1qXzOQZ5STfgPojaQkWuCYGswkg44OJ25xdLTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9Ohy1UE/blBNLKUUtpEzOULDFRHKldxu0/7I0cXNQvbvOEV3c9I4Yr4781J2qW2B
	 atReUYAfuJoP+dVZk7pm1Jdkz2GeWkbRpgTAQEI42XkNvcxFN/sAE7HW1trAMzFs+F
	 T2aUszl+N1PnJI9RhSewduAm6Y05jsSZLlrVv2FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 401/614] wifi: mt76: mt7996: Add missing locking in mt7996_mac_sta_rc_work()
Date: Tue, 16 Dec 2025 12:12:48 +0100
Message-ID: <20251216111415.904061917@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index cfad46a532bb7..502136691a69e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2860,6 +2860,8 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 	LIST_HEAD(list);
 	u32 changed;
 
+	mutex_lock(&dev->mt76.mutex);
+
 	spin_lock_bh(&dev->mt76.sta_poll_lock);
 	list_splice_init(&dev->sta_rc_list, &list);
 
@@ -2892,6 +2894,8 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 	}
 
 	spin_unlock_bh(&dev->mt76.sta_poll_lock);
+
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 void mt7996_mac_work(struct work_struct *work)
-- 
2.51.0



