Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4F51D3634;
	Tue,  8 Oct 2024 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394186; cv=none; b=V2wbgGQG6ELhul5HEEPMlNgesUHofJKe/lmnxqRnerusC9LmVPd9O6td850LDDFpywJDwgoin3kM/o4ZJOnES8EbnooOsmt/pc25LU9BNbAoN8ZuOboWCe198rW91Q9zhPSh+aRHiU43ygrcGqPoB/0JC6vb6Ni2E1uU98NQmWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394186; c=relaxed/simple;
	bh=thBHe263TsLvdcqOdLQFDjs65EOGAAmKt1ojegrIleU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lBoUufXktJPJbSeuElr0V/lmZr61IhLG2RfuSY3qWjm7awHrUANQEPtUMkNmzEC3CoG8oke22HFFcfbQPqEahnDUbaTSkComRPuJdBnfTrWXUh3Vu1SLrRw7QslxUg7RmUI039VGxcDqQ9+zdMAiq7oE7W8aj/1Qr/DJbn/TX+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xm8JI8nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xm8JI8nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A50C4CEC7;
	Tue,  8 Oct 2024 13:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394186;
	bh=thBHe263TsLvdcqOdLQFDjs65EOGAAmKt1ojegrIleU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xm8JI8nqUzuYRthJmACEZaty7RNJhj0Ff6rpsWWj43/mdBQVkcUET4IJNMv6du/K7
	 ZNwJWOhpq8C3H7xmct35DrHvQUti+6pQf3wT/uGCR9jSCZXHKg36sMP8LrcA8nRRZC
	 nFgMCvNlcjBqipi7t6hXnKRn4+XwdhQqa39YJBkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mads Bligaard Nielsen <bli@bang-olufsen.dk>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
	Robert Foss <rfoss@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 6.6 373/386] drm/bridge: adv7511: fix crash on irq during probe
Date: Tue,  8 Oct 2024 14:10:18 +0200
Message-ID: <20241008115644.065685502@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mads Bligaard Nielsen <bli@bang-olufsen.dk>

[ Upstream commit aeedaee5ef5468caf59e2bb1265c2116e0c9a924 ]

Moved IRQ registration down to end of adv7511_probe().

If an IRQ already is pending during adv7511_probe
(before adv7511_cec_init) then cec_received_msg_ts
could crash using uninitialized data:

    Unable to handle kernel read from unreadable memory at virtual address 00000000000003d5
    Internal error: Oops: 96000004 [#1] PREEMPT_RT SMP
    Call trace:
     cec_received_msg_ts+0x48/0x990 [cec]
     adv7511_cec_irq_process+0x1cc/0x308 [adv7511]
     adv7511_irq_process+0xd8/0x120 [adv7511]
     adv7511_irq_handler+0x1c/0x30 [adv7511]
     irq_thread_fn+0x30/0xa0
     irq_thread+0x14c/0x238
     kthread+0x190/0x1a8

Fixes: 3b1b975003e4 ("drm: adv7511/33: add HDMI CEC support")
Signed-off-by: Mads Bligaard Nielsen <bli@bang-olufsen.dk>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240219-adv7511-cec-irq-crash-fix-v2-1-245e53c4b96f@bang-olufsen.dk
(cherry picked from commit aeedaee5ef5468caf59e2bb1265c2116e0c9a924)
[Harshit: CVE-2024-26876; Resolve conflicts due to missing commit:
 c75551214858 ("drm: adv7511: Add has_dsi variable to struct
 adv7511_chip_info") in 6.6.y and adv7511_chip_info struct is also not
 defined]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1291,17 +1291,6 @@ static int adv7511_probe(struct i2c_clie
 
 	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);
 
-	if (i2c->irq) {
-		init_waitqueue_head(&adv7511->wq);
-
-		ret = devm_request_threaded_irq(dev, i2c->irq, NULL,
-						adv7511_irq_handler,
-						IRQF_ONESHOT, dev_name(dev),
-						adv7511);
-		if (ret)
-			goto err_unregister_cec;
-	}
-
 	adv7511_power_off(adv7511);
 
 	i2c_set_clientdata(i2c, adv7511);
@@ -1325,6 +1314,17 @@ static int adv7511_probe(struct i2c_clie
 
 	adv7511_audio_init(dev, adv7511);
 
+	if (i2c->irq) {
+		init_waitqueue_head(&adv7511->wq);
+
+		ret = devm_request_threaded_irq(dev, i2c->irq, NULL,
+						adv7511_irq_handler,
+						IRQF_ONESHOT, dev_name(dev),
+						adv7511);
+		if (ret)
+			goto err_unregister_audio;
+	}
+
 	if (adv7511->type == ADV7533 || adv7511->type == ADV7535) {
 		ret = adv7533_attach_dsi(adv7511);
 		if (ret)


