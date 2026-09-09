Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7986A5678EF;
	Wed,  9 Sep 2026 14:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963268; cv=none; b=d2p7x0z8fgilgZF3tozGLI0ZSxTWBHzI3a815pT39siUV+OCuySbdCYgEPjmF8qaXYFRYckB75YUAIIU9UiQwaUnJXYwjJQH/d3p0OsygyVOZSYTsoXFKMUpJhsjYqrCN1n3w2Ce2pqYWFm6Mf2ZI08GJXyL0wcRRcaboGmo5Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963268; c=relaxed/simple;
	bh=SIiBop4xo9NiJM1Hetl+JpvEkr8Ebh6Yp4BHG8fKHG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjAUwCybzyJMfOODIiRez6myr3TZKKqRlljOPg9QS6bevvR3fjPFyy6U2GGvwi/TlIUsU419yzfkh2bmF93heHOYg0mOOEeiin+spHt524onfseW+LgvKzaEOPXIwpDoutb4xm4Pt3rK/OBcha9iFBNmY1ErCe8AHMEctVcgovQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BphQtj9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BphQtj9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E361F00A3A;
	Wed,  9 Sep 2026 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963267;
	bh=4stgDi8KQ3uQvu3P6XkyJIWLX6tOiTioZe8vWnT26VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BphQtj9LxLwyDHiWqcx0Y6bFxfjhxm0LwgLGIaTsDnsOsS5+DtOolqpj54m0oKZNo
	 GEGAeRWG/sLe2CAgGJnpAs+29Rr4IUUbXm3sdjke3ywcc9fmKnlbEad6rnI1fu9ZVK
	 7kXC7TwwuiqDvuucN+tGHzkqO+pPlQq5JZx0ptTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.18 020/583] usb: storage: realtek_cr: fix use-after-free on disconnect
Date: Wed,  9 Sep 2026 15:35:05 +0200
Message-ID: <20260909134238.522296630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


