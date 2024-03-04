Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ECE7868F;
	Mon,  4 Mar 2024 21:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587690; cv=none; b=l5UxA0GQxJIPRchd6P1jKv/5sZmo9hjLxrV5U5uo/mZq+Oxkx7s94s1rOGMDWqbNI7K6NVNQWmRLSJN2o1xitQqst+AYeTTNugwDln5210CuWS7yKOzhh5ZDvGsF4K1wDkD9wxuc64j4ybYilKj2EO6kUOh/eumqhBhPscn+sBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587690; c=relaxed/simple;
	bh=s2u1Rw6QQgXmGuLowcfXzgFYv8SIVBzzDoHfZJxZriU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub5x7ZqMKAIp+3FTxCgKDDvOyiIb/L5zTBYzjE2WDrOTQZPoKCBFSIiMW5viubiLDejbzh+uov/IscjQlhOsX7g6xp7LNFAOS3/tru6CVygObC/X7EON7DEebySne1NGKd77IbhcQAZoSHMfcMo35oWjfguLLNWUkDNv8u7uiP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKLU4Bml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKLU4Bml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E094C433F1;
	Mon,  4 Mar 2024 21:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587690;
	bh=s2u1Rw6QQgXmGuLowcfXzgFYv8SIVBzzDoHfZJxZriU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKLU4BmlwkMU6qFGasawtW8RCHOs/O27emYq4LvhdeUcMWCg0rtfavmuw0rjMSSFB
	 3swSeFM9ZodD3L2brYyyEQdGbeT5rjfagPmwKk49srLPY8v0JstXPHeRoAeS67Kaw+
	 JtfCkI8Ux/rwKmgBw1InqhAW1FPWNR7KN7mZ7fBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 053/162] ASoC: cs35l56: cs35l56_component_remove() must clear cs35l56->component
Date: Mon,  4 Mar 2024 21:21:58 +0000
Message-ID: <20240304211553.555407479@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ae861c466ee57e15a29d97629e1c564e3f714a4f ]

The cs35l56->component pointer is used by the suspend-resume handling to
know whether the driver is fully instantiated. This is to prevent it
queuing dsp_work which would result in calling wm_adsp when the driver
is not an instantiated ASoC component. So this pointer must be cleared
by cs35l56_component_remove().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: e49611252900 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Link: https://msgid.link/r/20240129162737.497-4-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: eba2eb2495f4 ("ASoC: soc-card: Fix missing locking in snd_soc_card_get_kcontrol()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 45b4de3eff94f..09944db4db30d 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -809,6 +809,8 @@ static void cs35l56_component_remove(struct snd_soc_component *component)
 	struct cs35l56_private *cs35l56 = snd_soc_component_get_drvdata(component);
 
 	cancel_work_sync(&cs35l56->dsp_work);
+
+	cs35l56->component = NULL;
 }
 
 static int cs35l56_set_bias_level(struct snd_soc_component *component,
-- 
2.43.0



