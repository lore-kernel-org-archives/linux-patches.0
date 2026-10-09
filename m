Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3853B4DA9AF;
	Fri,  9 Oct 2026 14:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555758; cv=none; b=ZiGkVY56kQi8+IRPJj5qXC2eIJsa/ONFkvq0EF+2K2Vdb2uGQCDpCeur0ZFQf+n6UgdPlZwv+rfdIwGwkxpjKaA8MvF1zZIOwy5LNc0mX3bUSSu/FwUIXJUmsfR+yBp7lzCRY7fX7D8k+ZxqgGKM2m/jS9tLB3B2PBfSQZmBn2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555758; c=relaxed/simple;
	bh=QhZVyVN3fxzVTs9ooi8/HUfgnH7L4itA73bpMrigg84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svKZhZ4Q4ILycqZq7AnbfWVBw/oMQAN4qJvFWZ7iBEcsPtO11ds4GTPVL9SwM3vR3swNbrVT1gNsMwV2Zy+daHpZlB+DV6SdaMU72qt89qwwincskQguj9SyAPpXTHQsk9AT/hfzitYyCGvdPvUfM5RdAJxIEuP9GDR4LmvtUIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfofcgb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfofcgb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AF01F00893;
	Fri,  9 Oct 2026 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555757;
	bh=E+llPs//mGnoKkjTOuYhCNmGw7ly6LeHBgHNedTDmX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfofcgb2MjZsHJJImeYp2csopRLXStHqZ3MHQOImziJU2rVmCbCKDzrssvt7lO8E1
	 BmFlutoA5+ab7bV2tzT6QZnQaJIRtYJSQk6QRSHUUDtJmeeW5FoKz8aDmKiaK+o/Si
	 nZXzTtXLrmA/O8jgknwC5bV/Pi9jsixyJqH5kgIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zizhi Wo <wozizhi@huawei.com>
Subject: [PATCH 7.2 060/428] vt: skip screen update for DEC alignment test on backgroup consoles
Date: Fri,  9 Oct 2026 16:06:37 +0200
Message-ID: <20261009140947.458652311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
@@ -2860,7 +2860,8 @@ static void do_con_trol(struct tty_struc
 			csi_J(vc, CSI_J_VISIBLE);
 			vc->vc_video_erase_char =
 				(vc->vc_video_erase_char & 0xff00) | ' ';
-			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
+			if (con_should_update(vc))
+				do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
 		}
 		return;
 	case ESsetG0:	/* ESC ( */


