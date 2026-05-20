Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2BA3DC4DA;
	Wed, 20 May 2026 17:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298163; cv=none; b=FJOMxKlgtBh3Efhm5oa8mYqGwric5zvg6ukfeu9bHtn8OmHUOf8XFe+kFSpAKBlhFmo2u3hHs0+hbr8avqCzWWD2ea8bY9amGR3lnXRDhvXKXp8ZmzHTkM4BHVwqIdN43FQXwQqesuvioaR5Djiz5lw2EpzbyDWPTnnCcDQLwnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298163; c=relaxed/simple;
	bh=GeoO/TStQeKJhMlbAgoMrkwuWgHuNvmn9ZkWx2YLDpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADlgA4wL7Ux06t1lFH1RFtSjU5Poh6plFPZxaDoSHo6zEEA4HfNWNV6hwt3KSd2fVMAeOQdIxM07Z2zSSwTGiqx933DMLLtwMpDgKt4SQ8Soh0ivEr5ETaIHYt/WRYnjryWptJ2QlZAgEQ8P/rSIZ4tzVZWJBXjx7DlSEFVmXv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eClBj7T5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eClBj7T5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4491F000E9;
	Wed, 20 May 2026 17:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298162;
	bh=UwvTyC5N8CPtrYdqc2BV+VjmO1jBWXkZ351g59bqG4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eClBj7T5YEXDqkNxFdFKWIx95MJKgAYqiAqRnIDTioiquFj2ZcWvhByYRkRstKnCo
	 3qORbei3MigM1tWFD3uerOWHmj4n90Yd4JPLlsd0I1WooXTnMHzV2L2qJ1aGZ4Kuwl
	 cU8XRPN2vtpd8X0qWturUH63e0Y0dTW1PF3aG5mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Rastyogin <gerben@altlinux.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 304/957] ASoC: rsnd: Fix potential out-of-bounds access of component_dais[]
Date: Wed, 20 May 2026 18:13:07 +0200
Message-ID: <20260520162141.124480745@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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



