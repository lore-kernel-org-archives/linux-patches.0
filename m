Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB37643CEE7;
	Thu, 30 Jul 2026 14:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421767; cv=none; b=HYsGh33yuIjzR7wUXl/nRw51qwL1EXbZILlOeL+iO5NWRALfL7oyC3XHp0Fhfy13DYZEAWDuIUlrBrZhsUc8D/Xl1hWWXQBJO5Pd9R09of7yXqmksfx4Rp3IaDxFRMYBHEn30EcUUpY5MGMPcCSxoc8J9cgq3yPMIt24PCwssdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421767; c=relaxed/simple;
	bh=zW52Em28sadQpqSfJdMJsKSBtSqkCZVee+3kC7CBssY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBF/Vs3pgUbsf71eNJtlhCLOV8cM5H1XjAH/RaVZJk7LC4AwFoDjp+p52vIScyX1mjxH6yWewaMKTbxu3rVIZKpmhaa4O6ownlsTjjDepb+QaJW4m63VeQ1gSAfYnGF08gbsdk0CxkwzVkMFdQzQz1pm1MTTTZgzMhe50CzsHi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdFJGPsO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdFJGPsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23F21F000E9;
	Thu, 30 Jul 2026 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421766;
	bh=bbLrVEuJcwIVjDeMjc1XzPzptBybhjhy6teF7SpjnNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdFJGPsOvKCxrtJEnuZzHV6LycRiV2eNV+H9WQd0MNiTkF70vRtmf1wtyUw6vjNJV
	 KqJKf4vdselbrDyC5DfjmIeyyPjwVP27FSu4pyGA9CidXerUG1Qd1oN5q0I3gAwMw1
	 b5JGuOprLFHMYiG6v4bvM3rb0JgBORE/mzLtR9oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 212/744] drivers/virt: pkvm: Fix end calculation in mmio_guard_ioremap_hook()
Date: Thu, 30 Jul 2026 16:08:05 +0200
Message-ID: <20260730141448.787816859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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



