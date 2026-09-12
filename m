Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854CC37B00E;
	Sat, 12 Sep 2026 13:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218890; cv=none; b=X48sSOoz/jqvb1JnKfS4mSFzYBL8pjBT35VqxLICGuF0gC4/F/CFpJ2polxYz2c3m9gbznIj/lkubIYM5xHCE3h/5yzyzWqGCdaDDURLbdd7rs32ogP0Xt45DO/sgKxbrDqCvoyvmgNIBtkezyTAnCtm6GgP+usOgAH2Bnz7BAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218890; c=relaxed/simple;
	bh=QC7/r+M3I8hZYXJQx+xu1TNJKv1tf1KwCh0b4Jrh0r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFMrPP/ZpRCyTMFH1pmvWNhD30f9xc9S+13dV1FwcxQQtOguaH/Ef5ZGD4p5eJbiORJnIvbIDvr2m5wqcqguPhzYsLeDYxCuxLiPdhxoIDeI82DNMgfYN5UnikyHkXrtPVGSFhh1m2zrw6dFizQLf+0ccgZ5x389iJGfugAmNDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvD7Zxv/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvD7Zxv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4A81F000FF;
	Sat, 12 Sep 2026 13:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218888;
	bh=NrjHyRqDsr2yxvjWgxtLHebitzVj/eA0eJZB8UTo2gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvD7Zxv/eLCAroGrAv3/ndbiN4aG+1PvYxQ7lT6MKKmdn4d2/kf//Z5NV7vDkKzlO
	 0dM6tjqfp/EDPoUtrXKsQNdwYr1QlLOk7QRfVh+xXExoRSItL4rqQEzpY0Od7bc3zb
	 WYiKAQgY484naySdG57fvbc2Vsu85iCxaiQD0bak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1237/1376] rtc: gamecube: check return value of devm_rtc_register_device()
Date: Sat, 12 Sep 2026 09:01:03 +0200
Message-ID: <20260912065635.115112693@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit ca45cfa74370644d371b552bef57938c19e3c80c ]

gamecube_rtc_probe() ignored the return value of
devm_rtc_register_device() and always returned success. Propagate the
error so probe fails when RTC registration fails.

Fixes: 86559400b3ef ("rtc: gamecube: Add a RTC driver for the GameCube, Wii and Wii U")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260731080458.417532-1-gonglinkai@kylinos.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-gamecube.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-gamecube.c b/drivers/rtc/rtc-gamecube.c
index 045d5d45ab4b0..889028cecf4a5 100644
--- a/drivers/rtc/rtc-gamecube.c
+++ b/drivers/rtc/rtc-gamecube.c
@@ -355,9 +355,7 @@ static int gamecube_rtc_probe(struct platform_device *pdev)
 	rtc->range_max = U32_MAX;
 	rtc->ops = &gamecube_rtc_ops;
 
-	devm_rtc_register_device(rtc);
-
-	return 0;
+	return devm_rtc_register_device(rtc);
 }
 
 static const struct of_device_id gamecube_rtc_of_match[] = {
-- 
2.53.0



