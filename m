Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D981DFD1;
	Sun,  1 Sep 2024 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209518; cv=none; b=oJKRbG8uqLPvtwrXZKRZ9B//mqmv4NGXFbqWrdOFXVhCWRapgX/IHDReBfdpee1eCFmoMJcItwAVE0Oy+igysX4CdcFhkPJ+OLZcnlur5DPmWZ/howUUj376k7KInD5DlY3n+yzsHMrrd7ZrXlNMcK+Mf9xrV8on87ZPSqtBNCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209518; c=relaxed/simple;
	bh=LKdoAgnDo1eFiRfscr8PGt8fq1NW/5egY6XzJCYpJJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xip0xB2SfDzrDlbNdNLVw2CylIGpuH8Sdh8H9j6bxBf4TXqZzqdKY0ac1/aacpjuqDsgaOgHBL7yDyx+oW5eDXQGexuYK1IRwvK4EU4CxhK5APojIoldV2Ph5lRz/+69IEZWaST6NAKQjQBSowRszC6M1v3px0SP+f9ztOzuYAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLQZUCjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLQZUCjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA91C4CEC3;
	Sun,  1 Sep 2024 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209518;
	bh=LKdoAgnDo1eFiRfscr8PGt8fq1NW/5egY6XzJCYpJJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLQZUCjFtOBwFlabvZ/NoR2ZDq/nAe2Sf1Hh30B/CmavgwUY+FZQZMq7G5Mp5G98Z
	 xwIwrXo4vTv7Uo+rjuS1AYtfnCz6cy2SB37ERfSLqO1HwcSv/HOVSBCpmXDkKu3pQG
	 iC7H3WQg+hQt0e0MvU2nRaoF7Sb91LVzUYjFHJKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parsa Poorshikhian <parsa.poorsh@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/151] ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7
Date: Sun,  1 Sep 2024 18:16:30 +0200
Message-ID: <20240901160815.233414922@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e8e9cfb4a9357..04fd52bba0573 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -578,7 +578,6 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
-	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



