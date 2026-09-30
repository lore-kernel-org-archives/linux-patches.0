Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CFD33D6FD;
	Wed, 30 Sep 2026 16:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785936; cv=none; b=Yds7ew5PyXqbPnmMnhjdtjrHDiQMxGVZ1qta7T8A0CJcYKzHCippvdWFzccWHuh8qeZIuxE7fZYdr+mReOCRkClOAxeV9iHX3jT2xGQF6ZeNgAld7tDqJ5d2dGK96XR2sS22JuWVR0cy1gQyPwFrlLctQPZJ5pQ+sQVaF2dY8vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785936; c=relaxed/simple;
	bh=yVDsb5LcneYwzEl0A/w1x/k/GAOBO2MSaWIKz3DSGFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beDG6TN70BSPDDXW4ULMhJXNiJ+9RhbtWvSQuBb4ftJiFuFul+UqN1w2FiUgD1v6wuNwsAAI3CGxkSNtGvaaxS4LJnJiwnOEeZLjby6c8I1+G7RHdxBT8zkCXdrOQsEIoCvhOdyMjUodIjeIRTZZnLfzZ4sWj+ZT7s4xLjqhV1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Exo30jkV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Exo30jkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9BB1F000FF;
	Wed, 30 Sep 2026 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785935;
	bh=d4lELuISYm+8GkEIGGNeSSeBNH2V209hZbmtIhPewUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Exo30jkVvwMB6ol0kSb1j1zoUofwj3u6VRkzI6MIZRzoIeusgQ3pBJMvYd9TqGErS
	 wvQpwSqU/ECDTuJcT/l91bk6LfYbbmb7OngLPExleKl+V7RBkDBV9mBzw4R8phU5gf
	 DsCj7jjM9EohsLINwvqX5U5aAFj0B9Td7AUkHGcc=
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
Subject: [PATCH 6.1 682/982] powerpc/iommu: Fix the overflow validation in iommu_tce_check_ioba
Date: Wed, 30 Sep 2026 17:23:38 +0200
Message-ID: <20260930152431.412045597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a612abe4bfd57..81bd60c8094c1 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1055,7 +1055,7 @@ int iommu_tce_check_ioba(unsigned long page_shift,
 	if (ioba < offset)
 		return -EINVAL;
 
-	if ((ioba + 1) > (offset + size))
+	if ((ioba + npages < ioba) || (ioba - offset + npages > size))
 		return -EINVAL;
 
 	return 0;
-- 
2.53.0



