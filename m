Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826471448EF;
	Thu, 11 Apr 2024 10:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830368; cv=none; b=AZcGVFl5wcdBvr99ufSEcFMZ2ARdGs2YHlXzPbgmX0/C65yt781OT1urhih57oYLgjr4pxTDlC+0ie/3HUcsh36VCO3Oa26+FQKOhDnzZBg4ipXAN5scYnKDbJZoClfGJ1CUDRbZ9QiD/SpEZyeQmrdYVVm79L0CWioGYM0SxMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830368; c=relaxed/simple;
	bh=L/GDP2sWP/lgDKl14jQDRoXnmb41kzcWq+MqK8qUeB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/Q8VAObaPhnqu4WxNm9vP64454bALfjGewB74nCDgSUGpd0/SFqatTUst9iItkG9TrCBRFINH9JZZAUmZRBJoMQyZ7nFozJI+y6iSrYGsqjgVyiOSI3aJ5Jd359Rt5lbE2T/33hP0lljFhMF6YGlNkqN27DbI3hNOnzu4GsMn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAVaS9+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAVaS9+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0720BC433C7;
	Thu, 11 Apr 2024 10:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830368;
	bh=L/GDP2sWP/lgDKl14jQDRoXnmb41kzcWq+MqK8qUeB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAVaS9+OTozlr2AxRfwXsYAXybi9Dlty77/4ivS79ECZHFVXrn44OlT5urAKOx5HM
	 jxOBoSzgaGm2EbHhGs+3KbwScbFlAoMgn13fn2h1h9q/EudAa5d9IC9cLzfEt/5U5t
	 tprK2bHjKid8OB5szMJjEdHCWb5p4T4YsnKuxYMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Wang <zhipeng.wang_1@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 122/143] ASoC: soc-core.c: Skip dummy codec when adding platforms
Date: Thu, 11 Apr 2024 11:56:30 +0200
Message-ID: <20240411095424.578630404@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 23fb6bc2696119391ec3a92ccaffe50e567c515e ]

When pcm_runtime is adding platform components it will scan all
registered components. In case of DPCM FE/BE some DAI links will
configure dummy platform. However both dummy codec and dummy platform
are using "snd-soc-dummy" as component->name. Dummy codec should be
skipped when adding platforms otherwise there'll be overflow and UBSAN
complains.

Reported-by: Zhipeng Wang <zhipeng.wang_1@nxp.com>
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://msgid.link/r/20240305065606.3778642-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 516350533e73f..8b5b583a2bad0 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1218,6 +1218,9 @@ static int snd_soc_add_pcm_runtime(struct snd_soc_card *card,
 			if (!snd_soc_is_matching_component(platform, component))
 				continue;
 
+			if (snd_soc_component_is_dummy(component) && component->num_dai)
+				continue;
+
 			snd_soc_rtd_add_component(rtd, component);
 		}
 	}
-- 
2.43.0



