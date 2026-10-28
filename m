Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210792;
	b=lbqs7ktwpVZzOkf+kUDBmFJnXplr5kL/X419xZ5MejkSKdP9QwKcwNlOcn4khNNVAel7
	 ObntyOY682EKZ9JymBm5U1aqq0ZNurHKkMsCHax+mliPtkEGFIjXECfkxoSxQ6HH+siKZ
	 dztmynJw77OKSFa1HUgZfC6JVVFhm2XGmlRdcEvlV/g0qv3F96o/ULJkfouKwYuEkccM1
	 8ZqQNkJprFPKDuEtl68urI1LGs8ZkrR9j2nzvXq1eiHxoaP5kuJqW5004nhXk89WCehzj
	 46j0GtxqZQxXLQm/oQ7oArS/M5AnU29aHN91hO+x0AfnosxDucxJ3MUkXXLIv0g/3cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2VG31RdozhImAPM9iMxYTMf/GbtdW+WHsq6xM38YiBw=;
	b=FuhlguwfkszOPZZkSJTrTQoltuI5KuMR5QvcZE9t/qSNMBOS31exMf/sq3rNR8Eo6dsr
	 32pbZkwJ6F6dps+nrNzHxzynJ1E1dT1pnZ7WFsrrAlXlj0IogiFjfoxQ7/IehIY9Rkc0a
	 iRwoqfHkvJLAP35NAvOjrNR44tVmdBGHmg7kw9ILxGs5cYrCPUQf5aPTbjbi5JRxO3jtC
	 GD80Imt+ixWfAyv1A5ByuyS/LFhebc+VTU1oKtwVPO6wQpPh/ODcWAECaLomwe/7Yvtz8
	 EA3H9S09Ii6W1wWwJzcykmjvelhxo85HB/qKappFpj6PTC14fzJyIifz6cg9gZqAM+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JfiGmhKs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8354606A323;
	Wed, 28 Oct 2026 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JfiGmhKs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040F81F01825;
	Wed, 28 Oct 2026 18:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210791;
	bh=2VG31RdozhImAPM9iMxYTMf/GbtdW+WHsq6xM38YiBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfiGmhKs42+eaBnnDEOlcbxAA9JjTaMtIKMiTiFsjtMv6UzE9bnh89wjAEmCgflvS
	 GAGt3qVKxQZGIi25qQvslX3Ya+DNIOfWqb039tLSBF6bVHGytUHsdJcA/1L4dlQ54A
	 08MKPtQj3Y3GrrTFTdft3T6BRVbmsXiGH+sBNQmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zizhi Wo <wozizhi@huawei.com>
Subject: [PATCH 5.15 150/571] vt: skip screen update for DEC alignment test on backgroup consoles
Date: Wed, 28 Oct 2026 17:54:57 +0100
Message-ID: <20261028170011.575741942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2543,7 +2543,8 @@ static void do_con_trol(struct tty_struc
 			csi_J(vc, 2);
 			vc->vc_video_erase_char =
 				(vc->vc_video_erase_char & 0xff00) | ' ';
-			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
+			if (con_should_update(vc))
+				do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
 		}
 		return;
 	case ESsetG0:


