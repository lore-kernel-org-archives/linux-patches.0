Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AB61F8919;
	Tue, 17 Dec 2024 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456663; cv=none; b=DsOH6sehbYAXbExQm0Tz6e8JENHiOktk6LdHoyFZ68vf2UCZ0TYzuk2BpDGCN3OM+8QHRxZEedsq1peZGQGcATCN8jZ/7ULVFXZuOuaMRrnA0FSLxE9B6F3RqAcWEz/9QA+e2DmPFvfAqBm9pb3+M2w3KX+srJaiMYJY7gyZNIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456663; c=relaxed/simple;
	bh=Y6dYUOL/6Wg/UNFBiNDQvWoLTENS14oBVizwTP+/RTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbRAFssq/FOlNOM1tnEJ0hO+i8U20IPWsyWNINXvBbTM0jligNkn6A00y4+Vf7maiTxnyhFieu/lco1wR8wxoZW0Cf4B/hvdzqwOyZnXyONKBtTwq65NmLXVODxeJKixNbbGmtyuYCX/fu5XKGcqIw3khX7Ce5MF//dy89pZb4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4Yy4AE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4Yy4AE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7060CC4CED3;
	Tue, 17 Dec 2024 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456662;
	bh=Y6dYUOL/6Wg/UNFBiNDQvWoLTENS14oBVizwTP+/RTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4Yy4AE3gk9TvHxlPGBypT5jpjWoYoWh9fIzcs3UHH1tHHSQgKwVZZ2U20OgwTiGt
	 /y171pgv85pndPW39cq3BNdIDlnZDukPBHAE9bp9zKreJlaWN2s29Afhukk9MBYhZs
	 aZJeNO075ko180RiXWqOGLD/gQP7bFi41sDdzWLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/172] ASoC: tas2781: Fix calibration issue in stress test
Date: Tue, 17 Dec 2024 18:08:04 +0100
Message-ID: <20241217170551.649853027@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 2aa13da97e2b92d20a8ad4ead10da89f880b64e7 ]

One specific test condition: the default registers of p[j].reg ~
p[j+3].reg are 0, TASDEVICE_REG(0x00, 0x14, 0x38)(PLT_FLAG_REG),
TASDEVICE_REG(0x00, 0x14, 0x40)(SINEGAIN_REG), and
TASDEVICE_REG(0x00, 0x14, 0x44)(SINEGAIN2_REG). After first calibration,
they are freshed to TASDEVICE_REG(0x00, 0x1a, 0x20), TASDEVICE_REG(0x00,
0x16, 0x58)(PLT_FLAG_REG), TASDEVICE_REG(0x00, 0x14, 0x44)(SINEGAIN_REG),
and TASDEVICE_REG(0x00, 0x16, 0x64)(SINEGAIN2_REG) via "Calibration Start"
kcontrol. In second calibration, the p[j].reg ~ p[j+3].reg have already
become tas2781_cali_start_reg. However, p[j+2].reg, TASDEVICE_REG(0x00,
0x14, 0x44)(SINEGAIN_REG), will be freshed to TASDEVICE_REG(0x00, 0x16,
0x64), which is the third register in the input params of the kcontrol.
This is why only first calibration can work, the second-time, third-time
or more-time calibration always failed without reboot. Of course, if no
p[j].reg is in the list of tas2781_cali_start_reg, this stress test can
work well.

Fixes: 49e2e353fb0d ("ASoC: tas2781: Add Calibration Kcontrols for Chromebook")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20241211043859.1328-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 12d093437ba9..1b2f55030c39 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -370,7 +370,7 @@ static void sngl_calib_start(struct tasdevice_priv *tas_priv, int i,
 			tasdevice_dev_read(tas_priv, i, p[j].reg,
 				(int *)&p[j].val[0]);
 		} else {
-			switch (p[j].reg) {
+			switch (tas2781_cali_start_reg[j].reg) {
 			case 0: {
 				if (!reg[0])
 					continue;
-- 
2.39.5



