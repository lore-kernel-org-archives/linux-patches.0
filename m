Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D043A3B8BBB;
	Sat, 17 Oct 2026 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257321; cv=none; b=XX+1QUQhS1hsYuInNsXaf4luriBHy2w0UOzwAXbqiJ6dc1ot4yuqZs8jC7kGAebRP6Wf+3+cT5GeTGBHlZE6w/S6XcQkREbQ4+khf6OwJReB+r0pXcAN8K7nlkVwi9E77+lNwd0egaukV4BHE8JmXYt7UYyHrLky/VliXsD1idU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257321; c=relaxed/simple;
	bh=5DZlHAmH4NC8YyoyFIWz1t7dDmZ9cdsAXT7llamHLQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rigvN1Dz+vhGMYsUY+ONqxU9lEiGVMDofw2TZjMi2kWdDN6wqCjgjFpcIaPPDP6q98nt72ccKvrcm9PaFymoc/srVCURTBkpKyoyQkLOBYRJUNyeEUWQLGpBZdsYBD4BG22vPdw1Q0SoTgk4WYZ3sqnTS0Ysmd2JmARaQunYL3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dn6yz1qt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dn6yz1qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4C31F000C4;
	Sat, 17 Oct 2026 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257320;
	bh=6cSgUetJ1dZ676F/TzB3/FpaG+y5I4tA5L4pcRYYXBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dn6yz1qthFXbCIgxh7dNOL4kXSHutKAdwILuuD72hlD/8RBpyEWULE2sj4wAmEW3A
	 m4u1k9AHnU0uREzM/9MTmzh579l4iCeWBcYpSX7uX9FnVtt1kXDYKQBduIOBQYaJSY
	 2MZL6SCMacsr4xGhkOUMPjLYrpwod1nN4wkEnUDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ca23c8570669ead78867@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.6 0520/1674] drm/fb-helper: defer setup when fbdev_probe() fails, not just on -EAGAIN
Date: Sat, 17 Oct 2026 17:46:32 +0200
Message-ID: <20261017160444.454518937@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

commit 755c94d178b7e972bb766199d34e4ba4f63a89eb upstream.

__drm_fb_helper_initial_config_and_unlock() calls
drm_client_modeset_probe() first, which already fills in each
mode_set->mode/num_connectors for every connected output, and only
afterwards calls drm_fb_helper_single_fb_probe() to create
fb_helper->fb and wire it into those mode_sets via
drm_setup_crtcs_fb().

If drm_fb_helper_single_fb_probe() fails with anything other than
-EAGAIN (e.g. dev->driver->fbdev_probe() itself fails), the function
bails out before drm_setup_crtcs_fb() runs and before setting
fb_helper->deferred_setup. The client is left with mode_sets that
have a mode and connectors but mode_set->fb == NULL, and nothing
marks this fb_helper as needing a retry.

__drm_fb_helper_restore_fbdev_mode_unlocked() only skips committing
when fb_helper->deferred_setup is set, so a later .restore() call
(drm_lastclose() on process exit, in this report) commits the stale
mode_set through drm_client_modeset_commit() ->
drm_client_modeset_commit_atomic() -> __drm_atomic_helper_set_config(),
which hits WARN_ON(!set->fb).

Mark fb_helper->deferred_setup on any drm_fb_helper_single_fb_probe()
failure, not just -EAGAIN, so restore keeps skipping the commit until
a later hotplug event successfully re-probes and re-populates
mode_set->fb. The real error code is still returned to the caller
unchanged.

Reported-by: syzbot+ca23c8570669ead78867@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ca23c8570669ead78867
Fixes: ca91a2758fce ("drm/fb-helper: Support deferred setup")
Cc: stable@vger.kernel.org
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260927075434.72658-1-ngocthang2710.1999@gmail.com
Link: https://patch.msgid.link/20260917154743.1621-1-shechenglong@xfusion.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1837,10 +1837,10 @@ __drm_fb_helper_initial_config_and_unloc
 
 	ret = drm_fb_helper_single_fb_probe(fb_helper);
 	if (ret < 0) {
-		if (ret == -EAGAIN) {
-			fb_helper->deferred_setup = true;
+		/* modesets are probed but fb_helper->fb isn't; defer restore too */
+		fb_helper->deferred_setup = true;
+		if (ret == -EAGAIN)
 			ret = 0;
-		}
 		mutex_unlock(&fb_helper->lock);
 
 		goto err_drm_fb_helper_release_info;


