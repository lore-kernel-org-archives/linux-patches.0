Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65173B6366;
	Thu, 30 Jul 2026 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423888; cv=none; b=S/PDOcIEwHSRlAEX4u/hMiNRFYk7v2PZosBzJqg4wbU7Av+a9sryLsYbaAfDpRASgAfZ97RYF0DN4xzXBIDq1zfWV8Y8UvtCnLH0dkPVkIcuIYhWzz9kronX3VENeYQulOSPD0HKI4zcidxjyRNLJVCydravfpMiS9KFvcYjpU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423888; c=relaxed/simple;
	bh=r4RHeDWEuPw+TSdpenxuFbrgX5cp6YgWa4HOXgPLErY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKaEtpvSulZoK/c/5MMpD7ogvDEsWnIT0bQOwB/gvqkfGGSisVPMKad3rOEfOvW/z/gy68inepRt2kHEvpe9Pl84xfeBu6eSsbGlUVvJkxUVotLI9FOIMiS0F2b40h7AOaXQe00CCLbqmOZGvfNZ8vLdpO40EJ7rPCUryMzbWBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKHdzgf/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKHdzgf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037D91F000E9;
	Thu, 30 Jul 2026 15:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423887;
	bh=eoDC59RM2n//QjAAUEBzTlLEcmIm/dLbtrob9NJxxM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKHdzgf/jXJgWQ0YbMz73p880Vh8Ac4gPqfSwLu0TMeT4hUKrY+NPMjrrtYpPiG3s
	 rkYzJTbPDX4jte9KjaI/KL7xWxA5ghrUStU7uCgc/+vFxM+oyIfUvpAxk7DapD6aBx
	 l9w5XlozIbaVdV0Sa5EoYYV6YHCVWIrnsktx4dBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 200/675] drivers/virt: pkvm: Fix end calculation in mmio_guard_ioremap_hook()
Date: Thu, 30 Jul 2026 16:08:50 +0200
Message-ID: <20260730141449.394313749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 62c740f823a8e47ffe56e45a7472c27cf988e2f6 ]

Sashiko (locally) reports a logical issues in mmio_guard_ioremap_hook()

mmio_guard_ioremap_hook() attempts to handle unaligned addresses and
sizes. However, aligning the start address before adding the size, might
shift the end to the page before.

Fixes: 0f1269495800 ("drivers/virt: pkvm: Intercept ioremap using pKVM MMIO_GUARD hypercall")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
index 4230b817a80bd8..d66291def0f408 100644
--- a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
+++ b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
@@ -82,8 +82,8 @@ static int mmio_guard_ioremap_hook(phys_addr_t phys, size_t size,
 	if (protval != PROT_DEVICE_nGnRE && protval != PROT_DEVICE_nGnRnE)
 		return 0;
 
+	end = PAGE_ALIGN(phys + size);
 	phys = PAGE_ALIGN_DOWN(phys);
-	end = phys + PAGE_ALIGN(size);
 
 	while (phys < end) {
 		const int func_id = ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_FUNC_ID;
-- 
2.53.0



