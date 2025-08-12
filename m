Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B975260583;
	Tue, 12 Aug 2025 19:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026045; cv=none; b=pvn3aJgToGqCoxtcAlff27ZpE7tqb1yzqCnXi4/s0WVP46FL+mYN9c8Mj7FuiDn6l9ANDYH0feBWBzQvVegcsvQTSt3hoCVL3fNIFt0h0wnnM6+MUcoKyoa3zCS45/YRoakQx7LjV/8XKLrEnrr2KEBK8HH2z+3TFrUyHPOGpOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026045; c=relaxed/simple;
	bh=85F0G+46XL8soh5qKCG9p8qtXxO6En25Ju9nxZ3vy0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbVeBoYPEmDWD/KdRtNUJ02NWndJdigYw9GuXW4ZNzezSc8QcdP4lFt5cUjosHfjDMyQEgT7Vv/SJsSvG7E/BgB4jbiZERZIAE2Kk7NG3ac/ev1k60kGxKqic2KctWzffPFIbVvRo6KNv/Yg4w0EWDlesZqwHZIrptns8ZMXOWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kq//5MX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kq//5MX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4D2C4CEF0;
	Tue, 12 Aug 2025 19:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026045;
	bh=85F0G+46XL8soh5qKCG9p8qtXxO6En25Ju9nxZ3vy0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kq//5MX256Y0tX0IU+oHcvtwnBYOiiNX1eI331R3okxKHijjrT1tdsCpDqqb681s2
	 O3O/PSXWsjD4PBU1dbLxftXk1KlHM9AdupAF/QDS+cy/Az0tmfwuDdIUeILFtYEjHX
	 h9vgqJpmAO0TT0nCcPlz+r0cGExRnK7mWA3j6aqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 219/480] RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap
Date: Tue, 12 Aug 2025 19:47:07 +0200
Message-ID: <20250812174406.484521208@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 7826c8f37220daabf90c09fcd9a835d6763f1372 ]

