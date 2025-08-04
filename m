Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321612A1AA;
	Mon,  4 Aug 2025 00:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267698; cv=none; b=Rw1ZeS2qaVmWsrJ3SZAsdsKlqAx+Om0TXc94SJ13CyLQRr0oXWcoMXAtPh95OTSRC8Ga9BnzAnpRqRlv/j4S61fBT7WASH5tudVzr936itr6i1k1RJh5RTPf4NO558W75ENiETgbAlWdLTUAdSj2KW3qvRueIOe66N3NxpNCsnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267698; c=relaxed/simple;
	bh=d+pA1lGR4/KPjTjA766/NtFGb6LS9xQGKn+feb3sNHk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UJ0zkqJ+T+JkLUu7tmL8cBLEuondeovYV5hZEfWLwuvznFSnxeoizWqke5wjgKB0PoICd+6OeVLVpfddRUj1V0GdpHv883tAGPn3nrarn5PeP2QY7D8HWPrS7LgmaFwrs+AlVQoUyWhGa8p5PkR3TmZ/4Miaglo2obGRveRiAKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFgLj4IY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFgLj4IY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBAEC4CEFB;
	Mon,  4 Aug 2025 00:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267698;
	bh=d+pA1lGR4/KPjTjA766/NtFGb6LS9xQGKn+feb3sNHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFgLj4IYJa5QtvQeJOXVwQ0g1lntUzQzZ0yPdR/9m/upZrDlNZOcekYp52D5Aj4OJ
	 Yry5vlvUhnbnjefHzXhxQk6zjs3wE0VbaoeradBTki62lBd/ITF9E+9L2FQLGqVBnX
	 K2Xm+NDjBL+SyXjqHqa6/BSb18AAURrCs4tsh21SOAmtjwAEbTWionEaaK36gh3d60
	 FgrIXoOvEpMmKozCyBGs75waCIV6QbQu2p2nyH7eutGFmroEA5jeUAvIcJJzWaROdc
	 eKZVijnV6zzaHZCuFwu9XAJCvxzO4kP5svyL1IKDXXhWs3BFmujZ7mBzQ6VWtuxGMc
	 I6wOlbRBcTUPg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 18/59] ASoC: soc-dapm: set bias_level if snd_soc_dapm_set_bias_level() was successed
Date: Sun,  3 Aug 2025 20:33:32 -0400
Message-Id: <20250804003413.3622950-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Based on my analysis, here's my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix**: This is a clear bug fix that addresses an inconsistency
   in bias level management. The commit message clearly explains that
   `snd_soc_dapm_set_bias_level()` doesn't always update
   `dapm->bias_level`, particularly when dealing with card-level DAPM
   contexts where `snd_soc_dapm_force_bias_level()` is not called.

2. **Small and Contained**: The fix is minimal - it only adds 4 lines of
   code:
  ```c
  /* success */
  if (ret == 0)
  snd_soc_dapm_init_bias_level(dapm, level);
  ```
  This ensures that `dapm->bias_level` is always updated when the bias
  level change succeeds.

3. **Important Correctness Issue**: The inconsistency could lead to
   incorrect bias level tracking, which affects power management
   decisions in the ASoC subsystem. Code that checks `dapm->bias_level`
   (as shown in lines like `if (dapm->bias_level == SND_SOC_BIAS_ON)`)
   may make wrong decisions if the bias level isn't properly tracked.

4. **No Architectural Changes**: This is a straightforward fix that
   doesn't introduce new features or change the architecture. It simply
   ensures consistent behavior between the two bias level setting
   functions.

5. **Low Risk**: The change only affects the success path (when `ret ==
   0`) and uses an existing inline function
   `snd_soc_dapm_init_bias_level()` that simply sets `dapm->bias_level =
   level`. This is the same operation that
   `snd_soc_dapm_force_bias_level()` performs on success.

6. **Affects User-Facing Functionality**: Incorrect bias level tracking
   can lead to power management issues, potentially causing audio
   devices to not power up/down correctly, which directly impacts users.

The commit fixes a real bug where the DAPM bias level state could become
out of sync with the actual hardware state, particularly for card-level
DAPM contexts. This is exactly the type of bug fix that stable kernels
should include - it's small, targeted, fixes a real issue, and has
minimal risk of introducing regressions.

 sound/soc/soc-dapm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 7729f8f4d5e6..7facb7b2dba1 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -734,6 +734,10 @@ static int snd_soc_dapm_set_bias_level(struct snd_soc_dapm_context *dapm,
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

