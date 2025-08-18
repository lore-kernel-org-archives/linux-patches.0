Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3BE3218C0;
	Mon, 18 Aug 2025 12:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521874; cv=none; b=AVP40JsuAUmTKvsFfG2z4NRDP5kkwmHfmxec/u5hBODlngvSYW4+roqCnRU37TEdPxwopKOkaeZ7ceJePDEfPvWJpVdW0j4mnRyZWjnI6Dyas1m3upLM75BYveDywm+MOJEtznj238C+c7CMrqffGrH7m4ZzmnJJBSgsRuRzHwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521874; c=relaxed/simple;
	bh=0XHeeSL4cVyeQbarNEiQyQewM2X1e1tvRpKvvwBrUdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9GorWbJEoTzlMaNOuXkCp5NITUQkSxeT+4Ng/pO0sjca6RDs54tb9nFs8qYTKw7yjYVYplVryyHsM11LLCMmy+zTcFkSBQb1lyVHMa1LAtJD5ojk0C80hJlg5Ao28UCVup5ocoLQjwp+8xAX/RAIaarYnR8fy0LbR21/y0cExQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVz8aOTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVz8aOTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9ACC4CEEB;
	Mon, 18 Aug 2025 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521874;
	bh=0XHeeSL4cVyeQbarNEiQyQewM2X1e1tvRpKvvwBrUdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVz8aOTz2GfUCOQ9OHlc7/B7/fBXbtXQ7yC06hxAZUqXhAocFIpy5AsjQLbsYGXIC
	 agjgtzKf+LrRHhx39TzWWN0s6t50W2EgY2CELWb4hu4LCP6E2Mj5b3eovZ9A7f7c/+
	 F1j1MvOG0ZU8Uo4OkHrmiLUwjljhdAv8MFdJWDVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/444] ASoC: soc-dapm: set bias_level if snd_soc_dapm_set_bias_level() was successed
Date: Mon, 18 Aug 2025 14:42:21 +0200
Message-ID: <20250818124453.238405098@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit f40ecc2743652c0b0f19935f81baf57c601eb7f0 ]

ASoC has 2 functions to set bias level.
	(A) snd_soc_dapm_force_bias_level()
	(B) snd_soc_dapm_set_bias_level()

snd_soc_dapm_force_bias_level() (A) will set dapm->bias_level (a) if
successed.

(A)	int snd_soc_dapm_force_bias_level(...)
	{
		...
		if (ret == 0)
(a)			dapm->bias_level = level;
		...
	}

snd_soc_dapm_set_bias_level() (B) is also a function that sets bias_level.
It will call snd_soc_dapm_force_bias_level() (A) inside, but doesn't
set dapm->bias_level by itself. One note is that (A) might not be called.

(B)	static int snd_soc_dapm_set_bias_level(...)
	{
		...
		ret = snd_soc_card_set_bias_level(...);
		...
		if (dapm != &card->dapm)
(A)			ret = snd_soc_dapm_force_bias_level(...);
		...
		ret = snd_soc_card_set_bias_level_post(...);
		...
	}

dapm->bias_level will be set if (A) was called, but might not be set
if (B) was called, even though it calles set_bias_level() function.

We should set dapm->bias_level if we calls
snd_soc_dapm_set_bias_level() (B), too.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87qzyn4g4h.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 99521c784a9b..196799b2fe24 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -740,6 +740,10 @@ static int snd_soc_dapm_set_bias_level(struct snd_soc_dapm_context *dapm,
 out:
 	trace_snd_soc_bias_level_done(dapm, level);
 
+	/* success */
+	if (ret == 0)
+		snd_soc_dapm_init_bias_level(dapm, level);
+
 	return ret;
 }
 
-- 
2.39.5



