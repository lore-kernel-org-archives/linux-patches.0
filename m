Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC66617A30A;
	Sat, 12 Sep 2026 13:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218919; cv=none; b=iBcMMsVcP6MNNII7BaCTf8tNLDlomuY3MjodDFR+bcWEGbw50cZZevnLy24hYts5zGE0fjSUMN2ei/6g5Uv9VwSWlLcF8JFlzopllwke3isQosUeaxklak9GG47icM0Wjo2GexZIqtht4zVgsm1LvMbFKvMxhofCOzs9Rj9P7oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218919; c=relaxed/simple;
	bh=2iwSU6t7T7nwcm+2gLUa4hYuz4F/Ocjz57qzEiD6zE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVMLjUAbjXtRUD+HWyaa4OegSLvdkVOe1W9xqb4d4Xduj+zQH7/FnPK/CjsqxR2KrUzN9vDv8+XBIJiRIE6oUSt5NlRSo8njVKXrmZyn2S766msaxXFyXwUY3jYN+jIuQ3LdTDMsEuQ4LupQEp0BrfCxsEHcPXuVp+SQ8DDWT5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uB5MgbdN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uB5MgbdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081E01F000FF;
	Sat, 12 Sep 2026 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218917;
	bh=GmO6oW90G+e1kV3Iul5tdhqkLdDKYdNI1H/M0sHgZDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uB5MgbdNF9uSUhiphxDIZ6inU3qgHSSnvBPnVtPVu8ueyIiES7YoH+H7LgXl7c/OV
	 GFc2mjKIq+NT1VK4jJg5RVLsEqFhk0eH82VMDCUbBhvm8nyAkztvWFFH7ZJgS/jfLK
	 RvXScDOshFDE7zY96nBdDgXHrpahNsegrsTChVww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1242/1376] ALSA: ice1712: Fix the card leak at probe error with the auto-cleanup
Date: Sat, 12 Sep 2026 09:01:08 +0200
Message-ID: <20260912065635.226212393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit d736eba9c453fedce664fdf592c8b71ecff1932b ]

snd_ice1712_probe() performs multiple initialization steps after
snd_card_new(), but directly returns on failures from later steps
without releasing the ALSA card, causing resource leaks when
probing fails.

Use snd_devm_card_new() together with scope-based cleanup
via __free(snd_card_unref), and clear the card pointer after
successful registration to keep it alive.

Fixes: ca642da4b33d ("ALSA: ice1712: Allocate resources with device-managed APIs")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260820014117.14044-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ice1712/ice1712.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index ad21806591875..45cb3e7b8d214 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2549,7 +2549,7 @@ static int snd_ice1712_probe(struct pci_dev *pci,
 			     const struct pci_device_id *pci_id)
 {
 	static int dev;
-	struct snd_card *card;
+	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_ice1712 *ice;
 	int pcm_dev = 0, err;
 	const struct snd_ice1712_card_info * const *tbl, *c;
@@ -2561,8 +2561,8 @@ static int snd_ice1712_probe(struct pci_dev *pci,
 		return -ENOENT;
 	}
 
-	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
-			   sizeof(*ice), &card);
+	err = snd_devm_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
+				sizeof(*ice), &card);
 	if (err < 0)
 		return err;
 	ice = card->private_data;
@@ -2666,6 +2666,7 @@ static int snd_ice1712_probe(struct pci_dev *pci,
 	if (err < 0)
 		return err;
 	pci_set_drvdata(pci, card);
+	card = NULL; /* probe succeeded, don't release as error */
 	dev++;
 	return 0;
 }
-- 
2.53.0



