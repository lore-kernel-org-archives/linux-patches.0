Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA034BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C8AC433D2;
	Tue,  7 Mar 2023 17:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209210;
	bh=JKfjvsKIKS0QAYDIeHgBGQTWEH93aa30ijgpjkV1Ga4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZkHMMeH0vUv0DZ7/wrTgErGmKEYoVL7VlVsA25HEV/hfr9PasngLw6CoLCTrXukn
	 rpvLKFo+1mKWw049+yuZbJPYZPQjlTbu5F3up/z4gB0JCiyS0eHwao6v2bEtoIu0Sz
	 wnN0Iyf7O9wTMuWOO3yzJU/KXDzeD26ZKj2t4tO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0145/1001] wifi: mt76: mt7915: fix unintended sign extension of mt7915_hw_queue_read()
Date: Tue,  7 Mar 2023 17:48:37 +0100
Message-Id: <20230307170028.348960617@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit edb0406bda4629ef496f52eb11cbea7e92ed301b ]

In the expression "map[i].qid << 24" starts as u8, but is promoted to
"signed int", then sign-extended to type "unsigned long", which is not
intended. Cast to u32 to avoid the sign extension.

Fixes: 776ec4e77aa6 ("mt76: mt7915: rework debugfs queue info")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index a7fdcd1f3d988..5a46813a59eac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -811,7 +811,7 @@ mt7915_hw_queue_read(struct seq_file *s, u32 size,
 		if (val & BIT(map[i].index))
 			continue;
 
-		ctrl = BIT(31) | (map[i].pid << 10) | (map[i].qid << 24);
+		ctrl = BIT(31) | (map[i].pid << 10) | ((u32)map[i].qid << 24);
 		mt76_wr(dev, MT_FL_Q0_CTRL, ctrl);
 
 		head = mt76_get_field(dev, MT_FL_Q2_CTRL,
-- 
2.39.2



