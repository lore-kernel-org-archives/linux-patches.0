Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A801519BE;
	Wed,  5 Feb 2025 14:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765269; cv=none; b=Bp9uHrIzJV2q1LcUtTSY2xbPYjvHmQn3FJwA+krQr8DPgpBuw4XJbopXmQqNSvtMmuvTSEGAZuwSSfZ2N+kHhbNdVsJ0sqT3whW/A1jP80CklLvI4sB3oodj1+GpCm/rvU4sJdmML8tQx9/bTsmGU76mESAokdjPXfh1nxplaf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765269; c=relaxed/simple;
	bh=Wen3Ic4RgLijVZvm9w030DB+wLI8R1o8+YCl3kG1HDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGrq6HP/ZwlWMIyBCV5TynPMamwpnFa7YYnCH6zSvz9h+6iOVuM1hEkuBun+p/KgGfQ1OJrcGkJ/K2PkG8OtShWHNTyo1jp+ipZQJIhcM4JLso6KEE3B9jFfUGr7AS6pQ/wvV+OyvcEwcRO46xrTHbZjJR1x8ivty2rBtycaPYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edOHVQGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edOHVQGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD11C4CED1;
	Wed,  5 Feb 2025 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765269;
	bh=Wen3Ic4RgLijVZvm9w030DB+wLI8R1o8+YCl3kG1HDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edOHVQGJKk29klUu1o9MHkpCxFzyn++PtIzHN7r/TfyHgIJY9GosjcU5f05hDFd7a
	 x/2KFEKNOTf0VJJYHJj2hWOYtKzFLoUzM1nNRF7LM9IE5Yhe2wCSXSuRcbUKYKrrS/
	 Gd3eOUUp5Sc41Mi/pZaLMwG2toXapT3Tz9qAMFU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 161/623] wifi: mt76: mt7925: fix off by one in mt7925_load_clc()
Date: Wed,  5 Feb 2025 14:38:23 +0100
Message-ID: <20250205134502.393936560@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 08fa656c91fd5fdf47ba393795b9c0d1e97539ed ]

This comparison should be >= instead of > to prevent an out of bounds
read and write.

Fixes: 9679ca7326e5 ("wifi: mt76: mt7925: fix a potential array-index-out-of-bounds issue for clc")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/84bf5dd2-2fe3-4410-a7af-ae841e41082a@stanley.mountain
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 748ea6adbc6b3..0c2a2337c313d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -638,7 +638,7 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	for (offset = 0; offset < len; offset += le32_to_cpu(clc->len)) {
 		clc = (const struct mt7925_clc *)(clc_base + offset);
 
-		if (clc->idx > ARRAY_SIZE(phy->clc))
+		if (clc->idx >= ARRAY_SIZE(phy->clc))
 			break;
 
 		/* do not init buf again if chip reset triggered */
-- 
2.39.5



