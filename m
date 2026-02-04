Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EAE2D6611;
	Wed,  4 Feb 2026 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219013; cv=none; b=TirKLqW9eYR44qpQmoJUQbqEP/0CjFgOufCP/TbWIMvjsmOMdYfuO9kj4yWq3cqfFMhQAi9sfWswahADgKD9UtebCjkrcyKhasTnQFy8tYTAOs0B/JNC067m9auDUaBVhXWd5v3qqniV4o72tmw+wPZ1qeZ44cEH3sgRvO4kBJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219013; c=relaxed/simple;
	bh=M9uYQDJZYdZ9rQjv5YYNLRie80LBXiwsAGl7cCrSxXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmgoOhbFTfgl/7FhTAS/cPEZw5eZ/m53IeVDy8wWUtRz2o+OF2iER7lNv37w6MyZpC3ulLajAug2hNHiBrhpU7ELaWmz91scssQhLaXi4NVNfiPUOhqIzMQ5ym5tlI9p3zc9FQB/HDBVPSRwBgRBRPihzyYdkbMmy7mB8EX7KEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bca5DE2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bca5DE2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BE7C4CEF7;
	Wed,  4 Feb 2026 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219013;
	bh=M9uYQDJZYdZ9rQjv5YYNLRie80LBXiwsAGl7cCrSxXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bca5DE2TlhAqtsxSpnVdmSZE/JDbArYMArGOiCuDumhB7aTvkmt4FvOM8EJNH3UHN
	 Bk9Zn2TUfuck5HqqMSOI3MiQm9WNwI0MYikCYZmNeuleeTYm40QLfRVjBRcmnc3JZK
	 86HnJvJzu1xbHbnl6mF4h3jzUM2VHCiK6EB6rMmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tagir Garaev <tgaraev653@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/122] ASoC: Intel: sof_es8336: fix headphone GPIO logic inversion
Date: Wed,  4 Feb 2026 15:40:23 +0100
Message-ID: <20260204143853.337724416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tagir Garaev <tgaraev653@gmail.com>

[ Upstream commit 213c4e51267fd825cd21a08a055450cac7e0b7fb ]

The headphone GPIO should be set to the inverse of speaker_en.
When speakers are enabled, headphones should be disabled and vice versa.

Currently both GPIOs are set to the same value (speaker_en), causing
audio to play through both speakers and headphones simultaneously
when headphones are plugged in.

Tested on Huawei Matebook (BOD-WXX9) with ES8336 codec.

Fixes: 6e1ff1459e00 ("ASoC: Intel: sof_es8336: support a separate gpio to control headphone")
Signed-off-by: Tagir Garaev <tgaraev653@gmail.com>
Link: https://patch.msgid.link/20260121152435.101698-1-tgaraev653@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 10b189ea88dba..09acd80d23e0f 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -120,7 +120,7 @@ static void pcm_pop_work_events(struct work_struct *work)
 	gpiod_set_value_cansleep(priv->gpio_speakers, priv->speaker_en);
 
 	if (quirk & SOF_ES8336_HEADPHONE_GPIO)
-		gpiod_set_value_cansleep(priv->gpio_headphone, priv->speaker_en);
+		gpiod_set_value_cansleep(priv->gpio_headphone, !priv->speaker_en);
 
 }
 
-- 
2.51.0



