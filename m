Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8456C1509BC;
	Tue, 20 Feb 2024 21:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464705; cv=none; b=AP8MRmSLLJ0Ui60uBJpkSEbkBScqFZz9hxA9cfgWp/MC1g+zLYPz8QXCH2jittjZDE8NA1DtzzC5LDBk2UB21BpqLkbpFAFcxOhS5izvsvDX2XsPxRV4dZ5SpJaT1ZqXuuwH/ENUgE+Q8MEn5g4V0Fjbj1aPUSAeTdecAsu+acA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464705; c=relaxed/simple;
	bh=xcL9f0hMFHa2rruGsnehYS6fUAQ4npjQ7dlZft1MMyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQt2ZiLL1lwDUOhUtOKhTq/GzOMc6QOXp2xPeWJyJsWoEhqH9/3dhrW8M2vZ6NAMTg3QMMYdfR1HWxMuurFzAa2nY0adqAO/S7OvwW+WJc2UbSKeLVLvlx5ucq9oiwxhBylRQZ399ilBbN08tgsnqe60H83a5jHk8UlYRWZuLtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfSJDylX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfSJDylX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3644C433F1;
	Tue, 20 Feb 2024 21:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464705;
	bh=xcL9f0hMFHa2rruGsnehYS6fUAQ4npjQ7dlZft1MMyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfSJDylX77lQmpeETY3k6fUzeDExzg6zRAsZ4r+5RzxBQ4RmhJrYWw250lU2D9o1K
	 1mUx11PexMqU50V7ZKUZeQ7d/tyKBbE/ofB9X59CTkGo5WqKmTViLjD/HbOdkUgt/H
	 Vwi084fj8145ZSMQMyDLp2JJLGq14xvG7scbQkwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 111/309] powerpc/iommu: Fix the missing iommu_group_put() during platform domain attach
Date: Tue, 20 Feb 2024 21:54:30 +0100
Message-ID: <20240220205636.665848358@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

[ Upstream commit 0846dd77c8349ec92ca0079c9c71d130f34cb192 ]

The function spapr_tce_platform_iommu_attach_dev() is missing to call
iommu_group_put() when the domain is already set. This refcount leak
shows up with BUG_ON() during DLPAR remove operation as:

  KernelBug: Kernel bug in state 'None': kernel BUG at arch/powerpc/platforms/pseries/iommu.c:100!
  Oops: Exception in kernel mode, sig: 5 [#1]
  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=8192 NUMA pSeries
  <snip>
  Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1060.00 (NH1060_016) hv:phyp pSeries
  NIP:  c0000000000ff4d4 LR: c0000000000ff4cc CTR: 0000000000000000
  REGS: c0000013aed5f840 TRAP: 0700   Tainted: G          I         (6.8.0-rc3-autotest-g99bd3cb0d12e)
  MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 44002402  XER: 20040000
  CFAR: c000000000a0d170 IRQMASK: 0
  ...
  NIP iommu_reconfig_notifier+0x94/0x200
  LR  iommu_reconfig_notifier+0x8c/0x200
  Call Trace:
    iommu_reconfig_notifier+0x8c/0x200 (unreliable)
    notifier_call_chain+0xb8/0x19c
    blocking_notifier_call_chain+0x64/0x98
    of_reconfig_notify+0x44/0xdc
    of_detach_node+0x78/0xb0
    ofdt_write.part.0+0x86c/0xbb8
    proc_reg_write+0xf4/0x150
    vfs_write+0xf8/0x488
    ksys_write+0x84/0x140
    system_call_exception+0x138/0x330
    system_call_vectored_common+0x15c/0x2ec

The patch adds the missing iommu_group_put() call.

Fixes: a8ca9fc9134c ("powerpc/iommu: Do not do platform domain attach atctions after probe")
Reported-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Closes: https://lore.kernel.org/all/274e0d2b-b5cc-475e-94e6-8427e88e271d@linux.vnet.ibm.com/
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/170784021983.6249.10039296655906636112.stgit@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index c6f62e130d55..4393d447cb56 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1290,8 +1290,10 @@ spapr_tce_platform_iommu_attach_dev(struct iommu_domain *platform_domain,
 	int ret = -EINVAL;
 
 	/* At first attach the ownership is already set */
-	if (!domain)
+	if (!domain) {
+		iommu_group_put(grp);
 		return 0;
+	}
 
 	if (!grp)
 		return -ENODEV;
-- 
2.43.0



