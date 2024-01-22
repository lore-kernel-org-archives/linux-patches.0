Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C8B1427B;
	Tue, 23 Jan 2024 02:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975357; cv=none; b=BPbPJbgSVdF96Ix+tamtp1gwlkpXCZtUcR9ADg0+qz+P9rup2C+ePqngfp1bUnsumuuQDtRtsT170DdFau+EED6V49McG5/FM76XEkao6jfjD6iqwq2Ri/FXrN+jXM/XRWVcBE/2uNYtWO0YRpJ7xJfF0JqKG88NMvGUue9AidM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975357; c=relaxed/simple;
	bh=el/2wFp4Xh1eD/UjfCZLlb3l/fLHiaB5K6fG6v9t4Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rld2JPUP29ZP6IlIAuQF3c+2i/8iDhs9h9js+IvUEWwfD7MMcdCWvr5u7kZ9gN18enJDIyUj0NuiLs2rg7WgmKjA5qMaoAUjf8xTfeEfM47rw8rWQq3HybHd8ghtxBBBk4Q3A8OAgFmCDB5cvhHWuF1U+2lvAY5thrjXPaGwgc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQYtV553; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQYtV553"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3661C43399;
	Tue, 23 Jan 2024 02:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975356;
	bh=el/2wFp4Xh1eD/UjfCZLlb3l/fLHiaB5K6fG6v9t4Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQYtV5534jEMaBofc2/NuMyugv0g0xzSghMNNywdau2QCBXmfgBKDeeLiCppo+ZgX
	 DfUvfZNexNEzVbUKKJuFClsMJJw8y0zw5ObAaNBDVKk1oNU9XSxqq30+G16jX/upTP
	 BW+cdhvuLo0pAp5MFsF0Rf1rlralUUQx3k+z3le0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 319/583] ALSA: scarlett2: Add missing error check to scarlett2_config_save()
Date: Mon, 22 Jan 2024 15:56:10 -0800
Message-ID: <20240122235821.807760070@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit 5f6ff6931a1c0065a55448108940371e1ac8075f ]

scarlett2_config_save() was ignoring the return value from
scarlett2_usb(). As this function is not called from user-space we
can't return the error, so call usb_audio_err() instead.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Fixes: 9e4d5c1be21f ("ALSA: usb-audio: Scarlett Gen 2 mixer interface")
Link: https://lore.kernel.org/r/bf0a15332d852d7825fa6da87d2a0d9c0b702053.1703001053.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index d260be8cb6bc..64cfe2d6045e 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1337,9 +1337,11 @@ static void scarlett2_config_save(struct usb_mixer_interface *mixer)
 {
 	__le32 req = cpu_to_le32(SCARLETT2_USB_CONFIG_SAVE);
 
-	scarlett2_usb(mixer, SCARLETT2_USB_DATA_CMD,
-		      &req, sizeof(u32),
-		      NULL, 0);
+	int err = scarlett2_usb(mixer, SCARLETT2_USB_DATA_CMD,
+				&req, sizeof(u32),
+				NULL, 0);
+	if (err < 0)
+		usb_audio_err(mixer->chip, "config save failed: %d\n", err);
 }
 
 /* Delayed work to save config */
-- 
2.43.0



