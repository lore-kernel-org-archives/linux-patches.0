Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F7647CA67;
	Sat, 12 Sep 2026 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232181; cv=none; b=CXllG8pbLKYkM5yxL1Axw25nO/uvPLMrdnlZgGqo/S7CHx2yvIQSyRi+YHYp+E1+ToP8Xi6LCJOVEvFihvHxdUJ5Flqafkfp+KjeBhbTe8Q1zlVsU4ddwh/xvq+KQy/ddLoAFZk3uZ4qfWtSUN/VD2nvfX0F1lg52PBgvYW+s9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232181; c=relaxed/simple;
	bh=qIPJ79hc8ynqHOI1qWfftPnIrTnTaAvU6rL4eDYpzG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgrGTsxqR7u8cgflVFZEaimAWKEsI1kTTrI3c0/Ittq26KxqwEDu1Xscvn4QGpfCIrPOTAlZi8ZIjSGWEC6MPShevNbT3985EyQ494c4iRGLwu02vufEGP6dl7uW57JpmzirLAqRDHJffVtmR4+AkNtE7F9vMD/Ds0Hq+J4W/kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afFc1v0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afFc1v0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161C21F000FF;
	Sat, 12 Sep 2026 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232177;
	bh=RowXWHui8n9LXF4sqoGeUkwgophtxdKg1Q1EIW/Holk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afFc1v0oiCPhb5JzrAQXG6f1qVOEw8gbX5B4yhb7oGFwJssrcx3fXcFMtyRGz2r/x
	 5QYrPM6qkMpePM6J81LgqfcA9D48GpALmZvy8cBgYToL8Iwnad4S8MhqYxVItYArKo
	 Ie2oxU1Ygh4qXl9Lvwxl7EiL7Lm0l7qLjSNvSng8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chang <ot_chhao.chang@mediatek.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1147/1191] pinctrl: mediatek: Fix new design debounce issue
Date: Sat, 12 Sep 2026 09:04:35 +0200
Message-ID: <20260912065613.910460960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



