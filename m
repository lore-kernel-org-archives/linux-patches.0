Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD9F253F1E;
	Mon, 23 Jun 2025 13:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684736; cv=none; b=dMENor5R2JSU2idXeMbsaRvSV17AfRSaSKcbfN42RlwVbJ0MujFtGoKWcpOcSjUiOlx0A2tSwtOlXhDEGzc5Y58yOIeyqbcQL1p69B7Hvu1kLzV7Sq4HvHiN0j/ZW51rtQIUBdH+I6HyDDcfJ7TCfgMISYy+Y7vofgj3l6G+9pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684736; c=relaxed/simple;
	bh=snto/jOmO7P5Ejx5NUqmylm9t7MC11Hwwzx9wCG9t90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=enBJdtNynbZ974sjHCR69/5c0lcEe0pt/SWCJqTeM80f22dROFwoC1Pd3iiqZBbe43PtCtGxR+dDv2Nyg7jTnBCWtrbp8MHutoeJ3MkHNoI67f+6AkjO8BfXVf03icWsTbIY+dt7WQjs4KcpuLb4FrjwVByrbZu4/bnMisZ1K/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQCPgM8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQCPgM8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAB5C4CEF0;
	Mon, 23 Jun 2025 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684735;
	bh=snto/jOmO7P5Ejx5NUqmylm9t7MC11Hwwzx9wCG9t90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQCPgM8AWbPMuY91f3m97tnY5xh6oromAAFu0hi2dodYKvlSBrLf4nHWRg8FxYGdn
	 zXaU1eucbE97aJsUXctNLjpOhavIdmp4iLeHFLhAwT4K7hJGXUu4zty5UBuyRpg0Oy
	 cAHdlisMFNN+OIEtpVbteLbkEzt8Bh2pZy5srLpU=
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
Subject: [PATCH 6.15 162/592] sysfb: Fix screen_info type check for VGA
Date: Mon, 23 Jun 2025 15:02:00 +0200
Message-ID: <20250623130704.130942401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -143,6 +143,7 @@ static __init int sysfb_init(void)
 {
 	struct screen_info *si = &screen_info;
 	struct device *parent;
+	unsigned int type;
 	struct simplefb_platform_data mode;
 	const char *name;
 	bool compatible;
@@ -170,17 +171,26 @@ static __init int sysfb_init(void)
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


