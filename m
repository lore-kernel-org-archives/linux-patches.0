Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061453;
	b=VzLHISOZLCvRTAxw3VmeDloH8/BeyRR8/XOYrME1lXG18JM0nCfiF/CgJnlknYIyfnDh
	 A+432u5PMYQFr7WCtg3CQKon+nQFhsAsl1dEbUZrF9VpDKJkL3uSy4j30Typ+beYAkZte
	 T+3oVWKkeaFGkgEue0VhlBZ6Qiy9C2tQi+DLG0cm16XdNf4+EgN590rmfz+6MUr61L4He
	 AM0yM8x2tae/65TYVUqaOD1yfENkSuqNgpFnOewREdEAcX7AbEKYc7W1qDBENFa3nFuyJ
	 +02SBL3oMjs/wlbMHjchFiZnnkQWx8LMEwQWNcNW4iG+FXaqj4C2HFy4Dai3FKj5LFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9/dnUEMjgdakZmCO/iGjxXm6kT5lwMCeED8sFlR8qks=;
	b=OTkSKDVhB3nxn0SfVg+Qn81pKh2TP47nYb1vhxJL28MwOrZaL1DPVptqSbXiblTiplOm
	 nf2YGQawSR9PUPdo953EoeCR350pwr457ryCxqYwX6+vxaHhKLnAsUG4kTb5FVZjBqJBy
	 6JRHBIZiQzUt0932zRizTBS3LrwseKlBmOAbE9DZ2OZXoKAQWd/Fys/UeIGci6ZR8NJVq
	 wPoEGIRhCGWyCbTEMJuGGOS9qFm8y08LDM09Ppq8nc4GzKn+eOImrn7D+Wg5ryeQqauEh
	 FsgeQFg9iz6vRbpqT8XjjYoUxflver/H8YzyDrbq7s7EIJgcSyhhiPfQ8YTA2GYqjBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kBs2rw9i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE6D606A337;
	Thu, 19 Nov 2026 04:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kBs2rw9i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409961F000C5;
	Thu, 19 Nov 2026 04:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061453;
	bh=9/dnUEMjgdakZmCO/iGjxXm6kT5lwMCeED8sFlR8qks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBs2rw9iVyflFpU9eAeY8aSGza3056dW3EDNs0NEWsV8/IbDRjUk7nQkGwA0tVkEK
	 fxmjZ78XAchtRRNi2h9fe1dOQfMBo4I42/yD/WeESnfxLF4E8MMCwGEU+zZ2aMf4hh
	 LDKbFilCgCXS/d/Uc8pCutcLk0PkmusmTEUEM23I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1551/1848] ALSA: hda: intel: Cancel delayed work at shutdown, too
Date: Wed, 18 Nov 2026 15:59:49 +0100
Message-ID: <20261118150024.551660762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f5417611f2551..4ff6b650f1ed3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2490,12 +2490,17 @@ static void azx_remove(struct pci_dev *pci)
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



