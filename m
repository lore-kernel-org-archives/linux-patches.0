Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10580269811;
	Tue,  8 Apr 2025 12:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116185; cv=none; b=Q/Buo0ptA2iGklJwi1W0YR3ENdYC2T/g4g36kNxVaWiQPTZevRrHnX4L0VBDdrAfk/l+mSbGMmeFUCdagOysY0DKJK+DvtfMpTZocbSta5ZtQh0/NJpZi+HrRRALyU1Nq7Scr9ZQGIAutV7sMZcUtPb//uGHAhY7UWKke1QzZoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116185; c=relaxed/simple;
	bh=8VFdns7BATAQrW6rNcFGvFkl8kOTZcpXrSWOnLia3nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaFGckMucclBUAv07s4aILu+xvICItDgfEv43kidVj16AXxaHP3UV5HwjmgZZYEdn9cbvRxPUHKhecJGZ7a5K2W9nhD2gBKFeM46a6WSmBGviJOgYzVINrEz2lnxQHUfolhLISb8HiIeRw9FtSbbIk8voVJx5PBAJVuXpm1LCYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCMJjz+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCMJjz+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A19C4CEE7;
	Tue,  8 Apr 2025 12:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116184;
	bh=8VFdns7BATAQrW6rNcFGvFkl8kOTZcpXrSWOnLia3nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCMJjz+edDHpHAdMSVSLfHVQY0ne7drDkyucbVSwZWQSW2fhwPORxoYT5BsuuT573
	 rgAEHNwSS47OJHFrXQjKBXqSZDKikEnF5zhtOGsWbns+km8FifsWu5+cI9xAptdW5M
	 redIWlirZN+LhFutXg8gjeXRYmn1vQpivK3w7FeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Oleg Gorobets <oleg.goro@gmail.com>
Subject: [PATCH 6.12 044/423] ALSA: hda/realtek: Always honor no_shutup_pins
Date: Tue,  8 Apr 2025 12:46:10 +0200
Message-ID: <20250408104846.776040207@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8c7da13a804c0..20b3586e4cb6f 100644
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



