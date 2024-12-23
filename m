Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118727E0FF;
	Mon, 23 Dec 2024 16:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969642; cv=none; b=jpTWbvNKSzrqVsvrhQX/9xNGaNxN2Tm1TWMza0+VixqL/MoadKrIq5mJwDZNHePtd31zcJ1IW+TVAVF9cjdqYWIs5ObyEF/0DbCG5hazQM/zcDL7i1fky02oKzEQb/5qs/BlxuWRyBdHbDXHOM3afg5xkXP2+k4gbGjpgwhvxG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969642; c=relaxed/simple;
	bh=vf+PeKTsT4tvYoLzmEJGrMbczHiwENAB01Zy8FLtFYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNc5hMqRkGqt9eo39h6qLkXnr9a9fAa5tM9mlaf3yu3fim5AHtQt1Z46DJ1fOu9ByZuYFoNVELz1CiZ6koxsvF/XnwmLaekEgpDuIXSMOsd7c7moXAo/4tDcAf2O+RVPW/QCDfPGt+Zymon424xh4u8SYM1zLhWLprBI7RKYIxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUP1o6B3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUP1o6B3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4F5C4CED4;
	Mon, 23 Dec 2024 16:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969640;
	bh=vf+PeKTsT4tvYoLzmEJGrMbczHiwENAB01Zy8FLtFYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUP1o6B30/YZmIC+fQfLuKRB+ox6vRc4A94Y/mMLKaSVV6xlW/1OdHzf+WhlOIpON
	 l8p9Rj6CQ9iOsjfJ+DwkvaMwDggWq1PrY+BmblQpejwkuKfP3Na1xBeLqvB+xm/e+9
	 mYYUgVmY3U+K7WiW2JPjzaVCJrhD4G7Cqy9AxgRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Neuling <michaelneuling@tenstorrent.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/160] RISC-V: KVM: Fix csr_write -> csr_set for HVIEN PMU overflow bit
Date: Mon, 23 Dec 2024 16:56:56 +0100
Message-ID: <20241223155408.832677024@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Neuling <michaelneuling@tenstorrent.com>

[ Upstream commit ea6398a5af81e3e7fb3da5d261694d479a321fd9 ]

This doesn't cause a problem currently as HVIEN isn't used elsewhere
yet. Found by inspection.

Signed-off-by: Michael Neuling <michaelneuling@tenstorrent.com>
Fixes: 16b0bde9a37c ("RISC-V: KVM: Add perf sampling support for guests")
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20241127041840.419940-1-michaelneuling@tenstorrent.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/aia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 2967d305c442..9f3b527596de 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -552,7 +552,7 @@ void kvm_riscv_aia_enable(void)
 	csr_set(CSR_HIE, BIT(IRQ_S_GEXT));
 	/* Enable IRQ filtering for overflow interrupt only if sscofpmf is present */
 	if (__riscv_isa_extension_available(NULL, RISCV_ISA_EXT_SSCOFPMF))
-		csr_write(CSR_HVIEN, BIT(IRQ_PMU_OVF));
+		csr_set(CSR_HVIEN, BIT(IRQ_PMU_OVF));
 }
 
 void kvm_riscv_aia_disable(void)
-- 
2.39.5



