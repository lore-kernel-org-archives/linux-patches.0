Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AA0604B5;
	Tue, 23 Jan 2024 01:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974700; cv=none; b=XeXE6+vsy6DTm49n+hySIrdNmPgnsjdJRQTYPAYKmNkc3IIFT0wc/UW38VId4eYhDYPdtJxzBt0nomfEs/2/215K9+lR62OIS0sXPcm7Ha5ECbp3YiEeQfdz5ouh3NXFGZ7wwbm/4+IfYawXkpod9l4LFQ3SjqwhF2do8O/2wx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974700; c=relaxed/simple;
	bh=7ep2YmWZXW8KRZ79Bm404oAtp32AXYpQ1tFriZkZ+Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ov4+XyPC1HMlGr7livI3GVQxdpsuft2wV/aHDqMn9VxZuaHp5QsJcRsn5KF1OJzJFmLCxvhDpo0ypRwc3aH2I9f+srYPcVYW0E01vt5hRDU3jTnbzbWNoLwEIe/plWF2Me92hjK0feRDOHl4/9PwUIX9ANSzY7r6c/wIXf8ywV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wm1jSp9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wm1jSp9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4D0C43394;
	Tue, 23 Jan 2024 01:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974700;
	bh=7ep2YmWZXW8KRZ79Bm404oAtp32AXYpQ1tFriZkZ+Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wm1jSp9rkuc73ixDh4QKu3tsXEoe2KdD9FwE1WgoXWQNQhbValWwdHsgZRZnQQdfa
	 qMY4pOMoovOKwqjicDdu5iwPxqpbt5ABOxprI+zkB+J6b1hIJB4r7yfCnuXufNMIOF
	 6aiinN5SNZGi7prsqD203eCd3/RC16Q4kbxkT0AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/374] ALSA: scarlett2: Add missing error check to scarlett2_config_save()
Date: Mon, 22 Jan 2024 15:58:07 -0800
Message-ID: <20240122235752.745368712@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index 53ebabf42472..6e79872e68c4 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1213,9 +1213,11 @@ static void scarlett2_config_save(struct usb_mixer_interface *mixer)
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



