Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D4FBE46;
	Tue,  8 Jul 2025 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993584; cv=none; b=nvu/97scWoOQyjtb3sfrHgBMN3WhUF7DejdUpCG+LLamQo018ID30rAvqR4BuuSobPKe+deaLQh50we0mIjGN0tWaf1AM1JxSntcC1zcFvqZ/vpzyHopI8wNr+/s/X+r1C5TloATXuMkEvoBbjUo02Jq0l8v98Ed7j0kd1SIhKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993584; c=relaxed/simple;
	bh=PAQp2aljDE8rkAuSoGbIwBfY7I3mHc/PDxkireKZglE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIsvzuik32vKbasDf+xllr3jrBBL4NFN0YUGH1WelPdxpAaZEmQHVTtn3FNGyjLG5bzEuw9PQTs3zvouJya9aYdW9aKDxPerfpU6pyYGHAK5avwHB8s09zn2AuFF5GT7L4+KMVKIATFkZNszSQ3pddlRiGgXJbt/BISQLJx1l+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQknFqE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQknFqE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C125AC4CEED;
	Tue,  8 Jul 2025 16:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993584;
	bh=PAQp2aljDE8rkAuSoGbIwBfY7I3mHc/PDxkireKZglE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQknFqE2TZDOf1rragi+4wb69PhP116miI/Gc82XGuyTCV/Oi+vES8MYFST20PASr
	 qzsTxXbzCM9sHxwUJXjZibSh3nXVpbaJ/uKshvxmcgs7CPqFndcuHF3b1fudoZmpWj
	 7OmE15Cf1WwvsM6ebdd6LcJUlYQgBEhmVql1p0qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 124/178] ALSA: sb: Dont allow changing the DMA mode during operations
Date: Tue,  8 Jul 2025 18:22:41 +0200
Message-ID: <20250708162239.827964992@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ed29e073ba93f2d52832804cabdd831d5d357d33 ]

When a PCM stream is already running, one shouldn't change the DMA
mode via kcontrol, which may screw up the hardware.  Return -EBUSY
instead.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218185
Link: https://patch.msgid.link/20250610064322.26787-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/sb/sb16_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index 74db115250030..c4930efd44e3a 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -703,6 +703,9 @@ static int snd_sb16_dma_control_put(struct snd_kcontrol *kcontrol, struct snd_ct
 	unsigned char nval, oval;
 	int change;
 	
+	if (chip->mode & (SB_MODE_PLAYBACK | SB_MODE_CAPTURE))
+		return -EBUSY;
+
 	nval = ucontrol->value.enumerated.item[0];
 	if (nval > 2)
 		return -EINVAL;
-- 
2.39.5



