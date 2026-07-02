Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A894623EAAD;
	Thu,  2 Jul 2026 16:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011389; cv=none; b=KnccvIK8pPrDOU+wYFyJOb89Z2FvzbtZ7GAZI1HqQ8aIzqky7hxWH+ERXupD1BPT70o/aiG6VN45xEqeFLon1fu3yM4T7ULlVmCbX15hKcqJ6KV8EJI+tzTgMS+gf+t7U666O5XiCd5Q4TkUQIeuoDF00BzhGTyUVC0OVx9l1RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011389; c=relaxed/simple;
	bh=/749971AkzzBDTnPOjknewmjQZHhLs7fKcodrwxxq34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mv0m2AQzA4h+fOt6s+CDWh13jluuFBeJA9JoZ/RAZ6Ninig2LOlKFMxa3xEYWcuUVq6SuZiZLnUzGGO5jnNPoAna3wk+HMvnDhNpmHkY3fPULLGKYWqxI0jR9r/yILkQgCZbLJcHAAN4u5w4KuOzqlRNfQJtjpQLVpOb6Vs030E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0u4t3fi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0u4t3fi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B441F00A3A;
	Thu,  2 Jul 2026 16:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011388;
	bh=l6fJB8um8liq6oEpWQgkZlOJkT1UeH1oJRs8m92i8Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0u4t3fi7gHwWVymF3tAamy8BG/GhpEG8aPQ8az0E8D6V2XrN4mXvd46m2FMaXl+gM
	 WJrcGGSlVfEMqcpgjDeD9oQYh1gZtctDmbQL09MLIW/nAj2MOdTBELKfOmkHSDpjlZ
	 SwVfGuA1wCzd6xrOIiZX7r9mdWh/JUUKOhlwvAxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 088/108] KVM: SVM: Fix page overflow in sev_dbg_crypt() for ENCRYPT path
Date: Thu,  2 Jul 2026 18:21:25 +0200
Message-ID: <20260702155113.935019177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

commit 78ee2d50185a037b3d2452a97f3dad69c3f7f389 upstream.

In sev_dbg_crypt(), the per-iteration transfer length is bounded by
the source page offset (PAGE_SIZE - s_off) but not by the destination
page offset (PAGE_SIZE - d_off).  When d_off > s_off, the encrypt
path (__sev_dbg_encrypt_user) performs a read-modify-write using a
single-page intermediate buffer (dst_tpage):

  1. __sev_dbg_decrypt() expands the size to round_up(len + (d_off & 15), 16)
     before issuing the PSP command.  If len + (d_off & 15) > PAGE_SIZE,
     the PSP writes beyond the end of the 4096-byte dst_tpage allocation.

  2. The subsequent memcpy()/copy_from_user() into
     page_address(dst_tpage) + (d_off & 15) of 'len' bytes overflows
     by up to 15 bytes under the same condition.

Trigger example: s_off = 0, d_off = 1, debug.len = PAGE_SIZE -
the PSP is instructed to write round_up(4097, 16) = 4112 bytes to
a 4096-byte buffer.

Fix by also bounding len by (PAGE_SIZE - d_off), the same check that
sev_send_update_data() already performs for its single-page guest
region.

 ==================================================================
 BUG: KASAN: slab-use-after-free in sev_dbg_crypt+0x993/0xd10 [kvm_amd]
 Write of size 4095 at addr ff110062293bb009 by task sev_dbg_test/228214

 CPU: 96 UID: 0 PID: 228214 Comm: sev_dbg_test Tainted: G     U  W           7.0.0-smp--5ce9b0c48211-dbg #156 PREEMPTLAZY
 Tainted: [U]=USER, [W]=WARN
 Hardware name: Google Astoria/astoria, BIOS 0.20250817.1-0 08/25/2025
 Call Trace:
  <TASK>
  dump_stack_lvl+0x54/0x70
  print_report+0xbc/0x260
  kasan_report+0xa2/0xd0
  kasan_check_range+0x25f/0x2c0
  __asan_memcpy+0x40/0x70
  sev_dbg_crypt+0x993/0xd10 [kvm_amd]
  sev_mem_enc_ioctl+0x33c/0x450 [kvm_amd]
  kvm_vm_ioctl+0x65d/0x6d0 [kvm]
  __se_sys_ioctl+0xb2/0x100
  do_syscall_64+0xe8/0x870
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
  </TASK>

 The buggy address belongs to the physical page:
 page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x7fe72b6a0 pfn:0x62293bb
 memcg:ff11000112827d82
 flags: 0x1400000000000000(node=1|zone=1)
 raw: 1400000000000000 0000000000000000 dead000000000122 0000000000000000
 raw: 00000007fe72b6a0 0000000000000000 00000001ffffffff ff11000112827d82
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ff110062293bbf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ff110062293bbf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 >ff110062293bc000: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                    ^
  ff110062293bc080: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ff110062293bc100: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ==================================================================
 Disabling lock debugging due to kernel taint

Fixes: 24f41fb23a39 ("KVM: SVM: Add support for SEV DEBUG_DECRYPT command")
Fixes: 7d1594f5d94b ("KVM: SVM: Add support for SEV DEBUG_ENCRYPT command")
Cc: stable@vger.kernel.org
Signed-off-by: Ashutosh Desai <ashutoshdesai993@gmail.com>
[sean: add sample KASAN splat, Fixes, and stable@]
Link: https://patch.msgid.link/20260501203537.2120074-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1340,6 +1340,7 @@ static int sev_dbg_crypt(struct kvm *kvm
 		s_off = vaddr & ~PAGE_MASK;
 		d_off = dst_vaddr & ~PAGE_MASK;
 		len = min_t(size_t, (PAGE_SIZE - s_off), size);
+		len = min_t(size_t, len, PAGE_SIZE - d_off);
 
 		if (dec)
 			ret = __sev_dbg_decrypt_user(kvm,


