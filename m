Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9F4441022;
	Tue, 16 Jun 2026 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623696; cv=none; b=TaCJDZYkKQ+PfGGgF7dKSMyZHUzVkEJamUo8VIp489huW3No0h/adCRsTINLfRiSJYwxRLaPprgpukVGLb9s9Tj6wNj6G38+9aZrBB/7U7gcRuKur/Mid/DPArevXQH3YaECmputICYvsr1AtX4vLLZNjkbU8M53FDRRMYO+Evc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623696; c=relaxed/simple;
	bh=Y3VBHMlKtpgLDNEsHrzsEF1UuE5+xb7S92lFXodTGEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aw1fg4WxcPgEvhFmQt6Jw/7eZM36HzPgeBmRM0PfpEgWaU1/2E7ZIfLOi1ZorwmLgZ/3VSUqf/6IgC+ayb8qLAFJW9UGwqV3rh13iQ9sekMUOr8z+vsUYlRfaY8jQPNgA+xrGmaueT7xhyCSMlyjs6xnzJ80RLY6QPDWxN4Iw7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdOnRktv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdOnRktv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAF31F000E9;
	Tue, 16 Jun 2026 15:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623695;
	bh=LuCB17T3LWOjvHGWdBKwnyfd7bwdaqmwNinENz+9Mgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdOnRktvdI0VQ/Znq1arABpjFIzmUiWDAajV30LMBa1U+EQFAhjcpyj8a7KnyoWEk
	 OOKOUsdHEsMa3oYtnCD+2PPsmUsZ869GBMl71og5FdqUQeNIFUPZwwz9hmheHghKw1
	 MOzRFgZU+SKdqchKNWNB7UpduvCruY1TGEIQEtEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 198/378] KVM: arm64: Correctly identify executable PTEs at stage-2
Date: Tue, 16 Jun 2026 20:27:09 +0530
Message-ID: <20260616145120.815712596@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oupton@kernel.org>

commit 17f073f78fc43280891ecde8f8ec3f84f98bb37c upstream.

KVM invalidates the I-cache before installing an executable PTE on
implementations without DIC. Unfortunately, support for FEAT_XNX
broke this check as KVM_PTE_LEAF_ATTR_HI_S2_XN was expanded to a
bitfield.

Fix it by reusing kvm_pgtable_stage2_pte_prot() and testing the abstract
permission bits instead.

Fixes: 2608563b466b ("KVM: arm64: Add support for FEAT_XNX stage-2 permissions")
Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
Signed-off-by: Oliver Upton <oupton@kernel.org>
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
Link: https://patch.msgid.link/20260602165901.52800-3-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -923,7 +923,9 @@ static bool stage2_pte_cacheable(struct
 
 static bool stage2_pte_executable(kvm_pte_t pte)
 {
-	return kvm_pte_valid(pte) && !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
+	enum kvm_pgtable_prot prot = kvm_pgtable_stage2_pte_prot(pte);
+
+	return prot & (KVM_PGTABLE_PROT_UX | KVM_PGTABLE_PROT_PX);
 }
 
 static u64 stage2_map_walker_phys_addr(const struct kvm_pgtable_visit_ctx *ctx,


