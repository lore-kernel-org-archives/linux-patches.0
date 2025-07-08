Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554588F5E;
	Tue,  8 Jul 2025 16:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993944; cv=none; b=TtiSXO9nKYWc+f9QRGnRNnLQrzpAUi/hsDxYYZIYQKtu67wxuEKglT+8CnS6sREx56woryVnZmK73bpTmlaHyY3a4b9fjdAHgI+E8qb2d2nTc53DMNz/vXvkBQzhgLk7sJLN/Db8cEonfqPe2qJ0FqkRL0ITmHizEnAUNLKQbAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993944; c=relaxed/simple;
	bh=ARySHLK5RF5iq+EY5Ji5WtGnIZVW+bEraYjCtUm5hUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDn7NL4DS9zTsQLQd/nQzW6vu4AdQ6z341EX9ySC/DAIF+887e0/HmBDqEXTPDASBHQymSqeH/TXly5Ues6psGiaV5QlZJnNtMvllSYLVp8BapPCSHHLSZzYaJN2zSjaqhFJfLPVdT/BYOmMv0QMDuUbRDUgjl/K10rZeHkD3H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4uRzm2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4uRzm2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A709FC4CEED;
	Tue,  8 Jul 2025 16:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993944;
	bh=ARySHLK5RF5iq+EY5Ji5WtGnIZVW+bEraYjCtUm5hUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4uRzm2JUMg7J9vbjWFesUt79DH7yqs2h4woJ9IQCWBzuYuktinOzp5SIC7qMiFyL
	 IC/9sRhG7o2wdWs4kGNR27nhUTqpKO0CJ38b4Qifsr46hEtaX4dYt8DiZhi8tCNZy5
	 pf0+F4Lv/NVhVnAEH4Ci2MU2bKAaiQfR3WdruKzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Claudio Suarez <cssk@net-c.es>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Du Cheng <ducheng2@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Zheyu Ma <zheyuma97@gmail.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Xiyu Yang <xiyuyang19@fudan.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/160] fbcon: use lock_fb_info in fbcon_open/release
Date: Tue,  8 Jul 2025 18:21:19 +0200
Message-ID: <20250708162232.702340639@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 04933a294dacca3aaa480889d53e6195778d4578 ]

Now we get to the real motiviation, because fbmem.c insists that
that's the right lock for these.

Ofc fbcon.c has a lot more places where it probably should call
lock_fb_info(). But looking at fbmem.c at least most of these seem to
be protected by console_lock() too, which is probably what papers over
any issues.

Note that this means we're shuffling around a bit the locking sections
for some of the console takeover and unbind paths, but not all:
- console binding/unbinding from the console layer never with
lock_fb_info
- unbind (as opposed to unlink) never bother with lock_fb_info

Also the real serialization against set_par and set_pan are still
doing by wrapping the entire ioctl code in console_lock(). So this
shuffling shouldn't be worse than what we had from a "can you trigger
races?" pov, but it's at least clearer.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Claudio Suarez <cssk@net-c.es>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Du Cheng <ducheng2@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Zheyu Ma <zheyuma97@gmail.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Link: https://patchwork.freedesktop.org/patch/msgid/20220405210335.3434130-13-daniel.vetter@ffwll.ch
Stable-dep-of: 17186f1f90d3 ("fbdev: Fix do_register_framebuffer to prevent null-ptr-deref in fb_videomode_to_var")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 5 +++++
 drivers/video/fbdev/core/fbmem.c | 4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 734b8f3f81b24..072a264ae380b 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -693,8 +693,10 @@ static int fbcon_invalid_charcount(struct fb_info *info, unsigned charcount)
 
 static void fbcon_release(struct fb_info *info)
 {
+	lock_fb_info(info);
 	if (info->fbops->fb_release)
 		info->fbops->fb_release(info, 0);
+	unlock_fb_info(info);
 
 	module_put(info->fbops->owner);
 }
@@ -706,11 +708,14 @@ static int fbcon_open(struct fb_info *info)
 	if (!try_module_get(info->fbops->owner))
 		return -ENODEV;
 
+	lock_fb_info(info);
 	if (info->fbops->fb_open &&
 	    info->fbops->fb_open(info, 0)) {
+		unlock_fb_info(info);
 		module_put(info->fbops->owner);
 		return -ENODEV;
 	}
+	unlock_fb_info(info);
 
 	ops = kzalloc(sizeof(struct fbcon_ops), GFP_KERNEL);
 	if (!ops) {
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index d938c31e8f90a..f4253ec8a6409 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1700,9 +1700,7 @@ static int do_register_framebuffer(struct fb_info *fb_info)
 		console_lock();
 	else
 		atomic_inc(&ignore_console_lock_warning);
-	lock_fb_info(fb_info);
 	ret = fbcon_fb_registered(fb_info);
-	unlock_fb_info(fb_info);
 
 	if (!lockless_register_fb)
 		console_unlock();
@@ -1719,9 +1717,7 @@ static void unbind_console(struct fb_info *fb_info)
 		return;
 
 	console_lock();
-	lock_fb_info(fb_info);
 	fbcon_fb_unbind(fb_info);
-	unlock_fb_info(fb_info);
 	console_unlock();
 }
 
-- 
2.39.5



