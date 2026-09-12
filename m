Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2812A3C583B;
	Sat, 12 Sep 2026 09:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204567; cv=none; b=mYiXZLQE0AXxLAlwujk2ms0JPRUqy0EAdqK1/F9sy+Zz6aEGOKsCjtUajA06VPz59/wo4qj/2QAqkvGnqGw0D7nxZymJ9gzIsKA3+EUwZNVdO7o8GPUXApSwLDaWoU2tF3ohZ99H7zJD8l/5oOEf7oBWtHaR3OJkFwidYyJgw84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204567; c=relaxed/simple;
	bh=WzjNeYpGoVXnQTF9vXx52+mZmsqbojk/9APZ9aa3k10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8MtL4mxRJcZP5e/UO4iAYez7oPBn+HVUSFPgoi0EX1OitQlJQF3jOPXYHsC8Dx+0MHTeVJH3dA3wo4Yyexu3ct/JMC1DxBVGy3tCZ9eF6cM0vQO1h64K+i7Z57ccKPCFc3nEvGa5hKzHX5m7HWMY1s8OYIN1OId8Y+9BeFhhpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlQyok0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlQyok0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC191F000FF;
	Sat, 12 Sep 2026 09:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204564;
	bh=ciIuAI9BPiNY6cbV8y4jBfnCVy/WSAeGaztoMEAnkv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlQyok0xw9KWCtJq5UCmtRUaBTmMuL0PFqWJrhVbxDqe/51GomR3gPoNibnQ0eaG7
	 rSyDA6FFVf0kwrONtgSyqVMMbKm57F3U0qCrA9SwPfz2IYpumXGZkCU41eEDbnXB03
	 WyluTP8UworXqYittxz9vuGmqQvA9EWUCKVlfdKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1638/1815] rtc: gamecube: check return value of devm_rtc_register_device()
Date: Sat, 12 Sep 2026 08:56:28 +0200
Message-ID: <20260912065727.446859413@linuxfoundation.org>
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



