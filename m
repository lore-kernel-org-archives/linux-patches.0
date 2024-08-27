Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918481C5793;
	Tue, 27 Aug 2024 15:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771600; cv=none; b=eovFRvHl8Sv+RG8eVPMVNZDqHCkuqVTAZ8Q7FD0UQ9JrmULdrTIYaX3s2jwah8DJkQqcjhnNf4eWqOpEQmBGWB+D4mp43rR3IsHhBjONX9bLIVFifMYMTclbP7Wdss9L+MhMX91YO7v9/pyvaJVkQf9e4IwX5Gjk/uj+mRxzeW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771600; c=relaxed/simple;
	bh=62hGVr4C/a2mXyOBVqMa9di2d8Qi1zNc/WwuTUWtu/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJxsiKR1Rhv9NfnryUvVP0IdJyBJI0iWiPUick9zsLZq563V8XjFyi1tT7xWoYyTRSvwMu40OHHRBytkuoA18/LuCoqGADspjMBTIDhMJy3r0QVJn0IfRr5x6HoXMbTzOZ0Sw2LIGHYhR/MbCkX3vBQH6jXrp8T4OpUOa21id2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrNfqKor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrNfqKor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AE4C61053;
	Tue, 27 Aug 2024 15:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771600;
	bh=62hGVr4C/a2mXyOBVqMa9di2d8Qi1zNc/WwuTUWtu/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrNfqKorlG4uxvz1G/Dua8ziYA0HaS6L6AQm+JXAYVcj7+OmpbZ3iGCVel1fGOwrL
	 dGMbnixy727PG60vjGXSxLs5n+949u3wm4a4vhPYIhXPcwqZgIXtucGDUw+RUvLFIe
	 UySXIDLRCmB2qT9SLE9KTj7XhtGwxC1f3AIMIfvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 206/273] drm/xe: Fix opregion leak
Date: Tue, 27 Aug 2024 16:38:50 +0200
Message-ID: <20240827143841.249750934@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit f4b2a0ae1a31fd3d1b5ca18ee08319b479cf9b5f ]

Being part o the display, ideally the setup and cleanup would be done by
display itself. However this is a bigger refactor that needs to be done
on both i915 and xe. For now, just fix the leak:

unreferenced object 0xffff8881a0300008 (size 192):
  comm "modprobe", pid 4354, jiffies 4295647021
  hex dump (first 32 bytes):
    00 00 87 27 81 88 ff ff 18 80 9b 00 00 c9 ff ff  ...'............
    18 81 9b 00 00 c9 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 99260e31):
    [<ffffffff823ce65b>] kmemleak_alloc+0x4b/0x80
    [<ffffffff81493be2>] kmalloc_trace_noprof+0x312/0x3d0
    [<ffffffffa1345679>] intel_opregion_setup+0x89/0x700 [xe]
    [<ffffffffa125bfaf>] xe_display_init_noirq+0x2f/0x90 [xe]
    [<ffffffffa1199ec3>] xe_device_probe+0x7a3/0xbf0 [xe]
    [<ffffffffa11f3713>] xe_pci_probe+0x333/0x5b0 [xe]
    [<ffffffff81af6be8>] local_pci_probe+0x48/0xb0
    [<ffffffff81af8778>] pci_device_probe+0xc8/0x280
    [<ffffffff81d09048>] really_probe+0xf8/0x390
    [<ffffffff81d0937a>] __driver_probe_device+0x8a/0x170
    [<ffffffff81d09503>] driver_probe_device+0x23/0xb0
    [<ffffffff81d097b7>] __driver_attach+0xc7/0x190
    [<ffffffff81d0628d>] bus_for_each_dev+0x7d/0xd0
    [<ffffffff81d0851e>] driver_attach+0x1e/0x30
    [<ffffffff81d07ac7>] bus_add_driver+0x117/0x250

Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240724215309.644423-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 6f4e43a2f771b737d991142ec4f6d4b7ff31fbb4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_display.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/display/xe_display.c b/drivers/gpu/drm/xe/display/xe_display.c
index 6ecaf83264d55..7cdc03dc40ed9 100644
--- a/drivers/gpu/drm/xe/display/xe_display.c
+++ b/drivers/gpu/drm/xe/display/xe_display.c
@@ -134,6 +134,7 @@ static void xe_display_fini_noirq(struct drm_device *dev, void *dummy)
 		return;
 
 	intel_display_driver_remove_noirq(xe);
+	intel_opregion_cleanup(xe);
 }
 
 int xe_display_init_noirq(struct xe_device *xe)
@@ -159,8 +160,10 @@ int xe_display_init_noirq(struct xe_device *xe)
 	intel_display_device_info_runtime_init(xe);
 
 	err = intel_display_driver_probe_noirq(xe);
-	if (err)
+	if (err) {
+		intel_opregion_cleanup(xe);
 		return err;
+	}
 
 	return drmm_add_action_or_reset(&xe->drm, xe_display_fini_noirq, NULL);
 }
-- 
2.43.0



