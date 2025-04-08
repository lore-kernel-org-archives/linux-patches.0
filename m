Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE2821ADAE;
	Tue,  8 Apr 2025 11:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110033; cv=none; b=TF7HZjVzDvMmHa9hb2HbN7DM8DAADCe6dD4xHRDzdawPcZtmL8uVXtFZ1g2huYqTDtcBvZ5wZh/zQeeakmFpskpwNHOGCQ+qThrmkMwe/P6B2XnbJRTHOvRxeO/vfSltgliNmWfhgauZeZreM4xGl8X97tEF8qDR4Gtwj4TQWyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110033; c=relaxed/simple;
	bh=qu0H1gOUad224dsafihHX5lMGSpDJOy+hploelsQibk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eG9uYY1QTpaWvinEgq7QYjf4CMuVtnIfL93s9A5k7uIUoHK7dueia7jyldHZT2dMLMLTU9OxiZ8bZhd+lGU8AzaEaluIw6bF5xfKpnS5EVioPf4p86sx6MfTrnnFFNPJV8B2guOGKEhAL5huQ7aMRQAFxUGEuJwnUakhT+VN/zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yqx8WWhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yqx8WWhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926F5C4CEE5;
	Tue,  8 Apr 2025 11:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110033;
	bh=qu0H1gOUad224dsafihHX5lMGSpDJOy+hploelsQibk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yqx8WWhdVPOtJLoOPpn7ptj6QnUGDGUE7cnK+YWO81HxQXd0PdGuPq927NuKPQAol
	 qpDgWuUXSFP1X0eSiC+Lv0AG7X1oU3Zv0aBuyRLD1jJMg4zK0wwjC/Pqy/jKfq58gB
	 tYMY5i/D2t7xPzDt7M5hgXIEODCLgfn/XVJaMJbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Oleg Gorobets <oleg.goro@gmail.com>
Subject: [PATCH 5.10 126/227] ALSA: hda/realtek: Always honor no_shutup_pins
Date: Tue,  8 Apr 2025 12:48:24 +0200
Message-ID: <20250408104824.111819459@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 494a34af46b03..f3cb24ed3a78a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -577,6 +577,9 @@ static void alc_shutup_pins(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 
+	if (spec->no_shutup_pins)
+		return;
+
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
@@ -592,8 +595,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
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



