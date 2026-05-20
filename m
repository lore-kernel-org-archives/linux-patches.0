Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21577370AE5;
	Wed, 20 May 2026 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295470; cv=none; b=NYbZVbeWLTIXItCgResQcWQ1rnA3IlOTtHHmnEOUX2Rnf8N6DOHFqQBGua31gSDAtOZcMpqe2eUXLJz76HCb+yjKOcfUlbnf/+sOx65rTG7MhVlZO18GdxEfFCdPp/wHkxkkKPMDz4TS5Bym1SCw9SELPhW3NWKqS9ix1yLzh+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295470; c=relaxed/simple;
	bh=OK3KRorpkksQ03t2Ahz0wQetQBy+A+vs+pdFJAnjPyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMmOsUjRq+iEZdy0pWZcgXmP+CnuaVPvynwDhWYOhnLH39+5C6ZdQPPJkWx9u1FLzdvdLH7TeizLyZDpC8jQAx+CxfwbZMBZzOj1LoguvozA4Z+WdMdUVhDJeytJJER0fverYCLYegAbuXb3rOfuBx1R2xCuOEs8/1LYUMsMYwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfBtwzdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfBtwzdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F081F000E9;
	Wed, 20 May 2026 16:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295469;
	bh=q7vGZ3xK6AEr0GDEFMdP3LoTOGMcVs7R3c0aN5/b0RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfBtwzdq69cr5icJfplgKK1JqtXvkQXus8odiy3Bv1d1uYPR/lvot/tTr3jvfUfMg
	 PoQ3Uyi8CVXb+qSsRkUeIVSx+WzYfsWCo++ypZq1pPi5oYcavgVYnnlVRKzhMA6ZLp
	 z1juQRkHW1wFRULiW1qfx4pnjMDgjigxmoNSwOgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Rastyogin <gerben@altlinux.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0391/1146] ASoC: rsnd: Fix potential out-of-bounds access of component_dais[]
Date: Wed, 20 May 2026 18:10:41 +0200
Message-ID: <20260520162157.048169368@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 sound/soc/renesas/rcar/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/renesas/rcar/core.c b/sound/soc/renesas/rcar/core.c
index 69fb19964a71d..2dc078358612d 100644
--- a/sound/soc/renesas/rcar/core.c
+++ b/sound/soc/renesas/rcar/core.c
@@ -1974,7 +1974,7 @@ static int rsnd_probe(struct platform_device *pdev)
 	 *	asoc register
 	 */
 	ci = 0;
-	for (i = 0; priv->component_dais[i] > 0; i++) {
+	for (i = 0; i < RSND_MAX_COMPONENT && priv->component_dais[i] > 0; i++) {
 		int nr = priv->component_dais[i];
 
 		ret = devm_snd_soc_register_component(dev, &rsnd_soc_component,
-- 
2.53.0



