Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A8E255241;
	Wed,  5 Mar 2025 18:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198590; cv=none; b=uUsPDlsvjWfb01Q3YCG7IWPaSb2Y78nYiQsbqv2fXOtFurtV9/DHG1duqqRPnR1SYXG+HjLJuR9ffo0HXs9XgPTJCORnF55GpJhDj06mk0RNMcjh9P8+juK24luWC8adFwP/gv1gu2R/keJELF1AqQWAfc9FXkKztY4XMuyEM0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198590; c=relaxed/simple;
	bh=4T7pGqLjFvfCxHBDFDQySgRaG4piNVTkI7GcLvJYKys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2VAJl/qhs5eZ28Lcdji5X+kxf+YMjlrdIgVlZbcv1H/oHpw0CRXzUR3rKqrOKHnF1CTcQ8JsuVascCWr++DDhC9xfNAVaxBhYNExTdQVvygUaTnCPq/7Om2+/H8Dt/sD7GPa8xUFly7sCFdwGOkok/xBhlpzeKOLWL2CmmhvEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J03C5Smk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J03C5Smk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D345C4CEE0;
	Wed,  5 Mar 2025 18:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198590;
	bh=4T7pGqLjFvfCxHBDFDQySgRaG4piNVTkI7GcLvJYKys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J03C5Smkh7MtmNQKy77wIucmREamxpAyGXc1FPu/4prg6ljtsaXL58RfiURAeBSVS
	 xoPZ9rKKBvzfUo38ucIzzM7c+Un0qMzKvC2r/XltenEMfXbwi+MXC28+SkYl1Qypdz
	 Iif5AIMllJ/OlFAesupxas/2rH2OcEt7rPlydTE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 080/157] riscv: KVM: Fix SBI TIME error generation
Date: Wed,  5 Mar 2025 18:48:36 +0100
Message-ID: <20250305174508.526962241@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit b901484852992cf3d162a5eab72251cc813ca624 ]

When an invalid function ID of an SBI extension is used we should
return not-supported, not invalid-param.

Fixes: 5f862df5585c ("RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v0.2")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20250217084506.18763-11-ajones@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 74e3a38c6a29e..5fbf3f94f1e85 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -21,7 +21,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	u64 next_cycle;
 
 	if (cp->a6 != SBI_EXT_TIME_SET_TIMER) {
-		retdata->err_val = SBI_ERR_INVALID_PARAM;
+		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
 		return 0;
 	}
 
-- 
2.39.5



