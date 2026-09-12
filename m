Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB71D2D23A6;
	Sat, 12 Sep 2026 13:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219475; cv=none; b=TyqLILwbnuXt9VX3r+GU+3uDxzB33rE+vAFhWVLlpwLJQ1Hl46jRepGKIlIyE4TxGsQ6LdX9Nv7NYCep3gGtajfzGyH3r6kloc/eUrfptRWJkcy6vs2yH7oR97KCY1c6oYOdtyzysxgDzw4cUfM+wv3ya7aSUiO38nl5T1vyoq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219475; c=relaxed/simple;
	bh=pJgfv1AcgIcouSmLWeTFwN9CO0JZBDTs9WEYWyL6LD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSma5IL4dWredCcgZnORK1kG8HsQvvo8eEwwrLgDmU71ArDZ70vx5K6ximt/DedtTzjhqHYdkzkhlIc6ley4iWjBpWvfB4xREds2D0cDTsaEwYmkhH3L4vB+By/p9KtBnk9UyY++n0C4L1QThBenxwGZjh0HJrb2GWiFun55xkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gk2irDby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gk2irDby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A34C1F000FF;
	Sat, 12 Sep 2026 13:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219473;
	bh=LwSmz5JjmdgwO2RjQqQFjhhMHPzOCi/Opy4RpLW9jHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gk2irDby1apzoR+E3AQExk7sJDyABqqoG/C8k19DsXWDR2OMGcI8ozd6qP1nROwV0
	 rNRVd6DGDYQpZAoIf1wl4xbRUrMjALcdO4ClDdzPdZefagxkTymD2rhpAibYx2MrsF
	 5CRyhVaSby6yGt7NuWim3/8nM60fOmOlLrlPN4Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chang <ot_chhao.chang@mediatek.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1341/1376] pinctrl: mediatek: Fix new design debounce issue
Date: Sat, 12 Sep 2026 09:02:47 +0200
Message-ID: <20260912065637.418135913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Chang <ot_chhao.chang@mediatek.com>

[ Upstream commit 34024cf69c51b11c2b608f5d578626b9b1c484f5 ]

Calculate the true offset of eint according to index.

Fixes: 3ef9f710efcb ("pinctrl: mediatek: Add EINT support for multiple addresses")
Signed-off-by: Hao Chang <ot_chhao.chang@mediatek.com>
Signed-off-by: Qingliang Li <qingliang.li@mediatek.com>
Link: https://lore.kernel.org/20250422075216.14073-1-ot_chhao.chang@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/mtk-eint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index 85a4f2d3701f5..4c4ee1d3a3a92 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -450,7 +450,7 @@ int mtk_eint_set_debounce(struct mtk_eint *eint, unsigned long eint_num,
 		return -EOPNOTSUPP;
 
 	virq = irq_find_mapping(eint->domain, eint_num);
-	eint_offset = (eint_num % 4) * 8;
+	eint_offset = (idx % 4) * 8;
 	d = irq_get_irq_data(virq);
 
 	set_offset = (idx / 4) * 4 + eint->regs->dbnc_set;
-- 
2.53.0



