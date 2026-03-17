Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0E53F54D1;
	Tue, 17 Mar 2026 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767452; cv=none; b=nt8cj0SC+cso4OIEDmUFChRunxjUYQfyPKAFGMxmtykndFMkk72JtYSgXuncpKu1WQ23UJHKVjAJniHWx807wsfWuJ90WjMQaKhSqt9VjSjV0cLhgIrT06WeIfV9DJ2BxnLrHFYMk59EyBzufJY1NUyzx/KVQOzqRJC2DEvXdDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767452; c=relaxed/simple;
	bh=jgml32+x9TdfguozwZNtgLnmfn3/8ei1F9d0KSqrOvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFAWDJBcLo0Bi575JdX3MPPdK+dVhGCDSTf9rsRu6r96LHdIJvmO29r2rlJHwJ9E319cHMWyLTSzdR05hFjFh4HnRgPHeFb8I5YvOGdjMV9XWLPQ58wvrqjibmA6Y5tA0YdY80lyHxJC3Bi0BJn8a2Wc/vu1VsXXX7sTFUFXhkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veKIk2tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veKIk2tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D021C4CEF7;
	Tue, 17 Mar 2026 17:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767452;
	bh=jgml32+x9TdfguozwZNtgLnmfn3/8ei1F9d0KSqrOvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=veKIk2tjwurjDxQ4q94RChqj++nFqWY0I0pWn7TqHvavKCJRDBHczNVaHPvT4Q9kE
	 peo4JeCj05XcZ3nIylE4lyxUdJ+YIJdrtrtZXffYNLntdVcJW2pKSgNt6k+LnoiX24
	 2DzeNlbxtHKXK00yraqH1INN0LPdxMWqF9DbVAFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/333] ASoC: amd: acp3x-rt5682-max9836: Add missing error check for clock acquisition
Date: Tue, 17 Mar 2026 17:31:58 +0100
Message-ID: <20260317163002.672890236@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 53f3a900e9a383d47af7253076e19f510c5708d0 ]

The acp3x_5682_init() function did not check the return value of
clk_get(), which could lead to dereferencing error pointers in
rt5682_clk_enable().

Fix this by:
1. Changing clk_get() to the device-managed devm_clk_get().
2. Adding proper IS_ERR() checks for both clock acquisitions.

Fixes: 6b8e4e7db3cd ("ASoC: amd: Add machine driver for Raven based platform")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260310024246.2153827-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp3x-rt5682-max9836.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/amd/acp3x-rt5682-max9836.c b/sound/soc/amd/acp3x-rt5682-max9836.c
index 4ca1978020a96..d1eb6f12a1830 100644
--- a/sound/soc/amd/acp3x-rt5682-max9836.c
+++ b/sound/soc/amd/acp3x-rt5682-max9836.c
@@ -94,8 +94,13 @@ static int acp3x_5682_init(struct snd_soc_pcm_runtime *rtd)
 		return ret;
 	}
 
-	rt5682_dai_wclk = clk_get(component->dev, "rt5682-dai-wclk");
-	rt5682_dai_bclk = clk_get(component->dev, "rt5682-dai-bclk");
+	rt5682_dai_wclk = devm_clk_get(component->dev, "rt5682-dai-wclk");
+	if (IS_ERR(rt5682_dai_wclk))
+		return PTR_ERR(rt5682_dai_wclk);
+
+	rt5682_dai_bclk = devm_clk_get(component->dev, "rt5682-dai-bclk");
+	if (IS_ERR(rt5682_dai_bclk))
+		return PTR_ERR(rt5682_dai_bclk);
 
 	ret = snd_soc_card_jack_new_pins(card, "Headset Jack",
 					 SND_JACK_HEADSET |
-- 
2.51.0



