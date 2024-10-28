Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F35E15B10D;
	Mon, 28 Oct 2024 06:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097833; cv=none; b=u/GmgHejCDJzNMnBhKUB1ZgXw9s3SwZLJ3Zt8+LwblJfs9Ooq+aqRBS7zD21khkCC/kkW/cOdUhKQZTN8S0q/vWZILxLQGwyWoISUvIin1O1cSaYxHbhZAu7pJnAK/LGZgufrzPZ2y82cMpwlOru+bVTzI08aBQiO42SfsS6BM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097833; c=relaxed/simple;
	bh=41pd/TX5w1BeD8oVe9UZzDTWm3ePC73hBpxzaq0Y8R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJ9D2uUHab/XY0/yqTgbPJ8w9C/frvuPu3QGcVpeS8QMcny5O1X4I2YipwxV7exwkWoidi8GWwOobJEwEZq7HHshwjr2nrR/xVOaM7pP4v3v5pQNDk675ZkeSWva6bsn5ftSboDLtl0EHVyGGE4dvOHBkfaEe9iotnS88qJHIO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOyjQBCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOyjQBCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE35AC4CEE3;
	Mon, 28 Oct 2024 06:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097833;
	bh=41pd/TX5w1BeD8oVe9UZzDTWm3ePC73hBpxzaq0Y8R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOyjQBCRpQPaf1eKBpMNWkOJ0oaMJx2ypvpfOC1DYCApHvgnPgLXzDlwWv3TfIVax
	 vOPwNhNGdi/2GL84jT+plh5MQKXlKFVk5yyAzJPtWjH7J7c2cxQRZ6mLMhmAx63Ub1
	 6aEEpABF/0LO/WdOsWXfBcqUniDizOZw9d1s/rUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/208] ASoC: max98388: Fix missing increment of variable slot_found
Date: Mon, 28 Oct 2024 07:25:47 +0100
Message-ID: <20241028062310.743628718@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit ca2803fadfd239abf155ef4a563b22a9507ee4b2 ]

The variable slot_found is being initialized to zero and inside
a for-loop is being checked if it's reached MAX_NUM_CH, however,
this is currently impossible since slot_found is never changed.
In a previous loop a similar coding pattern is used and slot_found
is being incremented. It appears the increment of slot_found is
missing from the loop, so fix the code by adding in the increment.

Fixes: 6a8e1d46f062 ("ASoC: max98388: add amplifier driver")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://patch.msgid.link/20241010182032.776280-1-colin.i.king@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98388.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/max98388.c b/sound/soc/codecs/max98388.c
index cde5e85946cb8..87386404129d9 100644
--- a/sound/soc/codecs/max98388.c
+++ b/sound/soc/codecs/max98388.c
@@ -764,6 +764,7 @@ static int max98388_dai_tdm_slot(struct snd_soc_dai *dai,
 			addr = MAX98388_R2044_PCM_TX_CTRL1 + (cnt / 8);
 			bits = cnt % 8;
 			regmap_update_bits(max98388->regmap, addr, bits, bits);
+			slot_found++;
 			if (slot_found >= MAX_NUM_CH)
 				break;
 		}
-- 
2.43.0



