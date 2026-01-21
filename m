Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CD633EAE0;
	Wed, 21 Jan 2026 18:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020214; cv=none; b=GtIHi1+6OltX59XswXbo3Kti1jAgVm88ZwDUvC3kW7eG3+1QKSrcKkViZ2l1B0P4qkFmrw+NLBWTdN6CMM9Ilymc3NOIVpR6clrkthvhS8pBLxStpoHI68HB696m8qe1YefP6VEbNVrU+jGB/BTtoNMKO5QZQ8osx8kpzba80gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020214; c=relaxed/simple;
	bh=IqdsUZ+gndtGgp2S9TBLb4LxGOkFAayanfTnEfO3y/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8O/2rlo5mP6XsidU7JWLlxNXim8C6hWeT76P/9Mp7WToNV1qO1k/r0n6nbcKLss3jZgHUKOpA8pd3YGq1e7AR0XX44nGHKIeXA1+g9Vf0u5SoFkehcYvXGGonBe9q6GnEb/akqFKzI9c16eDeE4VUOnd4JdUUuV7pre7Ev9fFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXbbScY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXbbScY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5207EC4CEF1;
	Wed, 21 Jan 2026 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020213;
	bh=IqdsUZ+gndtGgp2S9TBLb4LxGOkFAayanfTnEfO3y/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXbbScY4wG1nYaGQRtjWaBttYHFZUnR6xxs0V66SIbnRHzwlv9sCRIvbH4azVGONd
	 7pAYixV8iBbip3R3rkv1IaANt70vPjI8NuZbr2nJGLgU0deJqGDzdlBzl+Bq13AbkQ
	 mOe3QJI72PGDwW5Qb7bjPpa8c5SjsuJhnSVJ7hj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 092/198] selftests: kvm: replace numbered sync points with actions
Date: Wed, 21 Jan 2026 19:15:20 +0100
Message-ID: <20260121181421.866512154@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit a1025dcd377ef92d9a09af03b70ce80be281ee22 upstream.

Rework the guest=>host syncs in the AMX test to use named actions instead
of arbitrary, incrementing numbers.  The "stage" of the test has no real
meaning, what matters is what action the test wants the host to perform.
The incrementing numbers are somewhat helpful for triaging failures, but
fully debugging failures almost always requires a much deeper dive into
the test (and KVM).

Using named actions not only makes it easier to extend the test without
having to shift all sync point numbers, it makes the code easier to read.

[Commit message by Sean Christopherson]

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/x86/amx_test.c |   88 ++++++++++++++---------------
 1 file changed, 43 insertions(+), 45 deletions(-)

--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -124,6 +124,14 @@ static void set_tilecfg(struct tile_conf
 	}
 }
 
+enum {
+	/* Check TMM0 against tiledata */
+	TEST_COMPARE_TILEDATA = 1,
+
+	/* Full VM save/restore */
+	TEST_SAVE_RESTORE = 2,
+};
+
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 						    struct tile_data *tiledata,
 						    struct xstate *xstate)
@@ -131,20 +139,20 @@ static void __attribute__((__flatten__))
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_XSAVE) &&
 		     this_cpu_has(X86_FEATURE_OSXSAVE));
 	check_xtile_info();
-	GUEST_SYNC(1);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
-	GUEST_SYNC(2);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == 0);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
-	GUEST_SYNC(3);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	/* Check save/restore when trap to userspace */
 	__tileloadd(tiledata);
