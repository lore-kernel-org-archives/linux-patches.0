Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2A82E2652;
	Tue, 22 Jul 2025 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192604; cv=none; b=UpVhgCG105ERXRTQnd0CFALOfZd2PBOlaNMfXcCMT3zxbJ22u6A+q16dWBF2aahOJQdbpzRe8kmY9kVz+KGllF6LviEkj58ykDGepnmoUSRMk+ZhKBRSVxI3gIdzqT44iQWGBjbOGgVL5lFG7vsIdoJpHwyb49bZrVxmGjpI57E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192604; c=relaxed/simple;
	bh=VntaiVxK+8intHK4oJuDyCdbDOFiJCZNBtYeccP15eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZmnSTjmxFHUxu4aUKXPEsuoIrmP4V7YcMYmIjIEYwumzNDunTh4Fnq7uZ1sO7y6wgcTlt5RvTmFx0UDAky0mMlLh8sUDSzxABsSVWAiakJCMPNsIcVEeY2lg6mVAk5Lwv44R8Xhvm2IQ0B265RugI5rSphV0yJL/5ZFJn9NXQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVDSYvg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVDSYvg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB39C4CEEB;
	Tue, 22 Jul 2025 13:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192603;
	bh=VntaiVxK+8intHK4oJuDyCdbDOFiJCZNBtYeccP15eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVDSYvg/lhmcRF0p8lErBSYU5v/wX2lzFgKonaarFjRjrwEuBJVZg1USJhxbbpWxs
	 8AbiJUVIQGmk3dbYkSfZLbidTFZe8S+C+aen234FFO8woN3Zm6PYwxzTKWEbFdp6ZJ
	 TY9UmR8MVcgaK3CHc9rhNHPnIWVlF3cPZHEeN5ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 108/111] Revert "selftests/bpf: adjust dummy_st_ops_success to detect additional error"
Date: Tue, 22 Jul 2025 15:45:23 +0200
Message-ID: <20250722134337.446623333@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

This reverts commit 264451a364dba5ca6cb2878126a9798dfc0b1a06 which is
commit 3b3b84aacb4420226576c9732e7b539ca7b79633 upstream.

