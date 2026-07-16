Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5C0424668;
	Thu, 16 Jul 2026 14:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211866; cv=none; b=E89+jW8ZWKHzZgt5Vkg/beCPCDH1c3DUaFJZlospJVDib6HKtHZT//posVDxO902vwBB7UrX6Fx+Mn3t9nTMqai5/ERJ159C+Lx/m7Qv2L6N4l6mH9HOfz4gI6hs7X5pyVBSw1Sjab/M3fLCcKxE+Jh256GtlXbLKC5SHfHm3dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211866; c=relaxed/simple;
	bh=MOqysvvGeLkSupA3ATqIChtigDEAK7SbsD5CNIdaqkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGnTWYqHPb7RvnNTNMCiBoy0c7TTw84fgyVYvCJJilaHDNovMNeg4dhRgRhIPL9ndq9P25wkKgmGlbvSLXHMv0c7E3WLUdfDtpc/b+4zJUWvjJt+H05ZovLcDnaDiTSPHMVVPYaznADp0VNYEdNIZxfCERAEg8YAWSz36Yx986M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2roTn8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2roTn8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F6C1F000E9;
	Thu, 16 Jul 2026 14:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211863;
	bh=7jcdSn/8JhZNmeFs+hJuQ4/eUVv8R7yb8o+K9R4KCrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2roTn8tSo0H9lCdUtxzj4o4DAIdK1jBundtfF3llp2VFJBAF6L3cMzA3CxPB0AGj
	 VN19d5hruGd1YGAiCTg5TGqqek1EWlvso2k5+yM3IyzRonJWWoJGVCiiu2G7FpKXIL
	 +7CrxdwZynXfLdJsz/2wM3+kZIpkKkR4Q+DI/eBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 110/349] USB: chaoskey: Fix slab-use-after-free in chaoskey_release()
Date: Thu, 16 Jul 2026 15:30:44 +0200
Message-ID: <20260716133035.775596508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


