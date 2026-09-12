Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673AF34AB14;
	Sat, 12 Sep 2026 10:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209016; cv=none; b=rVYDoAdX3eaa6d1zsGxzrFAfOjmPolPQfRVGAHcjOVUZoLAFXc+8R+Og9HYEAHdL9gf0iJ+OfKM2USmz4OLNnsarsAvzYuqiKshLzSWKQSdjZxNbOrwaNuDNVEI9ZBWZdd9neC/wVvGSRIVGJokRcnPGQSNfjMH1eYEbzobtl4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209016; c=relaxed/simple;
	bh=pun021NPvTLkF+SAAKKwUn/syEKnYA078BusZC4XiUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cY0dIJ9903Tx7X1moKzmNv7webMyyTPZU6V4V8uxr434OX6zy8H07ftP4Rj8WIuAeuCcfTgOEKSxXhQ6F4BRCHUyM3ip4ZpMhZreTJrb7TNQB5cw8raIyVgULmh3zZ7k/d6G5x1jhWD4RPn9y1zKi6CM2S6xxavKFMVuBdFmEKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeZ7cNxS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeZ7cNxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F403B1F000FF;
	Sat, 12 Sep 2026 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209015;
	bh=1FPgEzqhsvzaoTz4FdtYYj8IaAT3psCCn1lTfK06ILE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeZ7cNxSg1HTjGb6eGOQLcjh3BRpqCmS1zGqMqMTjleGNynGZrbZTyLnkvoC6FOOG
	 pBSbPu/VfKr8UXCpLafMsTqXALzMwXaG0nQpMHSWstSL8D9i+fIWP50VvgD89uF4qb
	 HnM9BBL8W+i3nsaLVVC4PJS1Y/+RKHw/f4kCafg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jared.Huang" <jared.huang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0733/1518] wifi: mt76: mt7925: update clc before setting sar power table
Date: Sat, 12 Sep 2026 08:48:22 +0200
Message-ID: <20260912065640.017510582@linuxfoundation.org>
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

From: Jared.Huang <jared.huang@mediatek.com>

[ Upstream commit 8a27c5c764040fbc990cc416a927b1d7eadf559f ]

Fix the power table update sequence to ensure CLC is loaded before
setting SAR power table.

The firmware requires CLC baseline to be established first
to properly calculate the final power limit as min(clc_limit, rate_limit,sar_limit).

Fixes: 9557b6fe0c8b ("wifi: mt76: mt7925: refine the txpower initialization flow")
Signed-off-by: Jared.Huang <jared.huang@mediatek.com>
Link: https://patch.msgid.link/20260617071305.1808394-1-jb.tsai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 8ef0d981adc9a..cb1046c59cf6c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1688,9 +1688,15 @@ static int mt7925_set_sar_specs(struct ieee80211_hw *hw,
 	int err;
 
 	mt792x_mutex_acquire(dev);
+	err = mt7925_mcu_set_clc(dev, dev->mt76.alpha2,
+			 dev->country_ie_env);
+	if (err < 0)
+		goto out;
+
 	err = mt7925_set_tx_sar_pwr(hw, sar);
-	mt792x_mutex_release(dev);
 
+out:
+	mt792x_mutex_release(dev);
 	return err;
 }
 
-- 
2.53.0



