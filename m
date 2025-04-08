Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2134622257E;
	Tue,  8 Apr 2025 11:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113199; cv=none; b=T3CYleZNPUA69kU+Npy0qE/rSIxXOqQRN7/zlvX0/rDNNUwCBALfqRy/V4gdhiiw7kQsxlmA/9dL6X+CaRaLG10ieJPQQTe8qF/2cNVz0I+YiGmlvWFyjcXyj3uqU3e9MMoc9pCyHPgJVxDEqhEDdQYOx5qqPELmCOZtJA1V8i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113199; c=relaxed/simple;
	bh=lEJqp7aGHayU9a41iEuO/vUtmKPgnhzmc132P6v2VLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jO3A2PJHmTixdocikXT4WjcYjoMOveFEWP81U0rqGM+xDg8bXBQMcqsW9WOuRSGe3lEzGIyLVX/+DB5BLejDWaoDks7RaFDQ72mQNZc1v/E0ra/HcdpaSv0sEw4sD0ZFFE9RTyqkMsxZbSIH7/KpthVqg8PurYvKEux6+i92sY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2JY/pZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2JY/pZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52FBC4CEE5;
	Tue,  8 Apr 2025 11:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113199;
	bh=lEJqp7aGHayU9a41iEuO/vUtmKPgnhzmc132P6v2VLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2JY/pZvUyWOYnR+jnrh92ZElbM+ogMTiTY7LR3blTMo59jBe9tEh0H/6vBmkcAKo
	 Irf6ZOq9w+U0o2okWpBiGVO00yKhD4SpUiVfw8OV7oJtqzPaRJi+4GNzsiTUmhEy9K
	 zOFRm4wziGLM55O/3UMaG8fNgl+UY6Ay174YL7Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Oleg Gorobets <oleg.goro@gmail.com>
Subject: [PATCH 6.6 030/268] ALSA: hda/realtek: Always honor no_shutup_pins
Date: Tue,  8 Apr 2025 12:47:21 +0200
Message-ID: <20250408104829.316746869@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5a0c72c1da3cbc0cd4940a95d1be2830104c6edf ]

The workaround for Dell machines to skip the pin-shutup for mic pins
introduced alc_headset_mic_no_shutup() that is replaced from the
generic snd_hda_shutup_pins() for certain codecs.  The problem is that
the call is done unconditionally even if spec->no_shutup_pins is set.
This seems causing problems on other platforms like Lenovo.

This patch corrects the behavior and the driver honors always
spec->no_shutup_pins flag and skips alc_headset_mic_no_shutup() if
it's set.

Fixes: dad3197da7a3 ("ALSA: hda/realtek - Fixup headphone noise via runtime suspend")
Reported-and-tested-by: Oleg Gorobets <oleg.goro@gmail.com>
Link: https://patch.msgid.link/20250315143020.27184-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b3cd6090f46aa..81ebf59898a10 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -584,6 +584,9 @@ static void alc_shutup_pins(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 
+	if (spec->no_shutup_pins)
+		return;
+
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
@@ -599,8 +602,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
 		alc_headset_mic_no_shutup(codec);
 		break;
 	default:
-		if (!spec->no_shutup_pins)
-			snd_hda_shutup_pins(codec);
+		snd_hda_shutup_pins(codec);
 		break;
 	}
 }
-- 
2.39.5



