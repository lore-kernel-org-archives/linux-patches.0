Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE69B33C18B;
	Sat, 12 Sep 2026 15:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226430; cv=none; b=LgvLZS7z9IoyMhIqiwm5IRhuTlliQBtp3gBtmr5FCTR3+N+wCQJvfAwuX3QoOF5eOLKE90gvHdSew+fMLoE2pF9H4Fs/xjw2jbyc3vZA2swVbXd/M5j/jqI4DOKvfUCWQQl5KbCZBfi/7IBayqHHJCgJS8K1JGsQh/RoLHwn5c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226430; c=relaxed/simple;
	bh=i0Ktz56zu7nDbuhMKSfGyeBLjw2eSi3jHlNWBIqN0J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9MFWc+o19+ObVMJ3Evc1u6puSvqL33oGvOTAVUkI3SSipQmE1cz0FEXIElsNH5qeOm7txOvQ83pt9kwOxG/qjKz36ys3Vr4MPUA4NkxM0jf0d+eR06h0Dujc29fZ3Ml6ccN3C6HXPsaZWiaWNMkdjYqfwNU7AdCTOAeAGK6PVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExU3oDPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExU3oDPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87A61F000FF;
	Sat, 12 Sep 2026 15:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226429;
	bh=y/tn6cnhFal+IAQY9+iXTzpriX13bIFoqnihgcObdXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExU3oDPLaOkbqkjLWLNDh4+B5wgwk36Tumo02hBfaPIgLGWAHtqvFUNfkjLvtRcgQ
	 pZFj/ZMRaaE4sfifoHBuh2qpo8XK4qNXyCb4u+UW1lhNmix8GsJ57l/nfE3StuRJur
	 Y47ND/YWtFcyya6G2NgetBpB9x9ksMJzLNV2oEFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chang <ot_chhao.chang@mediatek.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1399/1424] pinctrl: mediatek: Fix new design debounce issue
Date: Sat, 12 Sep 2026 09:03:51 +0200
Message-ID: <20260912065638.592018757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



