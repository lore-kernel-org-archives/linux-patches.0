Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CD6384CE9;
	Sat, 12 Sep 2026 07:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199196; cv=none; b=iy84Thr2l0bVEpK7QcDPaRdcoLgIbVlmJHP0dIJUp2PtV2vEK3C1ALBLMs93f/1IBpqQiTulxSnKeRPLUtx4p4nUnzbU6vEQWWodlC+wVN6bspExqqGbr3sJ/ZjquZ0M0wGpbMNaMrv1xzT7F1I+J2Az106g63H0nvM0N+OZUGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199196; c=relaxed/simple;
	bh=f7hUBYErqlbwwpc4JtsDkvLcjQzhgQkMV2OFTmxL46c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bm9ziB8ID2FO1/P/In3PUseAQumYgyYRtHc1em67Eq3lu5LRkJm6xXXHbk4EGDEA7Pqr6GuQvW1e41Aw5uZopSM3qN/j3nwr4n/IABUe4u8w/PAFonARe4jfsd/ZzsMMcvigqDJxBdtGSrTlv4AEONsPK9sgi2mHNCQt/W8+U7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEQKV6oG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEQKV6oG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2917C1F00893;
	Sat, 12 Sep 2026 07:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199193;
	bh=SrK4gNJTgVW0hXe3ctTPIro/8sMX3E+qjtkeEORMTbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEQKV6oGAJmOJBHtsTyqP2bA+aWITWXBmJhYzZ37tEARD9Z+1Togs50QSlr2p5IrR
	 /jmIz/Myiy6x4KRtLrvRY+UMvKZDjjMPVswsHKHqzmznzhnIYz61okoL9+W+tFfJiT
	 SwEAgAK5SJqINePh6V0ASM7Vny3jVnoywYpomYTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0534/1815] ASoC: meson: Keep link pointers valid on realloc failure
Date: Sat, 12 Sep 2026 08:38:04 +0200
Message-ID: <20260912065701.414490993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index cdb759b466ad4..8617a4661a339 100644
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



