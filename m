Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E063019F43A;
	Thu,  3 Jul 2025 14:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554579; cv=none; b=tgNwJPDMloaikpeD8KG2y27UJsRWIKsF9XjBxjWOYl1aldKZSEdtA6D8THsyDQR9EmcBd8qx7rbXpZG1E5OxeV56IujHJxILLD+7jButGG0Q96Pi8+k7CfQ69JMDf+9zso5Xef6EqgaMtHkxcp9ZwaMljFm7+4ag6nbXiIpiiqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554579; c=relaxed/simple;
	bh=pudo/JJty8PhCvrfm43pDejdURBZGSQrbKGX+jQPecY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuvcW6NfMXZe3PUzr6quYSFZnIgDkqjIBZFvyMUDGIws7QSlqurZms9jCZjmxXDT/DNyvRiOgbOLjU5TrBoXsEsGa51y/fbFp/bCzpbgkjbR255EqP6FjY092oqaJVUzH3p4JTwNkuKVLoOCZ74viXtApoVeyf3l1a6sRAwH0V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAxLiryu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAxLiryu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB09C4CEE3;
	Thu,  3 Jul 2025 14:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554578;
	bh=pudo/JJty8PhCvrfm43pDejdURBZGSQrbKGX+jQPecY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAxLiryuV/Sh87NrVEZv+T2pqL+JPkX0WyW+zGVbFIs2aSAWzbV+RlxBRR7Q/U4YZ
	 5/DRcKU3PirAFwQ9do8YfG7UhZOuy7vzBJYT37LyfB4jBtxG3hZKMkl39O2AqQRteH
	 i4aKEJSmhxtxddpjwYYRC69MvKzm5nXSAU825oLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yikai Tsai <yikai.tsai.wiwynn@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 014/263] hwmon: (isl28022) Fix current reading calculation
Date: Thu,  3 Jul 2025 16:38:54 +0200
Message-ID: <20250703144004.860278115@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yikai Tsai <yikai.tsai.wiwynn@gmail.com>

[ Upstream commit b2446a16dbf2347a07af0cf994ca36576d94df77 ]

According to the ISL28022 datasheet, bit15 of the current register is
representing -32768. Fix the calculation to properly handle this bit,
ensuring correct measurements for negative values.

Signed-off-by: Yikai Tsai <yikai.tsai.wiwynn@gmail.com>
Link: https://lore.kernel.org/r/20250519084055.3787-2-yikai.tsai.wiwynn@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/isl28022.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/isl28022.c b/drivers/hwmon/isl28022.c
index 1fb9864635db9..1b4fb0824d6c0 100644
--- a/drivers/hwmon/isl28022.c
+++ b/drivers/hwmon/isl28022.c
@@ -154,6 +154,7 @@ static int isl28022_read_current(struct device *dev, u32 attr, long *val)
 	struct isl28022_data *data = dev_get_drvdata(dev);
 	unsigned int regval;
 	int err;
+	u16 sign_bit;
 
 	switch (attr) {
 	case hwmon_curr_input:
@@ -161,8 +162,9 @@ static int isl28022_read_current(struct device *dev, u32 attr, long *val)
 				  ISL28022_REG_CURRENT, &regval);
 		if (err < 0)
 			return err;
-		*val = ((long)regval * 1250L * (long)data->gain) /
-			(long)data->shunt;
+		sign_bit = (regval >> 15) & 0x01;
+		*val = (((long)(((u16)regval) & 0x7FFF) - (sign_bit * 32768)) *
+			1250L * (long)data->gain) / (long)data->shunt;
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.39.5



