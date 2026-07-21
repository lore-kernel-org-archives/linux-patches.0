Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A56384CC4;
	Tue, 21 Jul 2026 19:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662126; cv=none; b=kNqmhR/SysFAWz+x/SaVEvbxidURGs2W/4xNpASCZcyZk+ApV25acmXX/nzVggzbKvYgKqGWLWj23YT8xEHVWjpLyYBQMfG9ea93qKkX7W8Ooe3q0gCv6NommvkHAoo/zwa805Y6x+TW+G6Ry+1TCGTyTfVsT5ll1Z2IJkK8k2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662126; c=relaxed/simple;
	bh=r3lgS84/S1tIDUatbGGKDPMQcg+kQbvneiui+/mU41c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zs6qh2JZFjWk+F8RxMskqv3ONeoukqDs3eFHQqiW1hzJxIFc4ELf3rYvC086eQYp5s3MwG3ZLwYDYAlOPZnw1SDrFAwmXyecvAnu1fPYSNGmrVdDyF20Auixm/O3bJAs9Ra1J02ZbGxlFtu6lh6VigvPXfxSbBuqPQuHEXEx41A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZDkzXIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZDkzXIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B3E1F000E9;
	Tue, 21 Jul 2026 19:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662121;
	bh=xz6d6EkHYoabouw4vYtspeXgJlhzLAB/DiEcRuqgjw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZDkzXIg6zJaZN8JM1soGFg4GVD6nSz7VGOX8z6rRUukKBfO6p2/2s5LMPM7I30xx
	 nLl+4KiYR7VEvLrdYbSBR1VVsMqReU5QD0QSHBpUyUAu0+wWwFrqPQ8wezTsf1dDh6
	 SZRen4KgQfToE4qcct1gMTylGaiCdrr7ZLgPPUB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin FM <marcin@lgic.pl>,
	Cristian-Florin Radoi <radoi.chris@gmail.com>,
	George Salukvadze <giosal90@gmail.com>,
	Evgeny Kapusta <3193631@gmail.com>,
	Samu Toljamo <samu.toljamo@gmail.com>,
	Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>,
	Chapuis Dario <chapuisdario4@gmail.com>,
	=?UTF-8?q?Thibaut=20Fran=C3=A7ois?= <tibo@humeurlibre.fr>,
	=?UTF-8?q?=E5=BC=A0=E6=97=AD=E6=B6=B5?= <Loong.0x00@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Javier Tia <floss@jetm.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0281/1276] wifi: mt76: mt7925: fix stale pointer comparisons in change_vif_links
Date: Tue, 21 Jul 2026 17:12:04 +0200
Message-ID: <20260721152452.367138752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Tia <floss@jetm.me>

[ Upstream commit 9f1accf3069a0cd42c14ca6c7d44d5b17cc48a80 ]

In the error path of mt7925_change_vif_links(), the free: label iterates
over link_ids to clean up, but compares against `mconf` and `mlink`
which hold stale values from the last loop iteration rather than the
current link_id being freed.

Use array-indexed access (mconfs[link_id] / mlinks[link_id]) to compare
against the correct per-link pointers.

Fixes: 69acd6d910b0 ("wifi: mt76: mt7925: add mt7925_change_vif_links")
Tested-by: Marcin FM <marcin@lgic.pl>
Tested-by: Cristian-Florin Radoi <radoi.chris@gmail.com>
Tested-by: George Salukvadze <giosal90@gmail.com>
Tested-by: Evgeny Kapusta <3193631@gmail.com>
Tested-by: Samu Toljamo <samu.toljamo@gmail.com>
Tested-by: Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>
Tested-by: Chapuis Dario <chapuisdario4@gmail.com>
Tested-by: Thibaut François <tibo@humeurlibre.fr>
Tested-by: 张旭涵 <Loong.0x00@gmail.com>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Javier Tia <floss@jetm.me>
Link: https://patch.msgid.link/20260425195011.790265-2-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index b1f54cb54e1759..98ec76cf2fe8b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2063,9 +2063,9 @@ mt7925_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		rcu_assign_pointer(mvif->link_conf[link_id], NULL);
 		rcu_assign_pointer(mvif->sta.link[link_id], NULL);
 
-		if (mconf != &mvif->bss_conf)
+		if (mconfs[link_id] != &mvif->bss_conf)
 			devm_kfree(dev->mt76.dev, mconfs[link_id]);
-		if (mlink != &mvif->sta.deflink)
+		if (mlinks[link_id] != &mvif->sta.deflink)
 			devm_kfree(dev->mt76.dev, mlinks[link_id]);
 	}
 
-- 
2.53.0



