Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D25221356
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bq9PDavU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0051C433C7;
	Wed,  4 Oct 2023 18:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444408;
	bh=GlOyA4DV6DaLZgzsGgfkotpTtO+FE/MsIqty39FtQNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bq9PDavUyu1H4KNjW9XlIMMfRV7y9cGasIS00+uqkVvPmeNy9yWz2z9nd6v9coLtZ
	 jS+f25oIuRTxQqyISBdpAZ8woYunpJlsX6ArNSju2gdUoibw1VzqhvUXBL0I9GI9uo
	 GxphIzATMrOYKWXXLTuoiBV7DbA/XrjE4KA+Vyiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 212/321] ASoC: cs42l42: Ensure a reset pulse meets minimum pulse width.
Date: Wed,  4 Oct 2023 19:55:57 +0200
Message-ID: <20231004175239.075709613@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 41dac81b56c82c51a6d00fda5f3af7691ffee2d7 ]

The CS42L42 can accept very short reset pulses of a few microseconds
but there's no reason to force a very short pulse.
Allow a wide range for the usleep_range() so it can be relaxed about
the choice of timing source.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230913150012.604775-2-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index a0de0329406a1..56d2857a4f01c 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -2320,6 +2320,10 @@ int cs42l42_common_probe(struct cs42l42_private *cs42l42,
 
 	if (cs42l42->reset_gpio) {
 		dev_dbg(cs42l42->dev, "Found reset GPIO\n");
+
+		/* Ensure minimum reset pulse width */
+		usleep_range(10, 500);
+
 		gpiod_set_value_cansleep(cs42l42->reset_gpio, 1);
 	}
 	usleep_range(CS42L42_BOOT_TIME_US, CS42L42_BOOT_TIME_US * 2);
-- 
2.40.1



