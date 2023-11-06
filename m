Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440C6241F4
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jhmcxz07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E06C433C9;
	Mon,  6 Nov 2023 13:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277208;
	bh=2roMMTJsmhodd+6zEGxe+kbVB5mKaituLzIxPG+Hitk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jhmcxz07bDZWZo6gT/2H1ovUVnmaNsB1vSFmn+dGGf6Tox6Y8kG44zMApSr6d/NuW
	 jdraYsuNYry0PifegfhEvtvDkA79f90I8YrM9erNnCkMdKB+6wWpvOzZABR77oKpI5
	 gi9j+Cu4zDx7xLfNQx2jALRGmemhSvbvh2BpImLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/128] ASoC: simple-card: fixup asoc_simple_probe() error handling
Date: Mon,  6 Nov 2023 14:03:55 +0100
Message-ID: <20231106130312.543108388@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 41bae58df411f9accf01ea660730649b2fab1dab ]

asoc_simple_probe() is used for both "DT probe" (A) and "platform probe"
(B). It uses "goto err" when error case, but it is not needed for
"platform probe" case (B). Thus it is using "return" directly there.

	static int asoc_simple_probe(...)
	{
 ^		if (...) {
 |			...
(A)			if (ret < 0)
 |				goto err;
 v		} else {
 ^			...
 |			if (ret < 0)
(B)				return -Exxx;
 v		}

		...
 ^		if (ret < 0)
(C)			goto err;
 v		...

	err:
(D)		simple_util_clean_reference(card);

		return ret;
	}

Both case are using (C) part, and it calls (D) when err case.
But (D) will do nothing for (B) case.
Because of these behavior, current code itself is not wrong,
but is confusable, and more, static analyzing tool will warning on
(B) part (should use goto err).

To avoid static analyzing tool warning, this patch uses "goto err"
on (B) part.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87o7hy7mlh.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 283aa21879aa5..95e4c53cd90c7 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -680,10 +680,12 @@ static int asoc_simple_probe(struct platform_device *pdev)
 		struct snd_soc_dai_link *dai_link = priv->dai_link;
 		struct simple_dai_props *dai_props = priv->dai_props;
 
+		ret = -EINVAL;
+
 		cinfo = dev->platform_data;
 		if (!cinfo) {
 			dev_err(dev, "no info for asoc-simple-card\n");
-			return -EINVAL;
+			goto err;
 		}
 
 		if (!cinfo->name ||
@@ -692,7 +694,7 @@ static int asoc_simple_probe(struct platform_device *pdev)
 		    !cinfo->platform ||
 		    !cinfo->cpu_dai.name) {
 			dev_err(dev, "insufficient asoc_simple_card_info settings\n");
-			return -EINVAL;
+			goto err;
 		}
 
 		cpus			= dai_link->cpus;
-- 
2.42.0



