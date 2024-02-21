Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EAD78B73;
	Wed, 21 Feb 2024 14:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525616; cv=none; b=gfGqcSTusjwjYLsuvdFvopx5T8q8VB4/9o6fqzboe9KFOu32dAvBeD+JrPL8C6MjPhSNcDhwFmNmTGgkhrHSI1Sn0FoRQU154BjW0YyTuveakAXWm9qhxj9Zx/F2KUY8EXLdOVV67TDm0lUPOrT6GXECQtNKiNisPROLbGLLNys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525616; c=relaxed/simple;
	bh=hw3wAlGIfCQK+yiPBCzuyggFrFniM0ekHWiJ7EPSzG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApVoMXUCdf+xFweQssY6IbKIlJZD3rufDcZBF3RQ4+A7O+zmX5ozK9wlGzIUre00wDZe16tUqRyN6YomRX/LsnQ4FeQDT0Y8TURJYCdEhS/huJC6SlqqVI4j56v+ZjejVz9BbjHgP72JL5oKRHpW4sELkbaq6Cl0LdW6LPYyF+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4a6LWA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4a6LWA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C615C433C7;
	Wed, 21 Feb 2024 14:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525616;
	bh=hw3wAlGIfCQK+yiPBCzuyggFrFniM0ekHWiJ7EPSzG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4a6LWA9/Q3TvMdzsKCkK8VgB1Tn44ly/rWQblN/pDCEzMLD5yYRhMlRODAj0ODQs
	 IEo9ZbU4ToKJlkyOz7XVr88KGEYsV5pJrsXTXwxAI5sM5Foipg5Tuy+w4WHQUXMg2h
	 9fxE8WB2GIQhiec8MJmVnWoOd+V1/8QbWuXCs0Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 210/267] ASoC: rt5645: Fix deadlock in rt5645_jack_detect_work()
Date: Wed, 21 Feb 2024 14:09:11 +0100
Message-ID: <20240221125946.783464881@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit 6ef5d5b92f7117b324efaac72b3db27ae8bb3082 ]

There is a path in rt5645_jack_detect_work(), where rt5645->jd_mutex
is left locked forever. That may lead to deadlock
when rt5645_jack_detect_work() is called for the second time.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: cdba4301adda ("ASoC: rt5650: add mutex to avoid the jack detection failure")
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Link: https://lore.kernel.org/r/1707645514-21196-1-git-send-email-khoroshilov@ispras.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index c9512e97c12e..88093e58dd84 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3276,6 +3276,7 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 				    report, SND_JACK_HEADPHONE);
 		snd_soc_jack_report(rt5645->mic_jack,
 				    report, SND_JACK_MICROPHONE);
+		mutex_unlock(&rt5645->jd_mutex);
 		return;
 	case 4:
 		val = snd_soc_component_read32(rt5645->component, RT5645_A_JD_CTRL1) & 0x0020;
-- 
2.43.0



