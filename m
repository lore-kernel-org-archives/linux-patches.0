Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D264C43C7C4;
	Thu, 30 Jul 2026 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422530; cv=none; b=E5/vU7D2ietlfirvYkm4yJEW1Qyhnyx6aZHAIOAQ0TQOw8DSlcnp0U6CXDBrhUm9DmigWPHPoxQUea6EXOJTcptwa0jYO27k2oOHarkrMLp/PZ7nHbAhbIOAiEeBc2p1zPt8shcbJAKFSLPR0ogI0HcIjXMSIM6RZQfZDndh/0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422530; c=relaxed/simple;
	bh=alwPSHOfl5lu233D28T86COfhiak+/skC/DjOKs6KTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5LPqU0DkfHBhi3Q8oCpobCFY2ZiFoNJOh/lbAoFPcRibI87usBVACR7sx0CtGbt3S6Yhr4z9y68JmZ2LDqinnQkRMXqZbO0bqby75L5vY04U3y/SCaqv2ynzqIi8MwgaRaPZD3ge7Mcr2iO4Z5UqnR3Z05l9FRtDgGT6DiEI8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTwAZWq6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTwAZWq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD82B1F00A3D;
	Thu, 30 Jul 2026 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422528;
	bh=w0A2OcyqLSZYgKVdE3Ohgh5DlZaGCbBMYXF1k0dS8cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTwAZWq66L7SBjBIYYlJy7wM/X7OdZusoezHDlZH2+tEt/n2RF77MrHHxdDA+maoO
	 /fjNErN0Sdyfusi75GQaA7PC2DLrzGFrRpl4LNtkz+uf4plOVqCXnBTUKAmj59czXJ
	 l1S9PRyInRFISyxDr8oUkujryoDy9Zsun97x7eog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 7.1 471/744] drm/gpusvm: Zero HMM PFNs before scanning ranges
Date: Thu, 30 Jul 2026 16:12:24 +0200
Message-ID: <20260730141454.307513523@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsburskii <skinsburskii@gmail.com>

commit 67b8bfd4ec7dac6e79a7ad9ad19a7a9d6fc35a26 upstream.

drm_gpusvm_scan_mm() asks HMM to report the current CPU page-table
state without faulting missing entries by leaving default_flags set to
zero. The HMM PFN array is still caller-owned input/output state, and
the framework may preserve input bits while filling entries. It is not
safe for the caller to hand HMM an uninitialized array and then treat
entries without HMM_PFN_VALID as an authoritative unpopulated result.

Use kvcalloc() for the temporary PFN array so entries that are not
reported as valid start from the documented zero state. This prevents
random stack or heap contents from being interpreted as HMM PFN flags or
PFN values during the scan.

Fixes: f1d08a586482 ("drm/gpusvm: Introduce a function to scan the current migration state")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/178406967042.1113483.2116704310277917086.stgit@skinsburskii
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gpusvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -781,7 +781,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_s
 	const struct dev_pagemap *other = NULL;
 	int err, i;
 
-	pfns = kvmalloc_array(npages, sizeof(*pfns), GFP_KERNEL);
+	pfns = kvcalloc(npages, sizeof(*pfns), GFP_KERNEL);
 	if (!pfns)
 		return DRM_GPUSVM_SCAN_UNPOPULATED;
 


