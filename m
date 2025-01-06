Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87C514A617;
	Mon,  6 Jan 2025 15:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177986; cv=none; b=NwTWrGoeADOHT6qysTNKOnp4fRgKJ7WXZC2nCakgJt+NK+ccFU0FwHw9E0McY0USa6oTkFu29jVPIzOmTTnoCK8mAwwWwIJRYWJRbHro/GvInA0hdfg9F1YiT+WYhSPRpOCAeYgbfDzNVv41iSg8rCQR7mF0+Fz2KO/dJgMPV8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177986; c=relaxed/simple;
	bh=2s1mCsUkhr+XGrQnqQg/3CaH65VRSGOgbtS81dS/PFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QqtXp9Hm5oLIk5C8yY+0Dbojbi/Uhih/nhDR1qTWr+QIF7Dt8lBFHm/30VzybQbAStaFX2gG9w4OyD5CrKYtHulMSJuXVL6UyuMY60l2EwhlPLP8obGwGbW93bhQcvlkLqyVL5jI5KR6v8OKSZhGPuzV3UdbaZ4SQ5zb/XyT79U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QumhJjtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QumhJjtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274A8C4CED2;
	Mon,  6 Jan 2025 15:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177986;
	bh=2s1mCsUkhr+XGrQnqQg/3CaH65VRSGOgbtS81dS/PFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QumhJjtV/GgmSsp0j/LmXnX0yO714/3/rIdcEWGaQe0qADRamaiI6n/lVSWzLe/XB
	 grOoSiuN8HXPhETV7d/svDbDEgG/pc1qDgnn8JDlRtk/FyDnw3WAY56ZAsbZwOdWuA
	 G1aZrXFDUctrJos+ETclP3QrEqElCI6WihCg4nwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>
Subject: [PATCH 6.12 116/156] drm/xe: Wait for migration job before unmapping pages
Date: Mon,  6 Jan 2025 16:16:42 +0100
Message-ID: <20250106151146.096678532@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

commit 5e0a67fdb894d34c5f109e969320eef9ddae7480 upstream.

Fix a potential GPU page fault during tt -> system moves by waiting for
migration jobs to complete before unmapping SG. This ensures that IOMMU
mappings are not prematurely torn down while a migration job is still in
progress.

v2: Use intr=false(Matt A)
v3: Update commit message(Matt A)
v4: s/DMA_RESV_USAGE_BOOKKEEP/DMA_RESV_USAGE_KERNEL(Thomas)

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/3466
Fixes: 75521e8b56e8 ("drm/xe: Perform dma_map when moving system buffer objects to TT")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: stable@vger.kernel.org # v6.11+
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241213122415.3880017-2-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
(cherry picked from commit cda06412c06893a6f07a2fbf89d42a0972ec9e8e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -846,8 +846,16 @@ static int xe_bo_move(struct ttm_buffer_
 
 out:
 	if ((!ttm_bo->resource || ttm_bo->resource->mem_type == XE_PL_SYSTEM) &&
-	    ttm_bo->ttm)
+	    ttm_bo->ttm) {
+		long timeout = dma_resv_wait_timeout(ttm_bo->base.resv,
+						     DMA_RESV_USAGE_KERNEL,
+						     false,
+						     MAX_SCHEDULE_TIMEOUT);
+		if (timeout < 0)
+			ret = timeout;
+
 		xe_tt_unmap_sg(ttm_bo->ttm);
+	}
 
 	return ret;
 }


