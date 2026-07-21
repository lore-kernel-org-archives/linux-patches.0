Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEB940314E;
	Tue, 21 Jul 2026 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653625; cv=none; b=IM4EkZrrDoHwx3j8ERzeOLiiwMnGAMQ/KmtDYPxY4/+Ang+6ENBcB+XaBhY5I0zWebeXWSesLeLu5dnfUdAZrQ9qj9Q/MttA4VbjgSpUgURP0n86k8woMWHY8BkPzy3CyteTdQ22ix40/ZUPfYKpgAWfeBSkRThHtzeeGdluVuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653625; c=relaxed/simple;
	bh=4clDXvLOCCZP0PSj55Rghn0o7eB3CC36YkqoK0PM0Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JlEUAXiolWILHIwODLj0nah2D0mm/IVOmFzfkBvCrUUFtkfidiQt2eD6LRc08uedTg5bOPTLpa9pk7flHMHmXmfk3xEeUtiM+mwMEybkFlarKAjQunnu5DZODWZr9+bikBsqC1W7k9m+6BQzI3h0OanhRyyVuAQCFulfYzmdoPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bg9pjmZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bg9pjmZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBE41F000E9;
	Tue, 21 Jul 2026 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653623;
	bh=Gpph32ViypX2yH4PLQ3A7tgb3wjtJtaQSJWzcb/cJWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bg9pjmZseW/t0melVfOs3FwOtapfooEgGKn9tplz1dKj1q7OU4attfRsxbZoCJd1W
	 gbsOGTKLpvRWpCcqcuavomWsf+JJH/2wGdZHLYNZawXgaF0kxP9mqpyKbZLC1O1oJj
	 W/IF8o2rXGSGnMwrkMG2SditdK0IRvFWSxyupYf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1398/2077] drm/xe/pt: Fix NULL pointer dereference in xe_pt_zap_ptes_entry()
Date: Tue, 21 Jul 2026 17:17:51 +0200
Message-ID: <20260721152625.785039079@linuxfoundation.org>
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

From: Francois Dugast <francois.dugast@intel.com>

[ Upstream commit 3feeb667197bd58a17f4edfdbcad249ffcb3c864 ]

The page-table walk framework may pass a NULL *child pointer for
unpopulated entries. xe_pt_zap_ptes_entry() called container_of(*child)
before checking for NULL, then dereferenced the result, causing a crash.

Move the container_of() call after a NULL guard, so the function returns
early instead of proceeding with an invalid pointer. XE_WARN_ON is kept
to help root cause the issue, but we now bail instead of crashing the
driver.

v2: Comment that triggering XE_WARN_ON is unexpected behavior (Matt Brost)

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20260616081756.286918-1-francois.dugast@intel.com
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
(cherry picked from commit b9297d19d9df5d4b6c994648570c5dcd1cac68ff)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pt.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
index 8e5f4f0dea3f9a..bfc326acbde429 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -884,12 +884,20 @@ static int xe_pt_zap_ptes_entry(struct xe_ptw *parent, pgoff_t offset,
 {
 	struct xe_pt_zap_ptes_walk *xe_walk =
 		container_of(walk, typeof(*xe_walk), base);
-	struct xe_pt *xe_child = container_of(*child, typeof(*xe_child), base);
+	struct xe_pt *xe_child;
 	pgoff_t end_offset;
 
-	XE_WARN_ON(!*child);
 	XE_WARN_ON(!level);
 
+	/*
+	 * Below would be unexpected behavior that needs to be root caused
+	 * but better warn and bail than crash the driver.
+	 */
+	if (XE_WARN_ON(!*child))
+		return 0;
+
+	xe_child = container_of(*child, typeof(*xe_child), base);
+
 	/*
 	 * Note that we're called from an entry callback, and we're dealing
 	 * with the child of that entry rather than the parent, so need to
-- 
2.53.0



