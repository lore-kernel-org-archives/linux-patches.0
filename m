Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9724F85C5;
	Thu, 17 Sep 2026 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667885; cv=none; b=rOxE4CJUuRhJhfEmDCCRGqc7F+D5NVS2u2dVBJpF2R00KyUUNxI+xER7IHE14iJ6iOtr43AoM/CBKtyRqeAJ3GbPbuQwjdP1f+rPlqs6FapxEROAvvsd1xrRsEpZ8vYgM/z1Z/WZxg6cauTTdZeYCb9Et2w6sZUxfiUtwu9wypk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667885; c=relaxed/simple;
	bh=fa3cdVOco8UxYLMRgyonOLA1tna9LOpRQz/HlyKCfnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqg7jq2e0YWmOd0NI9PbOF6hB20hLWveQ7BY/lERpG4DAwm+J/eWMt5a5Mg6Q0/7ZfdByg1wcH6MVATvxEQtMIVOSbq4ObPtf1DEnN0mWJlQcqU1FrcXFaIDOSxHkv+8oSZC8VuAiDET63PXK8UnPTj67rjWIDelyIkmnPUsOvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/VMqKLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/VMqKLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46FB1F000FF;
	Thu, 17 Sep 2026 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667884;
	bh=+MmPDdTLmRFSBxp+s/5CdRElooBddrxxuegFrtAcvpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/VMqKLr8d3mHohZJgUr1ctIk7c195CMfwnjpWS1wMTZXo+gJugYpxoru7KDoagWE
	 /44fywzjXnImJBZxGTdyZE/S3GWWgRVgVNY8uG7ebdlMzpNoRkg0n77TX+STcZydoA
	 j44dkIFdpROYUaQe+O675CIcwTAUvIlJdcgmGIso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0240/1102] ALSA: es18xx: check control allocation before private data setup
Date: Thu, 17 Sep 2026 16:03:03 +0100
Message-ID: <20260917151545.617070835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 422e42b7c2b882ba1d16d4afc8891bcea7c4de93 ]

snd_es18xx_mixer() creates controls with snd_ctl_new1() and then stores
bookkeeping pointers or sets private_free before calling snd_ctl_add().
snd_ctl_new1() can return NULL on allocation failure, so those writes
can dereference a NULL control pointer.

Check the returned control pointers before using them and return -ENOMEM
on allocation failure.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260607074219.3-1-ruoyuw560@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/es18xx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 59c784a70ac1a..e660e7db8a5c2 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1776,6 +1776,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
 	for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_base_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es18xx_base_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		if (chip->caps & ES18XX_HWV) {
 			switch (idx) {
 			case 0:
@@ -1837,6 +1839,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
 		for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_hw_volume_controls); idx++) {
 			struct snd_kcontrol *kctl;
 			kctl = snd_ctl_new1(&snd_es18xx_hw_volume_controls[idx], chip);
+			if (!kctl)
+				return -ENOMEM;
 			if (idx == 0)
 				chip->hw_volume = kctl;
 			else
-- 
2.53.0



