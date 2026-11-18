Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031329;
	b=dk0t1bFAh4f483P0WKRfPvlMn+4eaWwC/xYBMq2efQTWs0q+wuXr+9tVi4QebrtCLJx0
	 S0C9A8RnkRsr04hSpxWknqP8xU5j/iSmatJBOY4FJSWFrIX0TV3iMWWSz9ZUxDc5pGPgD
	 s96zFY34hxJvEV6vglUyTStPOXgVlTqqOBsfJ4A3zrO6eMJWFdCpCeE91XcdT+boRXyv1
	 DjefOVxOKLrRvECmtqVNVJO+/rf8QEYpy/6KLksnTAiHzawm/xeh4dN3hPVE2NJe3IAAx
	 wbP/00FKrI5TOMFQdP8VlRgZ0LxT+/atRaW9OQ/hpFphFs4qDQ1eu3G9ser1WbMoshQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UYCOkASdssjpVjRAFLRm7nMPAi9Gl6f0DmD/fU5L+R8=;
	b=tan9YU9KLLaTl1d4vZtnI2I83S9DwHWS63XtjYrUZp7PqngOc13rLKfyeOZxDp959RBy
	 R3EpzkuQDwEVgbmaJ83thsyG/lWC5Sp+Lfv0vT+l4TgWT99KP8fr2rvzrP93m0rn73MfQ
	 sJKLJSrTjNER5fH/VvQ6yev1LBXn/UCdy0HTIdreuWmLv9hFhYx4Nm/VdZ8OuZf/lWhV2
	 HkfOQgUmo3agedRjFUoh/TgidZ4rlNFKX2pdU6xpChWTAcVdwwCdqOrhMBoox4IOQ8QN9
	 3cVYon+E92r9lwhQ5hIinkZjsxWyhyUaUmbUh027p4H3eP0SoNrFc/w0JMC3ZhCVhaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9426Q2+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6263C606A325;
	Wed, 18 Nov 2026 19:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9426Q2+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78601F000C4;
	Wed, 18 Nov 2026 19:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031329;
	bh=UYCOkASdssjpVjRAFLRm7nMPAi9Gl6f0DmD/fU5L+R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9426Q2+/VdNbnEjaq2JJCFgIX817xwwzk/BOnmQF3UaboFT0de7cmSOqJ7YmDRCP
	 Ijljqmu3RIzUZUrPsuyn0WALOkhgzQ0mIyYN4TPAlSe7x2ItJJBXeciskc+HrVwczZ
	 pLblodRM5NqmLYmA7BrYk42+oDNxWZ28QxnpDLJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1021/1756] ALSA: hda: intel: Cancel delayed work at shutdown, too
Date: Wed, 18 Nov 2026 15:52:28 +0100
Message-ID: <20261118150050.754200144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 58a51c11a2e8d..13fce4668f481 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2433,12 +2433,17 @@ static void azx_remove(struct pci_dev *pci)
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



