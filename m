Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42BC34B437;
	Sat, 17 Oct 2026 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260675; cv=none; b=VgWfxdGcQlxdKhyqbavJbUp9ce3kPIBSUPQ3OSWjxvJeBg7KF1rp72ZX9gx7Y8R+zqZQE49Gc5PXtD+brPCgAk45G0xM1b610EaxP2hA7TdedA1rQQm0LPOMnQ13yq9Yq8qrWmGDn1WJSXx96R668aNQ3pPUgvorFDa4DqwzVr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260675; c=relaxed/simple;
	bh=FqyFPDcD+T4VytoJ1PL1XgH7tbEymVf87BH5LvlEEmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEGs/8FhvQ+duATKLDTS+ysNHVFjumkARQicbR2KFmOKfn2YnAK41qGRBVqauVfP+9e6Vemi/dC3hwp/3IZr7luT3ZsIqj3idM6gelgA/zGSzw7jhrra7K7H6j9dtOex+TVM74qGX8OAZdIyMTKIptY+JK0nzb9hPiKSeiKN+l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgLaDIiq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgLaDIiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1451F000C4;
	Sat, 17 Oct 2026 18:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260674;
	bh=pmF2pgsM3O2psg5fc8yhyyqjgKDT8hWqa+5a7P2r75o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgLaDIiq235F2It2LggFX/NKNbdUCv8s2sBY8BHTmWQ5HsyM0OCEo1z2hIwM80R4+
	 2mlpMvmdxzuoLjnHCoQ2OoJ9C0VxsIiC18imQJuODd4mzR2b1Iwpg6HTokb6L3j57o
	 al4+az/7+QtlfABXMW7xtnDD3WiBPaxOfbaRKnn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1622/1674] iommu/amd: Do not reallocate GA log buffers on resume
Date: Sat, 17 Oct 2026 18:04:54 +0200
Message-ID: <20261017160512.718205278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 00a7dd64888d6dd72110b40e2824a088cf7b7386 ]

Commit c5e1a1eb9279 ("iommu/amd: Simplify and Consolidate Virtual APIC
(AVIC) Enablement") moved the GA log allocation from iommu_init_pci()
to enable_iommus_vapic(), which is called on every resume.

iommu_init_ga_log() assigns iommu->ga_log and iommu->ga_log_tail
unconditionally. Each resume therefore replaces the boot-time pointers
and leaks both old allocations. The function also uses GFP_KERNEL from a
syscore resume callback, where interrupts are disabled and the non-boot
CPUs are offline.

Return early if both buffers are already allocated. Clear the pointers
in free_ga_log() so a partial allocation failure cannot leave ga_log
dangling.

Fixes: c5e1a1eb9279 ("iommu/amd: Simplify and Consolidate Virtual APIC (AVIC) Enablement")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 7a9119f99e98a..10ab34bed410e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -958,7 +958,9 @@ static void free_ga_log(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
 	free_pages((unsigned long)iommu->ga_log, get_order(GA_LOG_SIZE));
+	iommu->ga_log = NULL;
 	free_pages((unsigned long)iommu->ga_log_tail, get_order(8));
+	iommu->ga_log_tail = NULL;
 #endif
 }
 
@@ -1003,6 +1005,9 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
 		return 0;
 
+	if (iommu->ga_log && iommu->ga_log_tail)
+		return 0;
+
 	iommu->ga_log = (u8 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					get_order(GA_LOG_SIZE));
 	if (!iommu->ga_log)
-- 
2.53.0



