Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00244522A;
	Wed,  5 Feb 2025 14:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765628; cv=none; b=oI0Q0ysa3/pjezD2t8uNHIl62HcDVtgTI6UTyDo0vdbnVvOoDdyg/RZB6nNSDxkJM02B4SI80Q1sDPquBgAGIEfLJnN+ReBbaiFUqbqvL0gWeFBz1VQ3atdm4TQDUkVMLhIplNQaSRcM+c/8EsRTHqMnIZMalOYLDIlW+XTy5cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765628; c=relaxed/simple;
	bh=eNGrD/MhLYRWRK/rIj9IyhaiPeo9pggo0WuwYhfdJZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngoOwcHyw/5JWrbLKJVj6oSBoQrvlPqMalx4Ry0HnpcKDqHCrfCAWA3ZeMXBJNlmjYMn0/j37Pp5j5+fEn1GVMyvN2dfYJUClWGZjft+oVJkDFNwS6p2mjvYex2QJj0nQDC/kQty7sYC6GJz/4o7x14ETO0OzK+HOJF74/od8/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2b7cwXmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2b7cwXmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632E7C4CED1;
	Wed,  5 Feb 2025 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765627;
	bh=eNGrD/MhLYRWRK/rIj9IyhaiPeo9pggo0WuwYhfdJZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2b7cwXmg6OxNo03Jlysx+evfZM5FoqpFa5nKxswKgC1D1SW0mov8sgnqVDriFDcsh
	 t0ZSfQuuQXbyL1oStIxwZUfqmwYzq4FYXVDy+Aft9oHq2X6unzl9DfVRGbR7k0e1ty
	 f1hq84SuSrg5DV8EUrC5czQ2qvPUTkD4nmFj4kT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 199/623] wifi: mt76: mt7925: Init secondary link PM state
Date: Wed,  5 Feb 2025 14:39:01 +0100
Message-ID: <20250205134503.845404408@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 28045ef2bc5bbeec4717da98bf31aca0faaccf02 ]

Initialize secondary link PM state.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-14-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index dcdb9bcff3c40..a2d1c43098d3c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1991,6 +1991,8 @@ mt7925_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			goto free;
 
 		if (mconf != &mvif->bss_conf) {
+			mt7925_mcu_set_bss_pm(dev, link_conf, true);
+
 			err = mt7925_set_mlo_roc(phy, &mvif->bss_conf,
 						 vif->active_links);
 			if (err < 0)
-- 
2.39.5



