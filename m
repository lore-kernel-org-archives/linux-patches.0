Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCD7471261;
	Tue, 21 Jul 2026 18:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658437; cv=none; b=lmrD/6++xW9CrY55oohhq7piG6WOJmXJzuH7+X6bAUjWx7Cwo9PvJWG7JHfxtRvVDfIOHnk9p0yK111liirxx5YS/8eZb36zG7k8DL/iG6tDv0YJvNbHXRzUQD+XD8xx+1bOjr9UTg+FKCwMHnf4rgjwQVK7A6pkeBz2r+hhZo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658437; c=relaxed/simple;
	bh=jcQ2nWsIqld3I8HPEHut1SbhZ4nJNvTtq+T7h7qss/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQnrXzlBg6AZIcj6q4czwmDy3ggoP8GApuHam4W2I3rdB9ByIXLGZlg+DX0V4NiMIlm+Ric1Pg6cRZcYakx+DCKsZvR7RGNakB8F7kwu4BkvCOjp51H8IOtEIWaxiQpX4IRZucl6+FBWQKDYq6smvpEv/UaFAYciRCNM4CP238c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5/d8/M2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5/d8/M2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27751F00A3A;
	Tue, 21 Jul 2026 18:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658436;
	bh=kG9GWJAdp71l/kkW6lTNypWkPmt8qTvWxNSrCQYYDhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5/d8/M244LA6xoXE52pvwiLnBs5ZwElxCfpXzYKCLeV6fwc00be3QHdZ0CmScqlt
	 utBjquGDZY9NkULmBMC6FBDdiqFQTOGo08TVe0rRcVI7f4d20ovslmcdvkZEgDR1jk
	 Kre/3fzRQqv8kBrqw4w1aSWv6LWkedzdm9iHDkes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 1142/1611] KVM: arm64: nv: Inject SEA if kvm_translate_vncr() cant resolve PFN
Date: Tue, 21 Jul 2026 17:20:58 +0200
Message-ID: <20260721152541.108700772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -353,6 +353,14 @@ struct s1_walk_result {
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
@@ -10,14 +10,6 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
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
@@ -1220,15 +1220,19 @@ static int kvm_translate_vncr(struct kvm
 
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
@@ -1367,8 +1371,6 @@ int kvm_handle_vncr_abort(struct kvm_vcp
 			 * Translation failed, inject the corresponding
 			 * exception back to EL2.
 			 */
-			BUG_ON(!vt->wr.failed);
-
 			esr &= ~ESR_ELx_FSC;
 			esr |= FIELD_PREP(ESR_ELx_FSC, vt->wr.fst);
 


