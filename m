Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7343B71B6;
	Wed, 30 Sep 2026 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792025; cv=none; b=FenPqjMveiep4qQfNxatJT5ZVkEhBcB/Ryx0c17huHkl5eZZcFp3ndBbnQ5/KqSEOdy7IQ+UgzLK7HKRwLhIUSYPWk7Tmfkg70TUAcLU2pdFydEz7a6WQGXZfHTk7SsUe9YLh3DKPWZzZ1BwjBNxwu4fnhFhV3eSGXPh3FmysBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792025; c=relaxed/simple;
	bh=oHLv32rdlqgqwislHhwLMnxRjakqXdm/Q7UMgwug0kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PI9jkn33rCdQTy5auYqJzeMKlDSUl/WqRhSZ5QFmXmF93XmJfCQzf+misEJD1mSyxTk7s/r9FwopXxFw8LGhnsHuBjCq6sC7OG9RdE/6NUhqRBqfWP+wWq4L+UeaeIM99a87zVqB7aDhBEg+47OOLQxBBl0Vd2GUNy7cxGy09I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqS35CK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqS35CK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DCB1F000FF;
	Wed, 30 Sep 2026 18:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792024;
	bh=3urE1dAd13Z37lwbJHV7oq7ZLoJsu5/qGpjBIW1f6vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqS35CK2KtMGdxIG+s6XX8Q7VeAJV7EdxQdMAuZ0gUi7Q6uiKkg9z2UevIw8jFjrS
	 LhkDAvaajvf7huvXTMgkxJyE8CvbxBwsgigxd1c0HIPD1GXY15MA2JWUghZEMpsTc6
	 GSUjPO5oLBC4ovL4MyRD0LouPrqF3ZdQVAuiRQWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 507/752] powerpc/iommu: Fix the overflow validation in iommu_tce_check_ioba
Date: Wed, 30 Sep 2026 17:26:17 +0200
Message-ID: <20260930152409.229869214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

[ Upstream commit 0b271f7d7f5ed45bc498a03ce0aa9cfd8402fc71 ]

The commit b1af23d836f8 ("KVM: PPC: iommu: Unify TCE checking") unified
IOBA parameter checking across KVM and VFIO into iommu_tce_check_ioba().
While doing so, the passed in argument npages is ignored and constant
value '1' is used leaving out a possible overflow as the callers can
legitimately be using npages > 1 for H_STUFF_TCE or H_PUT_TCE_INDIRECT
cases.

Fix this by accounting for 'npages', checking for arithmetic overflow,
and verifying that the entire requested range (ioba - offset + npages)
does not exceed the table capacity 'size'.

Fixes: b1af23d836f8 ("KVM: PPC: iommu: Unify TCE checking")
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index b858f186e9a70..abd10159c2e6e 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1053,7 +1053,7 @@ int iommu_tce_check_ioba(unsigned long page_shift,
 	if (ioba < offset)
 		return -EINVAL;
 
-	if ((ioba + 1) > (offset + size))
+	if ((ioba + npages < ioba) || (ioba - offset + npages > size))
 		return -EINVAL;
 
 	return 0;
-- 
2.53.0



