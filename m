Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622562;
	b=W/8WAEt0Ka643nWT/VP/W+WP3CwF00wwqmFGUm1x9ZROBTuBU3XC/miPfxP4kDQB8bOV
	 6zbT2c2b5pUsSVgk/jsMrRAn/JydmK6GRfsg71QqfMEIBC369LFsYAebpjZxYYFGrz+NS
	 AmIq1x5FLFgDbryF7/Xw4eR7VXscgDvq5+aOez7dsu+9pNPoxEovUi2gPXqeEhJit1OUg
	 cJRXg/nBDEQTxf5FttqTvBPbKkirG8fZDRQ2QJD0rXYgzBlxmgT3h4e77/DsPYgV7rdNY
	 silBR4zypkfJ85PJcaPYwCxi59AEQ2fokFfVi53Z/44Rb7yhmkshDKEhWWuDJvVSjZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=23v1+uRTeAKx5fVEJvt0ZxfFoJ2L+s7rItDEk+kl8h4=;
	b=qMHi/l2M8pA2tdzsM90e8UZYU+IPxAGEWKgb/BPNveqJud0pHo9C74lqbTNd2wDqLcB1
	 4tv6mNk8eMhztojOV3HHA7Nw0I9/URThbahi6cQKfJlZquBmmPqBi7UcKW8zMJdrGOEJV
	 zQudFP3ZbsIFDRRhdlArb6IV4FK2LqNf98DoA6FCRuYoEsosnVbTX9PVlrB//WE9tx/64
	 x4vT+nm3/i6bWV0qfuGWN8mg57F9I8XSRH9EZ+rCT6SPfzARZJDgyykdkU3cf6Cd6WQni
	 wjfYPCWbdA1q5a8y26E6J/kyXyoYxtg4heByd13ikeNsyH71csTqBvSPtPfqEdReMmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bNKjJ/zq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA2A606A32C;
	Wed, 25 Nov 2026 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNKjJ/zq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3707C1F000D2;
	Wed, 25 Nov 2026 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622561;
	bh=23v1+uRTeAKx5fVEJvt0ZxfFoJ2L+s7rItDEk+kl8h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNKjJ/zqxFM34zfKcP4ed1r8mjDsx+TA23Rsetu4LTYAOxw9GfL0CsRT4EgaeNXSw
	 VuuKmO1FCLVIH03kq3fYS+jJAs6rufjBQl7Tq0HZc8c42UpJrkVr35D2d55bssB+Ks
	 P0wgLC9yuGpN/fIAg0RR7HIOuVGG5bTk/L3ccoFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 576/990] ALSA: pcmtest: Fix leak at probe error
Date: Wed, 25 Nov 2026 15:32:23 +0100
Message-ID: <20261125143835.585384891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the deleted snd_pcmtst_create() function in full, including its older kzalloc(sizeof(*pcmtst), GFP_KERNEL) line where upstream had kzalloc_obj(*pcmtst), since the branch lacks that helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 66 +++++++----------------------------------
 1 file changed, 10 insertions(+), 56 deletions(-)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index b63df0623c73f..026bc53211d77 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -465,20 +465,6 @@ static snd_pcm_uframes_t snd_pcmtst_pcm_pointer(struct snd_pcm_substream *substr
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
@@ -582,40 +568,9 @@ static int snd_pcmtst_new_pcm(struct pcmtst *pcmtst)
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
 
@@ -623,10 +578,16 @@ static int pcmtst_probe(struct platform_device *pdev)
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
 
@@ -639,17 +600,11 @@ static int pcmtst_probe(struct platform_device *pdev)
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
@@ -657,7 +612,6 @@ static struct platform_device pcmtst_pdev = {
 
 static struct platform_driver pcmtst_pdrv = {
 	.probe =	pcmtst_probe,
-	.remove =	pdev_remove,
 	.driver =	{
 		.name = "pcmtest",
 	},
-- 
2.53.0



