Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026044;
	b=qUmE1Ez7aUbylMFgz7UGTzKIzPRci8YhCSF762itl9AfJpPo7pM0w4z3MmQlK3lEXwSU
	 OHdnM+uA0De/6siNuFGyXk5lN7sywQsYXu4YmOf4pw8ODV7C7gU/iYu2hF4Sw5LKh++H3
	 P6tvkRDdD8M4j1hoHViGOeyqFrRv7z4JPzJfzTtYSiaxF9pd8ESMQPaeOVs9li4G/obkB
	 h+XFBiZa/rXPQTJAQupBzZE4yRy2zn1Cieab1hWoHkHwBRlCWHmovHgWm/fg7zHRJKCac
	 XjkN0aGDtgk3T3ONRWXiybIUfjbedns8YkUFjZVycGnfZ11HgLUFTwk5vU59DUJbWXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K0+B9gWLnwk2ya/KsrV+vDdqsv1MbqLOImkGGbh5bAY=;
	b=m/lXFrUS4k1Siy3KrslDOcdPleNEBsVoLz07A59IX27ji0QdBMOQGQ50/wWISIp4roOv
	 +GgEmouFRmSl2whTZXegkvnkbcAPi1WAYAR9H7cd7bEmLesPyF6VbUlr1OMKPd0RxnNHy
	 vaiDnOgyCeZmYcNOCovweS7YOeAC6ofgz4oSL/Gy5Fmc3sI4NOvOhIy+6sCKf13OBjeCC
	 FOm+jrRsSiOTIsQDrYrKPMI2xWfG08BPl97Xiu2dNao2+YCyTVlaKIm9/95vg/xl5AfbE
	 TFYJn8gCyAZJ5wXInaSkO6lSqyusjb4uC9WSkLM2IAR2k6bbktt1fkoSxkrijhkDDfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rPhBvpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2A8606A325;
	Wed, 18 Nov 2026 18:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rPhBvpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295541F000C4;
	Wed, 18 Nov 2026 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026043;
	bh=K0+B9gWLnwk2ya/KsrV+vDdqsv1MbqLOImkGGbh5bAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rPhBvpeL4vPslA4EyYuGzTXVwwM3wNDjv5iHADWqoR5ee4qH0sVgTQDKsCu7YSqR
	 7/BQfH4RhQyGjNBudsfgdxEcbSh89bc5cOtGEtq67tWjE+EIlrL1eub8xCWNhEfxyC
	 WZ9EqofY2A3dIlPUFJo3aXsBL6FO0Z4K7yeugr30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1287/2151] ALSA: hda: intel: Cancel delayed work at shutdown, too
Date: Wed, 18 Nov 2026 15:50:22 +0100
Message-ID: <20261118150209.016439388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b83b78df0e53d9dd872d24e49a99658815b12770 ]

The shutdown procedure needs to cancel the delayed probe work in case
where the probe work stalls or is slow but still possible to
reactivated.

Fixes: c0f1886de7e1 ("ALSA: hda: intel: Allow repeatedly probing on codec configuration errors")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/controllers/intel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 523324a565c9c..449b6fda94913 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -2432,12 +2432,17 @@ static void azx_remove(struct pci_dev *pci)
 static void azx_shutdown(struct pci_dev *pci)
 {
 	struct snd_card *card = pci_get_drvdata(pci);
+	struct hda_intel *hda;
 	struct azx *chip;
 
 	if (!card)
 		return;
 	chip = card->private_data;
-	if (chip && chip->running)
+	if (!chip)
+		return;
+	hda = container_of(chip, struct hda_intel, chip);
+	cancel_delayed_work_sync(&hda->probe_work);
+	if (chip->running)
 		__azx_shutdown_chip(chip, true);
 }
 
-- 
2.53.0



