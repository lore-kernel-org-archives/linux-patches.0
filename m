Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDB576C85;
	Wed, 21 Feb 2024 13:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521648; cv=none; b=qRiFdZhaORH4KWALV928ekWP4OlyYwlATw327GL5gXYF7n0FxJWeXIp+malPtSrBWw/5ClNCBPisqebxuSWkRjI/fJp8AVVAmzR45W8JC+rmMzzTlSsWEgs8AewMO9p3w25YetdHFPkDN6kRak792f8im7l0Ga9SFNaQQLY77Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521648; c=relaxed/simple;
	bh=UkttCFqPJzp0o6puK6fBlK3P8hjZXHmpl9lIa1Pbo8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihvfP95zhaSvnpts0sUaU9c/aVptiPuh9aC6EJ10C+gQpI9IddETH10XcFIN94w0TW621w+DIIOFgOjyWI+PS/HExqG+bpBQe3pJLtsQ8fuCw3LUBvsLMcQ3v1vSUkcvKeohqDnnuL/KTqflu+PQVu6Pu/wEGP1DnqgVh+9uMkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Prd/lUp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Prd/lUp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691A7C433F1;
	Wed, 21 Feb 2024 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521647;
	bh=UkttCFqPJzp0o6puK6fBlK3P8hjZXHmpl9lIa1Pbo8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Prd/lUp7Ef1RFl3SBgqkT9O2Hu1l8B7aiDf1RTEd0ftuHoJ+8tovOdylIrxu/FGF3
	 aQM17pcYK7tl1X8UeVi2Wftl+9cA2nzozkEQdHYfWMaY88zfEzDpTz5dqls1FnMiVD
	 7yhkDG3SRr3TkgP6d9hNXytodkKTKkHBDXGGcmvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 168/202] ASoC: rt5645: Fix deadlock in rt5645_jack_detect_work()
Date: Wed, 21 Feb 2024 14:07:49 +0100
Message-ID: <20240221125937.186151756@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 37ad3bee66a4..5ec6e9f251c5 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3313,6 +3313,7 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 				    report, SND_JACK_HEADPHONE);
 		snd_soc_jack_report(rt5645->mic_jack,
 				    report, SND_JACK_MICROPHONE);
+		mutex_unlock(&rt5645->jd_mutex);
 		return;
 	case 4:
 		val = snd_soc_component_read32(rt5645->component, RT5645_A_JD_CTRL1) & 0x0020;
-- 
2.43.0



