Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6443242BE;
	Sat, 30 May 2026 16:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159765; cv=none; b=ppDNidspOqClJvACSdDaR2uGJ3Z4lzXy8fm02+2M7bj/WRqsD8te0tjSkIEjYxUnKSQu2Y4QASA6qkpxsxFG87sHLg7CGkkl9ygEg74i2wt1HbrraqN/FKCZtLTJxi1+w9a6d7bvxCamTSuv7JwDDH+Cg+vT1eAmOab0TaDNSFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159765; c=relaxed/simple;
	bh=I8S1N8uejRXSrBzhZdzPJYJmlJa46nFKkuKzVfFDmlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AY/MlCNKdNvERa2kXQ6e7Eo2XQB0BWXTkkOCUk9Cny7WsQUs2vU0h62CqPTJA7cF1prFn05yz+JN2MnOAEiDkG9XRvGL0Jk0+qm+Pd+4sCZKU7ZJD5Qkkwx/+IMZ718EOfzQRtPHSicYYiW5d72SkbGjF6oeMgp9JWsk1rhSiak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dt14T1Gf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dt14T1Gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1031F00893;
	Sat, 30 May 2026 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159764;
	bh=pHnPB9SK7Kerymuk9un5AZPB6vSlPdkQfjJBcw4UhTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dt14T1Gf0ZPMIbwu8I/jkTJtkPeTxhqphRQf9ZMkvYns2JvwcPYzt9hMbxPcqCXsj
	 u7xaxubhnk24GacJU32vSQJ6hWIIfgKHhdAUCXhbMK8LklykL1PG9GeYoj/BOVnWcD
	 rP9C1V9fOmds5xAQYIrN/sDzRl4laPefVzUU1wVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 155/969] crypto: ccp: Dont attempt to copy CSR to userspace if PSP command failed
Date: Sat, 30 May 2026 17:54:39 +0200
Message-ID: <20260530160304.822235841@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -669,7 +669,10 @@ cmd:
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
-	 /* If we query the CSR length, FW responded with expected data. */
+	/*
+	 * Firmware will returns the length of the CSR blob (either the minimum
+	 * required length or the actual length written), return it to the user.
+	 */
 	input.length = data.len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
@@ -677,6 +680,9 @@ cmd:
 		goto e_free_blob;
 	}
 
+	if (ret || WARN_ON_ONCE(argp->error))
+		goto e_free_blob;
+
 	if (blob) {
 		if (copy_to_user(input_address, blob, input.length))
 			ret = -EFAULT;


