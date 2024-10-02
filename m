Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA741EA80;
	Wed,  2 Oct 2024 14:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879414; cv=none; b=MfQ5PclfXK7QFfwk9u1HRIkILapaWT2ld3Le9L1iGU0SPMU2dD4lfr2Qe6tIwXcvvq3WCQiyAFY6ZR/ZoV9SpoW2kToHXII+qmMV4dQ8Uv/d+96gCQY7Yeys4Qo2UKMoNyzWY80TkID/Mv1tFtNfbBE8rlTjXARObxHrrQqm1AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879414; c=relaxed/simple;
	bh=wsCffBIZK5prVzeEjaJrdyqCCREHk+YxkG+tkjownr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFLm9KzhVVw7b7u2zLrcG9a7gw2XsT5ieUghw2DIojJGOyAEHB1c9R4+8pUfJY9VqpUSUiGuR6tRRiVRQ2aGVLdNIZahl8RT0UTxqvxFec5RvX10g70TfeZvoMFy+RpUtE+L7JOtA6F9v6A23HtVXMIGUGBUJsyeAGVrM9Jr1xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3CD+pU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3CD+pU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A82C4CEC2;
	Wed,  2 Oct 2024 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879413;
	bh=wsCffBIZK5prVzeEjaJrdyqCCREHk+YxkG+tkjownr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3CD+pU4OutIquuX9zjDnO1Zp5YQdyQz/Nt+XD2XJEKoJeGHfad85mttAjj9b1whO
	 SCdMaJ3LO49VfOlShWGs02azih6HV2ftd7+55U3XXt7St/Dq2nh+B4Ah2VXnfyRYIb
	 Q92kc1UWrMJLQWUgMzDGkz6+K4g+s20OR0KIEWtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/538] ASoC: rt5682s: Return devm_of_clk_add_hw_provider to transfer the error
Date: Wed,  2 Oct 2024 14:55:50 +0200
Message-ID: <20241002125756.617757892@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 3ff810b9bebe5578a245cfa97c252ab602e703f1 ]

Return devm_of_clk_add_hw_provider() in order to transfer the error, if it
fails due to resource allocation failure or device tree clock provider
registration failure.

Fixes: bdd229ab26be ("ASoC: rt5682s: Add driver for ALC5682I-VS codec")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20240717115436.3449492-1-make24@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682s.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index 68ac5ea50396d..92c647d439ec7 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -2828,7 +2828,9 @@ static int rt5682s_register_dai_clks(struct snd_soc_component *component)
 		}
 
 		if (dev->of_node) {
-			devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, dai_clk_hw);
+			ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, dai_clk_hw);
+			if (ret)
+				return ret;
 		} else {
 			ret = devm_clk_hw_register_clkdev(dev, dai_clk_hw,
 							  init.name, dev_name(dev));
-- 
2.43.0