-	GUEST_SYNC(4);
+	GUEST_SYNC(TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
 	__tilerelease();
-	GUEST_SYNC(5);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	/*
 	 * After XSAVEC, XTILEDATA is cleared in the xstate_bv but is set in
 	 * the xcomp_bv.
@@ -154,6 +162,8 @@ static void __attribute__((__flatten__))
 	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
 	GUEST_ASSERT(xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA);
 
+	/* #NM test */
+
 	/* xfd=0x40000, disable amx tiledata */
 	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
 
@@ -166,13 +176,13 @@ static void __attribute__((__flatten__))
 	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
 	GUEST_ASSERT((xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA));
 
-	GUEST_SYNC(6);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
 	/* Trigger #NM exception */
 	__tileloadd(tiledata);
-	GUEST_SYNC(10);
+	GUEST_SYNC(TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
 
 	GUEST_DONE();
 }
@@ -180,18 +190,18 @@ static void __attribute__((__flatten__))
 void guest_nm_handler(struct ex_regs *regs)
 {
 	/* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
-	GUEST_SYNC(7);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(!(get_cr0() & X86_CR0_TS));
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
-	GUEST_SYNC(8);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	/* Clear xfd_err */
 	wrmsr(MSR_IA32_XFD_ERR, 0);
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
-	GUEST_SYNC(9);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 }
 
 int main(int argc, char *argv[])
@@ -244,6 +254,7 @@ int main(int argc, char *argv[])
 	memset(addr_gva2hva(vm, xstate), 0, PAGE_SIZE * DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
 	vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xstate);
 
+	int iter = 0;
 	for (;;) {
 		vcpu_run(vcpu);
 		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
@@ -253,20 +264,9 @@ int main(int argc, char *argv[])
 			REPORT_GUEST_ASSERT(uc);
 			/* NOT REACHED */
 		case UCALL_SYNC:
-			switch (uc.args[1]) {
-			case 1:
-			case 2:
-			case 3:
-			case 5:
-			case 6:
-			case 7:
-			case 8:
-				fprintf(stderr, "GUEST_SYNC(%ld)\n", uc.args[1]);
-				break;
-			case 4:
-			case 10:
-				fprintf(stderr,
-				"GUEST_SYNC(%ld), check save/restore status\n", uc.args[1]);
+			++iter;
+			if (uc.args[1] & TEST_COMPARE_TILEDATA) {
+				fprintf(stderr, "GUEST_SYNC #%d, check TMM0 contents\n", iter);
 
 				/* Compacted mode, get amx offset by xsave area
 				 * size subtract 8K amx size.
@@ -279,11 +279,25 @@ int main(int argc, char *argv[])
 				ret = memcmp(amx_start, tiles_data, TILE_SIZE);
 				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d", ret);
 				kvm_x86_state_cleanup(state);
-				break;
-			case 9:
-				fprintf(stderr,
-				"GUEST_SYNC(%ld), #NM exception and enable amx\n", uc.args[1]);
-				break;
+			}
+			if (uc.args[1] & TEST_SAVE_RESTORE) {
+				fprintf(stderr, "GUEST_SYNC #%d, save/restore VM state\n", iter);
+				state = vcpu_save_state(vcpu);
+				memset(&regs1, 0, sizeof(regs1));
+				vcpu_regs_get(vcpu, &regs1);
+
+				kvm_vm_release(vm);
+
+				/* Restore state in a new VM.  */
+				vcpu = vm_recreate_with_one_vcpu(vm);
+				vcpu_load_state(vcpu, state);
+				kvm_x86_state_cleanup(state);
+
+				memset(&regs2, 0, sizeof(regs2));
+				vcpu_regs_get(vcpu, &regs2);
+				TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
+					    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
+					    (ulong) regs2.rdi, (ulong) regs2.rsi);
 			}
 			break;
 		case UCALL_DONE:
@@ -293,22 +307,6 @@ int main(int argc, char *argv[])
 			TEST_FAIL("Unknown ucall %lu", uc.cmd);
 		}
 
-		state = vcpu_save_state(vcpu);
-		memset(&regs1, 0, sizeof(regs1));
-		vcpu_regs_get(vcpu, &regs1);
-
-		kvm_vm_release(vm);
-
-		/* Restore state in a new VM.  */
-		vcpu = vm_recreate_with_one_vcpu(vm);
-		vcpu_load_state(vcpu, state);
-		kvm_x86_state_cleanup(state);
-
-		memset(&regs2, 0, sizeof(regs2));
-		vcpu_regs_get(vcpu, &regs2);
-		TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
-			    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
-			    (ulong) regs2.rdi, (ulong) regs2.rsi);
 	}
 done:
 	kvm_vm_free(vm);


