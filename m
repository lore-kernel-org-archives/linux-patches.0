Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F2136728D;
	Sat, 12 Sep 2026 09:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204843; cv=none; b=bEjq3VAZRzCs/HBTaIWX36HaRjTLCxfbH7A01I3nh8MTXFp77CMnbG8skDAmOaqLg6FXBx63Fd0AQNH1p8X1Z/It6lhE+EdrBkFQI/5tjkQMF7oQr4G09Px5rl4/RWCfqGmAUKzo7ta7evtclZhCqzYqHR1ByuZwcXD6NWb8utg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204843; c=relaxed/simple;
	bh=Rp3y59ym4PtAcsqSsVt3XRg2ywAZxRQe2lOFxTVH3Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4j0wNVcfDwtzgrCl40ywbb3QeAfZf1U+zqeMAPKj3Z39OVepP8fM1tH6vj0nlF4ve3K+UbhSMId0LNKgdtNbdSpGRzxT/meGX8GdKS0Nwf1sOMFcH4oONkPcsIRumc3zMdk4DR/JY3J0O0FHbnNtUnS5Q3HX4XwMwEjYs5W8kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPlJp8el; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPlJp8el"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723F01F000FF;
	Sat, 12 Sep 2026 09:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204842;
	bh=Gg8rjd3NvbZIjunkW7mT0SXpB99XVLTFSgQ2pWW/JJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPlJp8el6q7q7T2pcY38tlqCBxNpTCUNZ+sjKU5lYJp9lowqn1f9QIQoMohoGDTQg
	 AML2C7IrpQXi6Es7RBbpHu9p/sZxKUyP+owP7XerviPwn2+cj6HLRjRn9yRlDti3iM
	 IsCRyKY98CVX6gFMsKInh4BF6Ywq1oDPPlrI/o0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1653/1815] ALSA: ice1712: Fix the card leak at probe error with the auto-cleanup
Date: Sat, 12 Sep 2026 08:56:43 +0200
Message-ID: <20260912065727.800727768@linuxfoundation.org>
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
index 7d1a357ed90dc..d6bfd8fb20e65 100644
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



