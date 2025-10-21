Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DC227587D;
	Tue, 21 Oct 2025 20:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077513; cv=none; b=aZ4icaIDo7/g7/lSUlLptVBH36j7xUW4BnxhaLxBfFQFDmSiT0wjKRKR/xISbxpEmBRGCgER8jayt/7Yl5vhIGX2bjTPVKhXqmgCcrtNkq891BMSazXZP3m4K5yx6274FUVD+oTzw6DujNwOKzM807pTAkKrk5RBHbNJILycv9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077513; c=relaxed/simple;
	bh=1ObQ7JOpxbbIOY2uAh4ySuWzdqkdGdGJls9LzQm4/BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVVBDssykvsrxPaw9isWgU/vbCak7QnN8Cmx4eMBK9TjZyWoU0ImM1PJxr/4YIiUg688FYybVxyXzVABCpXg8risn09py8flsmcHv25n5PBqTATYb7f/z9b8gfDIjwjBacQDYKfLpfMsZAdkIvIARwwVmTHL0K1Jtls2GCrUHSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xyxx1L9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xyxx1L9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360AFC4CEF1;
	Tue, 21 Oct 2025 20:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077513;
	bh=1ObQ7JOpxbbIOY2uAh4ySuWzdqkdGdGJls9LzQm4/BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xyxx1L9J4NGIHwaiNVAIrnThGhmxf0W5noGK6H+D7TXL6LLg8u1rHSj8K6uMjGEME
	 DOCCKw1LAIvHrOp0Eivh5girc1ll+PefIBpXhaxPIausNr6mjz6Q2HSPv+teKwYN9z
	 9s9HN2t8a4K+hK/FjZsRbUw0kmMlOx5wdDoNIPKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 127/159] ALSA: usb-audio: Fix NULL pointer deference in try_to_register_card
Date: Tue, 21 Oct 2025 21:51:44 +0200
Message-ID: <20251021195046.206429623@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 10d9b72855970..557f53d10ecfb 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -850,10 +850,16 @@ get_alias_quirk(struct usb_device *dev, unsigned int id)
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



