Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F1D36E484;
	Sat, 12 Sep 2026 08:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201035; cv=none; b=sHjb99gztBdU1YUE1Eish+lWcnL9xEbt7nl2LrbEdp6n+zE6iFd7VSnOer6jsnxYpm4+QpH+m4Hzj5cKoA+1dqIEhZKM+y1bbN5yMYJ3OP/zL9vTipRQQOm524v6gm5phbZMxeIhM51HmEtU56+0NjaB9E7AdBTvHI3ghm4u1R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201035; c=relaxed/simple;
	bh=7SBRPjISZoM90e08Kbr0+cE1/zNYnB3Eh15Oq/gvBlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVLMLIrBIvd/UZB9rKMEzdQlvIj04nRlmqdnpXylpsCZvbag/VC4LHzXvLjcpUpICW9dDoyBiewzjT+hPFpEQY7WN6F1xbK7jyF+YU0AuqDtdzc/Gqcoh2TR3ZrN6qYI2S5EsO5Ak0RaMv9p4f1eahFLbGCqkNAWfCntbl/ZNA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWxUhBUX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWxUhBUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9471F000FF;
	Sat, 12 Sep 2026 08:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201034;
	bh=v64T1wBYHFqix8/LnXDQU9O+cBejjm+6a6VZfd7Xg4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWxUhBUXlvH4O9wKPPFgnhGZuT19F7snTA29CN2u5jIkn0cXyLp58YIP5cXsKOAjB
	 Q3yEm6H34ua7478cJwVc0LPzCKjJptsqZK0Wb140me05zU149T6ZLqlHtYcUnZWITi
	 qkrz6csAgqMeW+f1jDgZVAKbk3Dn5iz9A88BVq8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jared.Huang" <jared.huang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0870/1815] wifi: mt76: mt7925: update clc before setting sar power table
Date: Sat, 12 Sep 2026 08:43:40 +0200
Message-ID: <20260912065709.346303064@linuxfoundation.org>
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
index fd3dea043cbe7..6a09c0a0d4280 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1828,9 +1828,15 @@ static int mt7925_set_sar_specs(struct ieee80211_hw *hw,
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



