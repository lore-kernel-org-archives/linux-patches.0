Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BAC50E59C;
	Thu, 17 Sep 2026 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665824; cv=none; b=sN4lsa9cdkK43vSBi8DYU3OKp4et31OtOBSXk//orOdZlcw5ukEHdtCHYRdqr3NgPcMWnWReIGacjeRB7mPdwGYcXIC6CfBISwA9FRGOXPC0HLQ1IKf6feSXcwr3wUfsSR45b1udbcjhXcI6oXRxErNwcC894eBWu7nDNyv+cYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665824; c=relaxed/simple;
	bh=3ufngJ0CDdfFByCxjZE76jTcwM2yjH9vjKZa7E4gVrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvI3NSxHyX+7PLqvgC7QouyRQB31cCCXqVNydaOD8MrkNlJMXu287omtKOlD/B6Tr4hcQdzGPAHh7arbXnyxNOhPgydHciXWlKIeXNOUG3nYoBjxRpxz3fXjeZwsb1qZcwfzd297evwhcETZcwbHxRXWK/cP1M4EO2KXoISb3lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diewX5R3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diewX5R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C521F000FF;
	Thu, 17 Sep 2026 17:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665822;
	bh=8pqc5bmWYQy6+HMX5cTJkBtAa6rkCK+H3JJqv7yPIcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=diewX5R3o4bO9NlGsx/F5RVCvTWeQx7ORdIRXgv/YBV+UfC0AsHjrKcm9cvnnaJSW
	 NtZzpKOMjhxISqYggi+uMhV5FEkrCG7r7V7LDLaOATkZql5QkBy/pKmlGsz3XCIhB9
	 qpWe2Z05NJkvH1Dxa8dotWBkI/yX9gSIOEul+u2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0833/1250] iommu/amd: Do not reallocate GA log buffers on resume
Date: Thu, 17 Sep 2026 16:10:28 +0100
Message-ID: <20260917151614.526215946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0561c17a24e73..e9f1e38e0deea 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -931,7 +931,9 @@ static void free_ga_log(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
 	iommu_free_pages(iommu->ga_log);
+	iommu->ga_log = NULL;
 	iommu_free_pages(iommu->ga_log_tail);
+	iommu->ga_log_tail = NULL;
 #endif
 }
 
@@ -978,6 +980,9 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
 		return 0;
 
+	if (iommu->ga_log && iommu->ga_log_tail)
+		return 0;
+
 	iommu->ga_log = iommu_alloc_pages_node_sz(nid, GFP_KERNEL, GA_LOG_SIZE);
 	if (!iommu->ga_log)
 		goto err_out;
-- 
2.53.0



