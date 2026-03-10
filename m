Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB8C387587;
	Tue, 10 Mar 2026 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142189; cv=none; b=BVimuJxMFV3qAIUrulBRWx4feBWMZ6T9U2mcdveNG1tNRVRQMsjwgq+i9VfDBf7c6/WR5DSrSH5rvvCIgA/p5MFkUXxgWSPNzRLhhLFWypfEGWQ5GJeotdgQeiSVwtYidHIIqQxPoRNQbOSQgiAGiAt1NY4uvaEd7fBCw49xExw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142189; c=relaxed/simple;
	bh=vBsTLKWA9BKsGE5i2sAZKfN0NxLugNrDR2lDsckRbnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6oxPvqwxlUuQukkbUTmyqdB9XLxIwrbinuWCWH9zcEz6SLrdaBFWa+768JULcjwCIV1ex50r77WjZGvjzH7aZfQkfO76+rjIiuzFKv2XVgpt125VgocUsk2RLimNeGY4S4yujogDqL/I/hZtPCAGWJxlGIBtXNYRxc36+MVQKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N2xHU/GY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N2xHU/GY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5006C2BC9E;
	Tue, 10 Mar 2026 11:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142189;
	bh=vBsTLKWA9BKsGE5i2sAZKfN0NxLugNrDR2lDsckRbnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2xHU/GYMHhUJEhbDKSTDxHf8D6i3njibX3hkX6wJ8jQQirnGc7VVNfN9CV+ZpxJz
	 dSN+ZP63OBpQ6vVjD00OiAyd2LL/PsK9hzezWJxsY2dYClIVZeAdGOMooU2CFp/vNJ
	 zxXYxFhIBYmSlB3DTQuvRcP6l5K/wGM+G6U9qf/aQBpxg7HYxNDsgXu+O0d77Uuc1g
	 6gcFz1sEu6GBPZWcDrZ2cP+fWv4o1xkZ6bh2Q8DmrcfP56h/JifKyCsx2BJ5yhplm1
	 TTgrUf1z2ilEdzcyksPKmSavBoRXg6YpXTfrxNy0NIQIKPR2c1hm4T/TB0+EC7fKJK
	 Nw8hOgCGrlEGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Olivier Sobrie <olivier@sobrie.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 278/314] hwmon: (max6639) fix inverted polarity
Date: Tue, 10 Mar 2026 07:18:57 -0400
Message-ID: <59fed0c7cc760bc1134bdea1dde5a5e57f36ad7b.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Olivier Sobrie <olivier@sobrie.be>

[ Upstream commit 170a4b21f49b3dcff3115b4c90758f0a0d77375a ]

According to MAX6639 documentation:

  D1: PWM Output Polarity. PWM output is low at
  100% duty cycle when this bit is set to zero. PWM
  output is high at 100% duty cycle when this bit is set
  to 1.

Up to commit 0f33272b60ed ("hwmon: (max6639) : Update hwmon init using
info structure"), the polarity was set to high (0x2) when no platform
data was set. After the patch, the polarity register wasn't set anymore
if no platform data was specified. Nowadays, since commit 7506ebcd662b
("hwmon: (max6639) : Configure based on DT property"), it is always set
to low which doesn't match with the comment above and change the
behavior compared to versions prior 0f33272b60ed.

Fixes: 0f33272b60ed ("hwmon: (max6639) : Update hwmon init using info structure")
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Link: https://lore.kernel.org/r/20260304212039.570274-1-olivier@sobrie.be
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6639.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/max6639.c b/drivers/hwmon/max6639.c
index a06346496e1d9..1fc12e1463b58 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -623,7 +623,7 @@ static int max6639_init_client(struct i2c_client *client,
 			return err;
 
 		/* Fans PWM polarity high by default */
-		err = regmap_write(data->regmap, MAX6639_REG_FAN_CONFIG2a(i), 0x00);
+		err = regmap_write(data->regmap, MAX6639_REG_FAN_CONFIG2a(i), 0x02);
 		if (err)
 			return err;
 
-- 
2.51.0

