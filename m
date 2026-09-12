Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3C923BD03;
	Sat, 12 Sep 2026 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226225; cv=none; b=WDAsIvve7kysqrDNwe0pvmwiFSp5kgLT/qgfsQ0j4mc8gssfsRT0cxG6pyw1qXF5F58BfMfeb1gPNd2YFOkScjC0cduR+0Tf1cK4z0WM95JXDwpQcAD9gKgnoCJj1ujUahUfpXoUqBrxeYGPE1MtEWMosy8iEoirkBtBQWfnApc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226225; c=relaxed/simple;
	bh=1ijFCh0dxx7R7EFwrhh2RnMesJ7Cnjtfp3i5jo3adUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLrTFNzl7o0gmejl0O7Cznu7lzoP1yorzWXOchfCmthRbEAMwMK60hgaEWTIiIRfzvexubtHYqD/+5u/PH0THUoTU3x4dLcIwQuW0Fn97rwnHXDCzGbOdzHHLdiqNLw4UKKvZIuySWXmCjqs4jTMrIWhY3lxndNkvJwUtU4tdcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLcDmlPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLcDmlPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E361E1F00893;
	Sat, 12 Sep 2026 15:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226223;
	bh=an9+c4DUlPRaWdcw3B0Z2C3W1P+gxCavz7azOk3/C70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLcDmlPkohcgJGNFo4qKxCrMeC+He52xO6N8aClPBGOPx+SKhVB1MqgCgJY6E4OWK
	 ly/YG9Cm63KSkq9b5eXF6Q4VA0UNHycl3s3GOcT6LhZTnSW6L7e0MbMK259E4Pn+GK
	 poCUhLQWiJQCxtsKgOt9bcl6Z3WRhvVaHVrDk6KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1322/1424] ALSA: ice1712: Fix the card leak at probe error with the auto-cleanup
Date: Sat, 12 Sep 2026 09:02:34 +0200
Message-ID: <20260912065636.866344045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



