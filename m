Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E1E3B9930;
	Tue, 21 Jul 2026 21:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671134; cv=none; b=Y7Y09+4W+tizCYm33cB1HBTqYqGjzOn0HhqqlY4/yH1yY+HKhC5FESdEINoY6AXa1mp5HiIEZ/F2J6CXMtNEr6DGZJ/lDvXc031EcXNYd4t11TkVsj3XR3ycuT2MXvKwx3VlDiIB6vnA6VyFQ1pvf0NSiJCjbkTtFFjpRbnQ3SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671134; c=relaxed/simple;
	bh=V5h6rNDo9HxZyiqiP5o5LWaUSkdP3kgxau32x3rt2kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMW8rDHwj0MAzA8X+p5Hetmmt1ABKoCgOr6h7eMPOTwxxI+JqFE8sR4CcPwY+47r064TkUuIYb14K3UnrrkbLvexPEI72x2qpmvOHW4dmSPucK1uq2g85u2GM9DRnfFqXe/Wohiu0mfn36Z2pRIDYzJgI7sH8Wwny2F/YEGJIuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9G23sQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9G23sQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE0A1F000E9;
	Tue, 21 Jul 2026 21:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671132;
	bh=vX7KnFpzf1Er1qrIYlcl8NNorOlrVMpQn/KIRnM1TU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9G23sQr8Fku6sfhpfy7MRoGsUTaLKvxzHTqnJNJ6vAzsnPxucn1/h677GnQlEU2y
	 FVTxlAkAGmhaFfoaR8RdS90Rm6HXWUs+eK4i5dMcOb/2dlHB3FPHRKjuLkWMGa9oxI
	 niHNayyvcx9+gs8spuvrC7Xxteena4CEtvMxr9zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 087/843] USB: chaoskey: Fix slab-use-after-free in chaoskey_release()
Date: Tue, 21 Jul 2026 17:15:22 +0200
Message-ID: <20260721152407.958195010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit abf76d3239dee97b66e7241ad04811f1ce562e28 upstream.

The chaoskey driver has a use-after-free bug in its release routine.
If the user closes the device file after the USB device has been
unplugged, a debugging log statement will try to access the
usb_interface structure after it has been deallocated:

	BUG: KASAN: slab-use-after-free in dev_driver_string (drivers/base/core.c:2406)
	Read of size 8 at addr ffff888168e8a0b8 by task chaoskey_raw_re/10106

	Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
	Call Trace:
	 <TASK>
	 dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
	 print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
	 kasan_report (mm/kasan/report.c:595)
	 dev_driver_string (drivers/base/core.c:2406)
	 __dynamic_dev_dbg (lib/dynamic_debug.c:906)
	 chaoskey_release (drivers/usb/misc/chaoskey.c:323)
	 __fput (fs/file_table.c:510)
	 fput_close_sync (fs/file_table.c:615)
	 __x64_sys_close (fs/open.c:1507 fs/open.c:1492 fs/open.c:1492)
	 do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
	 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

The driver's last reference to the interface structure is dropped in
the chaoskey_free() routine, so the code must not use the interface --
even in a debugging statement -- after that routine returns.
(Exception: If we know that another reference is held by someone else,
such as the device core while the disconnect routine runs, there's no
problem.  Thanks to Johan Hovold for pointing this out.)

Since the bad access is part of an unimportant debugging statement,
we can fix the problem simply by removing the whole statement.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/linux-usb/20EC9664-054E-438B-B411-2145D347F97B@gmail.com/
Tested-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 66e3e591891d ("usb: Add driver for Altus Metrum ChaosKey device (v2)")
Cc: stable <stable@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/bb5b1dc6-eb59-43e1-8d26-51e658e88bbe@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/chaoskey.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/misc/chaoskey.c
+++ b/drivers/usb/misc/chaoskey.c
@@ -321,7 +321,6 @@ bail:
 	mutex_unlock(&dev->lock);
 destruction:
 	mutex_unlock(&chaoskey_list_lock);
-	usb_dbg(interface, "release success");
 	return rv;
 }
 


