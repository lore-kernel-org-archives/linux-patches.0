Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1F7331A43;
	Sat, 30 May 2026 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157488; cv=none; b=bFp11l8pwk5SJBmuce7IgFAM0iTrs89cnZL9W/ZglwFVq6qgienL61BcK4kdzn9NJXTnj0OKh5HzImwGHNC83PCr4AI4UYVtdSFoP12gH5cxKF8Fn0RgjO94ze6AQz5Fp8lPmo/rYM8TAWf7Sexqdb4WVByrN5YIVYTrQCXaYLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157488; c=relaxed/simple;
	bh=h3L8ND1Xleqh9k4pkrcRrR25q/8059AS03fBg29dUBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GGIYbSHO5ZX0XNHwJT9Jasam8QwPZj962aPsjj4E7gSNjqW8F6ldgQbbkVWvkpqWTxqm8Q2Op2jstwWaDyIfqC92jjekZDwxi5S7yEsWlRzWXOurfKJRay8xP4Po7RLCTrasYjZJpJoKoSjvKgyWmdxVrka2zKPF+7Lu1Pm1KAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAivxwm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAivxwm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ECC1F00898;
	Sat, 30 May 2026 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780157484;
	bh=F/9mH4Rfk7W5y1YJySmJMcQf5vzzWoJLLsPmtZXGm/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAivxwm3Rdi/AnRRMW0mTHDyQ4ZLJQV7sNKGyDo8xYbSjC2jgX0OvYvP9MedRxnfM
	 WUrvMp96yPjYMepC2jv6YbDXqJLx9kqfEKWW/Reh4SndFYv75L3p+SkNwOAYqA6KtI
	 mzW20QVoFORafo9tRaHsncmbI2xTOKcxbfAZ5dtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/776] ASoC: SOF: topology: reject invalid vendor array size in token parser
Date: Sat, 30 May 2026 17:55:16 +0200
Message-ID: <20260530160240.299407655@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 215e5fe75881a7e2425df04aeeed47a903d5cd5d ]

sof_parse_token_sets() accepts array->size values that can be invalid
for a vendor tuple array header. In particular, a zero size does not
advance the parser state and can lead to non-progress parsing on
malformed topology data.

Validate array->size against the minimum header size and reject values
smaller than sizeof(*array) before parsing. This preserves behavior for
valid topologies and hardens malformed-input handling.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260319-sof-topology-array-size-fix-v1-1-f9191b16b1b7@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 1bb2dcf37ffe9..16feb5d268022 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -941,7 +941,7 @@ static int sof_parse_token_sets(struct snd_soc_component *scomp,
 		asize = le32_to_cpu(array->size);
 
 		/* validate asize */
-		if (asize < 0) { /* FIXME: A zero-size array makes no sense */
+		if (asize < sizeof(*array)) {
 			dev_err(scomp->dev, "error: invalid array size 0x%x\n",
 				asize);
 			return -EINVAL;
-- 
2.53.0



