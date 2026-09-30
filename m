Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575FA3DBD44;
	Wed, 30 Sep 2026 19:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796158; cv=none; b=p/SVVyFGw5KSaSv9vlpgXAInBneSEUPfaqKq6h7OrvBMkrbfVkg4VBdfDQiS5F90mwyauUWl8Ut/aecyvEI7ZxQxHr9KssJmAwEnVbXZbVKgHyWHuUMg+3hNaxmaI5mhQmPJ9YgLe9o3aTRBhPeiLIzs1TNCQARhbQFNpLk0B4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796158; c=relaxed/simple;
	bh=YycNS+72WGuSX9S07QxucmpD2pPjVykZPUX7c9IM7B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twyvkdSVS1vOtnmoLlCuyDFrLrIXnWKW8ez+goHUHSwGCydU+6CxPXTxa/21iOFP6osyK7Vbob7DGdKImHDDbYDavZU3eJnAh/xu8x+Nmh4G62tDrKF0jepc00ByafXb1CL5nfG/X55dGG64mAUIZPU+hMIRYewoYnXxIpITc/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1E1tViwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1E1tViwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E621F000FF;
	Wed, 30 Sep 2026 19:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796156;
	bh=b5jBkq2mLItvgMHA+SfTAaM2oxWnxBXkw7Cz+aDZQtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1E1tViwIkeC7/gJCOu16jjFSxUooqEzLaYC0Sc4q/Txx7InR8jTVyDr1gjWV6vKPX
	 SgDeb37Wfr4nmma07ySqZPgOLJOQtzNjyHFsvqCNga/Mjm/5oHImefwOT6DHhO+fHK
	 n/rlR+RQSMfYw6xnZL6DhnRKP23Ovgx0bsHldqRQ=
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
Subject: [PATCH 6.6 0815/1193] powerpc/iommu: Fix the overflow validation in iommu_tce_check_ioba
Date: Wed, 30 Sep 2026 17:24:59 +0200
Message-ID: <20260930152452.351466099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index efaca0c6eff9d..49f01f6b9346b 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1056,7 +1056,7 @@ int iommu_tce_check_ioba(unsigned long page_shift,
 	if (ioba < offset)
 		return -EINVAL;
 
-	if ((ioba + 1) > (offset + size))
+	if ((ioba + npages < ioba) || (ioba - offset + npages > size))
 		return -EINVAL;
 
 	return 0;
-- 
2.53.0



