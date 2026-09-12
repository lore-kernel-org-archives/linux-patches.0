Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDECE3B3C19;
	Sat, 12 Sep 2026 20:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243532; cv=none; b=oWQrCBrsQxVtj+e0BlVIOeWfiVr/M/lIA/4Xz5ln1yd6YKBMBHImV8YFrIDiyWRvihaglDL7pjt2pA80rUIrxDkQZZZVP2J6z+DQAO1GQ77ZM4PKchAb5AklNelTcOKgz06zxFk5H/OfHPva/3AiVT7K73KFA77d//NZDo/LY28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243532; c=relaxed/simple;
	bh=C0Wn2LfUOSzl6W72wjVuY93GoW6SryNGUdTLXL8/INY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/rI7WY62+dUIvFApUVu7M2TJtmsXvIruUMgwX7MSVnjCmXon8fpx6fT7Av5m64+zT6GsdZKAZV6fuz6ogWc/FTeqH0EZ4Y32MUdDPGIlLs8+W3QxjzYXa80+DPkeRjpmn/lzb1dsjnt/VSvbNMYa28nQQ1CD31xciNxA97ZaCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PN7q8DnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PN7q8DnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA5C1F00899;
	Sat, 12 Sep 2026 20:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243529;
	bh=grpLTH85p3c303LHFfbqawmxiSozx83zs0Q3nOEXv/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PN7q8DnJShlG9S4UjuaxI+iMrsrHHm5l2JyN3LKxAVdo9Rlq6kR5+/k5sWZ1208aI
	 Px1wkKQh+LQ8oOdxQ1DK/B0aKA0vK9t9DL10Q5pWUY0Y0yk2S61XQEYcFUcLEUHVVU
	 4+ciYSr249UW//+4+m+6yZNZUBk3lvL8bbkiDT/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6665d3db5fef15914802@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 785/798] usb: atm: usbatm: fix invalid ci_range initialization
Date: Sat, 12 Sep 2026 09:06:53 +0200
Message-ID: <20260912065535.056563600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 56fe30d247dad..2eb3cee2061b5 100644
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



