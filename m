Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B574234752E;
	Sat, 12 Sep 2026 11:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211861; cv=none; b=HBS1yGAE3arPzIy8ggufUlAs+d1mb1nJ8WSsWowAWCDI541Xns96b/476DUN4Ks7NUJvw2ljjsaRiFNd6qUPKamGh5qND9eX3LXYEoNfLsf0noVz3MEyvYHGdMdVrEbAL+vFT6fpYkf1Z75TRWaYrFPUKwTL2eq7OugikWVxGJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211861; c=relaxed/simple;
	bh=AWZJJXuyaVRihTv2VL6PDrhYxiSt9SnYiK/aaX3FAuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enbqbm0WJHQwFRsV1rodxS7+iiLHVmx9xNDbjz89OtbnVV+qxWkvGZ1vDpBGpV/KKtq2nrbmVzuDLS9b05mRDklRmV7qqvZzGM8BPvVNXZF2P+AKD4ej/XI0ZXGpKJm3Q9q+UhwCg0gq2mGYFc999SCnNmQaCQQtYoDbFJ4ISpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhfLJZcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhfLJZcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652941F000FF;
	Sat, 12 Sep 2026 11:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211860;
	bh=A4G0I7BoE6TrqItuanCEwzW9ppHZxNX5PEJeLHvIgkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nhfLJZcAxoj/bopO8MqOfJbBshDzxy4vvnrsTS8eUeVARovMisr0Pgssd/WZ378yI
	 KBpwJTuLByj+zPhw75qvndJxjrL5eV7j/YtmEEhpg/gMexA+FoYovF9ZEKFrKkAIqJ
	 t+DoTXmGHArtb/nNnhTYB1lSDSGZGtVA/2xsxvzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1317/1518] ALSA: ice1712: Fix the card leak at probe error with the auto-cleanup
Date: Sat, 12 Sep 2026 08:58:06 +0200
Message-ID: <20260912065653.321401128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 4cec56769c0f6..e20f6bfcbdb87 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2523,7 +2523,7 @@ static int snd_ice1712_probe(struct pci_dev *pci,
 			     const struct pci_device_id *pci_id)
 {
 	static int dev;
-	struct snd_card *card;
+	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_ice1712 *ice;
 	int pcm_dev = 0, err;
 	const struct snd_ice1712_card_info * const *tbl, *c;
@@ -2535,8 +2535,8 @@ static int snd_ice1712_probe(struct pci_dev *pci,
 		return -ENOENT;
 	}
 
-	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
-			   sizeof(*ice), &card);
+	err = snd_devm_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
+				sizeof(*ice), &card);
 	if (err < 0)
 		return err;
 	ice = card->private_data;
@@ -2640,6 +2640,7 @@ static int snd_ice1712_probe(struct pci_dev *pci,
 	if (err < 0)
 		return err;
 	pci_set_drvdata(pci, card);
+	card = NULL; /* probe succeeded, don't release as error */
 	dev++;
 	return 0;
 }
-- 
2.53.0



