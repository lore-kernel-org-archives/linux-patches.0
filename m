Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCCD2EAE5;
	Thu, 12 Dec 2024 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015993; cv=none; b=qaH59haKHCTkgEzgydmIlPpcglSiOcPhEQZtmt7UpqYbWYcs6Axi4QZdRAut9gO/c1U1/7aJEu2XuVO30epnhGefqT9IzBgWTgQEpYncCNaYehZs5aQsMzkmgaQ/p9H9RDwgtCPh0dHpWHfDW3tWoEwHQdgu6r70n1uLBMjyVoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015993; c=relaxed/simple;
	bh=qm40uhayvrkO1McX1eecFbaY8SYyMGw9EXWVIbPrMbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGVDxohSwFhak266kc0OzNDSNTBQcvc7lTWZFDMRXACJ/zPbIF29lXKdU60qkKglgBPGLOsD6sg3Zbg/9Rie017ZrV1cSiJUMYMIwJIbkWXQ+6p0kHs0cQXWt/pu+UZ9xZcrrKOofaAZMug0L0Q4qLTf+MRv/xvo5EfIrkczNzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yazh2N6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yazh2N6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D8DC4CECE;
	Thu, 12 Dec 2024 15:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015992;
	bh=qm40uhayvrkO1McX1eecFbaY8SYyMGw9EXWVIbPrMbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yazh2N6fqpt0FlqkadaaDijt3IXk3h0Ovtw2fWKYXKLN1nSq0kQUsN4eYHw9CHFMU
	 KoL5+qBAEZn5rVcaULOEAMV7qwM2aEhKi00gWN1iotaCqmyj/EKojC3i++F3jtlgBQ
	 RQ3lcW3CIWui+Q0nJaT4/B1XfVlW+sHxnJQ6sx8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/466] drivers/virt: pkvm: Dont fail ioremap() call if MMIO_GUARD fails
Date: Thu, 12 Dec 2024 15:54:31 +0100
Message-ID: <20241212144310.843922773@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[ Upstream commit d44679fb954ffea961036ed1aeb7d65035f78489 ]

Calling the MMIO_GUARD hypercall from guests which have not been
enrolled (e.g. because they are running without pvmfw) results in
-EINVAL being returned. In this case, MMIO_GUARD is not active
and so we can simply proceed with the normal ioremap() routine.

Don't fail ioremap() if MMIO_GUARD fails; instead WARN_ON_ONCE()
to highlight that the pvm environment is slightly wonky.

Fixes: 0f1269495800 ("drivers/virt: pkvm: Intercept ioremap using pKVM MMIO_GUARD hypercall")
Signed-off-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20241202145731.6422-2-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
index 56a3859dda8a1..4230b817a80bd 100644
--- a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
+++ b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
@@ -87,12 +87,8 @@ static int mmio_guard_ioremap_hook(phys_addr_t phys, size_t size,
 
 	while (phys < end) {
 		const int func_id = ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_FUNC_ID;
-		int err;
-
-		err = arm_smccc_do_one_page(func_id, phys);
-		if (err)
-			return err;
 
+		WARN_ON_ONCE(arm_smccc_do_one_page(func_id, phys));
 		phys += PAGE_SIZE;
 	}
 
-- 
2.43.0



