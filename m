Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886EE3976BA;
	Sat, 17 Oct 2026 16:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256272; cv=none; b=OCV4iFE0gKYk8zbAqadhHOx+P0wRB8TgimMM4QI8tU90TT4KsSNABx484dIcJ6eMk+rf4pBw3Nfk0mHRXyWQcNlxVmFZRIb+1ko2YM9QKpW5is3aUBI7V0dioAC1Vz1GKMxj/Gx5ldROyzb6IrH5CQ7rw7C3eAJ1I+E1PnHBkro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256272; c=relaxed/simple;
	bh=ynUkgTMb5EOro2jEAFVgw2jKCp49H19zHnIIiqrHc9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+XqHowcdqgCvhXWJjmJAO2Zyb8XegEIZVsLziKXH5STBRGi7Amyj+newoudqAgxDC6XiaXOrM8EvoYYYz8ROlbor47yHE8rB3+vtjZTIcf5ph1XbEvyQm2zzhk7X642kyp1XkAC5/z6Tj/Q5rrEYkDLjqUt/9vA1pL3QXdbpyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PanlA0SD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PanlA0SD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEB61F000C4;
	Sat, 17 Oct 2026 16:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256271;
	bh=Ifg7bDtDtF2nw8ru/ewxhwhF0YLNe5xCQPuItkhk38M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PanlA0SDhnXXMBJaHMzCVkP06wfmcm4KLS26mQaKtsyO0JFYFo2VUV1afNb6pjh4m
	 1JMzWKfZpWb7U301ozidqQYZi/XApE+mQJpBRoOo9RosrzX9d3h7sziGs2eVUvLcnS
	 XOjpTuEAt973fdwRjhX8kAR6BbzHHTFWGdTu9ZMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zizhi Wo <wozizhi@huawei.com>
Subject: [PATCH 6.6 0181/1674] vt: skip screen update for DEC alignment test on backgroup consoles
Date: Sat, 17 Oct 2026 17:40:53 +0200
Message-ID: <20261017160435.798825929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

commit 0928ed9bd7946baee911efa401088697836e3b1e upstream.

[BUG]
Recently, we encountered a KASAN warning as follows:

BUG: KASAN: slab-out-of-bounds in fb_pad_aligned_buffer+0x11f/0x140
Read of size 1 at addr ff1100015fd9f6a4 by task tty_fbcon_oob/1239
CPU: 7 UID: 0 PID: 1239 Comm: tty_fbcon_oob Not tainted 7.3.0-rc1 #100 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc41 04/01/2014
Call Trace:
 <TASK>
 ...
 kasan_report+0xf0/0x120
 fb_pad_aligned_buffer+0x11f/0x140
 ccw_putcs+0x86c/0xa80
 fbcon_putcs+0x338/0x410
 do_update_region+0x21d/0x450
 do_con_write+0x1e0e/0x4880
 con_write+0x13/0x80
 n_tty_write+0x374/0x1010
 file_tty_write.isra.0+0x404/0x7a0
 ...

reproduce:
1) open /dev/tty0, set a KDFONTOP ioctl with op.op = KD_FONT_OP_SET,
op.width = 8 and op.height = 16 (visible VC1)
2) open /dev/tty1, set a KDFONTOP ioctl with op.op = KD_FONT_OP_SET,
op.width = 28 and op.height = 24 (invisible VC2)
3) echo 3 > /sys/devices/virtual/graphics/fbcon/rotate_all
4) write EShash8(esc hash8) to tty1

[CAUSE]
All VCs render to the framebuffer. setfont only modifies the target VC's
font without resizing the framebuffer backing buffer (par->rotated.buf);
the buffer is only resized for the visible VC
(fbcon_do_set_font -> ... -> vc_do_resize -> update_screen). This relies on
the con_should_update() check performed before every update_region().

However, the ESC # 8 path (do_con_trol -> do_update_region) omits the
con_should_update() check. After changing the font size of an invisible VC,
do_update_region() fills using the new font size against a buffer that was
never resized, causing an out-of-bounds access.

[FIX]
Only push the update when the console is visible and not blanked, add
the con_should_update() check in the do_con_trol() like every other call
site of do_update_region() (update_region(), invert_screen(), ...).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@kernel.org>
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://patch.msgid.link/20260905064337.3083103-1-wozizhi@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2497,7 +2497,8 @@ static void do_con_trol(struct tty_struc
 			csi_J(vc, 2);
 			vc->vc_video_erase_char =
 				(vc->vc_video_erase_char & 0xff00) | ' ';
-			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
+			if (con_should_update(vc))
+				do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
 		}
 		return;
 	case ESsetG0:


