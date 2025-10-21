Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74586273D9A;
	Tue, 21 Oct 2025 19:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076540; cv=none; b=hzyfukC9P62MZ6bgt5ZgkgbiOoFYep3/8ziQ6U1rzTT/Q82ZZmr6TUXKvErqTlR0ZYY9/IT82Tiz4gthmJgESEUa/A9ZalCQGbcOvmLFNnigqmLBuv9aEVBThdt7+qMdIy6ewycU84nsbunuy15sk2prJ1uSSp0YJDdRiXtWcXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076540; c=relaxed/simple;
	bh=Biyv34mINv1f8qHCOs+26c07ewlyCPSDwNS+RddYLdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNZLJXk+884GjnJmVLPDlFgMS2Yk6yPyqP4agz1HvL74afZEpZVdArArzUC/5t6JzAMmCr5gEZpuW8sbW4EIfMjeEsVZHDZktRSP+89z5PWFYm5Ce0veUcdWGsOEVkqSklRdw6RyzpAINBNR/LtNtJiBnTIoLRqtrZAUtEJgr1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBtUjdkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBtUjdkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02128C4CEF1;
	Tue, 21 Oct 2025 19:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076540;
	bh=Biyv34mINv1f8qHCOs+26c07ewlyCPSDwNS+RddYLdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBtUjdkfAkrVJ2LmtflSH/PTNMYpPb52vKc+mDrTNzEqbZzLbnkjrd4ON35H+rZSN
	 tEe/3/LkkE1TTHUTbwPdMKglKTHuPGVt1kAFiAlgLQuz/9uvtJ2tnDPZSuTQungIai
	 NWvVYsuFg5Y2vetiKYnuDUrFK62/gPCLXhUoCkGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/105] ALSA: usb-audio: Fix NULL pointer deference in try_to_register_card
Date: Tue, 21 Oct 2025 21:51:16 +0200
Message-ID: <20251021195023.257013360@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7743ea983b1a8..9335bc20c56df 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -754,10 +754,16 @@ get_alias_quirk(struct usb_device *dev, unsigned int id)
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



