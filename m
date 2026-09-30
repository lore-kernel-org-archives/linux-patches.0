Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89034F405E;
	Wed, 30 Sep 2026 18:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793746; cv=none; b=GBY6pukhwZ3CPZyrc8j6h6dE1pGyQA6r54fU8n3vYBBYY/wrB0mH6eHF48ZfNqnMN77z5mOzFXsm0ay7jzrllq8kRXfEwM+AIg1/t8K73bGd9s6BdR3mhLpq2diQ2U4t7rE1Tqm9QeSslRnIteJYFn3ViD6ioJM5T3QGIDjabMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793746; c=relaxed/simple;
	bh=18ubxypm9jJBPCQUwE+HzZVfJszljxLW6SjteJH2bEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5+Df6rwCP6nDex62FtDShtIa7gSdlNKLuo80LWl+O2Qdl4uPoaF1DuuQojBI09Km5KOqOsF1LzDWtLe4Myikl8RAbx9cB2LPfAnfgqP5nHD927jbhqSjT5h3TDl4cluMDveNdTB8x0DhfBnw88m87b7wpnro0AoTHUwAk5dis0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJASTSNQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJASTSNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C881F000FF;
	Wed, 30 Sep 2026 18:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793744;
	bh=SPtPi3oMByJlqSDJ3EwFuyFyLwsXlvwb/IH+XX5JoR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJASTSNQp21XMLveQAlD0HSonDe/ieQeCNvHOlFsAv1kSK6lnIjWJQRdjuGoJ97b/
	 hZoSLcg7Hd2+wpe9t/JpcBYl07ffnbMe/1vEly98Fh+lXmkj00ILIQ5Qrthrb3Pxkg
	 Vl1tai4+6pk2AOhi3Kq55nGhj8g12GTa1mcpOvWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shechenglong <shechenglong@xfusion.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 361/395] drm/client: fix restore of partially initialized client
Date: Wed, 30 Sep 2026 17:30:23 +0200
Message-ID: <20260930152348.518394044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: shechenglong <shechenglong@xfusion.com>

[ Upstream commit 1fca688e9443003e33cf30453e7a7560367656c9 ]

I got a null-ptr-deref report when closing a DRM file descriptor:

WARNING: drivers/gpu/drm/drm_atomic.c:2031 at
__drm_atomic_helper_set_config+0x18e/0x1b0 [drm]

Call Trace:
drm_client_modeset_commit_atomic+0x16b/0x220 [drm]
drm_client_modeset_commit_locked+0x56/0x160 [drm]
drm_client_modeset_commit+0x21/0x40 [drm]
__drm_fb_helper_restore_fbdev_mode_unlocked.part.0+0x7b/0x80
drm_fbdev_client_restore+0xe/0x20 [drm_client_lib]
drm_client_dev_restore+0x9f/0xc0 [drm]
drm_release+0xc5/0xe0 [drm]

The warning is followed by a NULL pointer dereference:

BUG: kernel NULL pointer dereference, address: 0000000000000008

RIP:
__drm_fb_helper_restore_fbdev_mode_unlocked.part.0+0x41/0x80
[drm_kms_helper]

Call Trace:
drm_fbdev_client_restore+0xe/0x20 [drm_client_lib]
drm_client_dev_restore+0x9f/0xc0 [drm]
drm_release+0xc5/0xe0 [drm]
__fput+0xdc/0x2b0
__x64_sys_close+0x39/0x80
do_syscall_64+0x8d/0x460
entry_SYSCALL_64_after_hwframe+0x76/0x7e

drm_client_register() adds the DRM client to the device client list
before invoking the initial hotplug callback. If the hotplug callback
fails, the client remains registered.

For the fbdev client, a failure during drm_fb_helper_initial_config()
causes the partially initialized fbdev helper to be cleaned up.
drm_fb_helper_fini() releases fb_helper->info and leaves it NULL.

The fbdev client therefore remains registered even though there is no
fully initialized framebuffer device.

Later, when userspace closes the DRM file descriptor, drm_release()
can invoke the restore callbacks of registered DRM clients:

drm_release()
drm_client_dev_restore()
drm_fbdev_client_restore()
drm_fb_helper_restore_fbdev_mode_unlocked()

drm_fbdev_client_restore() currently restores the fbdev state
unconditionally. For a partially initialized fbdev client this can
submit an incomplete modeset state and subsequently access fbdev
state which has not been initialized, resulting in the warning and
NULL pointer dereference above.

drm_fbdev_client_unregister() already uses fb_helper->info to
distinguish a fully probed framebuffer device from a partially
initialized client.

Use the same condition in drm_fbdev_client_restore() and skip restore
if no framebuffer device has been successfully initialized.

Signed-off-by: shechenglong <shechenglong@xfusion.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 5d08c44e47b9 ("drm/fbdev: Add memory-agnostic fbdev client")
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v6.13+
Link: https://patch.msgid.link/20260907035147.1339-1-shechenglong@xfusion.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/clients/drm_fbdev_client.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/clients/drm_fbdev_client.c
+++ b/drivers/gpu/drm/clients/drm_fbdev_client.c
@@ -30,6 +30,14 @@ static int drm_fbdev_client_restore(stru
 {
 	struct drm_fb_helper *fb_helper = drm_fb_helper_from_client(client);
 
+	/*
+	 * The client is registered before the initial fbdev probe.
+	 * If probing failed, the client remains registered but there
+	 * is no valid fbdev framebuffer to restore.
+	 */
+	if (!fb_helper->info || !fb_helper->fb)
+		return 0;
+
 	drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, force);
 
 	return 0;


