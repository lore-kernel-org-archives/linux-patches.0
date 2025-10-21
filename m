Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD48D1E1E04;
	Tue, 21 Oct 2025 20:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076955; cv=none; b=QA5bARuGfkSjsmL/5UJfVblQgXNNx1cikjwqjUJsO0RmvZ1T0u8GqAIIZVc+oX3Z5TeXyRVEWBAqF1gZvI83knqvvi5VxO6ku2m7+fe6IhWC53PsgcQv7n6CrC0z0VKdb7ZIhLJ+qwKGIxj09DhkzC1cW6xAEcMmh4qGzIY5GGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076955; c=relaxed/simple;
	bh=MVlwPOadfulU0D4MQGgTLSAZOTfR1xqpziCWriNZJ88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+yLBzBrsK1HWmlWqMLcaf7vuXTcw8ow506ZiMWWdJuHVvaTvTKGv2fjPcK5O3iGFxJ2l2X2rAwnbhUSW7Ift6AzrzZjOUJ4BwcbGUF6hE+0Djg6GpnGV3wHsg2wW25GpeNKtuVJKeMOCclFASMHlN2jpAkumH+cY0Ub5nuTz6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isQUq5L4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isQUq5L4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E308BC4CEF1;
	Tue, 21 Oct 2025 20:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076955;
	bh=MVlwPOadfulU0D4MQGgTLSAZOTfR1xqpziCWriNZJ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isQUq5L4QZMhCTwoOVvLvHCM5GuvUOEwCJlkXAoH5S2704iIH2iPXXBdqT7h0aYOv
	 c1PFrD9qc9opw6pE136IEsF5j6hWm5PSJ+75+eGLgN6bCqXXWTHS7bQ7wRJ+uMh7qt
	 BegvGeFYrM68bhD8D18OWZdz4W3IeWoXuCpoxbVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/136] ALSA: usb-audio: Fix NULL pointer deference in try_to_register_card
Date: Tue, 21 Oct 2025 21:51:16 +0200
Message-ID: <20251021195038.079959034@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9c411b82a218d..d0a42859208aa 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -760,10 +760,16 @@ get_alias_quirk(struct usb_device *dev, unsigned int id)
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



