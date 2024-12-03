Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9191EE00B;
	Tue,  3 Dec 2024 16:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242772; cv=none; b=ffjdBaiJyC/4mV/PhO00puVkvqOq7U9ilqCKc1B5hoqmjIGjvlDh4HmQ6IF5BL7GDvavdMscviYZ0lcEXLn7qFw+zUM9WE9UMQyfk56PLqQMirKfY/8Qivl+8TJrSKlEWy1dlP7TgbL37vWvS3LFuD3h5AD1mNhrbY2Q4JVHmDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242772; c=relaxed/simple;
	bh=NdSIErFNJNZGLFuHNyNx8wqUDhihgxXecw1rrGBSIr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNFmajGB/cinXahH9lzjs5A8GQt5HtC9h0h9BCATLgPfi937goFn2Rh1gSfCKFg2PPCmQIxJaH0/ILKBB+jQiTGLF/QEyusyGJcFOaRebwPPV6Jb7KtMsH+Um/hmpTLJ23UK8b0AlaRwtKOmpm8jKCpQ+sBiOONEvUIBDddwgbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGQZfEFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGQZfEFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41985C4CECF;
	Tue,  3 Dec 2024 16:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242772;
	bh=NdSIErFNJNZGLFuHNyNx8wqUDhihgxXecw1rrGBSIr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGQZfEFjeDo+rxDVxXhgDVBwHDQYtGioZD4yzybDE0Mz5I1DvgfNOGayB2CDAvUUM
	 Rhguvz1zB2krirHNDDtXQF1ueREJ2cprCNsK4hP2MFZUsTIS6Z2x0JxSQJkQOpcPLf
	 tmHwVSFgMMpBaRpfanGe1+G7msfySo0xcTuO/3q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 805/826] rtc: ab-eoz9: dont fail temperature reads on undervoltage notification
Date: Tue,  3 Dec 2024 15:48:52 +0100
Message-ID: <20241203144815.158437829@linuxfoundation.org>
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit e0779a0dcf41a6452ac0a169cd96863feb5787c7 ]

The undervoltage flags reported by the RTC are useful to know if the
time and date are reliable after a reboot. Although the threshold VLOW1
indicates that the thermometer has been shutdown and time compensation
is off, it doesn't mean that the temperature readout is currently
impossible.

As the system is running, the RTC voltage is now fully established and
we can read the temperature.

Fixes: 67075b63cce2 ("rtc: add AB-RTCMC-32.768kHz-EOZ9 RTC support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://lore.kernel.org/r/20241122101031.68916-3-maxime.chevallier@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ab-eoz9.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/rtc/rtc-ab-eoz9.c b/drivers/rtc/rtc-ab-eoz9.c
index 02f7d07112877..e17bce9a27468 100644
--- a/drivers/rtc/rtc-ab-eoz9.c
+++ b/drivers/rtc/rtc-ab-eoz9.c
@@ -396,13 +396,6 @@ static int abeoz9z3_temp_read(struct device *dev,
 	if (ret < 0)
 		return ret;
 
-	if ((val & ABEOZ9_REG_CTRL_STATUS_V1F) ||
-	    (val & ABEOZ9_REG_CTRL_STATUS_V2F)) {
-		dev_err(dev,
-			"thermometer might be disabled due to low voltage\n");
-		return -EINVAL;
-	}
-
 	switch (attr) {
 	case hwmon_temp_input:
 		ret = regmap_read(regmap, ABEOZ9_REG_REG_TEMP, &val);
-- 
2.43.0



