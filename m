Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019241;
	b=mHU4SF/65oFOdn1MY5V4OgTuzd2JkZ6MTQeBDDUtpozL0E6aX6MLWTwXTT4FumtD4nB6
	 b/yOHF+iGsRwWqzNm/kXRHLSz/nPKCA9Qp+caCvcb8Dq7inzCqNLjhEhWcbx0Tz5ieGUP
	 Y3SwR8Ki4IYLXEs9pwefi9A3sGDDKnNOffz9OqkcfwIk2BO26Bls2lJJRPc7KCCtAjEmn
	 ifzVt58GniUa7HxwaLDywSCF5c/+CYD5RtB7/CJvOhyWiSyAOB8m+FESwBUQeblztQ1O8
	 4ZaY9y98mQMuZIOYdsN24Dg7wPtzMSWg2fwgz2hWDiycuLUcrtsOzFNny11nNxwyLgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dVqJgrYzX8+4UE8FkEGXkj8FK9O+MietKEz2bxyqVBs=;
	b=iXKZHCPzS3m0zPnJUCqvauwZCxkCeBnQ5w5Hod6q/J05ucwvyJmuN4pZFDdS7Vai2iLq
	 JxvcVLjJc6P1iRM+PDe8qTPtpcUefgoOvGw1Efd2PEnGZqLW0vmWCQvmrqmbffdYcsuCI
	 BwabTAj+RTl+SglnZzbQtXIw9K1DFNSYlo20WCrkj8MuVKrnU3M6qHRYtmhqH3imswMWw
	 4kYzPDaQv4QxZPjdpuO990syvKXaMVE7Kv3xAqFaJUoKD0Qn+3g2TSqfD9dsST19pkEPO
	 Fd4Azi4W1Xv6a/Ld83IGQiUyJquHOJDJrDTPnfsmgXccoBW1YBz3Uh4D5ZOhpcVTpPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKgjbyUv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4573960A260A;
	Wed, 18 Nov 2026 16:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKgjbyUv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473A21F000C4;
	Wed, 18 Nov 2026 16:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019240;
	bh=dVqJgrYzX8+4UE8FkEGXkj8FK9O+MietKEz2bxyqVBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKgjbyUvofVSCDX6PBwhz7SNwa/gfEhM/iTkZnGI3pZeUO9pgIaQJEqkvOLffamlr
	 uhjiFhb35yShi1izLVaPqCyP8b+4cgGtfwWK3PB825sJHZ8lREzyTDQ97OxPRIm2QB
	 gMKM6gWjqbeSJuBZEyJj7uXRitvOodTArjXhVH5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1524/2651] ALSA: pcmtest: Fix leak at probe error
Date: Wed, 18 Nov 2026 15:46:04 +0100
Message-ID: <20261118150342.859223179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit d0f2ca62e89f3c666d0ec203eaa23b8d965e5443 ]

When an error happens at probe of pcmtest driver before
snd_card_register() succeeds, we have to release the card explicitly,
but it's not done, leading to a potential memory leak.

Also, pcmtest driver manages struct pcmtst object unnecessarily
complicatedly by a dynamic allocation and release.

This patch fixes and cleans up the resource management:
- Use card's private_data allocation for struct sndpcmtst at the card
  creation, which is released automatically together with the card
- Since the allocation of pcmtest is gone, snd_pcmtst_create() is
  rather pointless, so just directly calling snd_pcmtst_new_pcm()
- Use the new auto-clean mechanism to handle the error case at probe.
- Many release handlers became superfluous and dropped

In the end we got a good amount of code reduction.

Fixes: 315a3d57c64c ("ALSA: Implement the new Virtual PCM Test Driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172533.14667-3-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 66 +++++++----------------------------------
 1 file changed, 10 insertions(+), 56 deletions(-)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index fea9580593e66..b4e333b4c4381 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -446,20 +446,6 @@ static snd_pcm_uframes_t snd_pcmtst_pcm_pointer(struct snd_pcm_substream *substr
 	return bytes_to_frames(substream->runtime, v_iter->buf_pos);
 }
 
-static int snd_pcmtst_free(struct pcmtst *pcmtst)
-{
-	if (!pcmtst)
-		return 0;
-	kfree(pcmtst);
-	return 0;
-}
-
-// These callbacks are required, but empty - all freeing occurs in pdev_remove
-static int snd_pcmtst_dev_free(struct snd_device *device)
-{
-	return 0;
-}
-
 static void pcmtst_pdev_release(struct device *dev)
 {
 }
@@ -563,40 +549,9 @@ static int snd_pcmtst_new_pcm(struct pcmtst *pcmtst)
 	return err;
 }
 
-static int snd_pcmtst_create(struct snd_card *card, struct platform_device *pdev,
-			     struct pcmtst **r_pcmtst)
-{
-	struct pcmtst *pcmtst;
-	int err;
-	static const struct snd_device_ops ops = {
-		.dev_free = snd_pcmtst_dev_free,
-	};
-
-	pcmtst = kzalloc_obj(*pcmtst);
-	if (!pcmtst)
-		return -ENOMEM;
-	pcmtst->card = card;
-	pcmtst->pdev = pdev;
-
-	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, pcmtst, &ops);
-	if (err < 0)
-		goto _err_free_chip;
-
-	err = snd_pcmtst_new_pcm(pcmtst);
-	if (err < 0)
-		goto _err_free_chip;
-
-	*r_pcmtst = pcmtst;
-	return 0;
-
-_err_free_chip:
-	snd_pcmtst_free(pcmtst);
-	return err;
-}
-
 static int pcmtst_probe(struct platform_device *pdev)
 {
-	struct snd_card *card;
+	struct snd_card *card __free(snd_card_free) = NULL;
 	struct pcmtst *pcmtst;
 	int err;
 
@@ -604,10 +559,16 @@ static int pcmtst_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	err = snd_devm_card_new(&pdev->dev, index, id, THIS_MODULE, 0, &card);
+	err = snd_devm_card_new(&pdev->dev, index, id, THIS_MODULE,
+				sizeof(*pcmtst), &card);
 	if (err < 0)
 		return err;
-	err = snd_pcmtst_create(card, pdev, &pcmtst);
+
+	pcmtst = card->private_data;
+	pcmtst->card = card;
+	pcmtst->pdev = pdev;
+
+	err = snd_pcmtst_new_pcm(pcmtst);
 	if (err < 0)
 		return err;
 
@@ -620,17 +581,11 @@ static int pcmtst_probe(struct platform_device *pdev)
 		return err;
 
 	platform_set_drvdata(pdev, pcmtst);
+	card = NULL; /* probe succeeded, don't release as error */
 
 	return 0;
 }
 
-static void pdev_remove(struct platform_device *pdev)
-{
-	struct pcmtst *pcmtst = platform_get_drvdata(pdev);
-
-	snd_pcmtst_free(pcmtst);
-}
-
 static struct platform_device pcmtst_pdev = {
 	.name =		"pcmtest",
 	.dev.release =	pcmtst_pdev_release,
@@ -638,7 +593,6 @@ static struct platform_device pcmtst_pdev = {
 
 static struct platform_driver pcmtst_pdrv = {
 	.probe =	pcmtst_probe,
-	.remove =	pdev_remove,
 	.driver =	{
 		.name = "pcmtest",
 	},
-- 
2.53.0



