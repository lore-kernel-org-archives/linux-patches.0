Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625437;
	b=gsTIYDU6+b7x6KoC4gM6ALpEULOf2ReYMl3hgLdVvzghL5Fd7I4wH1sMPKTwxw/1Wv4f
	 CVSNPK4mnVkO9ZghIWxzzHt0UIvz4QXeU+qLDJmJHfVed+m3lFQ7K9k1i67ec5Yhu7aFP
	 Yheo6e8xtux2KTH72z6SNmWc5mAYglt3hDstFJJCfA4kVhtr+wW5FOJWLDYzs5lecgiff
	 FLQW5ZuKpbScFyXjI6XKCfxWpsotuA+xv7b6cq2XV/EfFLlEpM3Ae0OC8rqIdhvTGaYVy
	 eGXyuB/ytV170Ecy20mZyfTQ81R4h5UYghOQ7r8r08XHxZRFGpWhrIssFOWl/HmrbCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L1ILNmzk7rxv0QPOJwMmm4Dm/8PBTptJhIbWsS3lrjk=;
	b=GWu7K+t3xAvEtPxqdubx6tRx4qoruKtpCKbmkcrVeYKOLOssn5T7wqLcRslZ+35C4tOC
	 PXsU56IZuIofKPOUcIfytsCzG/eynD06Th8Fvqy3cgBoqVipYZNT046uw0cHAObJ9HStr
	 zX2K8NYurlTqU6ASuYT7cbMz9v4fmKRHiH8ihIFjhzX17prhJWwrr9Vh6HCKlvOeoDTbo
	 U6Y0rQv2EZkvhT/Wszo1ksGZIcZDfonca3ICnV0hEhs04AZ3BKcf0dYhwZoUeGaV5rYLZ
	 4lGOxA2f0qXQBaiHLyFvUk9Rx95dPFkl1Q5oz9r+l9+rsk+DNj+t0aJXiZ65m+32XCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=myme2APg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315B9606A321;
	Wed, 25 Nov 2026 16:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=myme2APg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276D51F000C0;
	Wed, 25 Nov 2026 16:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625436;
	bh=L1ILNmzk7rxv0QPOJwMmm4Dm/8PBTptJhIbWsS3lrjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myme2APgOYLs+1yvVCVVgaajb3OmYgD1oSbrttZfQeFtD7TYxJpwHwBZewLh/OzGH
	 OyTY/OZeYt32RuSP11ZTfAb19QrFfSJ5j2n7dKKCrKz0lLOdXd+/zBavr3TvWaKAvF
	 LkWcTa+YMmHUgQL+4A2s9jam2RwKXkzSj1n/ePcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 471/816] ALSA: pcmtest: Fix leak at probe error
Date: Wed, 25 Nov 2026 15:33:39 +0100
Message-ID: <20261125143900.103273849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context in two hunks (kzalloc vs kzalloc_obj, .remove_new vs .remove), both on lines the patch deletes, so the final code matches upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 66 +++++++----------------------------------
 1 file changed, 10 insertions(+), 56 deletions(-)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index 0376fe17365a8..0e325ae96371f 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -464,20 +464,6 @@ static snd_pcm_uframes_t snd_pcmtst_pcm_pointer(struct snd_pcm_substream *substr
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
@@ -581,40 +567,9 @@ static int snd_pcmtst_new_pcm(struct pcmtst *pcmtst)
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
-	pcmtst = kzalloc(sizeof(*pcmtst), GFP_KERNEL);
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
 
@@ -622,10 +577,16 @@ static int pcmtst_probe(struct platform_device *pdev)
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
 
@@ -638,17 +599,11 @@ static int pcmtst_probe(struct platform_device *pdev)
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
@@ -656,7 +611,6 @@ static struct platform_device pcmtst_pdev = {
 
 static struct platform_driver pcmtst_pdrv = {
 	.probe =	pcmtst_probe,
-	.remove_new =	pdev_remove,
 	.driver =	{
 		.name = "pcmtest",
 	},
-- 
2.53.0



