Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D719946D2B9;
	Tue, 21 Jul 2026 17:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654095; cv=none; b=EpDNZplXO8mw8xL4bcrGCyEpp94gNe1BhjbKHYRl0LKPniTqhT203ht4g2MqEJPzlM4HhugYV7c8UIL6JR2wcHWIdPhsKOPRTNCX85nlq/klVXpC3z/SXrAxfyOo2Wvkaa4DNqpcmr6uGekfF21Fd9KwAFhDaD/k8Bq+Q3TjDdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654095; c=relaxed/simple;
	bh=7Je1+ZK3O0fgjezAaWWBv5Z6+BW55gEXTrLJL4XmC8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0Tkf1ipTxJvJg3e231wIzOT+jqVIyUPgHl7pmnueOPkyIAaxl6EYOs6uj/56ZMXfrdMDYVNqgwZaHk+2b7uMv+0EgF6+lfinqAzv8rJD/rQneTsUNZbvlZ0Bc9RY/5TuZQ4J+LzFtUJLk+2NVOq+1qK27WcIqq0Zi28g3Njd3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAvb91Pg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAvb91Pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAAC1F000E9;
	Tue, 21 Jul 2026 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654094;
	bh=tlRXVbYrWW8yOmjs2rzzJhXK6xWdmlZW7AuA4yiObDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAvb91PgIEugGj3g/ji1bartlaPW+JtbU8Em5a/Syl0q1n2lJsewzoZZqg9HhWWNA
	 oSND9N17Du1opCCjPpWsXio59uKDPIue1lDW9xiBWq4MaH/v9SWSZWTC/KK1bM5mx2
	 oSuIy8NT4fCG8nhKy9s+6Gqcit4YFnmCfgNokQRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 1576/2077] KVM: arm64: nv: Inject SEA if kvm_translate_vncr() cant resolve PFN
Date: Tue, 21 Jul 2026 17:20:49 +0200
Message-ID: <20260721152629.949981757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oupton@kernel.org>

commit 9f3e83345a56280efffe235c65593c7e544c0fcc upstream.

kvm_handle_vncr_abort() assumes that s1_walk_result conveys an abort
when kvm_translate_vncr() returns -EFAULT. This is not always the case
as it's possible to encounter 'late' failures on the output of S1
translation, e.g. a GFN outside of the memslots.

Fix it by preparing an external abort before returning from
kvm_translate_vncr(). Get rid of the BUG_ON() in the fault injection
path while at it.

Cc: stable@vger.kernel.org
Fixes: 2a359e072596 ("KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2")
Signed-off-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260618234207.1063941-3-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_nested.h |    8 ++++++++
 arch/arm64/kvm/at.c                 |    8 --------
 arch/arm64/kvm/nested.c             |   10 ++++++----
 3 files changed, 14 insertions(+), 12 deletions(-)

--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -388,6 +388,14 @@ struct s1_walk_result {
 	bool	failed;
 };
 
+static inline void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
+{
+	wr->fst		= fst;
+	wr->ptw		= s1ptw;
+	wr->s2		= s1ptw;
+	wr->failed	= true;
+}
+
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		       struct s1_walk_result *wr, u64 va);
 int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa,
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -11,14 +11,6 @@
 #include <asm/kvm_mmu.h>
 #include <asm/lsui.h>
 
-static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
-{
-	wr->fst		= fst;
-	wr->ptw		= s1ptw;
-	wr->s2		= s1ptw;
-	wr->failed	= true;
-}
-
 #define S1_MMU_DISABLED		(-127)
 
 static int get_ia_size(struct s1_walk_info *wi)
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1309,15 +1309,19 @@ static int kvm_translate_vncr(struct kvm
 
 	gfn = vt->wr.pa >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
-	if (!memslot)
+	if (!memslot) {
+		fail_s1_walk(&vt->wr, ESR_ELx_FSC_EXTABT, false);
 		return -EFAULT;
+	}
 
 	*is_gmem = kvm_slot_has_gmem(memslot);
 	if (!*is_gmem) {
 		pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
 					&writable, &page);
-		if (is_error_noslot_pfn(pfn))
+		if (is_error_noslot_pfn(pfn)) {
+			fail_s1_walk(&vt->wr, ESR_ELx_FSC_EXTABT, false);
 			return -EFAULT;
+		}
 	} else {
 		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
 		if (ret) {
@@ -1444,8 +1448,6 @@ int kvm_handle_vncr_abort(struct kvm_vcp
 			 * Translation failed, inject the corresponding
 			 * exception back to EL2.
 			 */
-			BUG_ON(!vt->wr.failed);
-
 			esr &= ~ESR_ELx_FSC;
 			esr |= FIELD_PREP(ESR_ELx_FSC, vt->wr.fst);
 


