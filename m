Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160F51DE4FB;
	Wed, 19 Mar 2025 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394872; cv=none; b=fwElm64ptsejInki0bJjqgT7Rdy8u9Eovtrmp7lg2DdFM2bXj+5/EmVXR/4thcVoQ8AhcezRVMM7dunlB63XwEzdgzO/3fJIG76TJhWcfKTSd5XsQDtSqmOhkycSex+kT7VTNjHls9a4hlZV8psm9WyoaQ+QSHjKkOE4lD0XUZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394872; c=relaxed/simple;
	bh=HpCJMmtZfzC1M+dXi9kRghFuEaI9QnD6JVq0Rk0j0og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbHMfEFCTpAPK2T6luFFMw/IHSs6wb3j5a1C6/bSBiEIds97+u7B4Kyy63TQ5PUajJfHvBdiWlN6xLPs1ju4wapJeilrbA2HfY4/SxiC4jT4zWAJktrYKHjCvpNYZm01J4eIHm9qyJYqoHM81WTmfU5Ed0Lf6XPSn3icV8kWQyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CClqh8s0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CClqh8s0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF112C4CEE8;
	Wed, 19 Mar 2025 14:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394872;
	bh=HpCJMmtZfzC1M+dXi9kRghFuEaI9QnD6JVq0Rk0j0og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CClqh8s0SRLYQeTHKfI2d8DyM1z5ygaVwj3bxR6tWhcoWxcPjNvvI0iApdagMRXF5
	 9+7AbO335H2RwpY6k80q10dn6KHOm8qn/5g4561OFBb7JEdNeET/94EUyK1oEHaEJD
	 9mc42047ixyua5ym/MgXpgYUZEd3TfgdQKPiNHY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Tai <thomas.tai@oracle.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 027/241] fbdev: hyperv_fb: Fix hang in kdump kernel when on Hyper-V Gen 2 VMs
Date: Wed, 19 Mar 2025 07:28:17 -0700
Message-ID: <20250319143028.382843517@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit 304386373007aaca9236a3f36afac0bbedcd2bf0 ]

Gen 2 Hyper-V VMs boot via EFI and have a standard EFI framebuffer
device. When the kdump kernel runs in such a VM, loading the efifb
driver may hang because of accessing the framebuffer at the wrong
memory address.

The scenario occurs when the hyperv_fb driver in the original kernel
moves the framebuffer to a different MMIO address because of conflicts
with an already-running efifb or simplefb driver. The hyperv_fb driver
then informs Hyper-V of the change, which is allowed by the Hyper-V FB
VMBus device protocol. However, when the kexec command loads the kdump
kernel into crash memory via the kexec_file_load() system call, the
system call doesn't know the framebuffer has moved, and it sets up the
kdump screen_info using the original framebuffer address. The transition
to the kdump kernel does not go through the Hyper-V host, so Hyper-V
does not reset the framebuffer address like it would do on a reboot.
When efifb tries to run, it accesses a non-existent framebuffer
address, which traps to the Hyper-V host. After many such accesses,
the Hyper-V host thinks the guest is being malicious, and throttles
the guest to the point that it runs very slowly or appears to have hung.

When the kdump kernel is loaded into crash memory via the kexec_load()
system call, the problem does not occur. In this case, the kexec command
builds the screen_info table itself in user space from data returned
by the FBIOGET_FSCREENINFO ioctl against /dev/fb0, which gives it the
new framebuffer location.

