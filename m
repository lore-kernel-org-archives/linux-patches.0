Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3424E2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFA3C433EF;
	Tue, 18 Apr 2023 12:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821464;
	bh=CgPIBuvQobeCEXJ85ow/D53Br8R3NtX34PVqfwAAaz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UV3BuxN85rWpimrg5d7pS38siKLBAwOdPQNgbqA/3pNidxKcTK/gcsnt8w0HZAk3b
	 wYa69/9cq3eUO7s7e3vlDOlIR0LNSFt0KkoNuFXTYpa/PSx9cEr1NY66gUuVDfwLoy
	 bDf/vlcxVwhORBBNyaVfvj7Nrygg4dXuinxqMVnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 04/91] ALSA: i2c/cs8427: fix iec958 mixer control deactivation
Date: Tue, 18 Apr 2023 14:21:08 +0200
Message-Id: <20230418120305.687681456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

commit e98e7a82bca2b6dce3e03719cff800ec913f9af7 upstream.

snd_cs8427_iec958_active() would always delete
SNDRV_CTL_ELEM_ACCESS_INACTIVE, even though the function has an
argument `active`.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230405201219.2197811-1-oswald.buddenhagen@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/i2c/cs8427.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/i2c/cs8427.c
+++ b/sound/i2c/cs8427.c
@@ -561,10 +561,13 @@ int snd_cs8427_iec958_active(struct snd_
 	if (snd_BUG_ON(!cs8427))
 		return -ENXIO;
 	chip = cs8427->private_data;
-	if (active)
+	if (active) {
 		memcpy(chip->playback.pcm_status,
 		       chip->playback.def_status, 24);
-	chip->playback.pcm_ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+		chip->playback.pcm_ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+	} else {
+		chip->playback.pcm_ctl->vd[0].access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+	}
 	snd_ctl_notify(cs8427->bus->card,
 		       SNDRV_CTL_EVENT_MASK_VALUE | SNDRV_CTL_EVENT_MASK_INFO,
 		       &chip->playback.pcm_ctl->id);


