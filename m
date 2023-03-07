Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72904BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE69C433EF;
	Tue,  7 Mar 2023 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209173;
	bh=HfaJWHZl+JH43C1Bek46RIqZuuGlw8+EzMGUtsguQ8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpYyhrfqO0DUOcyKuhuE9VPayg3sWy2xJHNGjLlx+8EwfigZydcVhfiIRH5I7Mji0
	 8ljLoNNh0XpglS3MmrcQvF13zhK/5HMzLrclJHFkoRwKKHmpqHpwubNmwiDxUPaUs4
	 8JEr2uizKU7DRxcpO8xHJ8kngixzg3rj0bALl5H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	coverity-bot <keescook+coverity-bot@chromium.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0134/1001] wifi: mt76: mt7915: fix mt7915_rate_txpower_get() resource leaks
Date: Tue,  7 Mar 2023 17:48:26 +0100
Message-Id: <20230307170027.883997394@linuxfoundation.org>
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

[ Upstream commit 8b25301af01566f4b5a301fc1ad7c5d2b1788d7f ]

Coverity message: variable "buf" going out of scope leaks the storage.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527799 ("Resource leaks")
Fixes: e3296759f347 ("wifi: mt76: mt7915: enable per bandwidth power limit support")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index fb46c2c1784f2..a7fdcd1f3d988 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -996,7 +996,7 @@ mt7915_rate_txpower_get(struct file *file, char __user *user_buf,
 
 	ret = mt7915_mcu_get_txpower_sku(phy, txpwr, sizeof(txpwr));
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Txpower propagation path: TMAC -> TXV -> BBP */
 	len += scnprintf(buf + len, sz - len,
@@ -1047,6 +1047,8 @@ mt7915_rate_txpower_get(struct file *file, char __user *user_buf,
 			 mt76_get_field(dev, reg, MT_WF_PHY_TPC_POWER));
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+out:
 	kfree(buf);
 	return ret;
 }
-- 
2.39.2



