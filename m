Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284961ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7156BC433C8;
	Tue, 25 Jul 2023 11:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284135;
	bh=QopH2+eYoFzzOFoa+9g7mkn59aHMUm8ww/eZk8MuO/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7Kjopiq+uyufdyxvTr9mU8X92OkQGMTe5pCP0SKeU6HAVIP886o3GqM9W6xhavDW
	 SFXn/yIhjEB49BbIHB8Nb1S+NwgmQAI9mrRWCE371h3mvgaoCP5GQpuzFLvfXSycb2
	 VfxHRbY9d8h1EqVDOfzjsFQDGn0JZ/7OKQJiz8Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/509] w1: w1_therm: fix locking behavior in convert_t
Date: Tue, 25 Jul 2023 12:42:37 +0200
Message-ID: <20230725104603.728670861@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit dca5480ab7b77a889088ab7cac81934604510ac7 ]

The commit 67b392f7b8ed ("w1_therm: optimizing temperature read timings")
accidentially inverted the logic for lock handling of the bus mutex.

Before:
  pullup -> release lock before sleep
  no pullup -> release lock after sleep

After:
  pullup -> release lock after sleep
  no pullup -> release lock before sleep

This cause spurious measurements of 85 degree (powerup value) on the
Tarragon board with connected 1-w temperature sensor
(w1_therm.w1_strong_pull=0).

In the meantime a new feature for polling the conversion
completion has been integrated in these branches with
commit 021da53e65fd ("w1: w1_therm: Add sysfs entries to control
conversion time and driver features"). But this feature isn't
available for parasite power mode, so handle this separately.

Link: https://lore.kernel.org/regressions/2023042645-attentive-amends-7b0b@gregkh/T/
Fixes: 67b392f7b8ed ("w1_therm: optimizing temperature read timings")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20230427112152.12313-1-stefan.wahren@i2se.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/slaves/w1_therm.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 6546d029c7fd6..3888643a22f60 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -1094,29 +1094,26 @@ static int convert_t(struct w1_slave *sl, struct therm_info *info)
 
 			w1_write_8(dev_master, W1_CONVERT_TEMP);
 
-			if (strong_pullup) { /*some device need pullup */
+			if (SLAVE_FEATURES(sl) & W1_THERM_POLL_COMPLETION) {
+				ret = w1_poll_completion(dev_master, W1_POLL_CONVERT_TEMP);
+				if (ret) {
+					dev_dbg(&sl->dev, "%s: Timeout\n", __func__);
+					goto mt_unlock;
+				}
+				mutex_unlock(&dev_master->bus_mutex);
+			} else if (!strong_pullup) { /*no device need pullup */
 				sleep_rem = msleep_interruptible(t_conv);
 				if (sleep_rem != 0) {
 					ret = -EINTR;
 					goto mt_unlock;
 				}
 				mutex_unlock(&dev_master->bus_mutex);
-			} else { /*no device need pullup */
-				if (SLAVE_FEATURES(sl) & W1_THERM_POLL_COMPLETION) {
-					ret = w1_poll_completion(dev_master, W1_POLL_CONVERT_TEMP);
-					if (ret) {
-						dev_dbg(&sl->dev, "%s: Timeout\n", __func__);
-						goto mt_unlock;
-					}
-					mutex_unlock(&dev_master->bus_mutex);
-				} else {
-					/* Fixed delay */
-					mutex_unlock(&dev_master->bus_mutex);
-					sleep_rem = msleep_interruptible(t_conv);
-					if (sleep_rem != 0) {
-						ret = -EINTR;
-						goto dec_refcnt;
-					}
+			} else { /*some device need pullup */
+				mutex_unlock(&dev_master->bus_mutex);
+				sleep_rem = msleep_interruptible(t_conv);
+				if (sleep_rem != 0) {
+					ret = -EINTR;
+					goto dec_refcnt;
 				}
 			}
 			ret = read_scratchpad(sl, info);
-- 
2.39.2



