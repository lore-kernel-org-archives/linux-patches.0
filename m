Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC742224239;
	Tue,  8 Apr 2025 12:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115575; cv=none; b=nbVJpJMppNuHdSwqty4esxujopeyx8/y+8TWYC+Dtw//zKk2CVKXSchI7ydC3MuilCAiUjFSceOdYfp+mlPVVvINJ8EJQKn4dAA7hEUVejPd17eMhJbI/+Rl7/1iiRrk3dmT35T/7j919fg+J8xYSk0VDmPNronB75XjvQxRmPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115575; c=relaxed/simple;
	bh=1tao1UnZGwzifB5rOqsY/Y9mHbk6HLLpLaDFZRiwUlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGROuxt7cqNAcQXyLZkPdorHrTnAQ9HG+gQZpKARHd7CBKsUss6cMo8cVAGIyjpG7rd2/4p/Vic3hGjsiWMZNdhTVgi3JirBDzAxzyzGspSMXq/Yif005tZEDXf9BW9j8ZomFaz4b39YALo7sz0iIAG874FckXpIT/IFPueARGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkt3HgWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkt3HgWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AA3C4CEE5;
	Tue,  8 Apr 2025 12:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115575;
	bh=1tao1UnZGwzifB5rOqsY/Y9mHbk6HLLpLaDFZRiwUlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkt3HgWHO7FBnz/uqHhNivXubdNmUhB5ieNmoFVe7ihEPRElIYmMI1dgp81TYMUGK
	 HVpbJPzkXpZR8rdZcR9XMCtxhtRC7CSZzqJCUULjqrm58PzksyAiqmYdjkSWstnMVe
	 W2f7ivGdETyd1AIP6AMfjvc/029uX5V5QruoXEsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Oleg Gorobets <oleg.goro@gmail.com>
Subject: [PATCH 6.1 025/204] ALSA: hda/realtek: Always honor no_shutup_pins
Date: Tue,  8 Apr 2025 12:49:15 +0200
Message-ID: <20250408104821.061002352@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a562e574fe403..86a4e8c7d3f91 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -582,6 +582,9 @@ static void alc_shutup_pins(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 
+	if (spec->no_shutup_pins)
+		return;
+
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
@@ -597,8 +600,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
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



