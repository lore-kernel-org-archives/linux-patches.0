Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1603335BA7;
	Mon, 18 Aug 2025 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525078; cv=none; b=e8YgS684K2CgN+ck2CTp3eKIxHWQfbVhrddH953V5LeRDkrH2Gp4oUvDQru8drPaMfv0LEN4NMXgfDOnKkOvWZkyQ0woYB2S6E9qPXkOgKz+2t9tAeobIgVhdJtUv5eKydcU9fyViQYcHEDE9tyUhxCO6ck64NwhP8lgqY2QPlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525078; c=relaxed/simple;
	bh=B7ONYW15dckmzkpEUyEqCakKBo+ZfSRk87VBdzJXtTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/9JIs1FBB5e3Jit3MFADTw2kDmNEK2puRp1qGoswPAojNLTocEjeigaocXMHY12dy/dM+p2QrnZwltRvVLCQMNiyNQG1UeBWRNOu8kKwnPS9BZN9JPW/ORDPlwVHrW3tJs6Pwu1HOLjJ+skHmMUkZSSHOXgLQ1IL4camKRqMQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plTUg2r4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plTUg2r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFE3C4CEEB;
	Mon, 18 Aug 2025 13:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525078;
	bh=B7ONYW15dckmzkpEUyEqCakKBo+ZfSRk87VBdzJXtTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plTUg2r4S+0iW0wwsEU/szH+KdQ3g1r8y7w77Gbsc4X2gWCUXoLEXjplJBqwPwq+q
	 Elu+ySEPbbSJIu+3U9x0hO5dVY3NcIlHh6muEGgS1KZv7PUNVL9ePCBSQWLYGH7aOZ
	 Tieq+aTa9tYoJHACeUTBTxrg3EUCrjYsvrQHHxF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 151/570] ASoC: soc-dapm: set bias_level if snd_soc_dapm_set_bias_level() was successed
Date: Mon, 18 Aug 2025 14:42:18 +0200
Message-ID: <20250818124511.632615858@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f26f9e9d7ce7..7d9c9e8839f6 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -739,6 +739,10 @@ static int snd_soc_dapm_set_bias_level(struct snd_soc_dapm_context *dapm,
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



