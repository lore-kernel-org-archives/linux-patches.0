Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495483DEFE2;
	Thu, 17 Sep 2026 17:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665172; cv=none; b=E9zwDG+kYY5+6fSVGZHt1FuTcBODol1XBOa3+9C8yxvp1EgtExTfmqhAEyK9HHu0VtcmHD0GZWZf3Kv6lfafoJkCyvke0vMW9x/Taj/7Ir757iptjmdrDhbWnVtT2PSaRWEdrIy+ooyuDO0k0p9uV5GOWzoL5b+ta46SW338hV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665172; c=relaxed/simple;
	bh=no6lY7026nAqQuOXzn8AmbrC9OxqYz+fau+oVjtRKws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tyz8AwUOj08UYlu3duYvlbJm9eeX/bIrlT2bMGw1lFTMykgM5yaB3iHAQQyQ+aOed/E+OWYJwPpl++lODaSCm70Lcber9zawBraElLejLHgD0fknPJGwrJ/w3bdm1XkycXq8hrNLc4gwSlVsEgpmfm2jmyitZKWx4p/8KaHv4xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09iQH0Re; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09iQH0Re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952F91F000FF;
	Thu, 17 Sep 2026 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665171;
	bh=uKJdXksY4/7rQUAHhGkDlntzpyBcQ8jTYRfawLY6Ed0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09iQH0Re7JCMf6ZFwROtlKJU2WjQ1fOuShtbr1QePaQhlv553TBs4iv8kWWsT8LHq
	 nefbrg/f/iGiuVoZSuTL1SH9kXBERt+yYTQehNtbka9DGS3nxTWh31WWABW5RSbNOL
	 LlKxwr9f85qtD+WgJ4+kRq56zz2xqbpgB0sGdat4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2442951a6abb004df963@syzkaller.appspotmail.com,
	Slawomir Stepien <sst@poczta.fm>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0617/1250] drm/cirrus-qemu: Validate BAR0 size during probe
Date: Thu, 17 Sep 2026 16:06:52 +0100
Message-ID: <20260917151608.594155483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Slawomir Stepien <sst@poczta.fm>

[ Upstream commit 92312d333bf700798f92f30406c721bce87506f3 ]

The `cirrus-qemu` driver relies on `CIRRUS_VRAM_SIZE` (4 MB) to validate
framebuffer sizes. However, during PCI probe, the driver mapped BAR0
without verifying that its size matches `CIRRUS_VRAM_SIZE`.

If a PCI device with a BAR0 smaller than 4 MB is bound to the driver, the
mapped VRAM will be smaller than expected. Because validation checks assume
4 MB VRAM, framebuffers larger than the mapped memory can be created.

When the display plane is updated (e.g. during release),
`cirrus_primary_plane_helper_atomic_update()` copies the framebuffer to
VRAM using `drm_fb_memcpy()`. Writing past the end of the mapped I/O memory
causes a supervisor write page fault:

BUG: unable to handle page fault for address: ffffc9000389c000
...
RIP: 0010:memcpy_toio+0x7c/0xe0 arch/x86/lib/iomem.c:110
...
Call Trace:
 <TASK>
 iosys_map_memcpy_to include/linux/iosys-map.h:285 [inline]
 drm_fb_memcpy+0x325/0x5d0 drivers/gpu/drm/drm_format_helper.c:442
 cirrus_primary_plane_helper_atomic_update+0x98a/0xb00
 drivers/gpu/drm/tiny/cirrus-qemu.c:358
 drm_atomic_helper_commit_planes+0x626/0xea0
 drivers/gpu/drm/drm_atomic_helper.c:3038
 drm_atomic_helper_commit_tail+0x60/0x510
 drivers/gpu/drm/drm_atomic_helper.c:1989
 commit_tail+0x2b1/0x3c0 drivers/gpu/drm/drm_atomic_helper.c:2074
 drm_atomic_helper_commit+0xa77/0xb10
 drivers/gpu/drm/drm_atomic_helper.c:2312

Fix this by validating in `cirrus_pci_probe()` that the PCI BAR0 resource
is not less than `CIRRUS_VRAM_SIZE`, returning `-ENODEV` if it is less.

Fixes: ab3e023b1b4c ("drm/cirrus: rewrite and modernize driver.")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+2442951a6abb004df963@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2442951a6abb004df963
Link: https://syzkaller.appspot.com/ai_job?id=ba262a3a-bccf-4ad8-a1b0-583c55d34fd6
Signed-off-by: Slawomir Stepien <sst@poczta.fm>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260825120729.493611-1-sst@poczta.fm
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/cirrus-qemu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/cirrus-qemu.c
index 97a93adc5669d..a6ce6aa99477e 100644
--- a/drivers/gpu/drm/tiny/cirrus-qemu.c
+++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
@@ -570,6 +570,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
 	struct cirrus_device *cirrus;
 	int ret;
 
+	if (pci_resource_len(pdev, 0) < CIRRUS_VRAM_SIZE)
+		return -ENODEV;
+
 	ret = aperture_remove_conflicting_pci_devices(pdev, cirrus_driver.name);
 	if (ret)
 		return ret;
-- 
2.53.0