The updated dummy_st_ops test requires commit 1479eaff1f16 ("bpf: mark
bpf_dummy_struct_ops.test_1 parameter as nullable"), which in turn depends on
"Support PTR_MAYBE_NULL for struct_ops arguments" series (see link below),
neither are backported to stable 6.6.

Without them the kernel simply panics from null pointer dereference half way
through running BPF selftests.

    #68/1    deny_namespace/unpriv_userns_create_no_bpf:OK
    #68/2    deny_namespace/userns_create_bpf:OK
    #68      deny_namespace:OK
    [   26.829153] BUG: kernel NULL pointer dereference, address: 0000000000000000
    [   26.831136] #PF: supervisor read access in kernel mode
    [   26.832635] #PF: error_code(0x0000) - not-present page
    [   26.833999] PGD 0 P4D 0
    [   26.834771] Oops: 0000 [#1] PREEMPT SMP PTI
    [   26.835997] CPU: 2 PID: 119 Comm: test_progs Tainted: G           OE      6.6.66-00003-gd80551078e71 #3
    [   26.838774] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
    [   26.841152] RIP: 0010:bpf_prog_8ee9cbe7c9b5a50f_test_1+0x17/0x24
    [   26.842877] Code: 00 00 00 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc f3 0f 1e fa 0f 1f 44 00 00 66 90 55 48 89 e5 f3 0f 1e fa 48 8b 7f 00 <8b> 47 00 be 5a 00 00 00 89 77 00 c9 c3 cc cc cc cc cc cc cc cc c0
    [   26.847953] RSP: 0018:ffff9e6b803b7d88 EFLAGS: 00010202
    [   26.849425] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 2845e103d7dffb60
    [   26.851483] RDX: 0000000000000000 RSI: 0000000084d09025 RDI: 0000000000000000
    [   26.853508] RBP: ffff9e6b803b7d88 R08: 0000000000000001 R09: 0000000000000000
    [   26.855670] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9754c0b5f700
    [   26.857824] R13: ffff9754c09cc800 R14: ffff9754c0b5f680 R15: ffff9754c0b5f760
    [   26.859741] FS:  00007f77dee12740(0000) GS:ffff9754fbc80000(0000) knlGS:0000000000000000
    [   26.862087] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [   26.863705] CR2: 0000000000000000 CR3: 00000001020e6003 CR4: 0000000000170ee0
    [   26.865689] Call Trace:
    [   26.866407]  <TASK>
    [   26.866982]  ? __die+0x24/0x70
    [   26.867774]  ? page_fault_oops+0x15b/0x450
    [   26.868882]  ? search_bpf_extables+0xb0/0x160
    [   26.870076]  ? fixup_exception+0x26/0x330
    [   26.871214]  ? exc_page_fault+0x64/0x190
    [   26.872293]  ? asm_exc_page_fault+0x26/0x30
    [   26.873352]  ? bpf_prog_8ee9cbe7c9b5a50f_test_1+0x17/0x24
    [   26.874705]  ? __bpf_prog_enter+0x3f/0xc0
    [   26.875718]  ? bpf_struct_ops_test_run+0x1b8/0x2c0
    [   26.876942]  ? __sys_bpf+0xc4e/0x2c30
    [   26.877898]  ? __x64_sys_bpf+0x20/0x30
    [   26.878812]  ? do_syscall_64+0x37/0x90
    [   26.879704]  ? entry_SYSCALL_64_after_hwframe+0x78/0xe2
    [   26.880918]  </TASK>
    [   26.881409] Modules linked in: bpf_testmod(OE) [last unloaded: bpf_testmod(OE)]
    [   26.883095] CR2: 0000000000000000
    [   26.883934] ---[ end trace 0000000000000000 ]---
    [   26.885099] RIP: 0010:bpf_prog_8ee9cbe7c9b5a50f_test_1+0x17/0x24
    [   26.886452] Code: 00 00 00 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc f3 0f 1e fa 0f 1f 44 00 00 66 90 55 48 89 e5 f3 0f 1e fa 48 8b 7f 00 <8b> 47 00 be 5a 00 00 00 89 77 00 c9 c3 cc cc cc cc cc cc cc cc c0
    [   26.890379] RSP: 0018:ffff9e6b803b7d88 EFLAGS: 00010202
    [   26.891450] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 2845e103d7dffb60
    [   26.892779] RDX: 0000000000000000 RSI: 0000000084d09025 RDI: 0000000000000000
    [   26.894254] RBP: ffff9e6b803b7d88 R08: 0000000000000001 R09: 0000000000000000
    [   26.895630] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9754c0b5f700
    [   26.897008] R13: ffff9754c09cc800 R14: ffff9754c0b5f680 R15: ffff9754c0b5f760
    [   26.898337] FS:  00007f77dee12740(0000) GS:ffff9754fbc80000(0000) knlGS:0000000000000000
    [   26.899972] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [   26.901076] CR2: 0000000000000000 CR3: 00000001020e6003 CR4: 0000000000170ee0
    [   26.902336] Kernel panic - not syncing: Fatal exception
    [   26.903639] Kernel Offset: 0x36000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
    [   26.905693] ---[ end Kernel panic - not syncing: Fatal exception ]---

Link: https://lore.kernel.org/all/20240209023750.1153905-1-thinker.li@gmail.com/
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/dummy_st_ops_success.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/bpf/progs/dummy_st_ops_success.c
+++ b/tools/testing/selftests/bpf/progs/dummy_st_ops_success.c
@@ -11,17 +11,8 @@ int BPF_PROG(test_1, struct bpf_dummy_op
 {
 	int ret;
 
-	/* Check that 'state' nullable status is detected correctly.
-	 * If 'state' argument would be assumed non-null by verifier
-	 * the code below would be deleted as dead (which it shouldn't).
-	 * Hide it from the compiler behind 'asm' block to avoid
-	 * unnecessary optimizations.
-	 */
-	asm volatile (
-		"if %[state] != 0 goto +2;"
-		"r0 = 0xf2f3f4f5;"
-		"exit;"
-	::[state]"p"(state));
+	if (!state)
+		return 0xf2f3f4f5;
 
 	ret = state->val;
 	state->val = 0x5a;


