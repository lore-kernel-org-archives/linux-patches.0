Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D298D29A1;
	Tue, 17 Feb 2026 20:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361389; cv=none; b=peV9bmH+cAq8apPEwtlmEgbHwLEVDgvyvjNBpyHlBSWgwEAl3QdkuE9FbJWq4ouEuJJposjaGMr3OWX3IhWe2s03w3iAodacSMBUkCaEB2L7Z9Il7+pADzvtVEDgVvvaeuK01s7ozQnPywVZLvhixFUbOTXDP6U9FzGzHZ8Vy/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361389; c=relaxed/simple;
	bh=jNVWH41cPno6l9l7XjJbhqf1DSa8fiVb7moXynABoro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOkcN20ZuMPYUsV5hmkoGK3tUUtJ8XMbPP/CmUOkTwtm4O8cRn4rvW/dVY0uyxznQQDDE0m2D3Stg+SXT6LB9xnCY2V0N17rFywRxwhyHW1KtFGPzb/ZrOKjTHM5FwNul+g8QTOSTqMdmCrLG6hKSWud1Hp4Dpb4+fl5OCJY0t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5UxGX57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5UxGX57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5504AC4CEF7;
	Tue, 17 Feb 2026 20:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361389;
	bh=jNVWH41cPno6l9l7XjJbhqf1DSa8fiVb7moXynABoro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5UxGX57kLhOyZvn3/oJSUZ7FGwKu22UC9QGocdOd2AkfYrvltw3GV9vyayZO4Lxb
	 ToLsBlPZn0GShaWnRuNV7zAo79KRyUZIwSvhAV3Dyz3aUp2PskaJU0YmhOpFdSGcTc
	 ybNaAHV4ijMzmZB4r/rqspx7mCh/vewhUXeHQpVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.19 04/18] fbdev: rivafb: fix divide error in nv3_arb()
Date: Tue, 17 Feb 2026 21:32:00 +0100
Message-ID: <20260217200002.856473136@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
References: <20260217200002.683975158@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 0209e21e3c372fa2da04c39214bec0b64e4eb5f4 upstream.

A userspace program can trigger the RIVA NV3 arbitration code by calling
the FBIOPUT_VSCREENINFO ioctl on /dev/fb*. When doing so, the driver
recomputes FIFO arbitration parameters in nv3_arb(), using state->mclk_khz
(derived from the PRAMDAC MCLK PLL) as a divisor without validating it
first.

In a normal setup, state->mclk_khz is provided by the real hardware and is
non-zero. However, an attacker can construct a malicious or misconfigured
device (e.g. a crafted/emulated PCI device) that exposes a bogus PLL
configuration, causing state->mclk_khz to become zero.  Once
nv3_get_param() calls nv3_arb(), the division by state->mclk_khz in the gns
calculation causes a divide error and crashes the kernel.

Fix this by checking whether state->mclk_khz is zero and bailing out before
doing the division.

The following log reveals it:

rivafb: setting virtual Y resolution to 2184
divide error: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 PID: 2187 Comm: syz-executor.0 Not tainted 5.18.0-rc1+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:nv3_arb drivers/video/fbdev/riva/riva_hw.c:439 [inline]
RIP: 0010:nv3_get_param+0x3ab/0x13b0 drivers/video/fbdev/riva/riva_hw.c:546
Call Trace:
  nv3CalcArbitration.constprop.0+0x255/0x460 drivers/video/fbdev/riva/riva_hw.c:603
  nv3UpdateArbitrationSettings drivers/video/fbdev/riva/riva_hw.c:637 [inline]
  CalcStateExt+0x447/0x1b90 drivers/video/fbdev/riva/riva_hw.c:1246
  riva_load_video_mode+0x8a9/0xea0 drivers/video/fbdev/riva/fbdev.c:779
  rivafb_set_par+0xc0/0x5f0 drivers/video/fbdev/riva/fbdev.c:1196
  fb_set_var+0x604/0xeb0 drivers/video/fbdev/core/fbmem.c:1033
  do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1109
  fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1188
  __x64_sys_ioctl+0x122/0x190 fs/ioctl.c:856

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/riva/riva_hw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/riva/riva_hw.c
+++ b/drivers/video/fbdev/riva/riva_hw.c
@@ -436,6 +436,9 @@ static char nv3_arb(nv3_fifo_info * res_
     vmisses = 2;
     eburst_size = state->memory_width * 1;
     mburst_size = 32;
+    if (!state->mclk_khz)
+	return (0);
+
     gns = 1000000 * (gmisses*state->mem_page_miss + state->mem_latency)/state->mclk_khz;
     ainfo->by_gfacc = gns*ainfo->gdrain_rate/1000000;
     ainfo->wcmocc = 0;