The Smnpm extension requires special handling because the guest ISA
extension maps to a different extension (Ssnpm) on the host side.
commit 1851e7836212 ("RISC-V: KVM: Allow Smnpm and Ssnpm extensions for
guests") missed that the vcpu->arch.isa bit is based only on the host
extension, so currently both KVM_RISCV_ISA_EXT_{SMNPM,SSNPM} map to
vcpu->arch.isa[RISCV_ISA_EXT_SSNPM]. This does not cause any problems
for the guest, because both extensions are force-enabled anyway when the
host supports Ssnpm, but prevents checking for (guest) Smnpm in the SBI
FWFT logic.

Redefine kvm_isa_ext_arr to look up the guest extension, since only the
guest -> host mapping is unambiguous. Factor out the logic for checking
for host support of an extension, so this special case only needs to be
handled in one place, and be explicit about which variables hold a host
vs a guest ISA extension.

Fixes: 1851e7836212 ("RISC-V: KVM: Allow Smnpm and Ssnpm extensions for guests")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20250111004702.2813013-2-samuel.holland@sifive.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_onereg.c | 83 +++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 30 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 2e1b646f0d61..cce6a38ea54f 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -23,7 +23,7 @@
 #define KVM_ISA_EXT_ARR(ext)		\
 [KVM_RISCV_ISA_EXT_##ext] = RISCV_ISA_EXT_##ext
 
-/* Mapping between KVM ISA Extension ID & Host ISA extension ID */
+/* Mapping between KVM ISA Extension ID & guest ISA extension ID */
 static const unsigned long kvm_isa_ext_arr[] = {
 	/* Single letter extensions (alphabetically sorted) */
 	[KVM_RISCV_ISA_EXT_A] = RISCV_ISA_EXT_a,
@@ -35,7 +35,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
 	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
 	/* Multi letter extensions (alphabetically sorted) */
-	[KVM_RISCV_ISA_EXT_SMNPM] = RISCV_ISA_EXT_SSNPM,
+	KVM_ISA_EXT_ARR(SMNPM),
 	KVM_ISA_EXT_ARR(SMSTATEEN),
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSCOFPMF),
@@ -112,6 +112,36 @@ static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
 	return KVM_RISCV_ISA_EXT_MAX;
 }
 
+static int kvm_riscv_vcpu_isa_check_host(unsigned long kvm_ext, unsigned long *guest_ext)
+{
+	unsigned long host_ext;
+
+	if (kvm_ext >= KVM_RISCV_ISA_EXT_MAX ||
+	    kvm_ext >= ARRAY_SIZE(kvm_isa_ext_arr))
+		return -ENOENT;
+
+	*guest_ext = kvm_isa_ext_arr[kvm_ext];
+	switch (*guest_ext) {
+	case RISCV_ISA_EXT_SMNPM:
+		/*
+		 * Pointer masking effective in (H)S-mode is provided by the
+		 * Smnpm extension, so that extension is reported to the guest,
+		 * even though the CSR bits for configuring VS-mode pointer
+		 * masking on the host side are part of the Ssnpm extension.
+		 */
+		host_ext = RISCV_ISA_EXT_SSNPM;
+		break;
+	default:
+		host_ext = *guest_ext;
+		break;
+	}
+
+	if (!__riscv_isa_extension_available(NULL, host_ext))
+		return -ENOENT;
+
+	return 0;
+}
+
 static bool kvm_riscv_vcpu_isa_enable_allowed(unsigned long ext)
 {
 	switch (ext) {
@@ -219,13 +249,13 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 
 void kvm_riscv_vcpu_setup_isa(struct kvm_vcpu *vcpu)
 {
-	unsigned long host_isa, i;
+	unsigned long guest_ext, i;
 
 	for (i = 0; i < ARRAY_SIZE(kvm_isa_ext_arr); i++) {
-		host_isa = kvm_isa_ext_arr[i];
-		if (__riscv_isa_extension_available(NULL, host_isa) &&
-		    kvm_riscv_vcpu_isa_enable_allowed(i))
-			set_bit(host_isa, vcpu->arch.isa);
+		if (kvm_riscv_vcpu_isa_check_host(i, &guest_ext))
+			continue;
+		if (kvm_riscv_vcpu_isa_enable_allowed(i))
+			set_bit(guest_ext, vcpu->arch.isa);
 	}
 }
 
@@ -607,18 +637,15 @@ static int riscv_vcpu_get_isa_ext_single(struct kvm_vcpu *vcpu,
 					 unsigned long reg_num,
 					 unsigned long *reg_val)
 {
-	unsigned long host_isa_ext;
-
-	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
-	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
-		return -ENOENT;
+	unsigned long guest_ext;
+	int ret;
 
-	host_isa_ext = kvm_isa_ext_arr[reg_num];
-	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
-		return -ENOENT;
+	ret = kvm_riscv_vcpu_isa_check_host(reg_num, &guest_ext);
+	if (ret)
+		return ret;
 
 	*reg_val = 0;
-	if (__riscv_isa_extension_available(vcpu->arch.isa, host_isa_ext))
+	if (__riscv_isa_extension_available(vcpu->arch.isa, guest_ext))
 		*reg_val = 1; /* Mark the given extension as available */
 
 	return 0;
@@ -628,17 +655,14 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 					 unsigned long reg_num,
 					 unsigned long reg_val)
 {
-	unsigned long host_isa_ext;
-
-	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
-	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
-		return -ENOENT;
+	unsigned long guest_ext;
+	int ret;
 
-	host_isa_ext = kvm_isa_ext_arr[reg_num];
-	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
-		return -ENOENT;
+	ret = kvm_riscv_vcpu_isa_check_host(reg_num, &guest_ext);
+	if (ret)
+		return ret;
 
-	if (reg_val == test_bit(host_isa_ext, vcpu->arch.isa))
+	if (reg_val == test_bit(guest_ext, vcpu->arch.isa))
 		return 0;
 
 	if (!vcpu->arch.ran_atleast_once) {
@@ -648,10 +672,10 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 		 */
 		if (reg_val == 1 &&
 		    kvm_riscv_vcpu_isa_enable_allowed(reg_num))
-			set_bit(host_isa_ext, vcpu->arch.isa);
+			set_bit(guest_ext, vcpu->arch.isa);
 		else if (!reg_val &&
 			 kvm_riscv_vcpu_isa_disable_allowed(reg_num))
-			clear_bit(host_isa_ext, vcpu->arch.isa);
+			clear_bit(guest_ext, vcpu->arch.isa);
 		else
 			return -EINVAL;
 		kvm_riscv_vcpu_fp_reset(vcpu);
@@ -1009,16 +1033,15 @@ static int copy_fp_d_reg_indices(const struct kvm_vcpu *vcpu,
 static int copy_isa_ext_reg_indices(const struct kvm_vcpu *vcpu,
 				u64 __user *uindices)
 {
+	unsigned long guest_ext;
 	unsigned int n = 0;
-	unsigned long isa_ext;
 
 	for (int i = 0; i < KVM_RISCV_ISA_EXT_MAX; i++) {
 		u64 size = IS_ENABLED(CONFIG_32BIT) ?
 			   KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
 		u64 reg = KVM_REG_RISCV | size | KVM_REG_RISCV_ISA_EXT | i;
 
-		isa_ext = kvm_isa_ext_arr[i];
-		if (!__riscv_isa_extension_available(NULL, isa_ext))
+		if (kvm_riscv_vcpu_isa_check_host(i, &guest_ext))
 			continue;
 
 		if (uindices) {
-- 
2.39.5



