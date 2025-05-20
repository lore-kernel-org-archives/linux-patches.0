Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F214248895;
	Tue, 20 May 2025 14:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750086; cv=none; b=BAJf75rqJ3cf9sv+r9vdug/92kmSlOT1APtMOfESz+eZjWQKIVGDe0rrLBC0lzOWpNaMhhjQM3WkmfW5PUCujUYYx5uWI8qpTfq1IbD/XGtmcgNV6x2uPM8PeEnhFG9IaTaWvQXbiOsLWniuTZ40YEL8nmsGt/W4rZ1JIxpwwqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750086; c=relaxed/simple;
	bh=a5JAN5KWEX6bN7ODKMIh7Sjjd5nwiSjuEh82CDTjPX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qGMsFJvDV8e26R5+JiHfVSNKtuGfTgZ/hqKkmkK+wPNYx1jM9fbjBSdq5BWRR1l7Rbexknt1AotQbxxfw2wW4uJI2/LmhXn3tugglsOLmF7wzuVJ2EzBuKJgnwrdHg+JRvi+PJM0NreO5xndNRM/3AfD+YSKbn8dvh11znFNGHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhOPVhjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhOPVhjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFFDC4CEF6;
	Tue, 20 May 2025 14:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750085;
	bh=a5JAN5KWEX6bN7ODKMIh7Sjjd5nwiSjuEh82CDTjPX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhOPVhjPeMveBWw0COzX1BhdhMI5lx6wUkxKEYXFGpyWJJE6Tnxi0NJaYp1j4VBvb
	 tUHi+CyiucponnzBsaKyH+OezZpXHK2d1bLSJcCnyGxlCwTccPxVXj8O9eySOiIuoB
	 JiPHETw9qVMdGbUFT//KCdS8kpDeTxydY3HAfCHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <jeffbai@aosc.io>,
	Xinhui Yang <cyan@cyano.uk>,
	Rong Zhang <i@rong.moe>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Yemu Lu <prcups@krgm.moe>,
	Runhua He <hua@aosc.io>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/143] platform/x86/amd/pmc: Declare quirk_spurious_8042 for MECHREVO Wujie 14XA (GX4HRXL)
Date: Tue, 20 May 2025 15:49:22 +0200
Message-ID: <20250520125810.333638892@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Runhua He <hua@aosc.io>

[ Upstream commit 0887817e4953885fbd6a5c1bec2fdd339261eb19 ]

MECHREVO Wujie 14XA (GX4HRXL) wakes up immediately after s2idle entry.
This happens regardless of whether the laptop is plugged into AC power,
or whether any peripheral is plugged into the laptop.

Similar to commit a55bdad5dfd1 ("platform/x86/amd/pmc: Disable keyboard
wakeup on AMD Framework 13"), the MECHREVO Wujie 14XA wakes up almost
instantly after s2idle suspend entry (IRQ1 is the keyboard):

2025-04-18 17:23:57,588 DEBUG:  PM: Triggering wakeup from IRQ 9
2025-04-18 17:23:57,588 DEBUG:  PM: Triggering wakeup from IRQ 1

Add this model to the spurious_8042 quirk to workaround this.

This patch does not affect the wake-up function of the built-in keyboard.
Because the firmware of this machine adds an insurance for keyboard
wake-up events, as it always triggers an additional IRQ 9 to wake up the
system.

Suggested-by: Mingcong Bai <jeffbai@aosc.io>
Suggested-by: Xinhui Yang <cyan@cyano.uk>
Suggested-by: Rong Zhang <i@rong.moe>
Fixes: a55bdad5dfd1 ("platform/x86/amd/pmc: Disable keyboard wakeup on AMD Framework 13")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4166
Cc: Mario Limonciello <mario.limonciello@amd.com>
Link: https://zhuanldan.zhihu.com/p/730538041
Tested-by: Yemu Lu <prcups@krgm.moe>
Signed-off-by: Runhua He <hua@aosc.io>
Link: https://lore.kernel.org/r/20250507100103.995395-1-hua@aosc.io
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index b4f49720c87f6..2e3f6fc67c568 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -217,6 +217,13 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "03.05"),
 		}
 	},
+	{
+		.ident = "MECHREVO Wujie 14X (GX4HRXL)",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "WUJIE14-GX4HRXL"),
+		}
+	},
 	{}
 };
 
-- 
2.39.5



