Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E43389118;
	Thu, 30 Jul 2026 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428218; cv=none; b=TVv+o+P+WzKOfcbGSMCy/+2bY2/KIBMbIzN06MoUyyuh6Z3P9woUDkIegxik9bCwLCIaY21sqr7Tj9QDuUn/r8TFzRROTO2eBxlPOjQQC7KJnNsJuh9QQ+FrkbGbvaUkfGq8s9q07UKQuFWphvWhJNIUj4Q7PhxfAni/f9BNEB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428218; c=relaxed/simple;
	bh=Te4pnfnUnVkewrsg0h+sABjwkSJ6oyIyCOWGksHRcMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwLFbK4fLY+DuENXD+UV9ANww+MtaF6lPNpFX6bDA9Jwz6mHlbaBrnhsmw9eNcSkdai153iOC2n+2Rkbi7qMi/PEi4rFVSjJeAb8AOdhTQsaVV9EScUfTFuT2i7BOispx5QxMU1oTi/G7nif72BN4BeZKgnsjC84L4B4xvbz3wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2g0qU8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2g0qU8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076471F00A3E;
	Thu, 30 Jul 2026 16:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428210;
	bh=HT2tCL3glURnMH277xV83YFDMIsYG0pmAWMNCcddqo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2g0qU8tHN1PZOeQPGI8lPlRiX5aQMLWeSoPcgf1zQqJfaFlIBnu1tSXSVLAzSw9B
	 Z7EII3xaDnG7ELw3UHFHzXCyKO9UL4kpdoWuaUR3rVcdYJRLxh2R4hLl+KwvnIbwSN
	 h2hXC28y31XRL25Na3f4nWQibDCDUtN/Zs9zhd74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 442/484] platform/x86: dell-laptop: fix missing cleanups in init error path
Date: Thu, 30 Jul 2026 16:15:39 +0200
Message-ID: <20260730141433.082247746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 6e9cab2247e5b243ae2d907ce7c948a8a9c8d61a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-laptop.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/platform/x86/dell/dell-laptop.c
+++ b/drivers/platform/x86/dell/dell-laptop.c
@@ -2295,6 +2295,11 @@ fail_backlight:
 	if (mute_led_registered)
 		led_classdev_unregister(&mute_led_cdev);
 fail_led:
+	dell_laptop_unregister_notifier(&dell_laptop_notifier);
+	debugfs_remove_recursive(dell_laptop_dir);
+	kbd_led_exit();
+	if (quirks && quirks->touchpad_led)
+		touchpad_led_exit();
 	dell_cleanup_rfkill();
 fail_rfkill:
 	platform_device_del(platform_device);


