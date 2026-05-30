Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018FE33F8A4;
	Sat, 30 May 2026 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165655; cv=none; b=CTDlcs9pLJtVeIx0DWkmE+kopWcKfV2KHid9JLifJM9W03OYhbKRWBcxkpEjqTouMpuA2ZNYvRA1BljVq3zHmE8cR4xS6zbj7wb3kK+ecfRvj47o3RQPvqt430pCeGKODHOBaC3VicFKmKUXtejy+kQHce+UJ6tFEd6ZMpDvkQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165655; c=relaxed/simple;
	bh=KgrLL6yAxK+JqKjFXsFDjzX0Kv2MVBLdOTexg+irGng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aa3EXH0SGxTJYTyPxDyT1MDFf3zAXYlg1YlIvPxlDQUFR8Z/pvsGgxGH5f1yJWsxx9FyddDkBhgq2xLatxglYBFt/qY0Rr0FWsHEjDkFvN/em4GOf+UAD9lq7Ot9NOYQ+8rHm2XiM9mdlvYuRFz03XbOPlaMh4LWYHmBHcVI8vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+R4TwJt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+R4TwJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E311F00893;
	Sat, 30 May 2026 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165653;
	bh=JjmfaoGbXGqqZOUooE3hqMi39JR9rlbpoDdaj1oUNNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+R4TwJt79/v554IoCw5L8+A0Tpy2dXv431U9lHKIiBuBumGdyatYQ9UOTsEZ7gDV
	 dwEW18wjyryRmlMxx8sILngbwWGfBNFOsEyL0aNNrU4GdsAdrKYK6X9kb/MgHEdgnK
	 mSOzZng/VOVarrB5BtG28mRLr4U4shZk6odLthUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 135/589] crypto: ccp: Dont attempt to copy ID to userspace if PSP command failed
Date: Sat, 30 May 2026 18:00:16 +0200
Message-ID: <20260530160228.328582724@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 4f685dbfa87c546e51d9dc6cab379d20f275e114 upstream.

When retrieving the ID for the CPU, don't attempt to copy the ID blob to
userspace if the firmware command failed.  If the failure was due to an
invalid length, i.e. the userspace buffer+length was too small, copying
the number of bytes _firmware_ requires will overflow the kernel-allocated
buffer and leak data to userspace.

  BUG: KASAN: slab-out-of-bounds in instrument_copy_to_user ../include/linux/instrumented.h:129 [inline]
  BUG: KASAN: slab-out-of-bounds in _inline_copy_to_user ../include/linux/uaccess.h:205 [inline]
  BUG: KASAN: slab-out-of-bounds in _copy_to_user+0x66/0xa0 ../lib/usercopy.c:26
  Read of size 64 at addr ffff8881867f5960 by task syz.0.906/24388

  CPU: 130 UID: 0 PID: 24388 Comm: syz.0.906 Tainted: G     U     O        7.0.0-smp-DEV #28 PREEMPTLAZY
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
   sev_ioctl_do_get_id2+0x361/0x490 ../drivers/crypto/ccp/sev-dev.c:2222
   sev_ioctl+0x25f/0x490 ../drivers/crypto/ccp/sev-dev.c:2575
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
Fixes: d6112ea0cb34 ("crypto: ccp - introduce SEV_GET_ID2 command")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -703,6 +703,9 @@ static int sev_ioctl_do_get_id2(struct s
 		goto e_free;
 	}
 
+	if (ret || WARN_ON_ONCE(argp->error))
+		goto e_free;
+
 	if (id_blob) {
 		if (copy_to_user(input_address, id_blob, data.len)) {
 			ret = -EFAULT;


