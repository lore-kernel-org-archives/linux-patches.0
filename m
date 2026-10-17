Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F10B3AEF36;
	Sat, 17 Oct 2026 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255784; cv=none; b=bCb4o4S33cPjQA4lrIlZCdmM+8PiANl9AtM3nEMPYwqkU0/k8wEgsBEEILEtfwE+wjdkd0Oa+PFaAkUUR7JQNPc/knO5gbefQgmpQyuDM+nz/YSRZ0Jzs62KKfsdn1I1R6uEx7PcmLhB+sSXJX5oJxfBz+x7S///zGtDlo3ugh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255784; c=relaxed/simple;
	bh=fDCgMSgVY6wwHUCDeD9ijfdEZrWuZmD+R78oj5XF490=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eb2cGpnCKei3sAeQ5/NamJqpSCJ/ClUzlMir9sKupaFI3DEwfjOTvPa0V79ZuMYJWrnOlG3vU9Uh4SnLld54gCQuTpKOJaWCzxxhpiEWfbDClf4Vydnloqm/h9dlyVBRpVc1QAd6h/8sslzS3r+SI3ewEH+Oq6qTDoi7wwvzlSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9GvgGnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9GvgGnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A668C1F000C4;
	Sat, 17 Oct 2026 16:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255783;
	bh=j5W5qb/kR+OvfLbnpzLBA9lgXIYEKJg4Hfi/zhwmuM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9GvgGnfeKzKHDrqqsQXitTMG3wgT3QdZAKfnV6PNQz1JWD7SnPYjlDL0vUGYquZG
	 Ut7+HwAzn66JCbpWRx2gHwKt9/tLEeUC8+7g5rzYHyO/stlW5LPdkh7kie1mmup8cn
	 +F7ZlDWIiQUJji1B0jVA8dlAQFECr0zvZhzSabyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0020/1674] usb: storage: realtek_cr: fix use-after-free on disconnect
Date: Sat, 17 Oct 2026 17:38:12 +0200
Message-ID: <20261017160431.660270503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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



