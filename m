Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FA1274B39;
	Sat, 12 Sep 2026 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226411; cv=none; b=Sbj11Hs0O6EZZ4rJg06zvgpnHuX9041A7H3nXksAMae5VZMccIUFCijGVnKClfrDn3vXLlEj+b4rpJEZnGV5Sqg5GQ1vsrbsFsqG4zGZpnB4VY4NpDRdnmj6EkgxCgoAJuz8XT+mMRU2cCg1FSJ07iNTGA5t10FA6z4dlbddZ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226411; c=relaxed/simple;
	bh=C6S8rcGdP4Ux2iqLpgoo6YzDCXirwlBBLwj9lbmp/JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNL3IEGx6XpkPDE1p3E2+N+WtR6X7Ww9z+g/oXdlCaLlY20AMiOd7SRdUmVNrAZ0AspElSow2A0rd9Ik9QKUTmP25bA/0ln9nb/FCtIrJVv8lNnYMJq3RccC600xICQEM0Fg1fw0ouOnqxRqN9qZDrxeEAXqxp1agIlnsHFDqC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygFsXLWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygFsXLWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308591F000FF;
	Sat, 12 Sep 2026 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226410;
	bh=DDvVU7xOBhPgRtIv+hOtsrIAjIowInQ8otlq5aTTZjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ygFsXLWvxP70/UY8aWulnJMhyp79kcjQ2TrJI/JuxnfKj/zi4OOB13XowU7Vp/JWg
	 zd9Loc5INpQQXp+4GhBJxhEhW7Jzig3kkCqsIPh2CCde19OSbfrQnahKD+vNRtZc2z
	 w7WUY++U+8D7j+dkGKzxQ/i/Fk/pW5N4QJX30GGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6665d3db5fef15914802@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1395/1424] usb: atm: usbatm: fix invalid ci_range initialization
Date: Sat, 12 Sep 2026 09:03:47 +0200
Message-ID: <20260912065638.501517005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



