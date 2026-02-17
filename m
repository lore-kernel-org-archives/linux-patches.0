Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6552D29A1;
	Tue, 17 Feb 2026 20:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361570; cv=none; b=FeR/KBiejiHCNCmvCJ4QBLbDY8+N7Q2Ao0nXjOYiusBb5YCNcGNSInt7YgypmrKN8IdzIUS1oFlU/WAqnAeHtNF77rE6gFonbmacYkZMtZ9W5cZPzcN0d8JeumOaqWvnPhUIj8mL7/6IU3J5DZLg7+g2QNGkfoO26ZE6WOGZHpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361570; c=relaxed/simple;
	bh=bHRb4OELz+ZnLoI8TAMi8sDrmB9rLHdKNDhv2sgQdL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJxq8p6IdQLCuWnI8xRmHQjO+ezycHw+LC19coIDqb817ArsIKH98k2Dmjw9P4RN7LiG6U4ZSVgoaPVgHd1cBbjj021IhWY1Izblnfh+nijrj1FKa+x6NgCg6DHyuY3diBHhyLirGkvB9zigd+EHefJoizoQ4ut9UAd2d01vbQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVd1zCmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVd1zCmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67D8C4CEF7;
	Tue, 17 Feb 2026 20:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361570;
	bh=bHRb4OELz+ZnLoI8TAMi8sDrmB9rLHdKNDhv2sgQdL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVd1zCmjw5tK9oNcECCfAjC1rBbgqEq+2Kx7U1r+PGqJI6Z6Xy0v3p6ryKbN+PXSI
	 ++YEZeJNgJmS10dmsHxRu6KfPl0d4j/klIdi4KBwFQdrXCxy2am731qE3/+TJKGuXw
	 /BS1zfaNe+timXoFkKVU3lXCreV0ycSK9qTAwNbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 11/42] ALSA: hda/realtek - fixed speaker no sound
Date: Tue, 17 Feb 2026 21:32:02 +0100
Message-ID: <20260217200006.439414092@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 630fbc6e870eb06c5126cc97a3abecbe012272c8 ]

If it play a 5s above silence media stream, it will cause silence
detection trigger.
Speaker will make no sound when you use another app to play a stream.
Add this patch will solve this issue.

GPIO2: Mute Hotkey GPIO3: Mic Mute LED
Enable this will turn on hotkey and LED support.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/f4929e137a7949238cc043d861a4d9f8@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d9c3d1443a956..6e7fa47741b0f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7650,11 +7650,22 @@ static void alc287_alc1318_playback_pcm_hook(struct hda_pcm_stream *hinfo,
 				   struct snd_pcm_substream *substream,
 				   int action)
 {
+	static const struct coef_fw dis_coefs[] = {
+		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC203),
+		WRITE_COEF(0x28, 0x0004), WRITE_COEF(0x29, 0xb023),
+	}; /* Disable AMP silence detection */
+	static const struct coef_fw en_coefs[] = {
+		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC203),
+		WRITE_COEF(0x28, 0x0084), WRITE_COEF(0x29, 0xb023),
+	}; /* Enable AMP silence detection */
+
 	switch (action) {
 	case HDA_GEN_PCM_ACT_OPEN:
+		alc_process_coef_fw(codec, dis_coefs);
 		alc_write_coefex_idx(codec, 0x5a, 0x00, 0x954f); /* write gpio3 to high */
 		break;
 	case HDA_GEN_PCM_ACT_CLOSE:
+		alc_process_coef_fw(codec, en_coefs);
 		alc_write_coefex_idx(codec, 0x5a, 0x00, 0x554f); /* write gpio3 as default value */
 		break;
 	}
-- 
2.51.0



