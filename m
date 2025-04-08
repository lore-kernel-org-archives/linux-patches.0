Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7B62676E1;
	Tue,  8 Apr 2025 11:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113191; cv=none; b=NDn6qCglAtcwy4xR1c+n1bNt42pk/ZUiGHHKDumA951W59qfbKoMP3U/Yb7Kn2S1UAbbh5TXrn5n5v5KXqwP7rcqlCHx+ZaNtPP66c2dIIodxw6+P7UQlB/lWNHt+GRebo1rm1mIb2qRIm1/LTKpk72Kz/mFqlYA7RTw91o0K2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113191; c=relaxed/simple;
	bh=k/P4JMW9U5PJMCxfeKShnrFPIXoFUxJAe5mOZLQhtXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dqh90kwbQ9lATlZehrAexzyIHojn/QJtyjzd5eIk3H+ar/Shr9ZCY88LWztO0Y48Sjkk7UHEljH/H9TilryaeS6Nct0mAMt/6OxYWyuahhJcOToEqenJSbwjgLUUL+49sDhU6w2hAm6d0ZLa/B15bJbkXTbOtMaNObpDU3CC54w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYHwdxob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYHwdxob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B2DC4CEE5;
	Tue,  8 Apr 2025 11:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113191;
	bh=k/P4JMW9U5PJMCxfeKShnrFPIXoFUxJAe5mOZLQhtXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYHwdxobvDXStGgBsQxgTQyKqPVuDnpMmIg2xoDimfjQNBE3xZvn0UR+h0eTbnMxV
	 etFn5QV1TGc4yxyX9w123PFDYJmr+YG4FsFfzPOVMbKjL43WAYYjbfcgz0AQWDSSgL
	 5u/z/5BZHlslW4wDP32xPC5MlXwCNskHDI8eUvao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/268] ASoC: cs35l41: check the return value from spi_setup()
Date: Tue,  8 Apr 2025 12:47:18 +0200
Message-ID: <20250408104829.236962721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

[ Upstream commit ad5a0970f86d82e39ebd06d45a1f7aa48a1316f8 ]

Currently the return value from spi_setup() is not checked for a failure.
It is unlikely it will ever fail in this particular case but it is still
better to add this check for the sake of completeness and correctness. This
is cheap since it is performed once when the device is being probed.

Handle spi_setup() return value.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 872fc0b6bde8 ("ASoC: cs35l41: Set the max SPI speed for the whole device")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Link: https://patch.msgid.link/20250304115643.2748-1-v.shevtsov@mt-integration.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41-spi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l41-spi.c b/sound/soc/codecs/cs35l41-spi.c
index 5c8bb24909eb4..bd73944758c6d 100644
--- a/sound/soc/codecs/cs35l41-spi.c
+++ b/sound/soc/codecs/cs35l41-spi.c
@@ -39,7 +39,9 @@ static int cs35l41_spi_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	spi->max_speed_hz = CS35L41_SPI_MAX_FREQ;
-	spi_setup(spi);
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
 
 	spi_set_drvdata(spi, cs35l41);
 	cs35l41->regmap = devm_regmap_init_spi(spi, regmap_config);
-- 
2.39.5



