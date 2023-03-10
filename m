Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9588481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848A4C4339B;
	Fri, 10 Mar 2023 14:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457429;
	bh=LOYjDsy62Hb8HMECGXe/ToF4xlSzflh09K6bV4/KwfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKnhXKYB4wmnftfVDaAou5ipAVfwNk6kA5Z5DyR7T5Gi3Bv3k6nLa46AVGm3jo5BN
	 w2+XHivPh37vdVs81kRh5f6iq62ddgbSEwn0ulwctz9PSCLdILUcJzhnJnw6No/Ld3
	 V2ZRCpStPOJlZUTvBX+qRuPqTJtjZe0M1kRKHeqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/200] ASoC: adau7118: dont disable regulators on device unbind
Date: Fri, 10 Mar 2023 14:38:31 +0100
Message-Id: <20230310133720.294247444@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit b5bfa7277ee7d944421e0ef193586c6e34d7492c ]

The regulators are supposed to be controlled through the
set_bias_level() component callback. Moreover, the regulators are not
enabled during probe and so, this would lead to a regulator unbalanced
use count.

Fixes: ca514c0f12b02 ("ASOC: Add ADAU7118 8 Channel PDM-to-I2S/TDM Converter driver")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20230224104551.1139981-1-nuno.sa@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau7118.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/sound/soc/codecs/adau7118.c b/sound/soc/codecs/adau7118.c
index bbb0972498876..a663d37e57760 100644
--- a/sound/soc/codecs/adau7118.c
+++ b/sound/soc/codecs/adau7118.c
@@ -444,22 +444,6 @@ static const struct snd_soc_component_driver adau7118_component_driver = {
 	.endianness		= 1,
 };
 
-static void adau7118_regulator_disable(void *data)
-{
-	struct adau7118_data *st = data;
-	int ret;
-	/*
-	 * If we fail to disable DVDD, don't bother in trying IOVDD. We
-	 * actually don't want to be left in the situation where DVDD
-	 * is enabled and IOVDD is disabled.
-	 */
-	ret = regulator_disable(st->dvdd);
-	if (ret)
-		return;
-
-	regulator_disable(st->iovdd);
-}
-
 static int adau7118_regulator_setup(struct adau7118_data *st)
 {
 	st->iovdd = devm_regulator_get(st->dev, "iovdd");
@@ -481,8 +465,7 @@ static int adau7118_regulator_setup(struct adau7118_data *st)
 		regcache_cache_only(st->map, true);
 	}
 
-	return devm_add_action_or_reset(st->dev, adau7118_regulator_disable,
-					st);
+	return 0;
 }
 
 static int adau7118_parset_dt(const struct adau7118_data *st)
-- 
2.39.2



