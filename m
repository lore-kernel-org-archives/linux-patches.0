Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019316;
	b=VMobu9fT0FpH94H+fXxHg8EP6uLIoO+sNxrccTIj3pX/boFxeFh8ByxHvj/SymQGpRKD
	 WFcO192EMgua6fdoIgk//GBm97ri30juiiMSIKulN9EDexI8ek9x83283tr6IIeicrSze
	 y8Af7rJYjiqp93WvcDBLJn6abzpB42oAjBmXVGdmeXbnrQjWsNo5iSkUVFmQXicMCj4DH
	 jhG0X0HC56Dp+G0Gr/7FhkPl2afbKbsgnVmYfkWwvpHcGZRWsc9R5HA6wc4IJyfX1Pzfr
	 mjsY5cCgYqs6MeRiZwJ/aUJux0E9ApK6dQQAMRDc5XfiaAlEzpEHJyRYz3SxC2euWbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgxhVtBg69qlVoUkH28/5QuXvlWO+jbV0EMk9/UDZ3o=;
	b=DjB6YI3Dcl7PouIpJNWS6MeEBWA1K6mv9xz1fyGviDl3Ux7mAduH9O7YE9p0zNPsRenq
	 6M1M/C8wsH3Es4RqiiAqPF6OdHVdTqtxExkc0w6SSmZteaNqWFV1kecD4Ud0uFlTaicg5
	 t0337hxW8Gnz0tHoT4n5F8djWnsDXDRRJIxfa5AiELifEwqf/rDLJHXNHs08qmAbDysBW
	 zkc0XFxQGXzamja5vFNGqb/G3xy48W5IIeLJeeYLT4QPLP73prUlFueYxwaZkslXm2+T3
	 OwtAalFThGeRm/p1QTPawbZz/sgB+/dNHF3uTI/5Kh0pW+UnkiI+xOntjp7JS5vl2Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qc/tez7o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F277960A2608;
	Wed, 18 Nov 2026 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qc/tez7o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CED01F000C4;
	Wed, 18 Nov 2026 16:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019315;
	bh=ZgxhVtBg69qlVoUkH28/5QuXvlWO+jbV0EMk9/UDZ3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qc/tez7odoFX27Tj7LNp+EZviJpneLtPClUZa8Tq0ggKvxh79HCZ1Ac4/fZTwNn3N
	 1zZJReLjj3GQg7yTbJU8IQFHma56exuGOglMxsh0+DIVFmeXYazUqUrKpmuJVA889r
	 ZgQ66fYM+fVbsiZ6WnjbfJCzACD5KbAnXq+/jMQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1552/2651] ALSA: hda: intel: Cancel delayed work at shutdown, too
Date: Wed, 18 Nov 2026 15:46:32 +0100
Message-ID: <20261118150343.830614032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 88b0207fde9cd..2b5b5d555f2cd 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -2484,12 +2484,17 @@ static void azx_remove(struct pci_dev *pci)
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



