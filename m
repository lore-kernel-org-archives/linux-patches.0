Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A357442FA1;
	Mon, 17 Aug 2026 14:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977201; cv=none; b=GJKQ+SRqQT4CZ6URSVV/RXJU+UYvhR792rmoLiRHSixfJOExJf5t4ugs/wdrYup/tbHG0ZoDanV4HPhVoC3TYOxsBFW99hbhZxRxkpl9kluCEivGCEVPPg8ZPNwdS9uXfTqj3U4mW1CjYc30OCiajc/+D46t8y+yJnnA3ZPwTqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977201; c=relaxed/simple;
	bh=c5TQCWvSIpQO2+OhsouckrtxL2xKl7CPuLr3v3SARcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5328fFZKEXM24UpZLjik6T/JE6hFOzqSB46UkjNRcb9OAYGDtGs0/PS7tTsirNY72dWbn2BngM81VVCWImBNheDBenD+o4nKTwuCT/9GGUjyl/q9AvdIS1adWoVDcGQs2ZqYewEEThn5rGEOYrB7BICBlACDOkdsfddFhVzrHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ru8ZW0d+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ru8ZW0d+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BE81F000E9;
	Mon, 17 Aug 2026 14:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977200;
	bh=qQ1enwTnFuj1kGul6I8k2kKqW+37qngmugjiPayt7Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ru8ZW0d+nKCdrDs87+fR73qGep8kU33OQU4BBi4itpyeRRQwRU0AWf4muvPmtz8XI
	 W5wm2wf9ntcmKFk8FhUJ30wAKvAoG5bB/+vvKnZD9nduVsrbtFXV2QP263E0VaX2Rd
	 KMZsuHRaywxxZX2U0az7UuRvbaLdGPpcwyl27Kj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/456] ASoC: max98095: fix missing IS_ERR() before PTR_ERR() on mclk lookup
Date: Mon, 17 Aug 2026 15:30:37 +0200
Message-ID: <20260817132549.750778554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit 317e21532e6ffa1de026bdbce5ba98e1b70ca5c6 ]

In max98095_probe(), the -EPROBE_DEFER check after devm_clk_get() is
broken due to a missing IS_ERR() guard.

The code intends to return -EPROBE_DEFER only when the clock lookup
fails with that specific error.  However, without IS_ERR() the check:

    if (PTR_ERR(max98095->mclk) == -EPROBE_DEFER)

is called unconditionally, including when devm_clk_get() succeeds and
returns a valid pointer.  Calling PTR_ERR() on a valid pointer
reinterprets its address as a signed long; the result is arbitrary
and is almost never equal to -EPROBE_DEFER, so the check silently
does nothing in the success case.  When devm_clk_get() fails with
any error other than -EPROBE_DEFER the check is also skipped, leaving
max98095->mclk holding an error pointer with no indication to the caller.

This means a deferred probe will never actually be triggered for this
device, and any non-EPROBE_DEFER clock error is silently swallowed with
the error pointer left in the mclk field.

Fix this by adding the missing IS_ERR() guard around the PTR_ERR() call,
matching the pattern already used in the sibling max98088 and wm8960
drivers.

Fixes: e3048c3d2be5 ("ASoC: max98095: Add master clock handling")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://patch.msgid.link/20260720103950.14474-1-udaykhare77@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98095.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 736cd70be7255..909f2e2f18910 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1990,8 +1990,9 @@ static int max98095_probe(struct snd_soc_component *component)
 	int ret = 0;
 
 	max98095->mclk = devm_clk_get(component->dev, "mclk");
-	if (PTR_ERR(max98095->mclk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (IS_ERR(max98095->mclk))
+		if (PTR_ERR(max98095->mclk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
 
 	/* reset the codec, the DSP core, and disable all interrupts */
 	max98095_reset(component);
-- 
2.53.0



