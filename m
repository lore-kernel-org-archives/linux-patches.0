Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0773264DC;
	Sat, 30 May 2026 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159773; cv=none; b=PLF6V4EDomTA52m/rRlgzvVPGv3Bna69V5Ff3lNAUMrywKD0RUR6T6zlHXY/7LGNJ9qZxOBC/Be+rlAd8N0pnDx0Gh1oFKHokuoEFDIH4rC8FwGox2tIegiZQzqrcbrVhnhrn+zmequWR6paXwGaGuhZz+tzd/0mCuHZ3jl3Dn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159773; c=relaxed/simple;
	bh=i2JX1fcaH/Vmk4ajMK2a1GrSXi9BTZSXW0NYn0eguyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9FDJ05qqoUO/er8NwuNDXhuDMLCFeuoWk7Cb3A2bv2SC63vTyayJ2f0UyREkTHAb2zevbGtefaBXSAv1mcemqNZ+mqYnkrRYs3YG5DjkvFJZtRKT6kJUrdhcuf3pTWitzgsO7j4Ikwn+m3c3aUQ3HVnJAa8ErQwZ3QjCmqsjio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1HD15Su; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1HD15Su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A206A1F00893;
	Sat, 30 May 2026 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159772;
	bh=CU/sTqdPBCGGe+1CBHNARHE08PDxABQ6xCLnS5n6krY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1HD15SupB3P/aq8XxK0N3lukzD1P6pIQ7+t0DQBbUEA/j7zhX7XgGG6TI7qTGQX9
	 uyKsEeCuqB/xY3F1Rr2b7AGBkMDHepHNbRX6c4BQiTx5bOrqOVuHUlg5+1CIv7u8OM
	 Wy6dfn+5LoRuu/hzZ+aKDZ12RYO0HJATGWiYHVVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 156/969] crypto: ccp: Dont attempt to copy PDH cert to userspace if PSP command failed
Date: Sat, 30 May 2026 17:54:40 +0200
Message-ID: <20260530160304.847984856@linuxfoundation.org>
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

commit e76239fed3cffd6d304d8ca3ce23984fd24f57d3 upstream.

When retrieving the PDH cert, don't attempt to copy the blobs to userspace
if the firmware command failed.  If the failure was due to an invalid
length, i.e. the userspace buffer+length was too small, copying the number
of bytes _firmware_ requires will overflow the kernel-allocated buffer and
leak data to userspace.

  BUG: KASAN: slab-out-of-bounds in instrument_copy_to_user ../include/linux/instrumented.h:129 [inline]
  BUG: KASAN: slab-out-of-bounds in _inline_copy_to_user ../include/linux/uaccess.h:205 [inline]
  BUG: KASAN: slab-out-of-bounds in _copy_to_user+0x66/0xa0 ../lib/usercopy.c:26
  Read of size 2084 at addr ffff8885c4ab8aa0 by task syz.0.186/21033

  CPU: 51 UID: 0 PID: 21033 Comm: syz.0.186 Tainted: G     U     O        7.0.0-smp-DEV #28 PREEMPTLAZY
  Tainted: [U]=USER, [O]=OOT_MODULE
  Hardware name: Google, Inc.                                                       Arcadia_IT_80/Arcadia_IT_80, BIOS 34.84.12-0 11/17/2025
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
   sev_ioctl_do_pdh_export+0x3d3/0x7c0 ../drivers/crypto/ccp/sev-dev.c:2347
   sev_ioctl+0x2a2/0x490 ../drivers/crypto/ccp/sev-dev.c:2568
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
Fixes: 76a2b524a4b1 ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1041,7 +1041,10 @@ static int sev_ioctl_do_pdh_export(struc
 cmd:
 	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
-	/* If we query the length, FW responded with expected data. */
+	/*
+	 * Firmware will return the length of the blobs (either the minimum
+	 * required length or the actual length written), return 'em to the user.
+	 */
 	input.cert_chain_len = data.cert_chain_len;
 	input.pdh_cert_len = data.pdh_cert_len;
 
@@ -1050,6 +1053,9 @@ cmd:
 		goto e_free_cert;
 	}
 
+	if (ret || WARN_ON_ONCE(argp->error))
+		goto e_free_cert;
+
 	if (pdh_blob) {
 		if (copy_to_user(input_pdh_cert_address,
 				 pdh_blob, input.pdh_cert_len)) {


