Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69C2239E93;
	Fri, 30 May 2025 12:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608801; cv=none; b=tMoaylMClB0zWtopPPwrKj6Z6bb2yGRv4Ft0vgb4lwu0xdOAVCMsdQaInnwWw3Y4P1LouTmRSKfanP8PpOO5ULnCd0NOuXirm4qEewxpiuOn381e+jKy7Zxr3kYagZddBKtBO7LkBqhiHmT95BM+i1ZdQaqI0d6F81fZJO/PJrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608801; c=relaxed/simple;
	bh=ZGvmiHzqTKuKrJo7YIaPa5zAtI61MS66X0lhCF+Y7gM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FunQ15v2eQA6cA/dFWnFj3oxYOQLvIS3LsCm7svBqP6tz34pm/UnkYkYyg6SXPSu/NA850qnNZwrSeKk3fmoIp6FvYOr+q5S0LKHnuj5MzNbNw1+COqFRps4xQ1dywBtcR63GYZTOt/pyJF0SaRAjxJi1FxPeqJY2C49SBJFBNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZE/BUvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZE/BUvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AD4C4CEEA;
	Fri, 30 May 2025 12:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608801;
	bh=ZGvmiHzqTKuKrJo7YIaPa5zAtI61MS66X0lhCF+Y7gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZE/BUvXF1JbFQlar1g7y3S1SvEq7ed6brpdQa7SEDo6aEt7GeDSs3nyUv0ky1rr4
	 /vpy4jS00UEFUf4mrS/f8EW7Pzauam85osHAhGzDaQCOmVS13tby0t38Nfw5Q0UOr5
	 ZYrNOo66AEWEjvwe8+dGnDlzhYwT2feT4LpuaL62jJSWOIwua3bTBpyNzeANyA0vsj
	 v2v0SpzUPR6mOu9wMTDkklHA7qGeJmLOeVtsYCpjvoiVj1YYrFfJcRZxOD29hr/7sK
	 o2H6ixUM5/NxnIR6kHImTAeIRWf0xHzFOP42a/Eq7/n0IJjYTa6l13dZ9S/aSO6M48
	 uEMCb5j4EV9hQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Frank Li <Frank.Li@nxp.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 21/28] platform-msi: Add msi_remove_device_irq_domain() in platform_device_msi_free_irqs_all()
Date: Fri, 30 May 2025 08:39:27 -0400
Message-Id: <20250530123934.2574748-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530123934.2574748-1-sashal@kernel.org>
References: <20250530123934.2574748-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 9a958e1fd40d6fae8c66385687a00ebd9575a7d2 ]

platform_device_msi_init_and_alloc_irqs() performs two tasks: allocating
the MSI domain for a platform device, and allocate a number of MSIs in that
domain.

platform_device_msi_free_irqs_all() only frees the MSIs, and leaves the MSI
domain alive.

Given that platform_device_msi_init_and_alloc_irqs() is the sole tool a
platform device has to allocate platform MSIs, it makes sense for
platform_device_msi_free_irqs_all() to teardown the MSI domain at the same
time as the MSIs.

This avoids warnings and unexpected behaviours when a driver repeatedly
allocates and frees MSIs.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/20250414-ep-msi-v18-1-f69b49917464@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. ##
Analysis: ### Bug Being Fixed: The commit addresses a resource
management asymmetry in the platform-MSI subsystem. The issue is that
`platform_device_msi_init_and_alloc_irqs()` performs two operations: 1.
Creates an MSI domain via `msi_create_device_irq_domain()` 2. Allocates
MSIs in that domain via `msi_domain_alloc_irqs_range()` However,
`platform_device_msi_free_irqs_all()` only performed one cleanup
operation: 1. Freed the MSIs via `msi_domain_free_irqs_all()` 2.
**Missing**: Domain cleanup via `msi_remove_device_irq_domain()` ###
Code Change Analysis: The fix is minimal and surgical - adding just one
line: ```c void platform_device_msi_free_irqs_all(struct device *dev) {
msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN); +
msi_remove_device_irq_domain(dev, MSI_DEFAULT_DOMAIN); } ``` This
creates the missing symmetry between allocation and deallocation
operations. ### Supporting Evidence from Kernel Repository: 1. **Related
NULL pointer crash**: The UFS driver commit `64506b3d23a3` shows that
missing MSI domain cleanup can lead to NULL pointer dereferences when
drivers repeatedly allocate/free MSIs, requiring a `Cc:
stable@vger.kernel.org # 6.3` tag. 2. **Recent platform-MSI evolution**:
The git blame shows the current implementation was added in commit
`c88f9110bfbc` (Jan 2024) by Thomas Gleixner, indicating this is
relatively new code that needs stabilization. 3. **Consistent pattern**:
The PCI MSI code (`drivers/pci/msi/irqdomain.c`) already follows this
pattern, calling `msi_remove_device_irq_domain()` in cleanup paths. ###
Stable Tree Criteria Assessment: ✅ **Fixes important bug**: Resource
leaks and "warnings and unexpected behaviours" when drivers repeatedly
allocate/free MSIs ✅ **Small and contained**: Single line addition with
clear purpose ✅ **Minimal side effects**: Only adds missing cleanup, no
behavioral changes ✅ **No architectural changes**: Simple resource
management fix ✅ **Confined to subsystem**: Only affects platform-MSI
infrastructure ✅ **Minimal regression risk**: Adding proper cleanup is
very low risk ### Comparison to Historical Examples: This is most
similar to "Similar Commit #1" (platform-msi resource leak fix) which
was marked "Backport Status: YES" and had explicit `Cc:
stable@vger.kernel.org`. Both commits: - Fix resource management bugs in
platform-MSI - Have minimal, surgical changes - Address issues that
affect driver stability - Follow existing patterns in the codebase The
asymmetry between allocation and deallocation is a classic bug pattern
that stable trees should address to prevent resource leaks and crashes
in drivers using platform MSI.

 drivers/base/platform-msi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 0e60dd650b5e0..70db08f3ac6fa 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -95,5 +95,6 @@ EXPORT_SYMBOL_GPL(platform_device_msi_init_and_alloc_irqs);
 void platform_device_msi_free_irqs_all(struct device *dev)
 {
 	msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN);
+	msi_remove_device_irq_domain(dev, MSI_DEFAULT_DOMAIN);
 }
 EXPORT_SYMBOL_GPL(platform_device_msi_free_irqs_all);
-- 
2.39.5

