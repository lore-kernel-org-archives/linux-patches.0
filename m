Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034DD330D47;
	Mon, 27 Oct 2025 19:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591889; cv=none; b=VSMWwMXL7yP70+xYl/CCkJoOPbKOjE7W7hADkZPSGQhJVch8qq2eDNo2LOOCO+QbxFJiPI3OD4AfB8gcrURcDG0a/aNpcP68yhlTTXiKIzUdjg/lDUUPwLi1E396G/OkxivcEU2gG/AZUj74RWYVxAd2zAV08w8tizy67OX+17Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591889; c=relaxed/simple;
	bh=KRp+sjnQBJGiec2Pg+3B/Rlxct92N0s/bzVG+QQpI8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCcmrJskXo64nQRZucbPEHg4zhgO4UGTWuo0ZLxSS02OSuuGshVm95JUOLrZfp/2gfJ9BIets0w2v/udv1cou9uq0KGSuytI9IRFLWJkM+vP3hJpgCqx4XH6JtrOgP2QblOcb2R6U/8PyIaFTghqfUAS4DTNya7CoWCrI+Fmzsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQz7BATi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQz7BATi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCF0C4CEF1;
	Mon, 27 Oct 2025 19:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591888;
	bh=KRp+sjnQBJGiec2Pg+3B/Rlxct92N0s/bzVG+QQpI8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQz7BATip2I1UkNUOCzbemUi4cuY7vquRckNWApQCTmOUa6jSmdvLgG5Rzi4cVBXI
	 x/H19yhYgrdHVav0WtYu7Ii7GlwIgHTsgJ72TaL+sUuX57URqHCr2573XQHLOrceXZ
	 Hb0u+jsd0VmXM0Oa4yAbRPVAAKgSAfAZB6AynF5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/123] ALSA: usb-audio: Fix NULL pointer deference in try_to_register_card
Date: Mon, 27 Oct 2025 19:35:17 +0100
Message-ID: <20251027183447.394030296@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit 28412b489b088fb88dff488305fd4e56bd47f6e4 ]

In try_to_register_card(), the return value of usb_ifnum_to_if() is
passed directly to usb_interface_claimed() without a NULL check, which
will lead to a NULL pointer dereference when creating an invalid
USB audio device. Fix this by adding a check to ensure the interface
pointer is valid before passing it to usb_interface_claimed().

Fixes: 39efc9c8a973 ("ALSA: usb-audio: Fix last interface check for registration")
Closes: https://lore.kernel.org/all/CANypQFYtQxHL5ghREs-BujZG413RPJGnO5TH=xjFBKpPts33tA@mail.gmail.com/
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index bec6d41a143d2..33ffa62032ab9 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -753,10 +753,16 @@ get_alias_quirk(struct usb_device *dev, unsigned int id)
  */
 static int try_to_register_card(struct snd_usb_audio *chip, int ifnum)
 {
+	struct usb_interface *iface;
+
 	if (check_delayed_register_option(chip) == ifnum ||
-	    chip->last_iface == ifnum ||
-	    usb_interface_claimed(usb_ifnum_to_if(chip->dev, chip->last_iface)))
+	    chip->last_iface == ifnum)
+		return snd_card_register(chip->card);
+
+	iface = usb_ifnum_to_if(chip->dev, chip->last_iface);
+	if (iface && usb_interface_claimed(iface))
 		return snd_card_register(chip->card);
+
 	return 0;
 }
 
-- 
2.51.0



