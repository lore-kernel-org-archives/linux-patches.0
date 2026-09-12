Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861773603D5;
	Sat, 12 Sep 2026 16:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231801; cv=none; b=KSS/3vAMlos69f1ViQxewIlhhCOxgUk3UQUFJqP0J1Eeyyfp+gVUDa2zFiSJEUxuRzsnhTvih/cWRi6800ibLoFJOcAwajfJFILprXZ8ed3UHhzJOdLjRpYpTDXA1gmCmbiHu9yzLA9e+L3sP3ejRBliwhwgbWnuHI7i53JL5cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231801; c=relaxed/simple;
	bh=j1/q3BgE+1y3fR7CdWg239iCYpmSxkNmikO+XkIcTQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZNdQ1Gvo5lN8KRdcnkSQaTkvHjPNwP4QYHxJxj4d64IA8zgYqP7quTgXKihKDter3njp1TZSW4C9KDtMp45IOnG00NSGt4UDR7J2RQv4CLHDflbM2R45hUNCVuH/sGzQDfExJXuD9vQla24oboKGpMsOT19dLiRaPRQHWuJSgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncS+1IZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncS+1IZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EB01F000FF;
	Sat, 12 Sep 2026 16:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231800;
	bh=gzqkrRTjOCZc1LCucXqsLaSxirknFlgPNdxS0FKvuxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncS+1IZA5WWJJO4SxSgiWpMBaQwiLh5/yCqEgJVm4IhHrnb7WZyXkQmJSZWYA3/Fd
	 nwi/uzEBn8C7jsdKaB6AfqKKpiQgB9sJzsKzdzyRI+Ubnn/R9otjvp0xktdYij5Vq0
	 IEPP3eu1GSf0dAau5jTAYiyvFGaydmMdBq6GttVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1074/1191] rtc: gamecube: check return value of devm_rtc_register_device()
Date: Sat, 12 Sep 2026 09:03:22 +0200
Message-ID: <20260912065612.294584555@linuxfoundation.org>
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



