Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC62B1F759C;
	Tue,  3 Dec 2024 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242088; cv=none; b=ZqyCIFrsDErsaElFKhVbmkrAal9MKyEwF0wA1haS0VrE9PNhh3GHapr+No2gfuDcA0gwDGLcRlZtv3lbgO3Hg+RqP7zEq77ib5ezIp4tV1HleGge/Y62f+YgikBAUVyTzP6bF+64z06yah2NzjcXhaSOPYaMYKEQNcdwqbxYHb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242088; c=relaxed/simple;
	bh=dYy0xzenxuJukqlE95VyuvQZqHOk9NmHthFXBVhvfD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8iwiF9RJXIK6/lldRa1sBtkjmQatZPCo2JsT3/0r9N8OcrltIqG2mNyXqsiy1HNmcDvYJPTjxWCKkSQwdQnrxl1huR5w20o4EFMAqlD0cGUh+8jYmzvDsrTw+/0BASnQ8HL0jCPbq5oNGhZztwPfZtThPtuFCLqX1zB3RUUv30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d82809gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d82809gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2732AC4CECF;
	Tue,  3 Dec 2024 16:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242088;
	bh=dYy0xzenxuJukqlE95VyuvQZqHOk9NmHthFXBVhvfD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d82809gdFTrIhfJUrTxyg5V3m4T/nQiB7gT/xbUtl9sd6JOnBhCsd7M7vkAeuMj5U
	 r9xrUxWybHRwMXi9o8SgKOBjOVtF2pPeZFfAfQXF0W4cGp/8OVBUnfOCD+TQWdcngL
	 v/XNsmZ8lTSjWnQjarX7Y4lu4AF9wf8wvLhu8JLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 604/826] phy: realtek: usb: fix NULL deref in rtk_usb2phy_probe
Date: Tue,  3 Dec 2024 15:45:31 +0100
Message-ID: <20241203144807.316626641@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 04e3e9188291a183b27306ddb833722c0d083d6a ]

In rtk_usb2phy_probe() devm_kzalloc() may return NULL
but this returned value is not checked.

Fixes: 134e6d25f6bd ("phy: realtek: usb: Add driver for the Realtek SoC USB 2.0 PHY")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20241025065912.143692-1-hanchunchao@inspur.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/realtek/phy-rtk-usb2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/realtek/phy-rtk-usb2.c b/drivers/phy/realtek/phy-rtk-usb2.c
index e3ad7cea51099..e8ca2ec5998fe 100644
--- a/drivers/phy/realtek/phy-rtk-usb2.c
+++ b/drivers/phy/realtek/phy-rtk-usb2.c
@@ -1023,6 +1023,8 @@ static int rtk_usb2phy_probe(struct platform_device *pdev)
 
 	rtk_phy->dev			= &pdev->dev;
 	rtk_phy->phy_cfg = devm_kzalloc(dev, sizeof(*phy_cfg), GFP_KERNEL);
+	if (!rtk_phy->phy_cfg)
+		return -ENOMEM;
 
 	memcpy(rtk_phy->phy_cfg, phy_cfg, sizeof(*phy_cfg));
 
-- 
2.43.0



