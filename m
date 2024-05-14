Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AC6139D19;
	Tue, 14 May 2024 11:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684646; cv=none; b=KzD8/hW2Anzpg7fUCv4IdOuX8Nug+bRvP6d2tFjRzVMV0HUe3a1TxelpJ2hjHGqMMoLWgEFh/XEDQgYMSozTtGSIbGaHPJifeM2lETUptbcISBFrlcHtZJTXmDiUxjCVaeLmOlb1bETLMd0YOWI9j0YAyH5qS0Saks22Z1r3M3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684646; c=relaxed/simple;
	bh=aj6mLU87irF7x0GycoH3mlN2Ao8K6IofHzOugQdil2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFB/eXWiWUxwcCsiVGtoTE2JI18DjGX7muF8FJdCofH1aFxEMCwcT3PpyFG3Hv84J9ZRRPjuan9ZJaYMH46gA2sSgp2fxv9JeQs3PYAu3XC2hkn60Rl567HIjJa/VDGeSTSpbQUnzQJscm78WgFJiSwGzwIyTlIL50SaeMJP+04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF+yeYun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF+yeYun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD8EC2BD10;
	Tue, 14 May 2024 11:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684646;
	bh=aj6mLU87irF7x0GycoH3mlN2Ao8K6IofHzOugQdil2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XF+yeYunqeM4TH60ifw4v1/yJfcUkjsb+dh+jCVZTV+9Ce+yqUHLpLZFtC16esoM3
	 N+ZRJ8jsVyMxu9KLMlBw/GHuoifICNZuMrqBzHZo/IX5d7VHei1tUll5cXIHi7/3Qg
	 9/PtIBBobjjPUotXWhgvEgYNzoerO9mPoL3YfoYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/301] ASoC: meson: cards: select SND_DYNAMIC_MINORS
Date: Tue, 14 May 2024 12:15:40 +0200
Message-ID: <20240514101034.849053518@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 6db26f9ea4edd8a17d39ab3c20111e3ccd704aef ]

Amlogic sound cards do create a lot of pcm interfaces, possibly more than
8. Some pcm interfaces are internal (like DPCM backends and c2c) and not
exposed to userspace.

Those interfaces still increase the number passed to snd_find_free_minor(),
which eventually exceeds 8 causing -EBUSY error on card registration if
CONFIG_SND_DYNAMIC_MINORS=n and the interface is exposed to userspace.

select CONFIG_SND_DYNAMIC_MINORS for Amlogic cards to avoid the problem.

Fixes: 7864a79f37b5 ("ASoC: meson: add axg sound card support")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240426134150.3053741-1-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/meson/Kconfig b/sound/soc/meson/Kconfig
index b93ea33739f29..6458d5dc4902f 100644
--- a/sound/soc/meson/Kconfig
+++ b/sound/soc/meson/Kconfig
@@ -99,6 +99,7 @@ config SND_MESON_AXG_PDM
 
 config SND_MESON_CARD_UTILS
 	tristate
+	select SND_DYNAMIC_MINORS
 
 config SND_MESON_CODEC_GLUE
 	tristate
-- 
2.43.0



