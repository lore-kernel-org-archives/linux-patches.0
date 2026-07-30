Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644123C3F4C;
	Thu, 30 Jul 2026 15:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425710; cv=none; b=q8ZXHp3qt73aCf9eKv0mKfmmNVP53D9zEEs9yTknkeZpiJzF6kfi4EtqOTWhlyRBfvLb1udDrXzsojfnWrY4jROnQiTi0xMdHNCDFn0cArr2vlVzE5MkZgyy0jUN9PpoecDOa9urYV8WndLCnjKGSCKRCzOqRXaAJ9iy8hN3h8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425710; c=relaxed/simple;
	bh=Yko1l53N3F7+dK0YU+0Me2NF0NrAcc8wvXOnXAp40Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iICJvPPFYSpK8jZ7cT3heJRqNbTqs/zKwyGa3WbpNk5XDZpOpJRmikqWX1Hgjj1YJ3eR0PSU+84bXonypnZP7DoTQA2SOowwqU1Z4N7HTveSgpI/b3TnXNsRDLRTYFfG9WQeP2qRos6ZuIvSlBrv5rGuUOrpZDZKbgVxXrLJArE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UK+Pfg/H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UK+Pfg/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2741F000E9;
	Thu, 30 Jul 2026 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425709;
	bh=FTZKSAoOuR/PQx0aXIDNG50WHbEPyyna39guA/Qc5Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UK+Pfg/HbxUDSyLz6fqUu3lpp/WSz5m8Otc4JoxxbVqeuBsmFhNGPw91UQSSi6od1
	 p7h4UvPJfIf+B0GtSDY6iwZg2+5PL9DdG8cOmXQCR+KRA5D0hDDFJMBDXHjyE1K2ON
	 4Pomjg5N2q4Q8v3XLrHrhZZF6NTfvRcdF0jsa3CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/602] drivers/virt: pkvm: Fix end calculation in mmio_guard_ioremap_hook()
Date: Thu, 30 Jul 2026 16:09:16 +0200
Message-ID: <20260730141439.417367704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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



