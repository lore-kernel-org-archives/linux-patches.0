Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24676882D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96802C4339E;
	Fri, 10 Mar 2023 15:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461312;
	bh=AG/RBwk8V1IfkP7WqcveNApV8OkXwvHpUA4Q2w6X4No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWxG5PJrVzP9Nkk4WEp4Xnn/trqaFjzuox0ky6LYUSFCE1u6tIcJPqye5w80hKvJM
	 rnGgWwjDvJD62OdA9LBN3ZrJYfBhWgdOgYqYAHu8ZxyRBdNLuB8yIItEnjErxrbyjU
	 8QGhc6FU+gExlpRG/Epkw92ZC4zp8SubxrGdHTrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Wang <zhipeng.wang_1@nxp.com>,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Philippe Schenker <philippe.schenker@toradex.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/136] rtc: allow rtc_read_alarm without read_alarm callback
Date: Fri, 10 Mar 2023 14:43:07 +0100
Message-Id: <20230310133709.110561803@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index 3ee17c4d72987..f49ab45455d7c 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -392,7 +392,7 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		return err;
 	if (!rtc->ops) {
 		err = -ENODEV;
-	} else if (!test_bit(RTC_FEATURE_ALARM, rtc->features) || !rtc->ops->read_alarm) {
+	} else if (!test_bit(RTC_FEATURE_ALARM, rtc->features)) {
 		err = -EINVAL;
 	} else {
 		memset(alarm, 0, sizeof(struct rtc_wkalrm));
-- 
2.39.2



