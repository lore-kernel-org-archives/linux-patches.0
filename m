Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3DC331A41;
	Wed, 20 May 2026 18:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302126; cv=none; b=PN4Cm+w42tDn+FzdoNVq6oTMSW7//qxDvUDqPGOUL8qONX9C5qUWZhDV2jBsTpk1cHdH41N2TeK+OT7WY9loBcwKmCn3vAq/4SIoLRKxOMK38iK39S1OcTMviP+XChCtXfnsYua1sF3yuyXvVkJpN5nrdFJJchWfElfV/WcFkts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302126; c=relaxed/simple;
	bh=60VGjSFeVR/Fw3uJEaERG5fQ/TUbUo4335PAaBI5K5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQkohXrUO9lkguyhoaUZlCDTPcll5fo8MNf31RT0pSFpxoRLRpfPO2BSxYlmGLvbg4fqeFTpayUkp2C27kyuaulBuR9838TzoDyZczVO+XH7jRq8GZNd84iWcEnA88qP2RvCnXN7hhbT1bqmmzzB3gOprZ6IM0KDSMV3Btph3Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJ7egtOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJ7egtOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B381F000E9;
	Wed, 20 May 2026 18:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302125;
	bh=N11CdETJ0bsK5WH/2zu0CHSOoboLzPJ0TqQ+MZs67mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJ7egtOeU1Q6OCe1SQRi3DV2yy0XwK1euDRyTvxBgk83O31WusHZmuzgcpYdOROLt
	 gfzohaDt2+RtllPSuBdb2enWHML8EtOkAl1olLPdfNCSdXjvsW4mJ6jiPt96/yXy89
	 kV3yEtT1ikGDRFzn9jJ/dBlt7RxAnPM3CxFJDsMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Rastyogin <gerben@altlinux.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/508] ASoC: rsnd: Fix potential out-of-bounds access of component_dais[]
Date: Wed, 20 May 2026 18:19:31 +0200
Message-ID: <20260520162101.843188819@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Rastyogin <gerben@altlinux.org>

[ Upstream commit f9e437cddf6cf9e603bdaefe148c1f4792aaf39c ]

component_dais[RSND_MAX_COMPONENT] is initially zero-initialized
and later populated in rsnd_dai_of_node(). However, the existing boundary check:
  if (i >= RSND_MAX_COMPONENT)

does not guarantee that the last valid element remains zero. As a result,
the loop can rely on component_dais[RSND_MAX_COMPONENT] being zero,
which may lead to an out-of-bounds access.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 547b02f74e4a ("ASoC: rsnd: enable multi Component support for Audio Graph Card/Card2")
Signed-off-by: Denis Rastyogin <gerben@altlinux.org>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20260327103311.459239-1-gerben@altlinux.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index 3cd14fbca28ea..68f91fc543493 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -1995,7 +1995,7 @@ static int rsnd_probe(struct platform_device *pdev)
 	 *	asoc register
 	 */
 	ci = 0;
-	for (i = 0; priv->component_dais[i] > 0; i++) {
+	for (i = 0; i < RSND_MAX_COMPONENT && priv->component_dais[i] > 0; i++) {
 		int nr = priv->component_dais[i];
 
 		ret = devm_snd_soc_register_component(dev, &rsnd_soc_component,
-- 
2.53.0



