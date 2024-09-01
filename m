Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D861EB5B;
	Sun,  1 Sep 2024 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210052; cv=none; b=IIWd3M1s9uOyut1IxcVKMuw/vw/3VzxTVEYpjVIRztMm2bTYehhuFxg5aMtvPIVADrux7ibw3g736PvMqCmc//QaayPCRtqVl8MkprGPEzQ1KJpkTHor2jPdBgFxU4fwv9nnulsF38fx5iCEuQj8z4EjFvgMibI1fkNuvetpHz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210052; c=relaxed/simple;
	bh=cXR7DFRQPm0+qZRrXdLaqDBL35f3N9C/HHrmjXIgjHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExgZZQnxvqdviVqK4eXPdrUQ8XjLNMEe4VCH0Lhwg61HWE7OfU3KwfHJCSEoW0TM7iDm58U95vSY4+13WSkgl470OhyNJ2a0Xmq7zYOc5F5GPSJk8SWrF3BvRoclaYFuMoQuGThRk36FVOWTXXUxCGZHiCK3mT7hr1TLynQhcVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6uXAu8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6uXAu8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AB6C4CEC3;
	Sun,  1 Sep 2024 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210052;
	bh=cXR7DFRQPm0+qZRrXdLaqDBL35f3N9C/HHrmjXIgjHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6uXAu8QD9h4J4/2umKZya9K/reQqFxlWYQRdJDZN92jFMIQXQofRLywUQWqd2E7k
	 /luHSB8bVPglJSMBkBWll5vbVBhEFGcsnGl6mjGl8R1aICcqrD+a8qq4sIAnO0L/Hu
	 BRyq77S8iG9waHIvLBRtE4utBpZi55GNAviD5WCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parsa Poorshikhian <parsa.poorsh@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/215] ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7
Date: Sun,  1 Sep 2024 18:15:54 +0200
Message-ID: <20240901160824.938129818@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8729896c7f9cd..05fb686ae2508 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -577,7 +577,6 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
-	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



