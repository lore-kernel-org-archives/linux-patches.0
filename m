Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B6C3C277B;
	Wed, 30 Sep 2026 19:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794936; cv=none; b=O3SZ37ZGuErnB0A+ri2nsDUElWu2NqL5ggEN4yQglPXzLGvC9vQQScENwW9yMFSc0Ia3Xe8FEfqhz+TgLV+/xL4fhHtau56fYC02wq6otJjJsrkq9BBptT5ilncZPXSQ5N7r9bldGWHAonhIMJ7vyx3aEgJjC3krpRpbxWQPn6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794936; c=relaxed/simple;
	bh=U7wd27izeR265aSrO+iqpGTzo1EfVe+rdr2eGRnIgVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAGks8S0H+/05Jj2oJ8IuRSnDwODbRcYsUzf+r1qLv4/Aur+OXRDWpTj9dagf/yWwj4PiYGGxMk2AP3Y8zvcncvTaSz00qa2ylym+BL9l2ajUo2/CZUdAk0n4HR+0BuuyM5WelOj8Gy4oDensFxRzL2sz5qPfNsrbY5mGZGjQX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8ypttFK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8ypttFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC61C1F000FF;
	Wed, 30 Sep 2026 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794935;
	bh=gxbz2nwqiEr0LMO7ywjrZfeQPk93VhGJ54oqc+TjlUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8ypttFK5FJLrdvd9VKabSccD2CW7aZTZ2O1PIeRaamyejIYXX1qS+pRW3v/mES4M
	 rbrma0KDFq80EV1jhiq3gnprZYi4TJGTgt36Vs3p621adsVMrOXR/+JyqNjeN0pNil
	 vn4cNW8YzN+1J2Q8a5HoiJbkipMGmBVK2Y3VchxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2442951a6abb004df963@syzkaller.appspotmail.com,
	Slawomir Stepien <sst@poczta.fm>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0386/1193] drm/cirrus-qemu: Validate BAR0 size during probe
Date: Wed, 30 Sep 2026 17:17:50 +0200
Message-ID: <20260930152442.759129757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
 drivers/gpu/drm/tiny/cirrus.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/tiny/cirrus.c b/drivers/gpu/drm/tiny/cirrus.c
index e1ebb651106af..9ae5105a7bf58 100644
--- a/drivers/gpu/drm/tiny/cirrus.c
+++ b/drivers/gpu/drm/tiny/cirrus.c
@@ -669,6 +669,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
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



