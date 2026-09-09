Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034B6562600;
	Wed,  9 Sep 2026 14:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962504; cv=none; b=lREqm+YwJFHgZW0AJUrK5JDV6H1FlQep4l/AXAa8xPNm0Rvacp0WdS0jAbO/pnfvrzdvHGV9fnsX5JpLzrXdloXlfDExl/M2tQkKIEZkehT9+Otd9hFJmDnt207UJxtRo7ce6wcpGfnUBPVNIdmI5HrW4du3KzgwomLzWtEGKPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962504; c=relaxed/simple;
	bh=LUHQKJ/77p/4Bmt9Uo22e/uiZo+AP1ysoapXoReaY/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCn3Ig66NITId9uXbopWGpxj7rwI6dHjZsEBeKvJL2IB8k4oriVXo6fBRWRWwzXCDUx96y/ihHxpZw/85Wh3TqqiVT9WuAlQ21KdrmBOzmc8GTNfy5i3cU+JHWKX6vcLn19Ni7EYo44seSCitEeJ82SxUgfu4sCqUYTZ9Sv8jOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Azoq5LOJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Azoq5LOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1606D1F00A3A;
	Wed,  9 Sep 2026 14:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962502;
	bh=54HVuK2+AqgWouQS8v8vMhFR7TGV5417t5oiB51tkFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Azoq5LOJAyduyQkWY4/oTo6stNBEUP5OKnlWZsuNswyLoSF1YCYgH0YHSyAjnKNCx
	 bPHxo5HfBv1rJzo6xI2D2oLOipIXeZ3ZgZfVG1L/JE5SVdn8r3ITpG2yHbNfBwW4nn
	 cdF0/V0WO7cWx7B0sbaLH99NLN0iGcuWqS6sxjhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 314/556] KVM: arm64: Consider SCTLR_EL2.M when mapping the L1 VNCR page
Date: Wed,  9 Sep 2026 15:39:54 +0200
Message-ID: <20260909134241.711026102@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 8c774604b6ecaca495fa3d27c21593269627f48f upstream.

We record a VNCR TLB even when SCTLR_EL2.M is 0 in order to make
our life easier. But this is not something that the architecture
anticipate.

As a consequence, a hypervisor is free to set VNCR_EL2 to
some PA when SCTLR_EL2.M==0, use it to run a guest which indirectly
accesses the VNCR page, then eventually set SCTLR_EL2.M==1 with
the same VA. Yes, this is odd, but apparently legal.

A common trick in HW is to invalidate the TLBs on SCTLR_ELx.M being
flipped. But doing this is a not a good idea for us (we'd need to
trap SCTLR accesses), and wouldn't scale as we nest deeper.

Instead, use the fact that the S1 MMU being off at the point of
translation is cached in our TLB, and if it doesn't match the current
MMU state, leave the VNCR unmapped.

Fixes: 2a359e072596f ("KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260806091026.620700-4-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_nested.h |    7 +++++++
 arch/arm64/kvm/at.c                 |    2 --
 arch/arm64/kvm/nested.c             |    4 ++++
 3 files changed, 11 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -388,6 +388,8 @@ struct s1_walk_result {
 	bool	failed;
 };
 
+#define S1_MMU_DISABLED		(-127)
+
 static inline void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
 {
 	wr->fst		= fst;
@@ -396,6 +398,11 @@ static inline void fail_s1_walk(struct s
 	wr->failed	= true;
 }
 
+static inline bool s1_walk_translated(struct s1_walk_result *wr)
+{
+	return wr->level != S1_MMU_DISABLED;
+}
+
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		       struct s1_walk_result *wr, u64 va);
 int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa,
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -11,8 +11,6 @@
 #include <asm/kvm_mmu.h>
 #include <asm/lsui.h>
 
-#define S1_MMU_DISABLED		(-127)
-
 static int get_ia_size(struct s1_walk_info *wi)
 {
 	return 64 - wi->txsz;
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1568,6 +1568,10 @@ static void kvm_map_l1_vncr(struct kvm_v
 	if (!vt->valid)
 		return;
 
+	/* We cache the MMU state in the TLB. Check that it matches. */
+	if (!!(vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_M) != s1_walk_translated(&vt->wr))
+		return;
+
 	if (read_vncr_el2(vcpu) != vt->gva)
 		return;
 


