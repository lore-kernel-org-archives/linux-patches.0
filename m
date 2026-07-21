Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642733955E0;
	Tue, 21 Jul 2026 17:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653635; cv=none; b=oFWhm+olUAgQ1iP0S7kEBh2QDTEngv8ijTTZLqpldbbjIoTdfVQm5mQtqHwfIMwOaUKenybDjedm5vsrM0KYyxKHGAYdjhmc1HxhbVD3Zp4BHeJK3GoihTCYz4q4hiP7ptbxUA6y4WclBFvTeVX2OZb0OXIEabzawXdOREv5usc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653635; c=relaxed/simple;
	bh=O5nVkvMf4N1VRYpY3RJLLifawM8TXVzGP580EMWWzyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=toSZuiE6SIBRtnVi1t/SAIJU8nYQpOsnsfJ+NwVKbCPl+JUELkYN2J6vMgOdNHOc9S3/trvk7JA7Q8Xj4z7gg5lWWGpC0YSlsLDBpb2/yCGqGHWQbk5fDLdFV5s7YoPwjupsR73BBaY2yO5XtToCHTgX43pFgtMS9zULId0u92E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GWFHwCS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GWFHwCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE141F000E9;
	Tue, 21 Jul 2026 17:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653634;
	bh=XJKzywh/OrsBzbHNeK+JbbI2YqyV6hwx/b2kBvguwKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GWFHwCSYpU++SWi347pAaKx+ZRvMAqno7LChZzIRQf84ZfWNYtH9akfX94lzObxr
	 r02kRoWoG5/kTaxh9lYRuXvUmQcL9NZ9hGaG4jH++/uNoSL+5wtCzNl882O9J2p1sy
	 7UkCNkCSGYdnwr/+zbva57JLw2luT3c/J1yqjqA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Zongyao Bai <zongyao.bai@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1401/2077] drm/xe/userptr: Drop bogus static from finish in force_invalidate
Date: Tue, 21 Jul 2026 17:17:54 +0200
Message-ID: <20260721152625.853123544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 0c56ea482aab1470b96a525ef53fa3eb8704f9a6 ]

The local "finish" pointer in xe_vma_userptr_force_invalidate() is
unconditionally written before each read, so the static storage class
serves no purpose. Worse, it makes the variable a process-wide shared
slot: the function's per-VM asserts do not exclude concurrent callers
on different VMs, so two such callers can race on the slot and take
the wrong if (finish) branch.

The function is gated by CONFIG_DRM_XE_USERPTR_INVAL_INJECT
(developer/test option, default n), so production builds are
unaffected.

Drop the static.

Fixes: 18c4e536959e ("drm/xe/userptr: Convert invalidation to two-pass MMU notifier")
Assisted-by: Claude:claude-opus-4.7
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Zongyao Bai <zongyao.bai@intel.com>
Link: https://patch.msgid.link/20260625224452.3243231-1-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit ed382e3b07fae51a09d7290485bff0592f6b168b)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_userptr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_userptr.c b/drivers/gpu/drm/xe/xe_userptr.c
index 6761005c0b900a..6f71bc66b14eba 100644
--- a/drivers/gpu/drm/xe/xe_userptr.c
+++ b/drivers/gpu/drm/xe/xe_userptr.c
@@ -269,7 +269,7 @@ static const struct mmu_interval_notifier_ops vma_userptr_notifier_ops = {
  */
 void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
 {
-	static struct mmu_interval_notifier_finish *finish;
+	struct mmu_interval_notifier_finish *finish;
 	struct xe_vm *vm = xe_vma_vm(&uvma->vma);
 
 	/* Protect against concurrent userptr pinning */
-- 
2.53.0



