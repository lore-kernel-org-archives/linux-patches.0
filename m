Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913171EEA5D;
	Mon, 23 Jun 2025 21:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714502; cv=none; b=n1fRw0GIh73NI+pkFQTM4iUPMgrrJsHhBS6aYOhBxPMBsPwpN4lAjWLqp+1n9ITK6yO9YpH59Z3kkaQ9USYm59gFhOjmxrNtIuLJopUE0NZgknkwPhl68TslYfJnRpKdXeUeHVxsKRqij+8V85OibY3ndMMkxIFTydD7S+F33/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714502; c=relaxed/simple;
	bh=95jLmIR3rXf61Lfovkb/5fy96gRjmh8kmn6Xvnae6bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=elfRJjxOA/3RWg1NrMDki0eu2t0rOwEQ26BqB86DXJmdbBKdUAztTi8L0gKShc03r5M+ASjr+GGSuhVdhqfz3kRKnF6QP3Pnz/LYy+uNxgPhxVn0npUMeMVArHV8qzfwPM+mkn4msGfIZ4vIlv3dDYt5pYaC75BiOyboM4omRuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ipet5aNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ipet5aNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B21C4CEEA;
	Mon, 23 Jun 2025 21:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714502;
	bh=95jLmIR3rXf61Lfovkb/5fy96gRjmh8kmn6Xvnae6bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ipet5aNWRiD6511k+p3Qs0mQ8voCqlt7QuBjShDoHu4sx7YKvHu9gq8k7asjdtKT7
	 xdzN8rad6xyS2nXSxEvX380vHOPljM1w2Kp88fKa4S/GL151yhOoZt5p+3ncgQje3Q
	 kVRi6Ak6a+EesQYodQ1f2RJzuJkaXR6/jYqkaN3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Helge Deller <deller@gmx.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Zsolt Kajtar <soci@c64.rulez.org>
Subject: [PATCH 6.12 133/414] sysfb: Fix screen_info type check for VGA
Date: Mon, 23 Jun 2025 15:04:30 +0200
Message-ID: <20250623130645.380091165@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit f670b50ef5e4a69bf4d2ec5ac6a9228d93b13a7a upstream.

Use the helper screen_info_video_type() to get the framebuffer
type from struct screen_info. Handle supported values in sorted
switch statement.

Reading orig_video_isVGA is unreliable. On most systems it is a
VIDEO_TYPE_ constant. On some systems with VGA it is simply set
to 1 to signal the presence of a VGA output. See vga_probe() for
an example. Retrieving the screen_info type with the helper
screen_info_video_type() detects these cases and returns the
appropriate VIDEO_TYPE_ constant. For VGA, sysfb creates a device
named "vga-framebuffer".

The sysfb code has been taken from vga16fb, where it likely didn't
work correctly either. With this bugfix applied, vga16fb loads for
compatible vga-framebuffer devices.

Fixes: 0db5b61e0dc0 ("fbdev/vga16fb: Create EGA/VGA devices in sysfb code")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: "Uwe Kleine-König" <u.kleine-koenig@baylibre.com>
Cc: Zsolt Kajtar <soci@c64.rulez.org>
Cc: <stable@vger.kernel.org> # v6.1+
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20250603154838.401882-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/sysfb.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -124,6 +124,7 @@ static __init int sysfb_init(void)
 {
 	struct screen_info *si = &screen_info;
 	struct device *parent;
+	unsigned int type;
 	struct simplefb_platform_data mode;
 	const char *name;
 	bool compatible;
@@ -151,17 +152,26 @@ static __init int sysfb_init(void)
 			goto put_device;
 	}
 
+	type = screen_info_video_type(si);
+
 	/* if the FB is incompatible, create a legacy framebuffer device */
-	if (si->orig_video_isVGA == VIDEO_TYPE_EFI)
-		name = "efi-framebuffer";
-	else if (si->orig_video_isVGA == VIDEO_TYPE_VLFB)
-		name = "vesa-framebuffer";
-	else if (si->orig_video_isVGA == VIDEO_TYPE_VGAC)
-		name = "vga-framebuffer";
-	else if (si->orig_video_isVGA == VIDEO_TYPE_EGAC)
+	switch (type) {
+	case VIDEO_TYPE_EGAC:
 		name = "ega-framebuffer";
-	else
+		break;
+	case VIDEO_TYPE_VGAC:
+		name = "vga-framebuffer";
+		break;
+	case VIDEO_TYPE_VLFB:
+		name = "vesa-framebuffer";
+		break;
+	case VIDEO_TYPE_EFI:
+		name = "efi-framebuffer";
+		break;
+	default:
 		name = "platform-framebuffer";
+		break;
+	}
 
 	pd = platform_device_alloc(name, 0);
 	if (!pd) {