This problem was originally reported in 2020 [1], resulting in commit
3cb73bc3fa2a ("hyperv_fb: Update screen_info after removing old
framebuffer"). This commit solved the problem by setting orig_video_isVGA
to 0, so the kdump kernel was unaware of the EFI framebuffer. The efifb
driver did not try to load, and no hang occurred. But in 2024, commit
c25a19afb81c ("fbdev/hyperv_fb: Do not clear global screen_info")
effectively reverted 3cb73bc3fa2a. Commit c25a19afb81c has no reference
to 3cb73bc3fa2a, so perhaps it was done without knowing the implications
that were reported with 3cb73bc3fa2a. In any case, as of commit
c25a19afb81c, the original problem came back again.

Interestingly, the hyperv_drm driver does not have this problem because
it never moves the framebuffer. The difference is that the hyperv_drm
driver removes any conflicting framebuffers *before* allocating an MMIO
address, while the hyperv_fb drivers removes conflicting framebuffers
*after* allocating an MMIO address. With the "after" ordering, hyperv_fb
may encounter a conflict and move the framebuffer to a different MMIO
address. But the conflict is essentially bogus because it is removed
a few lines of code later.

Rather than fix the problem with the approach from 2020 in commit
3cb73bc3fa2a, instead slightly reorder the steps in hyperv_fb so
conflicting framebuffers are removed before allocating an MMIO address.
Then the default framebuffer MMIO address should always be available, and
there's never any confusion about which framebuffer address the kdump
kernel should use -- it's always the original address provided by
the Hyper-V host. This approach is already used by the hyperv_drm
driver, and is consistent with the usage guidelines at the head of
the module with the function aperture_remove_conflicting_devices().

This approach also solves a related minor problem when kexec_load()
is used to load the kdump kernel. With current code, unbinding and
rebinding the hyperv_fb driver could result in the framebuffer moving
back to the default framebuffer address, because on the rebind there
are no conflicts. If such a move is done after the kdump kernel is
loaded with the new framebuffer address, at kdump time it could again
have the wrong address.

This problem and fix are described in terms of the kdump kernel, but
it can also occur with any kernel started via kexec.

See extensive discussion of the problem and solution at [2].

[1] https://lore.kernel.org/linux-hyperv/20201014092429.1415040-1-kasong@redhat.com/
[2] https://lore.kernel.org/linux-hyperv/BLAPR10MB521793485093FDB448F7B2E5FDE92@BLAPR10MB5217.namprd10.prod.outlook.com/

Reported-by: Thomas Tai <thomas.tai@oracle.com>
Fixes: c25a19afb81c ("fbdev/hyperv_fb: Do not clear global screen_info")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20250218230130.3207-1-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250218230130.3207-1-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 363e4ccfcdb77..ce23d0ef5702a 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -989,6 +989,7 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 
 		base = pci_resource_start(pdev, 0);
 		size = pci_resource_len(pdev, 0);
+		aperture_remove_conflicting_devices(base, size, KBUILD_MODNAME);
 
 		/*
 		 * For Gen 1 VM, we can directly use the contiguous memory
@@ -1010,11 +1011,21 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 			goto getmem_done;
 		}
 		pr_info("Unable to allocate enough contiguous physical memory on Gen 1 VM. Using MMIO instead.\n");
+	} else {
+		aperture_remove_all_conflicting_devices(KBUILD_MODNAME);
 	}
 
 	/*
-	 * Cannot use the contiguous physical memory.
-	 * Allocate mmio space for framebuffer.
+	 * Cannot use contiguous physical memory, so allocate MMIO space for
+	 * the framebuffer. At this point in the function, conflicting devices
+	 * that might have claimed the framebuffer MMIO space based on
+	 * screen_info.lfb_base must have already been removed so that
+	 * vmbus_allocate_mmio() does not allocate different MMIO space. If the
+	 * kdump image were to be loaded using kexec_file_load(), the
+	 * framebuffer location in the kdump image would be set from
+	 * screen_info.lfb_base at the time that kdump is enabled. If the
+	 * framebuffer has moved elsewhere, this could be the wrong location,
+	 * causing kdump to hang when efifb (for example) loads.
 	 */
 	dio_fb_size =
 		screen_width * screen_height * screen_depth / 8;
@@ -1051,11 +1062,6 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	info->screen_size = dio_fb_size;
 
 getmem_done:
-	if (base && size)
-		aperture_remove_conflicting_devices(base, size, KBUILD_MODNAME);
-	else
-		aperture_remove_all_conflicting_devices(KBUILD_MODNAME);
-
 	if (!gen2vm)
 		pci_dev_put(pdev);
 
-- 
2.39.5



