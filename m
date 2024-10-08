Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784851DEFE3;
	Tue,  8 Oct 2024 12:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390113; cv=none; b=i/SpjoRkqoBQouxD4deQOgg7Y2ngVMgTlG8lFvhzEAXw+yAIwm54T/VjScADOcDge8HFVZGlEdVaEub/4pFtAM45kLon8XJW0Kvw3W27pm2hRR2uOrDLQN4Z+WJChm248xEJOO0WFK/Fe0+vS7CsSvP/9bZ+i8TUU6ujqRULIns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390113; c=relaxed/simple;
	bh=xjCYzuOfGregGM5uFsDYzphNKPve6BK5rU73xXT6zdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QArR1hdB29lBrA2BU/EL1bFuVvJ0PrU1Lmvyd6B2V6yVk9zgZqEX43ezy3L3idbvgD72qPQ8qfaRa0mIgg4yw5SM9T9Q8f0iu1farzl/Q6RyyOE2+2iYTNAyomuBxA/zcgu26cTLmRal+IAfGGEU4g1qyoM+bFgFL97hSXACrvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vfo2YSg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vfo2YSg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED03AC4CEC7;
	Tue,  8 Oct 2024 12:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390113;
	bh=xjCYzuOfGregGM5uFsDYzphNKPve6BK5rU73xXT6zdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vfo2YSg/6YPg+83anlJcDuINmarpvd63NoZkIjwUm2GI9ERKeGXjplm7m7AknGnD+
	 cNcMXRrj62uONg0e/9FxjEQZn4+syE5+MIZIIrHpKxnFqpBtXRh6RJqlcolZ2gH5xk
	 YfDWuu46VIl5lQgRwJxsBTrV8+QSLkLATpBSDQfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 163/482] fbdev: pxafb: Fix possible use after free in pxafb_task()
Date: Tue,  8 Oct 2024 14:03:46 +0200
Message-ID: <20241008115654.719860558@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixin Wang <kxwang23@m.fudan.edu.cn>

[ Upstream commit 4a6921095eb04a900e0000da83d9475eb958e61e ]

In the pxafb_probe function, it calls the pxafb_init_fbinfo function,
after which &fbi->task is associated with pxafb_task. Moreover,
within this pxafb_init_fbinfo function, the pxafb_blank function
within the &pxafb_ops struct is capable of scheduling work.

If we remove the module which will call pxafb_remove to make cleanup,
it will call unregister_framebuffer function which can call
do_unregister_framebuffer to free fbi->fb through
put_fb_info(fb_info), while the work mentioned above will be used.
The sequence of operations that may lead to a UAF bug is as follows:

CPU0                                                CPU1

                                   | pxafb_task
pxafb_remove                       |
unregister_framebuffer(info)       |
do_unregister_framebuffer(fb_info) |
put_fb_info(fb_info)               |
// free fbi->fb                    | set_ctrlr_state(fbi, state)
                                   | __pxafb_lcd_power(fbi, 0)
                                   | fbi->lcd_power(on, &fbi->fb.var)
                                   | //use fbi->fb

Fix it by ensuring that the work is canceled before proceeding
with the cleanup in pxafb_remove.

Note that only root user can remove the driver at runtime.

Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pxafb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/pxafb.c b/drivers/video/fbdev/pxafb.c
index 2ef56fa28aff3..5ce02495cda63 100644
--- a/drivers/video/fbdev/pxafb.c
+++ b/drivers/video/fbdev/pxafb.c
@@ -2403,6 +2403,7 @@ static void pxafb_remove(struct platform_device *dev)
 	info = &fbi->fb;
 
 	pxafb_overlay_exit(fbi);
+	cancel_work_sync(&fbi->task);
 	unregister_framebuffer(info);
 
 	pxafb_disable_controller(fbi);
-- 
2.43.0



