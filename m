Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71D33B0ACC;
	Sat, 17 Oct 2026 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255432; cv=none; b=C1o7DcwOG4suT6c3EEGbZB/LgmXjxHwqNf9vkl9cqnfHy0wBmzilOxJlXpu18kLoH0uUjJhts4ahl6tOCDqNlx7HhvvUelIZz2Qp0SI+oZ2u2tA98lqsOQHQnL9AfWd+Ym8bHEh+xlvasfO6b8CefqK42q1pFtpbRvvtJCMOmeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255432; c=relaxed/simple;
	bh=zC85Q6h0d8ZmSD/2MBLwXIQ3kYsnm1J4ROxU0dxIVS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRpoRjKE65fuppduZtMw+f6gt4au7tIppRr8+Omdrqav50Z5jkRrKKo1SnCpvf92iR2DPKQ7RJUnRbqA+KEDHWRwdH8MHozlt2IxdZDM6v9z4bmdzvJzcPfv0MOFGBa9pbS09Y8tBQuVSxiJPgxriq8aKFsP+ASGX8+2k8Sld7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0mRhUcv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0mRhUcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172761F000C4;
	Sat, 17 Oct 2026 16:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255431;
	bh=M/ncPKzz36RyMY9OuC/4OW/ya1fgzzF47wyqXt1odSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0mRhUcv/k4TTrvfl8KlnGtJoUOywMmVtRwWUsG5/p/NbEqQvtexEXtkIyR4zdj4g
	 ADJUbiykVFRYt6C/K6MS9iQIFRIoe9e420MLpYZNQe8QLxj4V73tsU4btWfhhika00
	 rPnUJGGAvQoE6MA+A1IPT2KqC//TB2JNLd4GWz5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 774/869] iommu/amd: Do not reallocate GA log buffers on resume
Date: Sat, 17 Oct 2026 18:00:15 +0200
Message-ID: <20261017160056.762214572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 57d0e37f6c2bd..54aa09e1174d3 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -912,7 +912,9 @@ static void free_ga_log(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
 	iommu_free_pages(iommu->ga_log, get_order(GA_LOG_SIZE));
+	iommu->ga_log = NULL;
 	iommu_free_pages(iommu->ga_log_tail, get_order(8));
+	iommu->ga_log_tail = NULL;
 #endif
 }
 
@@ -957,6 +959,9 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
 		return 0;
 
+	if (iommu->ga_log && iommu->ga_log_tail)
+		return 0;
+
 	iommu->ga_log = iommu_alloc_pages(GFP_KERNEL, get_order(GA_LOG_SIZE));
 	if (!iommu->ga_log)
 		goto err_out;
-- 
2.53.0



