Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73863A544C;
	Sat, 12 Sep 2026 08:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201193; cv=none; b=HnPGv/WSDWprkAop6l9rEFS+Q8mN/PUyTvWQsqWiMnnxAL37AEsWuqZigYPgkEUbo+8XnY26mO3Ximq4iUrUpN9Fe2dA4J6AP/HontSTFFuv+M/kSJmEHFq5wi6GXKpTTQAjK1Mez8UEk+QusGSnJN+f6P3CJUUJ7fmHXNGs5Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201193; c=relaxed/simple;
	bh=aPRdYitYPsI7rrlkAgxrUH1snUxPtOQmrwBaFx3ApAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POSveI7wjN7WIIcb2Yd416TTZ/mlr35F4+zSzgKsSLjTTa8jKmO5mKkh6AeASrwpmKwr0o05jYC6R2y8cUYibPLzuz0rAiBh4nHKkZbvGy2+qxTGXxBUG9dMYM6qXCVOMZGiXgCJzhedeHMenBg3vnXeYU6L+kXKw9qEm/gZqcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3HJsii6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3HJsii6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137371F000FF;
	Sat, 12 Sep 2026 08:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201191;
	bh=rLa0uZxCWjtMFL+DjHLJKGRX8VxsadTAZKaUxgw2IQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3HJsii6tJXLVQzWI9ilxKHw4rfbyyvgWx0Gz9Wk2wB8qGbrBfAI+vWXe0JRnz0M8
	 Buz4cjeNJ4UE4wapvZjVGYw7jhysCHMkxhbZt0m5bCvOV2olcFu5a0zgVHzRz+ml4I
	 b63M0oLDGlri5ejIRY1lxajsOj6d6k3HhOFK4rxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0945/1815] wifi: mt76: mt7996: do not attach hif2 WED when the main WED attach failed
Date: Sat, 12 Sep 2026 08:44:55 +0200
Message-ID: <20260912065711.142345016@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 7c1924332e986019c6bcddf55c843361cccac73f ]

If the WED attach for the primary PCIe function fails, the probe path
still attached wed_hif2 for the secondary function, leaving the device
in an inconsistent half-WED configuration that crashes later. The hif2
call also re-enabled hwrro_mode, which the failed primary attach had
just turned off.

Skip the hif2 WED setup when the primary WED device is not active.

Fixes: 83eafc9251d6 ("wifi: mt76: mt7996: add wed tx support")
Link: https://patch.msgid.link/20260727150434.1778520-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index 0d7521d069811..ba064324a7cc7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -490,6 +490,9 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 	if (!wed_enable)
 		return 0;
 
+	if (hif2 && !mtk_wed_device_active(&dev->mt76.mmio.wed))
+		return 0;
+
 	dev->mt76.hwrro_mode = is_mt7996(&dev->mt76) ? MT76_HWRRO_V3
 						     : MT76_HWRRO_V3_1;
 
-- 
2.53.0



