Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BB733EAE0;
	Wed, 21 Jan 2026 18:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020217; cv=none; b=JQMY7PFYyJhd4qsq+9lrSLRkSKSyWv5mZx8mzup50I53+4Ja3hQourdkYVLu08Hpp0/bgw/q206NwcM20qcv2nJQg8O6YbleKjqh5dnTgjwz7LgyNqwXEIUs9OSVK9MDi5MBGP5wv4/HXKH5vpNLsu00bdurxcYOQWTPVBYvs4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020217; c=relaxed/simple;
	bh=pdisrH1GII42wJkvaRMbFaAxoeGnLM2XAEmsAhx28tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoJMuN9dsjsdqe9MIGy1PPLAF8NEN23EfUAOgB9C/w0sCF1u7Jx9AwfT41fjIG18G7mbo8nlK+OXHR+0sVCc8NpvNHcA+UioRywNIk/gkgMaP1GH7m46TPQF5zt8MToqcchMm7lgnJ4h/ilBQmFRqrvsIjLvGgHbYbuBE//YXT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvZtv44L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvZtv44L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DB3C4CEF1;
	Wed, 21 Jan 2026 18:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020217;
	bh=pdisrH1GII42wJkvaRMbFaAxoeGnLM2XAEmsAhx28tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvZtv44LwQmBq1EYjjZ+97/j55feY/6B9aRrntympHVr0AbtE1fQKUIYeHcR2Y/Km
	 c8HDbyGvKyni4tXy5uut5VZBhDEeIFNCKcTdTPqaehr5BNCTR49HKz0Mjn9NEKHmTF
	 +ieVzgeCW2UBHlK3zn3Jdzex3z3I22WGZKyErRus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 093/198] selftests: kvm: try getting XFD and XSAVE state out of sync
Date: Wed, 21 Jan 2026 19:15:21 +0100
Message-ID: <20260121181421.901388626@linuxfoundation.org>
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

commit 0383a8edef396cf0a6884b0be81d62bde60737b0 upstream.

The host is allowed to set FPU state that includes a disabled
xstate component.  Check that this does not cause bad effects.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/x86/amx_test.c |   38 ++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -125,11 +125,17 @@ static void set_tilecfg(struct tile_conf
 }
 
 enum {
+	/* Retrieve TMM0 from guest, stash it for TEST_RESTORE_TILEDATA */
+	TEST_SAVE_TILEDATA = 1,
+
 	/* Check TMM0 against tiledata */
-	TEST_COMPARE_TILEDATA = 1,
+	TEST_COMPARE_TILEDATA = 2,
+
+	/* Restore TMM0 from earlier save */
+	TEST_RESTORE_TILEDATA = 4,
 
 	/* Full VM save/restore */
-	TEST_SAVE_RESTORE = 2,
+	TEST_SAVE_RESTORE = 8,
 };
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
@@ -150,7 +156,16 @@ static void __attribute__((__flatten__))
 	GUEST_SYNC(TEST_SAVE_RESTORE);
 	/* Check save/restore when trap to userspace */
 	__tileloadd(tiledata);
-	GUEST_SYNC(TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
+	GUEST_SYNC(TEST_SAVE_TILEDATA | TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
+
+	/* xfd=0x40000, disable amx tiledata */
+	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
+
+	/* host tries setting tiledata while guest XFD is set */
+	GUEST_SYNC(TEST_RESTORE_TILEDATA);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
+
+	wrmsr(MSR_IA32_XFD, 0);
 	__tilerelease();
 	GUEST_SYNC(TEST_SAVE_RESTORE);
 	/*
@@ -210,10 +225,10 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_x86_state *state;
+	struct kvm_x86_state *tile_state = NULL;
 	int xsave_restore_size;
 	vm_vaddr_t amx_cfg, tiledata, xstate;
 	struct ucall uc;
-	u32 amx_offset;
 	int ret;
 
 	/*
@@ -265,20 +280,27 @@ int main(int argc, char *argv[])
 			/* NOT REACHED */
 		case UCALL_SYNC:
 			++iter;
+			if (uc.args[1] & TEST_SAVE_TILEDATA) {
+				fprintf(stderr, "GUEST_SYNC #%d, save tiledata\n", iter);
+				tile_state = vcpu_save_state(vcpu);
+			}
 			if (uc.args[1] & TEST_COMPARE_TILEDATA) {
 				fprintf(stderr, "GUEST_SYNC #%d, check TMM0 contents\n", iter);
 
 				/* Compacted mode, get amx offset by xsave area
 				 * size subtract 8K amx size.
 				 */
-				amx_offset = xsave_restore_size - NUM_TILES*TILE_SIZE;
-				state = vcpu_save_state(vcpu);
-				void *amx_start = (void *)state->xsave + amx_offset;
+				u32 amx_offset = xsave_restore_size - NUM_TILES*TILE_SIZE;
+				void *amx_start = (void *)tile_state->xsave + amx_offset;
 				void *tiles_data = (void *)addr_gva2hva(vm, tiledata);
 				/* Only check TMM0 register, 1 tile */
 				ret = memcmp(amx_start, tiles_data, TILE_SIZE);
 				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d", ret);
-				kvm_x86_state_cleanup(state);
+			}
+			if (uc.args[1] & TEST_RESTORE_TILEDATA) {
+				fprintf(stderr, "GUEST_SYNC #%d, before KVM_SET_XSAVE\n", iter);
+				vcpu_xsave_set(vcpu, tile_state->xsave);
+				fprintf(stderr, "GUEST_SYNC #%d, after KVM_SET_XSAVE\n", iter);
 			}
 			if (uc.args[1] & TEST_SAVE_RESTORE) {
 				fprintf(stderr, "GUEST_SYNC #%d, save/restore VM state\n", iter);


