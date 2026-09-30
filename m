Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3620037AA95;
	Wed, 30 Sep 2026 18:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794369; cv=none; b=HgQxAVAOWPHmNeX/6u8WZHiCj2XP4J+qYB50Bt4AwxYLWpEKBVG8pOdEs4yWgJ5054oKp9Stb7MjLVNJXsmGMlfZA+UHnEOf8To8lAT/JV4cjPlh1D14ibLU1czi2c58BYLVvI74P4EZpdGaKTA9uHtKTud/PXOGh+Adt1boH/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794369; c=relaxed/simple;
	bh=qgkxOj+PdKAY4aGE9s0gpLU3LNtKjqVaM8U6d2ZJTGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8MG7AZDnXZqApWpbRZ27IrR7B+138VFj6xrt6iuJg0tXo6AeVfXJyaUYZjCicmPWpWFcVbqADtNwR9Yxkc5uDiKZVNli/FhUnUGvTksMn2M+3dRLQX8FTCF54KPjpihLMR+sWfNCdZtCngIlDgwCWzQLf9BuctBiu5dMPUril4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4Did8sb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4Did8sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444E41F0089A;
	Wed, 30 Sep 2026 18:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794367;
	bh=gES85f5FbFq5yRR4t82/rh4F4Tm582vWmPUVh999KjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4Did8sb4vqABlbsqnjS5DcqcMDYUYutaPld4EZLzQ3Xzsa2pPCc74tt+jilDC8ad
	 w5ib0m3cvrnzjeVvS5/RGW85uPvEEbi1jurhdVZn5qEQXS8caPEDCrF3W2vp5hcf7X
	 kt/tTii6OIEZJn2kA0vXo3GdaCb9JNCdgG1Wh9E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0185/1193] ALSA: es18xx: check control allocation before private data setup
Date: Wed, 30 Sep 2026 17:14:29 +0200
Message-ID: <20260930152438.304462448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 0a32845b1017a..1d21c24c9e20d 100644
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



