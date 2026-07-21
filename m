Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E82447140C;
	Tue, 21 Jul 2026 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664660; cv=none; b=bOKwHwv8TI1gj2BzaE6GQyCjwRJqPqbrktGttHUe0kLEk4tQEhJBGsD3x49tj430wgLPQDJ5CTntDm3/nScqNfSZtRSropKTl421AnPYL9QMGkWQ/9UH6yNKflfTkWbLapJVCnvrVIpcppCHF179o2JoG7AMmt8E6kgF2kIwdUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664660; c=relaxed/simple;
	bh=7yZiydL1YorcIgupDkBCW2Zhfj/rJMhKU8JvsZ9ALhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mkrf2kw5JdyiTNgahXW/RcnfJO8A64kGI3XXRPr8dwsD8v5MW8rBz/9SpCwSqf66xA/t5KNW7yGK0encbpVwWyuXZ6xP1X5asqH7iQYFDm8cpRvEWPE37MK+Bni/FXzcVTzi4iOU3gKsSCLjmXGFEfeb/XQCcTuo90qZk7B02tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7cypLn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7cypLn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68921F000E9;
	Tue, 21 Jul 2026 20:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664659;
	bh=MQojmBphRdxAn79dt4gjpz8lcKK5mIBUoFlo2IU0JcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7cypLn0CfXWDbxied2brsatHdQPHvlE+owPadziMu8uk2Hz1k257i7+klyL/ylau
	 SGFG8XbrDkjL1s7CXS2ht2f8e+Dr6eWiRgywEUEV+69pHxq7QwIavn+Aa8GxGJL0kB
	 IIMYDhLM0kbzJHlbyPJNT6hQS5USJhA9ZqpMyVDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 1244/1276] KVM: arm64: Ensure level is always initialized when relaxing perms
Date: Tue, 21 Jul 2026 17:28:07 +0200
Message-ID: <20260721152513.933334676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1314,7 +1314,7 @@ int kvm_pgtable_stage2_relax_perms(struc
 				   enum kvm_pgtable_prot prot)
 {
 	int ret;
-	s8 level;
+	s8 level = TLBI_TTL_UNKNOWN;
 	kvm_pte_t set = 0, clr = 0;
 
 	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)


