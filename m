Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDA4268685;
	Tue,  8 Apr 2025 12:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114296; cv=none; b=Y+b7I3bizs6VZw7T5qLT/SqrqMiYDoVfzhGhgYQNXR8IgFSHjXq8DD3DSlzaHrb51bcP1Q17XuzfoSFcsdxIU2rBOjy50kcnb6NU2sWw5SRTrUaexFF4SkaCidbRQ5+nW8txpqQckKrfiAeSd2hzINCLHKpqbw1f+Sn/zuZJl6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114296; c=relaxed/simple;
	bh=/MBDyNUQrY7bC9nQzcirqoDeKyD9gW+l0XMDdECsSu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7kR7TrvQ6giEdmWs5dMCUS4wirZnKSgaFHCd4byDc6VoIldxkORGjaHqtC6wsHSBwbvqlPLgpUGY6bLua0x2qZ+9B0XYvLAJZNWPFZDk/BI0dHersjWU0hSVcpvdwj2eWWzPCvGzjA5WkyrLlQhyHKZQ/ttU1dS8RksbJaa1LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5mfTyWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5mfTyWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A319C4CEE5;
	Tue,  8 Apr 2025 12:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114295;
	bh=/MBDyNUQrY7bC9nQzcirqoDeKyD9gW+l0XMDdECsSu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5mfTyWxqE7KIJeHyeHcX2/QiK99kMXpQqeqGA346ufhqaH75JPDs8HWeUgHGZglM
	 pO9Z2fHWbTdI6cOb86mSDcXbJPOaVpeLak5tO/RyHEk/lo+JGce4o/eQ4iigcqWqQg
	 kFqZj5UUjx0fT/Je5XrA68IHrvH/aKfzHpH4Tim0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Oleg Gorobets <oleg.goro@gmail.com>
Subject: [PATCH 6.13 055/499] ALSA: hda/realtek: Always honor no_shutup_pins
Date: Tue,  8 Apr 2025 12:44:27 +0200
Message-ID: <20250408104852.608454033@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index ee1682a2e0388..4c7f578726e26 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -586,6 +586,9 @@ static void alc_shutup_pins(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 
+	if (spec->no_shutup_pins)
+		return;
+
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
@@ -601,8 +604,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
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



