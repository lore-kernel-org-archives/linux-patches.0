Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30D2221DB6;
	Fri, 24 Apr 2026 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038176; cv=none; b=s7psCjwSsBkGv7Q009l6ja5lr94vtK10CfauBwIZWlbKoDutR3oK5Ju1R77E4xmDA7lXnE2vnDxWYpIMHO2M7Q4kGuP54nHDhNGcmjUiMFPPbaMINGt/00Vb9gqf2/5VhzXVoRYVllSVia7v3+W7yKE5WzsB7igr1WmVw1rvJYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038176; c=relaxed/simple;
	bh=XPmEvXaAmA1Su4e/Ik6OB7vGhkyoe4LWVnMMnfJHfNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGGlFb/4dpzY8u55wk1rFqXg5YCNtJYNpSG0S9JBQ2Py2kd5A/0YExO8+0Ahq5Ru3lLEId9iPdsdkPYPsj338xbWIcmq0QkUaudh58u8VspF+60d2IUpNy1QpGsXK6k+09++ZGiAh5ynP54Wuf3NIeeYJPgvJP6D8ROjfOI0m4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqwvnZn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqwvnZn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E8DC19425;
	Fri, 24 Apr 2026 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038176;
	bh=XPmEvXaAmA1Su4e/Ik6OB7vGhkyoe4LWVnMMnfJHfNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqwvnZn3VHBdSS3Qiezs9Yv37FArfHBuraBMyakz8agmPc+dK5/RlErTaa7qJQR9D
	 V15ijtr3g9aVbNMaVN0wD6qUJirCwRSUl80wkh1oV0k/LcMDb3tCwjeMNA3ZW4isfV
	 sH8FGtDdQqN+UU5bM0BleyGtOqCcnwLEfHna4lvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 52/55] crypto: ccp: Dont attempt to copy CSR to userspace if PSP command failed
Date: Fri, 24 Apr 2026 15:31:31 +0200
Message-ID: <20260424132440.924147855@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit abe4a6d6f606113251868c2c4a06ba904bb41eed upstream.

When retrieving the PEK CSR, don't attempt to copy the blob to userspace
if the firmware command failed.  If the failure was due to an invalid
length, i.e. the userspace buffer+length was too small, copying the number
of bytes _firmware_ requires will overflow the kernel-allocated buffer and
leak data to userspace.

  BUG: KASAN: slab-out-of-bounds in instrument_copy_to_user ../include/linux/instrumented.h:129 [inline]
  BUG: KASAN: slab-out-of-bounds in _inline_copy_to_user ../include/linux/uaccess.h:205 [inline]
  BUG: KASAN: slab-out-of-bounds in _copy_to_user+0x66/0xa0 ../lib/usercopy.c:26
  Read of size 2084 at addr ffff898144612e20 by task syz.9.219/21405

  CPU: 14 UID: 0 PID: 21405 Comm: syz.9.219 Tainted: G     U     O        7.0.0-smp-DEV #28 PREEMPTLAZY
  Tainted: [U]=USER, [O]=OOT_MODULE
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 12.62.0-0 11/19/2025
  Call Trace:
   <TASK>
   dump_stack_lvl+0xc5/0x110 ../lib/dump_stack.c:120
   print_address_description ../mm/kasan/report.c:378 [inline]
   print_report+0xbc/0x260 ../mm/kasan/report.c:482
   kasan_report+0xa2/0xe0 ../mm/kasan/report.c:595
   check_region_inline ../mm/kasan/generic.c:-1 [inline]
   kasan_check_range+0x264/0x2c0 ../mm/kasan/generic.c:200
   instrument_copy_to_user ../include/linux/instrumented.h:129 [inline]
   _inline_copy_to_user ../include/linux/uaccess.h:205 [inline]
   _copy_to_user+0x66/0xa0 ../lib/usercopy.c:26
   copy_to_user ../include/linux/uaccess.h:236 [inline]
   sev_ioctl_do_pek_csr+0x31f/0x590 ../drivers/crypto/ccp/sev-dev.c:1872
   sev_ioctl+0x3a4/0x490 ../drivers/crypto/ccp/sev-dev.c:2562
   vfs_ioctl ../fs/ioctl.c:51 [inline]
   __do_sys_ioctl ../fs/ioctl.c:597 [inline]
   __se_sys_ioctl+0x11d/0x1b0 ../fs/ioctl.c:583
   do_syscall_x64 ../arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xe0/0x800 ../arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

WARN if the driver says the command succeeded, but the firmware error code
says otherwise, as __sev_do_cmd_locked() is expected to return -EIO on any
firwmware error.

Reported-by: Alexander Potapenko <glider@google.com>
Reported-by: Sebastian Alba Vives <sebasjosue84@gmail.com>
Fixes: e799035609e1 ("crypto: ccp: Implement SEV_PEK_CSR ioctl command")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1833,7 +1833,10 @@ cmd:
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
-	 /* If we query the CSR length, FW responded with expected data. */
+	/*
+	 * Firmware will returns the length of the CSR blob (either the minimum
+	 * required length or the actual length written), return it to the user.
+	 */
 	input.length = data.len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
@@ -1841,6 +1844,9 @@ cmd:
 		goto e_free_blob;
 	}
 
+	if (ret || WARN_ON_ONCE(argp->error))
+		goto e_free_blob;
+
 	if (blob) {
 		if (copy_to_user(input_address, blob, input.length))
 			ret = -EFAULT;


