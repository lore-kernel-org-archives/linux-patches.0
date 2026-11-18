Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041151;
	b=34cYkq2mpjSTz1grbhufjh0WYz+ZHgq0prGte+o1wGEGUKu/Zgx16r+s8SNEkc1d6zNN
	 9lVMBA4mvEt3r6PkjX78hO0x+V3fNc20U+Rrs2Sp1bCjLhKAhcrFBw6co9aSPsbUuT4NK
	 SGrjlJTIt0wtcoNHnlE2yYOUcH/OGvHCR2JvW8DRtyIeE5fIsriuqQmyN3Pbw0wyj1C5B
	 xazA8LC3Argh4H/PfbrxT5AA3N2BUYB0Z4HYoEFD9zF8UAFVapA0B4gjtnZVIUJYP0p/T
	 qX5Zq7geuc8/NB61H6t4Dw3LtyauvoW6aODXpyky5ceK3Ht+LTRM8IdU1FfjleCQr2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VEn7fN7NVe2tet+bg22B3q4sFgfYGdRfTCBxbTux6xw=;
	b=RsDwbL39HUAGvRyqqki57qJosFo4sfK9GrnNpZsxqVwoXvwdoEF49/6imIjnbHmBQb9F
	 7YiyuoE6RWFzBPng1NhsfgEw57wya9zCZU3WcbdxsJlIrKgO3I6Es7tVEO5rGuqeKQ1/i
	 tM3EB8S1mPTz2ZfZTc3dK9BIYgLjM6SKpey9sDio2Jeue50LM5ryZUukaBVDNoTVrYJVW
	 zM37ycKj76XF38K7wFimm0J7TmRFLaH2zyIOGiIZCZJXB6EnrozDBIngwqVEtqDsAKUPB
	 SZHylQgH6+a5K+ESgP/5QE93ZS7TlZ5sQGnQ/4z+utkRq891DP0v2DjNHhADOXAEDCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnFgKblA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24576606A31C;
	Wed, 18 Nov 2026 22:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnFgKblA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753CA1F000C4;
	Wed, 18 Nov 2026 22:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041151;
	bh=VEn7fN7NVe2tet+bg22B3q4sFgfYGdRfTCBxbTux6xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnFgKblAjp9KEt3eTm7TQcTyiPIuH2Cj725gubJO9D0G/bm1dlUIwq/qbMAPZcWzk
	 QtHzt1Xj23P+FleQLdCZmG4tOIhJphGNx2Su3hcg2f1OlbmHan33BNxmFoOQ0xr6jL
	 Tt22RWqpdbD2K9dT4KbFmfNlwf+vTsZLgSWoVBlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2709/3318] ALSA: hda: intel: Cancel delayed work at shutdown, too
Date: Wed, 18 Nov 2026 15:55:31 +0100
Message-ID: <20261118150442.158093042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 sound/pci/hda/hda_intel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 553f23133e145..abef69c82a645 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2465,12 +2465,17 @@ static void azx_remove(struct pci_dev *pci)
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



