Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7CE231A5D;
	Thu, 12 Dec 2024 16:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020349; cv=none; b=W/UfPKVLJTuNulYb2c+r9aPLhsmNV9B3FVc3Vxh3ugEPd7ueOOgrX3KPE7vI4cdNsVQojfPRo369Q22S43nE3QIwyRBVW75ftLMpeZJ5b58H+Yco2x4HBMqmS9Ld2GSLhO5aBhHxnTHkOUiymhpqFqxqw0zot+q5kKB8zRnXzPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020349; c=relaxed/simple;
	bh=vt5PhlZ72hpjqSBOEkHzTIjB+B4vjzemiWB6qa9JM1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQ4OO36Elqmncd1y1unfro8Y14pZSvZPVlz11gTIz/sXIWQItVnuGPwgX6Bvxa7JGnGuOYdIRcGWHgJLZd5XYNuJqd/K4yNxsJmWB3K/n90fda2q4YvUfVKzRXZils4GwTfVQWLY5fQY0oiVElmFyuD4gzpqvkpen2FP6ibIKjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo/AnnJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo/AnnJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C96AC4AF09;
	Thu, 12 Dec 2024 16:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020348;
	bh=vt5PhlZ72hpjqSBOEkHzTIjB+B4vjzemiWB6qa9JM1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zo/AnnJsuLhDh30zO8oPB6V336z98mKscEGkuvnoHTLB6INL/FVbw+EIscNUYnHmA
	 Fypu9EfvFMzBpl/+X62YguwqRp/tuOpORF6MBfrFqam/e8Bk+7zHvpZQeDnNvpPpMG
	 NbKvBcIov8Wn6T5p7ffyBHdvoGGYRNJNVAUQwYKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 444/772] rtc: ab-eoz9: dont fail temperature reads on undervoltage notification
Date: Thu, 12 Dec 2024 15:56:29 +0100
Message-ID: <20241212144408.271719900@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2f8deb8c4cd3e..da710a29e9620 100644
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



