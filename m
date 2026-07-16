Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805755A79B;
	Thu, 16 Jul 2026 14:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210706; cv=none; b=fU0PfwEc0nJj5iWqfpq8J70vJrxgb/NkHILFmjqLqPCZDGYqUUP7Zt7GRPAfYNQW7NYmbOlNbhGmERfzlIB4xeRhav9RsGad0i3OKJfJL67x0V9QVnN72LdoX286imF5TCUt0V9yNt6mjnJc6A9PNI5NeVXk7dzF4Dbe6h+wxQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210706; c=relaxed/simple;
	bh=O3m+NwpSm5tI/qw58isr26nhYp+c26Xj2xGpHa42/ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruSCl+lh0DWOWbCFKBMEoU2sr0myIMzEDOT64ActC919xthg7bM8jw99KxjJJY4TCS3Wvd0aC5C44mDQdAwRBOmWXkdQbWwaGrEzTAhwefKQDqtMYvcnDarv7GZFE5KzCMgUB2u8+cqSoyPQqD10+XPxpcToSgdfDItjs6YTWTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOxEzijg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOxEzijg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62FD1F000E9;
	Thu, 16 Jul 2026 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210705;
	bh=heMgYv8v7/4ID8NDCC7firwiG8mUHGk1kA2gktTvzbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOxEzijgfXshiHj6GhBiTOc2hsoJ0oF/pZH6QBsB9/hkdb/hDY4SS4GYKDDySAjp9
	 2ZWR9bCpgPMStKRaE8I14s8SJCiHRX+Hv/w/kBCFh3IK7EaKQs7JpeM8Lht/79Y8zn
	 EqmTdFW1jknheUe1QiYMY3Yo6oGp3V/aaQq0FKY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 150/480] USB: chaoskey: Fix slab-use-after-free in chaoskey_release()
Date: Thu, 16 Jul 2026 15:28:17 +0200
Message-ID: <20260716133047.953476608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -320,7 +320,6 @@ bail:
 	mutex_unlock(&dev->lock);
 destruction:
 	mutex_unlock(&chaoskey_list_lock);
-	usb_dbg(interface, "release success");
 	return rv;
 }
 


