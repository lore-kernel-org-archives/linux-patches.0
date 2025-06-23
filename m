Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799D222370A;
	Mon, 23 Jun 2025 22:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717538; cv=none; b=iyqsWGG8e0rjvSZL3EOz4ZHFuIxClxl8Dx46d19GpO3IBTvJsB4eoTlLzZTckOC3ux+zNH5HCjKRPfSwRNZ+Y4EH+6lrRQX6/L7k1UROiG+tE+RQgvIODs6ibs8j08024O1rquf50vE1MUkynz4TZMmJGgsPRmfPVudoQ79bYP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717538; c=relaxed/simple;
	bh=Ktb63+2mYSmP5oRxrQtR/ayfRwI02lHYeC27uYiZTwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SRwQHnuIlRjCub/lpkWMGgrVmRJKIgFSScKKQnaOceE3spedT6Q9f07xalz3fTcQKzp/235iCZAcLMGH40SQ/nJmws2hQoHVZrs5BB0m7llDExxw6yn6e0WkfH2kaPyhYvvfng8BrZ7xveLYywY+BkhyuT0fgrT4EO9gz8Yc8+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9ysLjDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9ysLjDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C18C4CEEA;
	Mon, 23 Jun 2025 22:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717538;
	bh=Ktb63+2mYSmP5oRxrQtR/ayfRwI02lHYeC27uYiZTwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9ysLjDs8Ur/K1viqCgmMdTTxWbZoTuCbhtr6p2kmzmFVLaaLZ08gF/ou7/jSXdfd
	 rPky2pj7l/szO4TaNBEq+z9uZQQh61GKd0j5KlkcWwvkHKEkmJUqwyDUTl57NjQ7SQ
	 GBhxw1B6kcKUbY7dnMjSRVrnH/YoM5nM0+2OM6to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 409/414] RISC-V: KVM: Dont treat SBI HFENCE calls as NOPs
Date: Mon, 23 Jun 2025 15:09:06 +0200
Message-ID: <20250623130652.172819952@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit 2e7be162996640bbe3b6da694cc064c511b8a5d9 ]

The SBI specification clearly states that SBI HFENCE calls should
return SBI_ERR_NOT_SUPPORTED when one of the target hart doesn’t
support hypervisor extension (aka nested virtualization in-case
of KVM RISC-V).

Fixes: c7fa3c48de86 ("RISC-V: KVM: Treat SBI HFENCE calls as NOPs")
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Link: https://lore.kernel.org/r/20250605061458.196003-3-apatel@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 9752d2ffff683..b17fad091babd 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -127,9 +127,9 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
 		/*
 		 * Until nested virtualization is implemented, the
-		 * SBI HFENCE calls should be treated as NOPs
+		 * SBI HFENCE calls should return not supported
+		 * hence fallthrough.
 		 */
-		break;
 	default:
 		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
 	}
-- 
2.39.5



