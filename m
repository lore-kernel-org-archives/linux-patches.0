Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE0CBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E5EC433D2;
	Tue,  7 Mar 2023 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209207;
	bh=JTOfQMj7XAabYh0D90udwL3b3BEyWEo1uwgwnQH04t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6JRr8Fsq4BjQ4NC+b5M61/wwt9gvoqGelTAekIRpdagwLsU366gRujCMhMUw9RnZ
	 a7QAIPhvuZO7su8+3/pqM8iiJM1usfPKM7bspmeyyVeN9shU2SvbNBnZXpFa+4LTzk
	 hUh2Ga7l9ndQ8k8vKyTosm3Ad3pzMcwBUP3O55vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	coverity-bot <keescook+coverity-bot@chromium.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0144/1001] wifi: mt76: mt7996: fix unintended sign extension of mt7996_hw_queue_read()
Date: Tue,  7 Mar 2023 17:48:36 +0100
Message-Id: <20230307170028.315087728@linuxfoundation.org>
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

[ Upstream commit 063cca0252b46970e7e9ca423d5e930be3179aa1 ]

In the expression "map[i].qid << 24" starts as u8, but is promoted to
"signed int", then sign-extended to type "unsigned long", which is not
intended. Cast to u32 to avoid the sign extension.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527813 ("Integer handling issues")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
index 99b23aef53a50..3d4fbbbcc2062 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
@@ -457,7 +457,7 @@ mt7996_hw_queue_read(struct seq_file *s, u32 size,
 		if (val & BIT(map[i].index))
 			continue;
 
-		ctrl = BIT(31) | (map[i].pid << 10) | (map[i].qid << 24);
+		ctrl = BIT(31) | (map[i].pid << 10) | ((u32)map[i].qid << 24);
 		mt76_wr(dev, MT_FL_Q0_CTRL, ctrl);
 
 		head = mt76_get_field(dev, MT_FL_Q2_CTRL,
-- 
2.39.2



