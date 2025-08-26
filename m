Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F9C35082F;
	Tue, 26 Aug 2025 13:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216158; cv=none; b=Gu6G5dKCKHByLtZG5AueSmke/EVcPQ3om01Ptzlbr2R77OmIeDkMIn0pEQ9SfClw8Un2txMEq0azlLIGu4k0snwiPNhOxpKkqXbRZJLzuEc9/KrP2+HR489Hlb/whNbNQWvn2r5yEu0t8BXzqUonesXi7oTAh+Xxsw89TYT2n5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216158; c=relaxed/simple;
	bh=THitS0EP9KuTfept+3Ec+fSJFNNohPvWbjHxFNPRWFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1V8XOYbPAwW1xBrayDDhmlryHfoNIrc053NpFt2d/jbaf9orzVKzgNiacIgLWRFqrPvxeXTqxnJjsSTN4S8bhGeHMvkXqwzQMLrpcq/X3leomcl4ogjfPb5kI/RwsI3VIWz/u2KtziLfVv7nSny/PkQ06xiTdjQSBiAwg21kqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmg+jDfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmg+jDfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CDCC113CF;
	Tue, 26 Aug 2025 13:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216158;
	bh=THitS0EP9KuTfept+3Ec+fSJFNNohPvWbjHxFNPRWFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmg+jDfEsRJ71VR0S89Sbdh5T6oCv8wsO6Sxsaq8IVLzedSiBL9S/G/K8UqEkMFDB
	 vvaEY4rLxlcms5lhMp/Qek3rErGON5HJjojOOTJXLf0aLEMY14ZLZH3pQzmO7uBc54
	 cL/9apCtxYgHCxUtyZYO/uYkyt8gGWJFwKI11Xl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/644] ASoC: soc-dapm: set bias_level if snd_soc_dapm_set_bias_level() was successed
Date: Tue, 26 Aug 2025 13:06:38 +0200
Message-ID: <20250826110953.992843699@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 538d84f1c29f..469ffc31068e 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -742,6 +742,10 @@ static int snd_soc_dapm_set_bias_level(struct snd_soc_dapm_context *dapm,
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



