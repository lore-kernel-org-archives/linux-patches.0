Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52234F5E0;
	Wed, 20 May 2026 18:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300564; cv=none; b=KiUEtWd0XD6d/sMmLxNGzaIbObimnqhbnJfuxL8SJrZuuxgcT8bCn+cLjS9W7lf+VjvP4dMXZpah6Ktw73v+Y6kA1uHD/9YrJ2/xjQqhsfONFJtKtKhEpduMKnTRcPwJ6PqKYRye4XR1GWv5cL7ZzipmC9xzNeBrKL0Opm39ojw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300564; c=relaxed/simple;
	bh=3RjFNUQ/RtVaANpDfRGIv4M8PtQRC2xVtTN62q0lQwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/+uzeHBf7crsk3liAnFyPoQsRTZl9mytC7nb9YhY/Bn5DkgtsSxWZKTYiBVgB7ffNqk8U4ON0mIC6e4JmD9kBKcsxIyfTz7vCpf2XZye69ts2oLmVk3dBoF0FXVfNuLNwgcIBboROlaSaJB7dkKdkffzWLj88d2itRXc13uscA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wes2YziZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wes2YziZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F6D1F000E9;
	Wed, 20 May 2026 18:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300562;
	bh=IxZjXlSjdmpIqrcVU+yG1fWumzIiCmNBuiFuuQgDNSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wes2YziZ41v3ajpARsJImVIg7k6cM8oeyvLONVD+Iv5Gidnb9H2xO0izFGS+CtaQM
	 9eDtm+7SYS6FfLh2R5/gexOc5CNlDxQOkly16QPJc2rKORs61ifOnBqXWGfsEm8yU8
	 NQcQpvzG6QWGdwhAVVgiIFMbLmBzhNhJB47Aixhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Rastyogin <gerben@altlinux.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/666] ASoC: rsnd: Fix potential out-of-bounds access of component_dais[]
Date: Wed, 20 May 2026 18:17:14 +0200
Message-ID: <20260520162116.045996272@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e3ef9104b411c..c1d5f9b4d9342 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -1978,7 +1978,7 @@ static int rsnd_probe(struct platform_device *pdev)
 	 *	asoc register
 	 */
 	ci = 0;
-	for (i = 0; priv->component_dais[i] > 0; i++) {
+	for (i = 0; i < RSND_MAX_COMPONENT && priv->component_dais[i] > 0; i++) {
 		int nr = priv->component_dais[i];
 
 		ret = devm_snd_soc_register_component(dev, &rsnd_soc_component,
-- 
2.53.0



