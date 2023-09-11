Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729F01170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B15C433C7;
	Mon, 11 Sep 2023 14:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442542;
	bh=wbNhwX2DaQ+VF0sU5+dfxJ9hes5s8wF2GtT6QHnpVfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQDzS38chrFghu2C98MmWNN8qGkZeMW4l9hdMR7+tcL4a8dIR+jZ/aHh6xNvDlQNG
	 ZuXarPRWi2ZyxFAdr23XzWREzRT0He3tiTpTN38g3QmAQnMTR+4yGeZzdLL4P+RumQ
	 dD1V5YDyOCCnFlRWkdklW9stQH5Q4rTlaXhOwk9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 026/737] ASoC: rt5682-sdw: fix for JD event handling in ClockStop Mode0
Date: Mon, 11 Sep 2023 15:38:05 +0200
Message-ID: <20230911134651.119197501@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 02fb23d72720df2b6be3f29fc5787ca018eb92c3 ]

When the system suspends, peripheral Imp-defined interrupt is disabled.
When system level resume is invoked, the peripheral Imp-defined interrupts
should be enabled to handle JD events.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Reported-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20230721090643.128213-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index 23f17f70d7e9b..9622aaf1b3e63 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -753,8 +753,15 @@ static int __maybe_unused rt5682_dev_resume(struct device *dev)
 	if (!rt5682->first_hw_init)
 		return 0;
 
-	if (!slave->unattach_request)
+	if (!slave->unattach_request) {
+		if (rt5682->disable_irq == true) {
+			mutex_lock(&rt5682->disable_irq_lock);
+			sdw_write_no_pm(slave, SDW_SCP_INTMASK1, SDW_SCP_INT1_IMPL_DEF);
+			rt5682->disable_irq = false;
+			mutex_unlock(&rt5682->disable_irq_lock);
+		}
 		goto regmap_sync;
+	}
 
 	time = wait_for_completion_timeout(&slave->initialization_complete,
 				msecs_to_jiffies(RT5682_PROBE_TIMEOUT));
-- 
2.40.1



