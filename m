Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F6F50B419;
	Wed, 30 Sep 2026 15:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782625; cv=none; b=p4E1WcQONfNC6N1E0wggrFCdqUVEDGvy6Y7EWXIdBRhx83DdaRnQtEHfoNdVcauZU3CdVu8qvjatA+67xvMLcmpN5W7ylkaBGkcwFIy0R8xX7me0jDFCdiat8mhQsKC2aBj+SliVjnge2n5mCWr3dWAh8en453go7MIEy5DqJGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782625; c=relaxed/simple;
	bh=HyUPRYqPIxoSbjN3YyN6gvSMZNREAiQFt1ROPrUoPFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNsDN2Pu3hgDzkw2sOSmRdNBJFUvm4Btepugw2D3+5oh3d09izjhJNRDBtINBQRjk3G2LqujakBiZ0JhmHuUkJTAwZGmYOk/ubd99DLD/5EmWCKmxbPuWXcvK/9TLk6hGbt3sc/bAr+fAxVcjurm1Mtlpe3k+7Bhs0YdVBmWlr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eK2UmyVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eK2UmyVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AEC1F0089A;
	Wed, 30 Sep 2026 15:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782612;
	bh=VW+c0qaVmIioldz95IzirxhiYZlOORZ0L/SheQDqDEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eK2UmyVPHz0Np84BMaB8TgYv2zYxHdZmJzDcMLXQbcFHhCm6taSMTGTLN+WWGPmLI
	 eGACJCK4Redww3Pl5BfX95/uv4fQ0i6QJxVddyuONUmh+4jEhhflPvHQ8RFXrLS8Mz
	 BUXHN4M658Zr4CoSeqbo0J++T/+SoeWoS0VehBXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/595] ALSA: es18xx: check control allocation before private data setup
Date: Wed, 30 Sep 2026 17:19:59 +0200
Message-ID: <20260930152350.019717637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5f8d7e8a54775..3780460fc8f37 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1820,6 +1820,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
 	for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_base_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es18xx_base_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		if (chip->caps & ES18XX_HWV) {
 			switch (idx) {
 			case 0:
@@ -1874,6 +1876,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
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



