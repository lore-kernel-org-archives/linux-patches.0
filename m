Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3897F7E8;
	Wed, 21 Feb 2024 14:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524600; cv=none; b=Cw/zQdUOB2Fa8GyVv8LSHVbnVHJdzQF+ITxgBvMR4SEg54DXFcOO5UgQx41xvHbNxEBrVlKWGxRtyE907XATM5QmtTEaocf5B9aDBzFAer2CExXYNdAt9bwK+4UPHu0g2EpHv9lAZYzdlPHeez3P5yGXaOKyQQlVhfHnHhcDMqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524600; c=relaxed/simple;
	bh=GTXH5a6crWCg23YSFFVV6JLiQtetXQZaD4R2o7OCXko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrFZdtU+DM0isvXHGR2QQ9FniVScT82XOZDBVSz4bD2R2ZgFGtOOvJwVq4fLyt8q0rE7ceDnGYyUGg6t9b0PZz+haHf0R4FZXg/1N1vTh3c3ACY4ZndRkIW/V/IkujiJ0Jott+5Kl1s2t2QsGy+F+Hs0k+aKOvuudeHRVnCct7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rh58gMpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rh58gMpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4F1C433F1;
	Wed, 21 Feb 2024 14:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524600;
	bh=GTXH5a6crWCg23YSFFVV6JLiQtetXQZaD4R2o7OCXko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rh58gMpMq8Tp56Jn70YB2YvDyoeGDUCj5D9Xtlq7eaKuQBXLzZk64RMZxbc74++5c
	 rqyFn2zFdKOI11q4AvxTgsMnEEBH7xKtJkm4xSNg9r5MDJM967kACMF8QJsNoc+gbX
	 bYQf0p4yofIxT7Dn5VP7XmWWHFNjVV9Uvf48Aq5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/379] ASoC: rt5645: Fix deadlock in rt5645_jack_detect_work()
Date: Wed, 21 Feb 2024 14:07:52 +0100
Message-ID: <20240221130003.575082336@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7dc80183921e..04457cbed5b4 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3276,6 +3276,7 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 				    report, SND_JACK_HEADPHONE);
 		snd_soc_jack_report(rt5645->mic_jack,
 				    report, SND_JACK_MICROPHONE);
+		mutex_unlock(&rt5645->jd_mutex);
 		return;
 	case 4:
 		val = snd_soc_component_read(rt5645->component, RT5645_A_JD_CTRL1) & 0x0020;
-- 
2.43.0



