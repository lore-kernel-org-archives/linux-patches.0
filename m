Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D02347DC
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A33CC433CA;
	Wed, 20 Sep 2023 12:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211352;
	bh=8c7cQBLOs9VG00Br/vStrEspSGk7aHkdU0CYYTmWoHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORqFYZ8zhrYg7+jnOfGUxCajjjoPWR144fREHaRzcA1XNkzf2NkKlb2qrmR9pMUlk
	 vq1vPGS/y4G61gcyZEH/MzlWIriwa6KUxkFUUAKSgcumTRPXnkJoaDGnADF44+Qk6H
	 0kEhlMU0LHwXx9xmLdlEPNGfUWwZglaO94+jrK7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Su Hui <suhui@nfschina.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 062/186] ALSA: ac97: Fix possible error value of *rac97
Date: Wed, 20 Sep 2023 13:29:25 +0200
Message-ID: <20230920112839.132075281@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 67de40c9df94037769967ba28c7d951afb45b7fb ]

Before committing 79597c8bf64c, *rac97 always be NULL if there is
an error. When error happens, make sure *rac97 is NULL is safer.

For examble, in snd_vortex_mixer():
	err = snd_ac97_mixer(pbus, &ac97, &vortex->codec);
	vortex->isquad = ((vortex->codec == NULL) ?
		0 : (vortex->codec->ext_id&0x80));
If error happened but vortex->codec isn't NULL, this may cause some
problems.

Move the judgement order to be clearer and better.

Fixes: 79597c8bf64c ("ALSA: ac97: Fix possible NULL dereference in snd_ac97_mixer")
Suggested-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20230823025212.1000961-1-suhui@nfschina.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ac97/ac97_codec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index e37eab3ddc734..5095048d5cea6 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -2026,10 +2026,9 @@ int snd_ac97_mixer(struct snd_ac97_bus *bus, struct snd_ac97_template *template,
 		.dev_disconnect =	snd_ac97_dev_disconnect,
 	};
 
-	if (!rac97)
-		return -EINVAL;
-	if (snd_BUG_ON(!bus || !template))
+	if (snd_BUG_ON(!bus || !template || !rac97))
 		return -EINVAL;
+	*rac97 = NULL;
 	if (snd_BUG_ON(template->num >= 4))
 		return -EINVAL;
 	if (bus->codec[template->num])
-- 
2.40.1



