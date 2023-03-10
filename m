Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0CA847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A8FC433D2;
	Fri, 10 Mar 2023 13:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456235;
	bh=n1jKkHfRjRG8GVzq653B5zAVJuxcG56uPlJAZuaqCLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kx5/cF8JOpaRu9Duc2XLL1/FYwBHMaE1xKCmZSpd53Evuxh5RvTSNmN+kznB4dbbi
	 hIToKnRUvNrQ1+r22xjYkn1Vr3sfOVackBUrigw59ZRS4sx06v91IXys7JTH88e9FR
	 JaruS0I2D/qkiVun6fXZCJ1ZU3djZNj4Ee6UpCSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Fomin <fomindmitriyfoma@mail.ru>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 126/193] ALSA: ice1712: Do not left ice->gpio_mutex locked in aureon_add_controls()
Date: Fri, 10 Mar 2023 14:38:28 +0100
Message-Id: <20230310133715.441433129@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Fomin <fomindmitriyfoma@mail.ru>

commit 951606a14a8901e3551fe4d8d3cedd73fe954ce1 upstream.

If snd_ctl_add() fails in aureon_add_controls(), it immediately returns
and leaves ice->gpio_mutex locked. ice->gpio_mutex locks in
snd_ice1712_save_gpio_status and unlocks in
snd_ice1712_restore_gpio_status(ice).

It seems that the mutex is required only for aureon_cs8415_get(),
so snd_ice1712_restore_gpio_status(ice) can be placed
just after that. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dmitry Fomin <fomindmitriyfoma@mail.ru>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230225184322.6286-1-fomindmitriyfoma@mail.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ice1712/aureon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/ice1712/aureon.c
+++ b/sound/pci/ice1712/aureon.c
@@ -1906,6 +1906,7 @@ static int aureon_add_controls(struct sn
 		unsigned char id;
 		snd_ice1712_save_gpio_status(ice);
 		id = aureon_cs8415_get(ice, CS8415_ID);
+		snd_ice1712_restore_gpio_status(ice);
 		if (id != 0x41)
 			dev_info(ice->card->dev,
 				 "No CS8415 chip. Skipping CS8415 controls.\n");
@@ -1923,7 +1924,6 @@ static int aureon_add_controls(struct sn
 					kctl->id.device = ice->pcm->device;
 			}
 		}
-		snd_ice1712_restore_gpio_status(ice);
 	}
 
 	return 0;


