Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787661DF98F;
	Wed,  6 Nov 2024 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895285; cv=none; b=KMq9OrxeW+zfkxok8R7j0vpLffFJ4bwvBXanz+dsSpyECxwpXnMEkrf6PZICQy69bY8BJycKw9dDMFJ8unG/8rpLhft50AAaM6E57PBsTi4n7gT8iWRWiUZ2dwPEQ94YLJ6sMJO9xKOKhO9G4yEzlfnRHzqmTacm/XL/mVcaMlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895285; c=relaxed/simple;
	bh=2ITKlNkc6vB2MGANEGlXIiSqLvk+7fnWYGmE2Lnt1lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUmHJs9LFkhn+P0gnwfI4L0RplIkmshnzGZRjkelTURvcnNCq23nC+NfnggalXYtNM3xfgX+DZPY0XnxxHA9DxqtXg3cTXn/tuV8lpCUfEuM6qxFAterBmBpqVY0AirV8R+cVVldT3NHt+Z0gMoSDSCgjx4tRqXiHUKX4/J9aWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYmHqKuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYmHqKuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F080BC4CECD;
	Wed,  6 Nov 2024 12:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895285;
	bh=2ITKlNkc6vB2MGANEGlXIiSqLvk+7fnWYGmE2Lnt1lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYmHqKuJfy7qqTwvU92J1n6DQB+1am/SunrNR6BYH63MJF7Bg3XlsEw8dd7iEKXwa
	 d2B7lxQo5xo9EYcch3a8K+xux4xdEbnFTyEADUBpXit/pL/VJNwj47u/xDZ3EXlUhn
	 zql2FQUkLga3FPv7ycF/LTmy3D1AcTr3opmPbw5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 165/350] fbdev: pxafb: Fix possible use after free in pxafb_task()
Date: Wed,  6 Nov 2024 13:01:33 +0100
Message-ID: <20241106120324.998513026@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 90dee3e6f8bc7..f76da5c6c6cd6 100644
--- a/drivers/video/fbdev/pxafb.c
+++ b/drivers/video/fbdev/pxafb.c
@@ -2437,6 +2437,7 @@ static int pxafb_remove(struct platform_device *dev)
 	info = &fbi->fb;
 
 	pxafb_overlay_exit(fbi);
+	cancel_work_sync(&fbi->task);
 	unregister_framebuffer(info);
 
 	pxafb_disable_controller(fbi);
-- 
2.43.0



