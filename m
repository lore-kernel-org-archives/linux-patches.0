Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E481A477984;
	Wed,  9 Sep 2026 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961710; cv=none; b=TE6zuRqeJDQ6kCm+/vpGh5BGjHmg81fKy6Fg3MsGALSos/f9WuNspavFSn/yTpWAab9ZAnn/fr2AUSwqfku7SsaYpi0NwRvfD9jC8aRHxnnYsEiy0J0lwT1u36Ppko2nofkE4PryQVS3lNPBgNWFNsx73cfezktlRnd269rPNRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961710; c=relaxed/simple;
	bh=xfPiOjNrvkGI88j8xYsXyAwWPN5J0WI7L7VIdZy+uc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oO5Wgl1dQlh/SN9oDo/oKTO4K5m0V6Qy5PIU2pw7euKVneoRauaE63DeLYPJ66SYToHWGXhbAuq2DEDsbZDSSheF3Fmr9kYFk2+e0lhw+OSlYAmhl3CudglstLxuTv0f1U0Flk6xiHx1BiDlv8vLaK/lY2X5nWSccTdwamyBej0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVU89AkW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVU89AkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DC81F00A3D;
	Wed,  9 Sep 2026 13:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961708;
	bh=EyMKYeANZcJaKoOGkWXgHSUwiivf6Mf5AY180hmyulQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVU89AkW4Xr2/yo/ru7oW5a9dLkaX9vs9fEx5OO0thWo7ifUc89dXSAVSD81UZ4bK
	 JzbJccVBgyxqVV08A4/o5/k0lTBFtzjxuNll4T19h/kmZ2dufkhhpUz327fnYVKwLT
	 avKCXxiAAFYKD5Ny/a7ja6rbzCYUhWNzEbAlquF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 7.2 034/556] usb: storage: realtek_cr: fix use-after-free on disconnect
Date: Wed,  9 Sep 2026 15:35:14 +0200
Message-ID: <20260909134231.701381628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 4ffee1aebb0c0ffcda9faffd17834ea9b00d42cc upstream.

realtek_cr_destructor() calls timer_delete() before the chip containing
the timer is freed. The timer callback may still be running and can
rearm itself, resulting in a use-after-free.

Use timer_shutdown_sync() to wait for the callback and prevent further
rearming. Do this unconditionally because ss_en may be changed after
the timer is armed.

Move timer_setup() into init_realtek_cr() so the timer is initialized
before any failure path can invoke the destructor.

Found by static analysis.

Fixes: e931830bb877 ("Realtek cr: Add autosuspend function.")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260727123414.44700-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/realtek_cr.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -916,7 +916,6 @@ static int realtek_cr_autosuspend_setup(
 	us->proto_handler = rts51x_invoke_transport;
 
 	chip->timer_expires = 0;
-	timer_setup(&chip->rts51x_suspend_timer, rts51x_suspend_timer_fn, 0);
 	fw5895_init(us);
 
 	/* enable autosuspend function of the usb device */
@@ -934,10 +933,7 @@ static void realtek_cr_destructor(void *
 		return;
 
 #ifdef CONFIG_REALTEK_AUTOPM
-	if (ss_en) {
-		timer_delete(&chip->rts51x_suspend_timer);
-		chip->timer_expires = 0;
-	}
+	timer_shutdown_sync(&chip->rts51x_suspend_timer);
 #endif
 	kfree(chip->status);
 }
@@ -982,6 +978,9 @@ static int init_realtek_cr(struct us_dat
 
 	us->extra = chip;
 	us->extra_destructor = realtek_cr_destructor;
+#ifdef CONFIG_REALTEK_AUTOPM
+	timer_setup(&chip->rts51x_suspend_timer, rts51x_suspend_timer_fn, 0);
+#endif
 	us->max_lun = chip->max_lun = rts51x_get_max_lun(us);
 	chip->us = us;
 


