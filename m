Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349824D4861;
	Thu, 17 Sep 2026 15:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659639; cv=none; b=jTPN3hIiMZP/V8e/dbiGf/9CkAKlI1JhNzkRpNqdXRvWebuZ+RSwxWPiKOO5RMN136yvyqYXNMX85nOQztJPsw/vRdQcD34L/5Bo7URfNCwvKHuh1hxkp3UOnHYl1wr6GX/bNX1jWxzuCzZ/hg6891GIG0fkEDdzDhuiMiBaKis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659639; c=relaxed/simple;
	bh=PWsoEkxN3hWwpLmdKlt6KYVqNW71vCPJ8oQc7jdxLrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWezMwVIofVJNqeQWf6mMZd2z6Hwaq5eOBIlCrXajGh0/gJHFZhMMfFOVJ2UnT7lAy1sm/PbyQM/j4fpaDnEYxUd663KMb/orvcAdLsCHy8wOqaqvQUsLQKa3dBUJpXp3pGeroj76n1GCA5edRj7z4phWtqjKKrR6qaap0i1vKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKrpxZuW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKrpxZuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE2A1F000FF;
	Thu, 17 Sep 2026 15:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659628;
	bh=0yhqDDsw5onOi+4M3aek3cyHqTp3THSbgnd0mqKKllU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKrpxZuWoR8vHxMpTsMVeuwTHWoraD5WaxyfmN27kssHAM8cvnZNn7uh8SBhGSMn0
	 a+wdFUDgXR3voNmj4TY0TBxdUB/4LbL//uy4ypWTHLUkipNhgEtu2dkYqVsNnvcs3U
	 suPlMUwcaf3np5kb4KpklpiZSfw+otCLInMGAdjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 319/733] iommu/amd: Do not reallocate GA log buffers on resume
Date: Thu, 17 Sep 2026 16:10:27 +0100
Message-ID: <20260917151359.441855490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 2563ebe9f2461..16ffc75ef3f0d 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -906,7 +906,9 @@ static void free_ga_log(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
 	iommu_free_pages(iommu->ga_log);
+	iommu->ga_log = NULL;
 	iommu_free_pages(iommu->ga_log_tail);
+	iommu->ga_log_tail = NULL;
 #endif
 }
 
@@ -953,6 +955,9 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
 		return -EINVAL;
 
+	if (iommu->ga_log && iommu->ga_log_tail)
+		return 0;
+
 	iommu->ga_log = iommu_alloc_pages_node_sz(nid, GFP_KERNEL, GA_LOG_SIZE);
 	if (!iommu->ga_log)
 		goto err_out;
-- 
2.53.0



