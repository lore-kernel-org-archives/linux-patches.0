Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399D552B1F7;
	Wed, 23 Sep 2026 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173261; cv=none; b=kjDZkXZGxVmUAbc/yK4WxKnjdNrqyizM5kOLcwN+Q4ljiRuq7RSTZfnBzTAQaROlxdOALG8UfK+/TM4CQhK98h/ZJXyvBD04kahIpFl9bqKfAutyU3fXwv30t2w4scPiqZNAr8p6KZ57wydVhgzAQHJ/FXrsbaYWtBy1xEdL1ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173261; c=relaxed/simple;
	bh=lV/I7UszkZOugZJlT9rGEFru/92SZO02q7o3ULYw36U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+PyEmsoerb7uWhaPR/rInrDbrjg97Y3GFundsmSRX6sC9DWufyRvAcl3U9bmNMWnmYb5BfZJ/oAzcix0Fj1sar+HnI0v7NO3cMbOX0MNGjv7Tkm8jcz0YfowL3Y4zfgx4lNFLsbl63Ubludv8wfNUEFhvbm6IEzWuDylectDk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Saja9ZEq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Saja9ZEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387BC1F000FF;
	Wed, 23 Sep 2026 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173259;
	bh=xWUmXd9m7DWCr3+HyHuxd6WShUfIN2jP/cdm7a9DNOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Saja9ZEqFmQMge83+XwnrHPhRR0Lzc4oNP8yszTyq4QIoLdkxM020Y2ba7eVBtkx1
	 qnmg7Ps7eaYE3kyzham+dRSLmHkTkEPpVQSZ1usPouX0dmGEvbsBDtAWNY3oYwLTAE
	 CP67yHWQ2RE7V6jLiUK+Fl5OtJQsMRPWh3NXKlCQ=
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
Subject: [PATCH 7.2 192/438] powerpc/iommu: Fix the overflow validation in iommu_tce_check_ioba
Date: Wed, 23 Sep 2026 16:03:33 +0200
Message-ID: <20260923140649.736373090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ee1b5cb557c9a..1ae8384637b5f 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1076,7 +1076,7 @@ int iommu_tce_check_ioba(unsigned long page_shift,
 	if (ioba < offset)
 		return -EINVAL;
 
-	if ((ioba + 1) > (offset + size))
+	if ((ioba + npages < ioba) || (ioba - offset + npages > size))
 		return -EINVAL;
 
 	return 0;
-- 
2.53.0



