Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE34D1A5BBC;
	Tue, 26 Aug 2025 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212919; cv=none; b=Upp+Fa05SVgPVLnvcO81wDfR23Dgrq5lCrIosnzhgBAw+uzVQmKOjNXoiqti9PuEKacWA1iv02Qj0VuGfmqvNf3IMBhQ0jvNJ4yC13B1tJ522d7J9eQvIkUaSiNBGA3BxyLWhjkOBhgXYK8bDXRgUviAM/bHq2DdUvuGHNeAmT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212919; c=relaxed/simple;
	bh=l66oGZdqiTcOQ2L/hTGaEIz+itd2O7u2VEMPIvU/SKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQAEu9oB7md02WYlSFKQsERZe5gh/BbGOiSPmwDlN0Tu+m4IWaxDXTGdk4F2dlAHAEwaamdPPTk3/UMLH9La64Izih2ADPRAAWByTUSd1JUBZ0gH31DmwQZiQhjhH3NMEz6/whOVngNlP5twfnAbTgDFzKI30WL16Lj8jrI909Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwtO557l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwtO557l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C9FC4CEF1;
	Tue, 26 Aug 2025 12:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212917;
	bh=l66oGZdqiTcOQ2L/hTGaEIz+itd2O7u2VEMPIvU/SKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwtO557lYjiB5bNDif5hg9j2pTlcC0gHA5o/XtQX4gzHG3i7f4Bd15MCO0H+3Kro0
	 r3GO1v/XqTalsP4EPwqQq7Lq9CRBu/5XvvUUjGlA2CRCSQa7dN2u7CX0ZN9ZXaJZlu
	 WV5AdTP0svmC8TSIJAohq1IZ293O/iBeq3wRIU3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/587] ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4
Date: Tue, 26 Aug 2025 13:04:33 +0200
Message-ID: <20250826110956.109680727@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 87aafc8580acf87fcaf1a7e30ed858d8c8d37d81 ]

code mistakenly used a hardcoded index (codec[1]) instead of
iterating, over the codec array using the loop variable i.
Use codec[i] instead of codec[1] to match the loop iteration.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250621185233.4081094-1-alok.a.tiwari@oracle.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/intel8x0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index ae285c0a629c..f3df6fe2b7f1 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2252,7 +2252,7 @@ static int snd_intel8x0_mixer(struct intel8x0 *chip, int ac97_clock,
 			tmp |= chip->ac97_sdin[0] << ICH_DI1L_SHIFT;
 			for (i = 1; i < 4; i++) {
 				if (pcm->r[0].codec[i]) {
-					tmp |= chip->ac97_sdin[pcm->r[0].codec[1]->num] << ICH_DI2L_SHIFT;
+					tmp |= chip->ac97_sdin[pcm->r[0].codec[i]->num] << ICH_DI2L_SHIFT;
 					break;
 				}
 			}
-- 
2.39.5



