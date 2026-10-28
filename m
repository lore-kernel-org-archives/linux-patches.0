Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210404;
	b=DNeU3HRYdjCrCC6K4GoRl3HsYp1rfZkQpD8JDwu0BVYWYd2TLGSe9OIpYV59r/+c40CE
	 8d4j3UYGsHTi8S2BIfE9MOntdgGdQtJcMyB5pIfVwA0bm6SXdVumQ5BCZfff51dtNWsSz
	 3ZMvZjpgDTtO0FzE/GR4eKDCPaCCKkleO3uLwmX+JxVqa1bp0gAUlF4PJLB7GSeKHfDT7
	 ClCFsBnzjsWGitybAhlG8Kfu3HEokBHjq7a76jAD+r2384UhGprrMOP+4GZJ3ffsLIvMX
	 4dNHHfYyAI8VwCJ9HNBw96FLa6ab+idlx+9AtcacXAvl5OdZs/afB4Tl0FEXgyktNiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=soV3O/w20qlUiiYsFaXLs9lbv4wQ+/3+D8fVC4H55U0=;
	b=n9LkRZuR48kekFjHqaNWc6pbRJ0Ez+QTy/cKwFfZA+HYD3ZcRXMqG8J5ziXtfW7iRt0l
	 NYBlC5Tb7u4T/B0xjm3XrTGgNjUwfaOXgx0uT6BnHApNvxJJFvZezZm0LYzg/439mbWXB
	 VqgGW3TW0i5O/UvrViSin0DU0KnSRFhsBJfnNu4xk0PqdNaQ1RbDei/K/gMfV8aGY0K9v
	 kruMBGuFTAuO/iTPXfzPezsKy6bg7bKYPDh4D1Rtw5sNaAmBUTlfmJeutwmq1oocMeXVW
	 rzg/KwDkDN1Vun5KUBYthFzXnE8cHLyT5n873+eCl/i9OBifm9h36o5R9FWFUmYShgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PAoZJU/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFA5606A31F;
	Wed, 28 Oct 2026 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PAoZJU/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353701F01825;
	Wed, 28 Oct 2026 18:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210403;
	bh=soV3O/w20qlUiiYsFaXLs9lbv4wQ+/3+D8fVC4H55U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PAoZJU/gD7Vr1thh28vu4Itqq3jqsoQ+LjU26KMW0gsCYfTaEFsnElO/eOWF8ir2a
	 PnLlNJgwTGb6LnKXkPBDc5yq4hDrxwdjb7iUrgj7LXRxhlHJlb7qPZUyEeZoKCZhtI
	 FM/cvgnVWlZrhZg/bNR0u8KMz8UV00+DZeJkt6xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/571] usb: storage: realtek_cr: fix use-after-free on disconnect
Date: Wed, 28 Oct 2026 17:52:42 +0100
Message-ID: <20261028170008.383144652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 4ffee1aebb0c0ffcda9faffd17834ea9b00d42cc ]

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
[ adapted the timer_delete() removal to the branch’s del_timer() spelling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/realtek_cr.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index a026c6cb6e684..de82d8260d729 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -915,7 +915,6 @@ static int realtek_cr_autosuspend_setup(struct us_data *us)
 	us->proto_handler = rts51x_invoke_transport;
 
 	chip->timer_expires = 0;
-	timer_setup(&chip->rts51x_suspend_timer, rts51x_suspend_timer_fn, 0);
 	fw5895_init(us);
 
 	/* enable autosuspend function of the usb device */
@@ -933,10 +932,7 @@ static void realtek_cr_destructor(void *extra)
 		return;
 
 #ifdef CONFIG_REALTEK_AUTOPM
-	if (ss_en) {
-		del_timer(&chip->rts51x_suspend_timer);
-		chip->timer_expires = 0;
-	}
+	timer_shutdown_sync(&chip->rts51x_suspend_timer);
 #endif
 	kfree(chip->status);
 }
@@ -981,6 +977,9 @@ static int init_realtek_cr(struct us_data *us)
 
 	us->extra = chip;
 	us->extra_destructor = realtek_cr_destructor;
+#ifdef CONFIG_REALTEK_AUTOPM
+	timer_setup(&chip->rts51x_suspend_timer, rts51x_suspend_timer_fn, 0);
+#endif
 	us->max_lun = chip->max_lun = rts51x_get_max_lun(us);
 	chip->us = us;
 
-- 
2.53.0



