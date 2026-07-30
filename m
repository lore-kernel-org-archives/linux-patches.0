Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA85F43E4B5;
	Thu, 30 Jul 2026 14:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422648; cv=none; b=UkkfzJLKZDTF8Mxpa1ZvITNqfhOyPAqpRlyGcauMsAqfG+IcJrFkJLtVtWqt7kZsBAXEeWB3/D10nZBqzEQGzjj6apoxdhNjNjn2fiLPIBypbeSWRryL0DPssOJ1iwYKXBRRqMHpiKYi6Y0gKCUlHn2uIJ84rMAOqlkimZjzmZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422648; c=relaxed/simple;
	bh=Rbzj2lTROLgmQufFbBnIXK8LihDyZ60OA3hrSfxpSlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViwBY63vkHXIa2ekMrCvBapd/Q2trydriikQ17HV7kx6a1S7YMuLVY/v21JSYN9kjXvG7PVzpHYc/QbXKphzHSfVeVYHeRIC+Ic7Pv3OM3BsC1EL5GPq4aLn6ZUvp9vK1ZAeVmjOh3aPGQzqIpcgQLuJphM118rZUAHhYKmrA1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7h6xAxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7h6xAxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112EC1F000E9;
	Thu, 30 Jul 2026 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422646;
	bh=5/QdNPxmrfiClmslX7mn+4PMSeBTLxpkRlUlwU6kn+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7h6xAxBrO4KXWNnu1IkNYkdSw1D9x4wY9M1GPAkhT+Cy0Tp+0ojPP+5Gltpbv3RI
	 3LHmlgwGGea1pC64H/I286gy6F0CYDNzwh0O64QrjxSRlYcK+3IeoQY5CDnhfv7kty
	 DO4whS1s1Hq3GeP1pJFp5EAbUdM9U0JJeLZsMWVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Subject: [PATCH 7.1 466/744] drm/pagemap: Clear driver-provided PFNs from migration PFN array
Date: Thu, 30 Jul 2026 16:12:19 +0200
Message-ID: <20260730141454.202955308@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit 1f1be4ba643fb67410d753111c37ae42a2e2a814 upstream.

DRM pagemap overloads the migration PFN array to store driver-provided
PFNs before calling migrate_vma_*() to finalize the migration. If an
error occurs during the incremental copy phase, the migration PFN
entries are reverted to their original state. After reverting the
device-folio mutations, clear any remaining driver-provided PFNs to
avoid confusing the migrate_vma_*() helpers.

Also clear any driver-provided PFNs if populate_devmem_pfn() fails, as
a precaution against stale entries being interpreted as migration PFNs.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 3902846af36b ("drm/pagemap Fix error paths in drm_pagemap_migrate_to_devmem")
Fixes: ec265e1f1cfc ("drm/pagemap: Support source migration over interconnect")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patch.msgid.link/20260721204353.1082632-1-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_pagemap.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -628,8 +628,10 @@ int drm_pagemap_migrate_to_devmem(struct
 	}
 
 	err = ops->populate_devmem_pfn(devmem_allocation, npages, migrate.dst);
-	if (err)
-		goto err_aborted_migration;
+	if (err) {
+		npages = 0;
+		goto err_finalize;
+	}
 
 	own_pages = 0;
 
@@ -710,8 +712,11 @@ next:
 		msecs_to_jiffies(mdetails->timeslice_ms);
 
 err_finalize:
-	if (err)
+	if (err) {
 		drm_pagemap_migration_unlock_put_pages(npages, migrate.dst);
+		for (i = npages; i < npages_in_range(start, end); ++i)
+			migrate.dst[i] = 0;
+	}
 err_aborted_migration:
 	migrate_vma_pages(&migrate);
 


