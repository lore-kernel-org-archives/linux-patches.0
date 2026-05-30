Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0897D137750;
	Sat, 30 May 2026 18:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166888; cv=none; b=HB0GVnNcSbPThQBL23NcjVIZT25/EXNFz8ha5612dPv2frmlFBxbDhQ9t9RrvvGrTkR8Dos0CwawSn4BnIQrf8PrExu35RkaYkkQsgp9LnO4ru8LO8h5xslo1vBCazuJvvgNk8vqodgf9qKT/PwcXzmGCYEOjDDFQ/X2J6fc8ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166888; c=relaxed/simple;
	bh=t6oI007iOUui/vUNa/CkpdN2bnSJ2rLNNE7Pa/cFm1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbFBNvcs++LyFIkF1wIONOmTMJ2yKqcxvj8IWP8i6lUPyGKgaGs/CWPuNnNTXaM5q0yzqTwmjz0LY6bIQHXEf6kZ3Zf9HNhjE/ybiIXdWfG6Q0VJeEaS4YQ8ZfqgLZjjb44W1xb7h8DZ/pu4VIhkmZbW+rh2XN9JSrdQXt4k2+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMaT1TAi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMaT1TAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA071F00893;
	Sat, 30 May 2026 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166886;
	bh=TGz2r58BFXLED63VifNDPKp+UiQ+qkaVfp1HFVv2HVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMaT1TAiqHY4X3SUEz6W4HE+efC7fpjyu3UBJlM+lVJhjmLn0oROBH09MGzhD+ReN
	 5CtCXJBBkPHOC+Kr1yOtaIY2+vBfPi/yvkWFa5rE3YwK0bUgARnsPkxJkDzbewTmKy
	 nL37HMLYDq7O4MgulynnvRVCIQwrPybvRwZ0N5Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Wang <zhipeng.wang_1@nxp.com>,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Philippe Schenker <philippe.schenker@toradex.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/589] rtc: allow rtc_read_alarm without read_alarm callback
Date: Sat, 30 May 2026 18:06:22 +0200
Message-ID: <20260530160237.776369838@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit a783c962619271a8b905efad1d89adfec11ae0c8 ]

.read_alarm is not necessary to read the current alarm because it is
recorded in the aie_timer and so rtc_read_alarm() will never call
rtc_read_alarm_internal() which is the only function calling the callback.

Reported-by: Zhipeng Wang <zhipeng.wang_1@nxp.com>
Reported-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Fixes: 7ae41220ef58 ("rtc: introduce features bitfield")
Tested-by: Philippe Schenker <philippe.schenker@toradex.com>
Link: https://lore.kernel.org/r/20230214222754.582582-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 7df7457d7dc13..d35c46498629e 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -393,7 +393,7 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		return err;
 	if (!rtc->ops) {
 		err = -ENODEV;
-	} else if (!test_bit(RTC_FEATURE_ALARM, rtc->features) || !rtc->ops->read_alarm) {
+	} else if (!test_bit(RTC_FEATURE_ALARM, rtc->features)) {
 		err = -EINVAL;
 	} else {
 		memset(alarm, 0, sizeof(struct rtc_wkalrm));
-- 
2.53.0



