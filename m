Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335121E520;
	Tue, 27 Aug 2024 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771221; cv=none; b=IfQFazSzFWmxGJvMCpQsYir3phIkaQnU7B1ppjMSERHyooswD/FND3hTIWTSTy+rKk8tffeOjIemyO2tezkmqSv0VmaIoNNupYPRqagdgHderSz7Hv+8g3eBBDMOSXIcpxqof9fza8QSCeGVq7bp34kXimV0NMb/AOGKCdEhbXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771221; c=relaxed/simple;
	bh=hXYM0a/c3MYf+uUIqNihLHrrL4+j7eayJw01hW6Yz98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYmdO2yjzJ5G75hl6D3z7i6O5wKOHikhJwEGMwuBeGxmhg03PIci7h+eUbLkvS3d2FsFivrgjMCfkuortzxKHqcPcaWUdx8ScDOYHlMd2NVLrzg/69uwvXNRxnUbbJhy6CCQoIoD75p1UaTcfB5pqCdj0Tbq/oJky6qv3FK1WBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJfgKOT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJfgKOT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EE4C4AF55;
	Tue, 27 Aug 2024 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771221;
	bh=hXYM0a/c3MYf+uUIqNihLHrrL4+j7eayJw01hW6Yz98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJfgKOT/wX5C0qUgulsEOEf3M6HoTuay3Foyn+smUR+7JkgniA6fFRR5IaV6qz9s3
	 2bWIdU5tIu08U+tRzKYW5+QqIrMYNJy5h7k955h3qKgYFe8TmGLLFT8BEokP1XIQOQ
	 tcdIfGRjSMcOTI8YjR/S7Yl7t5kzyGJN1zGXJ7Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parsa Poorshikhian <parsa.poorsh@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 123/273] ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7
Date: Tue, 27 Aug 2024 16:37:27 +0200
Message-ID: <20240827143838.087568779@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parsa Poorshikhian <parsa.poorsh@gmail.com>

[ Upstream commit ef9718b3d54e822de294351251f3a574f8a082ce ]

Fix noise from speakers connected to AUX port when no sound is playing.
The problem occurs because the `alc_shutup_pins` function includes
a 0x10ec0257 vendor ID, which causes noise on Lenovo IdeaPad 3 15IAU7 with
Realtek ALC257 codec when no sound is playing.
Removing this vendor ID from the function fixes the bug.

Fixes: 70794b9563fe ("ALSA: hda/realtek: Add more codec ID to no shutup pins list")
Signed-off-by: Parsa Poorshikhian <parsa.poorsh@gmail.com>
Link: https://patch.msgid.link/20240810150939.330693-1-parsa.poorsh@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3840565ef8b02..c9d76bca99232 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -583,7 +583,6 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
-	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



