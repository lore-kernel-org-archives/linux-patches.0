Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146F72D24B7;
	Tue, 10 Mar 2026 11:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141052; cv=none; b=eQGYi4Y73WrbeWTtkYffZiMLXlST8GEObt1/Oq1iQ95BIYXm4uWJP2YpMqFm5MS5B4DIIrusBO6hoJzhTCpBMS0ROFbjdhTsa0TI0XKtmed3pz6j6n0d+f57JZPUGVS+SkDfxV1ubfHYLGjX5KI7GvzJksnTOllQ9WJoUHZjnZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141052; c=relaxed/simple;
	bh=M6SqP4FUp4gybotx7Q+CV5B6GShepxd1sKEkcuKbKoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGcdbDlkYFm2RDAH2H8KqJHwj+tZUZJagT58FurCBiy0SGV/6KRQMRF1tkcy7+HLUtrwkaJ5+vpTyh7C7dVAy7Rm22kp9Aus2gdwqfnW6DThW6PKFyEH7iB3zQ9spav9GrIkyaNbspSC6SkNmclpAYlsfByDYn/eLp0bhQ73nuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hX/DkgHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hX/DkgHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D86C19423;
	Tue, 10 Mar 2026 11:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141051;
	bh=M6SqP4FUp4gybotx7Q+CV5B6GShepxd1sKEkcuKbKoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hX/DkgHZtMkOXU3rtPpGMi8O26VrfpW4LJWCPHTuIcHO2lsrkgRnPhMODQu1XWWLE
	 sxBVO4lhJxwNc6APB4iAe7twFIUlADVL/iY7jHSk7w7iP3153LIbvJpEEWzUg4ogh1
	 IKug9Arr3D+t5iCIeZhH6P0ZFSvHWM8Kchlzax/0TJdOWHPb6Rmr4iERiyEJ7r4BXN
	 kCYklyuSc+N6qFGy1JRWYIqexIHcMbuqPIpdzrtHiquzuCmmWnDto8zV+e5y5MqkLR
	 IofOnxOy+expCVAGuABtDXfriSZxPJu6H+5Ojchj07v1n8fRrQ1XiRT5n6XhpfQQku
	 xOmYn/tEnxNgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <ustc.gu@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 050/311] regulator: fp9931: Fix PM runtime reference leak in fp9931_hwmon_read()
Date: Tue, 10 Mar 2026 07:01:37 -0400
Message-ID: <14664adb2b5032d89d4d3d25432ad8bd331626eb.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 0902010c8d163f7b62e655efda1a843529152c7c ]

In fp9931_hwmon_read(), if regmap_read() failed, the function returned
the error code without calling pm_runtime_put_autosuspend(), causing
a PM reference leak.

Fixes: 12d821bd13d4 ("regulator: Add FP9931/JD9930 driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260224-fp9931-v1-1-1cf05cabef4a@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fp9931.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/fp9931.c b/drivers/regulator/fp9931.c
index 7fbcc6327cc63..abea3b69d8a08 100644
--- a/drivers/regulator/fp9931.c
+++ b/drivers/regulator/fp9931.c
@@ -144,13 +144,12 @@ static int fp9931_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 		return ret;
 
 	ret = regmap_read(data->regmap, FP9931_REG_TMST_VALUE, &val);
-	if (ret)
-		return ret;
+	if (!ret)
+		*temp = (s8)val * 1000;
 
 	pm_runtime_put_autosuspend(data->dev);
-	*temp = (s8)val * 1000;
 
-	return 0;
+	return ret;
 }
 
 static umode_t fp9931_hwmon_is_visible(const void *data,
-- 
2.51.0

