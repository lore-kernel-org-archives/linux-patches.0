Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954B935965;
	Mon, 27 Oct 2025 19:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592281; cv=none; b=FYM4ck89DNqUiM9rghG8n4zcWa8AsNsvdP1PhpdCxDUAe0+611LJx2rWTzoOLO/p37Hkt6fLBIpJC7zON8G4k/dDhSYDYm2w1SFi5hEHZL7OKQAZvjkj0v6WnYjUOA9gEKNTn+giijYt1BvaBaB9WpBLgCkIpFlPKZI1ZttWijI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592281; c=relaxed/simple;
	bh=D6DPpPviPX+tSCYrGURb8flm0sD1YSwhNhe+3vwecr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrxg4N2zWfYkyaKR3BARpdRuMB3Ra2eAQy2Sc1SjlIkVZVQZ1H4JdDTBIeUg7Xs5xVB3kIIRoQHBxZvnP/Ngs9A6Q62+17Z1iSoLVg3ZxVxaNRBST6VhfY46AIRXxkfuNpJLnuDMbEuHXCxAWVgIJ12XFLmah6/nwRxTV3CXTnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YihzqGEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YihzqGEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27572C4CEF1;
	Mon, 27 Oct 2025 19:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592281;
	bh=D6DPpPviPX+tSCYrGURb8flm0sD1YSwhNhe+3vwecr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YihzqGEO+79fY7IiyeD4728QIQ1hWiKoCpH2J9Je17zCwJdjTa9d/4YkT9cMhMlot
	 7U6pVVjOTcHGDjJbcT0NnXpGmJPeb+PiGkGWXX2l598Y5Jq/XFmGTL9AEf20WdKo7U
	 Zu5zem7l2C1bL+Imx2pGFXARVG+fbjmRX+j4FL8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/157] ALSA: usb-audio: Fix NULL pointer deference in try_to_register_card
Date: Mon, 27 Oct 2025 19:35:23 +0100
Message-ID: <20251027183502.947970704@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5f539a1baef3d..d7fe1c22a48bb 100644
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



