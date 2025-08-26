Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C7D34F496;
	Tue, 26 Aug 2025 14:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217679; cv=none; b=f8eEyQBruBo6p/F5PMbHqSkYH+M6VAt+eS1MS22e6DiaDJs1SDsW1yjeXN2LEzVdVCc6YvtZ4Rx3dqaMggWPscxychKahYs1e5u9GSdABWpjHgRUKHHuCA8O0UVnWIbQCF656UtxxxAK4JsVxJfvGcnqpO6ZdD3LHK5aIyFDp2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217679; c=relaxed/simple;
	bh=BMPQhpKj4utHRWpvOhV/KkYHgVz8Zc2aQ1WvVui/TYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L13Gx1suF/2rj1LNNUMuAIkHdB7sJl2fdh0bbvHBZGdHReGTw18Rjfx8qkwjinG/drjtCB3l6EpZLRydHF9h24FzPERQ51x90BbrLXqSH0MVNunoPrw/phWYH5ol3daBNvXhIdeREOK4ufAtdcCO7UaB/b8lQb7TP5dtPgQd/wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BlAitot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BlAitot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B36C4CEF1;
	Tue, 26 Aug 2025 14:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217676;
	bh=BMPQhpKj4utHRWpvOhV/KkYHgVz8Zc2aQ1WvVui/TYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BlAitotqyimprgBAEm280gclW3sCn11JFdBT8JafE+BuNIII3xSLrOyjx97EpB8n
	 uuRulaxJY9I/k5yBwRJmHFRoSt5gy95f3sh2mSTHXa5cpjFwE/sY6QBJWnnMiLHBa1
	 rjFfssqoQQ7uC74F7VEXE+2VxrySmX++ZshdrfKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/523] ASoC: soc-dapm: set bias_level if snd_soc_dapm_set_bias_level() was successed
Date: Tue, 26 Aug 2025 13:07:22 +0200
Message-ID: <20250826110930.176139618@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index acb46e1f9c0a..175c8c264b62 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -743,6 +743,10 @@ static int snd_soc_dapm_set_bias_level(struct snd_soc_dapm_context *dapm,
 out:
 	trace_snd_soc_bias_level_done(card, level);
 
+	/* success */
+	if (ret == 0)
+		snd_soc_dapm_init_bias_level(dapm, level);
+
 	return ret;
 }
 
-- 
2.39.5



