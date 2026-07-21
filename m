Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C583F2101;
	Tue, 21 Jul 2026 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658847; cv=none; b=Q+uDmOdYMXbbsjz4jEZOPMXQrnIZW1WzwdX6i2GQuad5ufNLw42AvywI7lu9hAZCKaNTYVYQgMXB2mMuIu9b+DpJD4DgVxSNqk1GI6WXUFB0S2ZGKAFFkQwOlB80WAsRTJnL0GPcNLdCSY65mCz2//KvhJEsp90DVtoGh8uSBoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658847; c=relaxed/simple;
	bh=cIbBMzfjb593YKa7o6aefAEIMz/lnet0bZb7Ev3v5ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lWoRUYZXFMc82mio8M5ONfwD4LLzgMpWhDqrcUaxN7dBzubn/VV1moNUWZrLyrdt/+gyCDjIJx7Pu5wOGKOaCozR1tXrkV9USiP55GwoUtpjfjKNzMHekHHZV6bdpkRqmSTK7NhN10PulAeT7ZoTazaiIYQ2+HRM+0kxNUPmSBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZkdGkxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZkdGkxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C581F000E9;
	Tue, 21 Jul 2026 18:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658846;
	bh=2uScvcWDv3T4IcDgoi/9h2gvrhU+h5M4dtD2eJQd3+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZkdGkxCnpdhJ8D9Xg9pyrD1KCmuTFzg7MJmPmYc2jgsBXqL2Rxkvt80vL/gbmp2v
	 Y2VUMPu8N+T8hg04PP0ZxeZZ06w4qM/+pgIrTRIBYSS4c119B4YISwkjiosdmDY0aF
	 iL/InkWxcL3htHqq5v+/uUF6z9O2kzckuySa77Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 1296/1611] platform/x86: dell-laptop: fix missing cleanups in init error path
Date: Tue, 21 Jul 2026 17:23:32 +0200
Message-ID: <20260721152544.596203106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 6e9cab2247e5b243ae2d907ce7c948a8a9c8d61a upstream.

dell_init() initializes several resources after dell_setup_rfkill(),
including the optional touchpad LED, keyboard backlight LED, battery
hook, debugfs directory and dell-laptop notifier.

If a later LED or backlight registration fails, the error path only
tears down the battery hook and rfkill resources. This leaves the
notifier, debugfs directory, keyboard backlight LED and optional
touchpad LED registered after dell_init() returns an error.

Add the missing cleanup calls before tearing down rfkill.

Fixes: 9c656b07997f ("platform/x86: dell-*: Call new led hw_changed API on kbd brightness change")
Fixes: 037accfa14b2 ("dell-laptop: Add debugfs support")
Fixes: 2d8b90be4f1c ("dell-laptop: support Synaptics/Alps touchpad led")
Fixes: 6cff8d60aa0a ("platform: x86: dell-laptop: Add support for keyboard backlight")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20260609081419.1995169-1-lihaoxiang@isrc.iscas.ac.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-laptop.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/platform/x86/dell/dell-laptop.c
+++ b/drivers/platform/x86/dell/dell-laptop.c
@@ -2551,7 +2551,12 @@ fail_backlight:
 	if (mute_led_registered)
 		led_classdev_unregister(&mute_led_cdev);
 fail_led:
+	dell_laptop_unregister_notifier(&dell_laptop_notifier);
+	debugfs_remove_recursive(dell_laptop_dir);
 	dell_battery_exit();
+	kbd_led_exit();
+	if (quirks && quirks->touchpad_led)
+		touchpad_led_exit();
 	dell_cleanup_rfkill();
 fail_rfkill:
 	platform_device_del(platform_device);


