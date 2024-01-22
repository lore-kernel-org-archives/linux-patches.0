Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955D34E1AD;
	Tue, 23 Jan 2024 00:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971378; cv=none; b=uysUunE0rpwYqAUnvBQ0P1zl8/l3CV8Tf6kXYB7RmaDg8Yckoaw410AhGcUBad19bvgB4weeeHknxGb3cJm7stvcIzQxfj3HO45aPWyNsY71UKRFGUv44CUxO0r5nXeKwhxXl7Mcl/ZCsQATepmfPkf3SfEbrnU9xeL2RVDdGdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971378; c=relaxed/simple;
	bh=nnlUs+Y1gDU2N7OvXpDz4wdXa7c8yyXNFUSblKQhBJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQBtr+Daq6tbdki947HyyIf0TyschKZura4pULsBtsJKXIAODPyqUrJscmFjLVtsI8NRnAgpwEwzF3ti0uV8axjMq7kXX364//YDfa68b0A+hALyPLUb1Qeg3ytU4oJQ/nmnmRMxqQCDhwOM9FQvpOW4Ky71+Fp9WqU3p6Rb+G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lP7It/Zb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lP7It/Zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78E0C433C7;
	Tue, 23 Jan 2024 00:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971378;
	bh=nnlUs+Y1gDU2N7OvXpDz4wdXa7c8yyXNFUSblKQhBJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lP7It/Zbio9fxAjOUL+XXFuYW9D+tc6ZuwYHllcwkOkcLjyagUgsczrB8VEKvhlVw
	 AqtD3qA43qga0wXZeJe18qtgCA+jhV6UAZ/ItgTDVc/ntyHQs72dJnsNVE9qKMW5A3
	 5AwURYkgr7NoKnUIufrHZrxFy3BDGbPSFzEweSnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 232/417] ALSA: scarlett2: Add missing error check to scarlett2_config_save()
Date: Mon, 22 Jan 2024 15:56:40 -0800
Message-ID: <20240122235759.934462160@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d11bb08667e..3da0d3167ebf 100644
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



