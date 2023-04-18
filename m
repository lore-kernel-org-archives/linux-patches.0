Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AD92572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0421C4339E;
	Tue, 18 Apr 2023 12:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821746;
	bh=76JEB8B+ffeW5lKj1shZ3Oh+S8yHioOzXCNOOvpndbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOhFEuOujoIN2v2mBPkRnKsmkPFLUsw/Bd8WbpP9HusCFoLLS81Lj5qL+KN/O7D+0
	 HBodDML2Qu5B3+G1UjBQDNOnb3xyFTO5ATOYb+WYsFGE54dXHE79Vivsj55xGuK2CE
	 fC4hK/2O3ESMML7RSdnZRvun34fWZyJx84u3ooZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel.vetter@intel.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Xingyuan Mo <hdthky0@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 6.1 026/134] fbcon: set_con2fb_map needs to set con2fb_map!
Date: Tue, 18 Apr 2023 14:21:22 +0200
Message-Id: <20230418120313.914678771@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit fffb0b52d5258554c645c966c6cbef7de50b851d upstream.

I got really badly confused in d443d9386472 ("fbcon: move more common
code into fb_open()") because we set the con2fb_map before the failure
points, which didn't look good.

But in trying to fix that I moved the assignment into the wrong path -
we need to do it for _all_ vc we take over, not just the first one
(which additionally requires the call to con2fb_acquire_newinfo).

I've figured this out because of a KASAN bug report, where the
fbcon_registered_fb and fbcon_display arrays went out of sync in
fbcon_mode_deleted() because the con2fb_map pointed at the old
fb_info, but the modes and everything was updated for the new one.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Helge Deller <deller@gmx.de>
Tested-by: Xingyuan Mo <hdthky0@gmail.com>
Fixes: d443d9386472 ("fbcon: move more common code into fb_open()")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Xingyuan Mo <hdthky0@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -846,10 +846,11 @@ static int set_con2fb_map(int unit, int
 		if (err)
 			return err;
 
-		con2fb_map[unit] = newidx;
 		fbcon_add_cursor_work(info);
 	}
 
+	con2fb_map[unit] = newidx;
+
 	/*
 	 * If old fb is not mapped to any of the consoles,
 	 * fbcon should release it.


