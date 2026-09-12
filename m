Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B87372ED0;
	Sat, 12 Sep 2026 18:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238937; cv=none; b=VeoRr3QX/ZD0ybApy/tKQp9DI6HQXjG/JdfzNh6xnhHlDtBqYwx8wx2d1SdUSDtjkGvMUgpNASEtsb50Ok2/2afrtTjxzx8lgTMIOKqUSAYWxVniP+IUoyG5mjKFRc9WLOqpS4dP95B7++DfKOhbusmJhpyzeckOTbE84WlPPBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238937; c=relaxed/simple;
	bh=92p0oeHvW5EfDTbIqNHXFjNeaqxHv/KRbTfNPelY+Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMeWL8iNQhGbefs0lPADxtaOQYduMxpwpAbT1a6nJlJ/Vjb87aJUaUS6w+Eq7ErmU4cUacXRRD1C2otsKWoGnCXfhfg1NAcN28jzzfZlajMv3RzN6NkWNFLsCZMaXWopA1scJq2eIeH+E6Otwh6bkaXXQa7xeEiH9XepxTuo/gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjsreQFo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjsreQFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233081F000FF;
	Sat, 12 Sep 2026 18:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238936;
	bh=mpOv1y2bIzhuGPcVlog3qm7x4HnvoA7szkCiPswS41s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjsreQFoYcfGx7yB40xPxDFBgfxLGlRotcT4wcTFS7alQVlOgkwS4rT0gI3DGD8on
	 Sg6lXFTFqw3i2e/L56OtEQ5gKCthyaGkk56ctrgOybbaYBRYegWFvFWMjLgaRWCTGB
	 UerRqC/Pvqrv79mVLa1b4M8+9VDfl/cwZKhmLEBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 563/935] ASoC: meson: Keep link pointers valid on realloc failure
Date: Sat, 12 Sep 2026 08:59:53 +0200
Message-ID: <20260912065539.745881312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 2aaa41cf974f83a6fb105422bac4e2f107150774 ]

meson_card_reallocate_links() grows the DAI link and private data
arrays with two consecutive krealloc() calls and updates the owner
pointers only after both calls have succeeded.

A successful krealloc() may move the data: it frees the old block and
returns a new one. When that happens for the link array and the second
krealloc() then fails, card->dai_link still points to the block that
krealloc() already freed, and the error path frees the new block too.
The probe error path then calls meson_card_clean_references(), which
dereferences card->dai_link and kfree()s it again, resulting in a
use-after-free and a double free.

Commit card->dai_link and card->num_links right after the first
krealloc() succeeds, so the pointer always refers to a valid allocation
that meson_card_clean_references() can walk and free. krealloc() with
__GFP_ZERO zero-initializes the added entries, so walking them on the
error path is safe. With both failure paths reduced to a plain return,
drop the goto labels and the error message.

Fixes: 7864a79f37b5 ("ASoC: meson: add axg sound card support")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20260717012433.1432285-1-lilinmao@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/meson-card-utils.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/sound/soc/meson/meson-card-utils.c b/sound/soc/meson/meson-card-utils.c
index 7e236c3ebfab4..e3cb363bb05a3 100644
--- a/sound/soc/meson/meson-card-utils.c
+++ b/sound/soc/meson/meson-card-utils.c
@@ -50,25 +50,20 @@ int meson_card_reallocate_links(struct snd_soc_card *card,
 			 num_links * sizeof(*priv->card.dai_link),
 			 GFP_KERNEL | __GFP_ZERO);
 	if (!links)
-		goto err_links;
+		return -ENOMEM;
+
+	priv->card.dai_link = links;
+	priv->card.num_links = num_links;
 
 	ldata = krealloc(priv->link_data,
 			 num_links * sizeof(*priv->link_data),
 			 GFP_KERNEL | __GFP_ZERO);
+	/* meson_card_clean_references() will free the links on this error path */
 	if (!ldata)
-		goto err_ldata;
+		return -ENOMEM;
 
-	priv->card.dai_link = links;
 	priv->link_data = ldata;
-	priv->card.num_links = num_links;
 	return 0;
-
-err_ldata:
-	kfree(links);
-err_links:
-	dev_err(priv->card.dev, "failed to allocate links\n");
-	return -ENOMEM;
-
 }
 EXPORT_SYMBOL_GPL(meson_card_reallocate_links);
 
-- 
2.53.0



