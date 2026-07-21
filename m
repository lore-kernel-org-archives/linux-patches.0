Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABBA4028CE;
	Tue, 21 Jul 2026 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654199; cv=none; b=F8VbZk3g0V+2/JqQS//BJC9KzrAU3EkfM8RssZTjuNBQl268pVdVEW1O70DFeWrKZHCrFYynSb6PbpaB25dzbdAL+ZH3kEdX2TrM1lrXjHVO/mFn5MWjQNdJm4mAErg+5FS//tyOjcDMk3zshFI8HYJXDsI8OHoCoyb84wb/0bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654199; c=relaxed/simple;
	bh=lZulbunmtQizmFDnINNR4n5r0P62maoHjRY96Si404Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfHfwsbCyBmzoYKFZok+im24Ie7xPGHX4D/ELa8cItusgwCQTlAIhb1Yl9Re4TxNyrkAtkow1S8gmLyQp9LiY5HuWmV9CbfPxJKVSHW5IIEyMpVoqXE63yfaKaA2PsGaFey5MY+4RfX035OofnoC2oAKWvDSfenzhACEYlqaCdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZS8nTI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZS8nTI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEE41F000E9;
	Tue, 21 Jul 2026 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654198;
	bh=PPbMhEmbd2dxtI7tC3RoHP6AIanBpW3v8RLjgvyCBSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZS8nTI4uHhXqWzNQW2uVMt6TTaWOHKK1wpfCK2yarttHfT5KIl6ZjBt8DRx7+p0B
	 JApzgEGQ7k1JjMKGGv8HEyLI052CpplrM4Vl6PDdV+IRo7HhNV2xFT8yTSgArNILZe
	 7e/iIM0hBdxpyBSTsi5uSimjbesEJ/uDXLGd9mS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 1571/2077] KVM: arm64: Ensure level is always initialized when relaxing perms
Date: Tue, 21 Jul 2026 17:20:44 +0200
Message-ID: <20260721152629.834216211@linuxfoundation.org>
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

commit 100baf0184896f859290a684f864b8200d8ac872 upstream.

stage2_update_leaf_attrs() returns early before writing to @level if the
table walker returned an error. At the same time,
kvm_pgtable_stage2_relax_perms() uses the level as a TLBI TTL hint when the
error was EAGAIN, indicating the vCPU raced with a table update and the TLB
entry it hit is now stale.

Fall back to an unknown TTL if none was provided by the walk.

Cc: stable@vger.kernel.org
Fixes: be097997a273 ("KVM: arm64: Always invalidate TLB for stage-2 permission faults")
Signed-off-by: Oliver Upton <oupton@kernel.org>
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
Link: https://patch.msgid.link/20260701231620.3300204-2-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1358,7 +1358,7 @@ int kvm_pgtable_stage2_relax_perms(struc
 				   enum kvm_pgtable_prot prot, enum kvm_pgtable_walk_flags flags)
 {
 	kvm_pte_t xn = 0, set = 0, clr = 0;
-	s8 level;
+	s8 level = TLBI_TTL_UNKNOWN;
 	int ret;
 
 	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)


