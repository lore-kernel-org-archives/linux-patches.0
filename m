Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2BA238C1A;
	Wed,  9 Sep 2026 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962600; cv=none; b=Pi2ZUdaSmKhoqqL1O0aJQMFtZpNiCBDpMDRK6OnY8yOubAL+j4xtRh0OwAmL1O5pxejndo8IXZ7gbKYZ/CrKOHJKwpJTlwNm7lDfncXxZj8sVBzaaKwi8c2IHfq//3Nxp3SYSo9hJpgue6FvWDRmIq069k6yOS15KzWJ22iNVg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962600; c=relaxed/simple;
	bh=MWAJERA4URRDmxOj/m/zwIb9fUgFWIx8idD/aPGIbfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQmvuUKUMpQY2TIuB0Vjc3957n92eWDVsCjDBSfKQeZOKRpfcgFmb6BvNtudN7TletkX6o/35xiewZPsF9xQGiJxPsvt1gHQ6fKYiHQ9+4sLIZYX56Ela36oNFJaXDlPgEaFGuybFWCQRGr9FShz3DvXmnBOn3KAPkOdjxP7lLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ON4KX4y9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ON4KX4y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ADC1F00A3A;
	Wed,  9 Sep 2026 14:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962599;
	bh=EFRmLCAftYXVZx5nI/1lyqmV/6mNkOJWuaZYBvKSsU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ON4KX4y9BQ+0DpDQGHXRVCcPWyz2K0o4NCMocIMWsns2OiK7bNwN67jiF+Y8BgO5b
	 Yfjg7PZUHPTHeboR15F9hg9QRurnPMj4ye9TUF+9suColYL7FDpPgpF6m7U6KuRxor
	 vfLy0JLiEG+++yd8ngqkz6C4Vt46U5zhzvhWtIMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 7.2 302/556] KVM: x86: Move enabling EFER.SVME and EFER.LMSLE to generic EFER setup
Date: Wed,  9 Sep 2026 15:39:42 +0200
Message-ID: <20260909134241.302830537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 6ccc19d4c1eb97a994180af8afcab58422cb409d upstream.

Move SVM-specific EFER bit enablement to generic x86 code, with the rest
of EFER bit enablement. Unifying the code for EFER bit enablement allows
for a later change to re-initialize EFER bits on module init.

No functional change intended.

Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260713181020.2735367-2-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    4 ----
 arch/x86/kvm/x86.c     |    6 ++++++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5658,10 +5658,6 @@ static __init int svm_hardware_setup(voi
 
 	if (nested) {
 		pr_info("Nested Virtualization enabled\n");
-		kvm_enable_efer_bits(EFER_SVME);
-		if (!boot_cpu_has(X86_FEATURE_EFER_LMSLE_MBZ))
-			kvm_enable_efer_bits(EFER_LMSLE);
-
 		r = nested_svm_init_msrpm_merge_offsets();
 		if (r)
 			return r;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10015,6 +10015,12 @@ static void kvm_setup_efer_caps(void)
 
 	if (kvm_cpu_cap_has(X86_FEATURE_AUTOIBRS))
 		kvm_enable_efer_bits(EFER_AUTOIBRS);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SVM)) {
+		kvm_enable_efer_bits(EFER_SVME);
+		if (!boot_cpu_has(X86_FEATURE_EFER_LMSLE_MBZ))
+			kvm_enable_efer_bits(EFER_LMSLE);
+	}
 }
 
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)


