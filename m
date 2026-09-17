Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CBD4B44AD;
	Thu, 17 Sep 2026 15:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658931; cv=none; b=N3+/++YMnuxFNRqOEfudBqdEZIM36y07xnrIZTEfsAY26+HK6H/An25oxYgOrE4wGmyG6xN7qzWa+UITP3SZ3nfUXGvtdIzQt2dDEuNa/s0qBcj+NYSUMwHLZ19re9gf4NBN1RMNHF9EPDvKrrx2U9wzpm+3IFo8oi8lYnamx3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658931; c=relaxed/simple;
	bh=JSLf55rCK7wEkPbuyljMIahRJeX40srF/ak01CZX7Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/z3hJoVFL3ruVBa7dgT0DWL+U0JFf+FwHxczICHXASeTa2AfZ2oAEwJzfBeGc2QT3sa52jeJciGYwyZKWKAJG2MXZUQCQzVDq5TM6uNymAFlcUiNBG+CY9HwL6uT8TiETx0Z+ilIdx7SltDK5b4oboPBwXqmsE/CP7piZ87HL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E42vKzQg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E42vKzQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C7F1F00899;
	Thu, 17 Sep 2026 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658922;
	bh=qh57qnLi0/K/rjuHMk5z+a/Wp/X7y73/x87r7XM9OIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E42vKzQg4xNq6ZUxD1hibzNYi8y7/+hndkFJGzzlR2XH9/RGXvwd5oQ/v3u0vJ3im
	 05mMXjDcXaJF7V1eIQX3iHwmfHF3O18+6l/E+DO5D3mg1fu3UrG3ZTsTQ9ox0O7KU3
	 /B+qlXkjiJzLpL/uK9XgDzAwZLTYXgJQiUbLAlj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2442951a6abb004df963@syzkaller.appspotmail.com,
	Slawomir Stepien <sst@poczta.fm>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 036/733] drm/cirrus-qemu: Validate BAR0 size during probe
Date: Thu, 17 Sep 2026 16:05:44 +0100
Message-ID: <20260917151351.641905625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 075221b431d37..3bf23fcf65749 100644
--- a/drivers/gpu/drm/tiny/cirrus-qemu.c
+++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
@@ -582,6 +582,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
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



