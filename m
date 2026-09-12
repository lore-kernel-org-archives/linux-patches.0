Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D184CF4F1;
	Sat, 12 Sep 2026 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232135; cv=none; b=LsZkIjqdLcVqSEvlZONxOXx3pvXXKQ3QpdOlDCVnU9Ed4/LNa4/UJUqQBAscd4cy0cYqrKDhF7nEnVAHND+OPnVvuZlmXqRLwx4pcVlreknW/TVQvyRHVO1VQJM6nt+TsNkquGxx23hC0QyPxdDjwxEEV1EERJBZqGI4iSSW2vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232135; c=relaxed/simple;
	bh=VPe1JPxlW+G6f2Te3F8kgJY18V9Wlk07r+VY2JV8Pl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHwlv66xaZWPRgBgm9IcuwPoJv5hHGDHGYgERa8HiNQuClI9SKnDQUdr2ODy0cAduussoa6whkLuAt6EKTHvlNCDXwEuXEwgXIQ1wnds+7kYIV4mdrAO16KJa2h3qs66Lrtje1afY5jSJ5RA4pvuf4kbS7cBw5dQx0xML1mZCxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yy5aZS6C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yy5aZS6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65561F000FF;
	Sat, 12 Sep 2026 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232133;
	bh=43g6AmlXzxvvzAHavHvmCL0FB6QGbzG6cfRvK7sbeps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yy5aZS6CFD3aYfwZIJ8NslXHhuEa7ayusWgwJceB5HpVYwV844GDL/FrNwFPmImWD
	 ImHtw3V204qm3labggIa57QLv1CjgPKdpgFWfrvaSoQ8aynd0E5/qxGKvzmgyP2xCf
	 QkdDDHivK+7foLnBSqLsMyDujG2t1oxWjugtCtQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6665d3db5fef15914802@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1139/1191] usb: atm: usbatm: fix invalid ci_range initialization
Date: Sat, 12 Sep 2026 09:04:27 +0200
Message-ID: <20260912065613.733029786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit a60fd8c6dbaa76da4163cf225ed2b9e982540f39 ]

syzbot reported a shift-out-of-bounds in __vcc_connect():

  UBSAN: shift-out-of-bounds in net/atm/common.c:382:32
  shift exponent -1 is negative
  CPU: 0 UID: 0 PID: 5987 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full)
  Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
  Call Trace:
   <TASK>
   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
   ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
   __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
   __vcc_connect+0x14b4/0x19c0 net/atm/common.c:382
   vcc_connect+0x328/0x8f0 net/atm/common.c:498
   pvc_bind+0x272/0x380 net/atm/pvc.c:52
   __sys_bind+0x2e3/0x410 net/socket.c:1976
   __x64_sys_bind+0x7a/0x90 net/socket.c:1979
   ...

ATM device ci_range fields (vpi_bits and vci_bits) represent the
number of bits supported for VPI and VCI addressing on the device.
net/atm/common.c directly uses these fields as bit shift counts:
  vpi >> dev->ci_range.vpi_bits
  vci >> dev->ci_range.vci_bits
  1 << vcc->dev->ci_range.vpi_bits
  1 << vcc->dev->ci_range.vci_bits

usbatm_atm_init() sets ci_range.vpi_bits and ci_range.vci_bits to
ATM_CI_MAX (-1), which is defined in <uapi/linux/atmdev.h> as a
sentinel value for userspace ATM_SETCIRANGE requests, not a valid bit
count. Shifting by -1 is undefined behavior and triggers UBSAN
warnings.

ATM UNI cell headers allow up to 8 bits for VPI (0..255) and 16 bits
for VCI (0..65535). Initialize vpi_bits to 8 and vci_bits to 16, as
done by solos-pci.

Fixes: c59bba75fa50 ("[PATCH] USB ATM: new usbatm core")
Reported-by: syzbot+6665d3db5fef15914802@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6665d3db5fef15914802
Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/all/20260824024620.23485-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260826133258.8306-1-kartikey406@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/atm/usbatm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index 1cdb8758ae01b..bbee6bfed5b88 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -917,8 +917,8 @@ static int usbatm_atm_init(struct usbatm_data *instance)
 
 	instance->atm_dev = atm_dev;
 
-	atm_dev->ci_range.vpi_bits = ATM_CI_MAX;
-	atm_dev->ci_range.vci_bits = ATM_CI_MAX;
+	atm_dev->ci_range.vpi_bits = 8;
+	atm_dev->ci_range.vci_bits = 16;
 	atm_dev->signal = ATM_PHY_SIG_UNKNOWN;
 
 	/* temp init ATM device, set to 128kbit */
-- 
2.53.0



