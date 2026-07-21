Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF393430CDC;
	Tue, 21 Jul 2026 19:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663232; cv=none; b=sZMj28Ut36dSsgO4CSDXAXCBBiLakvI91bdrCwhUXmvKMBG5Ad0eGRcHdjFnEmTZZnCrzZ8VOcf8AU8YGeKNrMwIR34IlPeuuVQlEPODYpjzfwFH9XCor3oSK2AiSzfDPQhFAxJl9dFebYIv/G9srD0F5K/3EFUgXikW/DDibqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663232; c=relaxed/simple;
	bh=t9LDf2q91VkSY5tdSplzxvE86ofHmfAw3+PDRhT6AA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vDA17cw0mTzu3RSfaV9SwJ9pxViiSoxi9jrxOufXXOoQEb7hZBx2KB1HZQMTtOAS178Tv3ZQM0HydZjUl+CVlHgRZc2SM+d4AjN8Y7B+LVun68nKyJMNmlVGfL3/vul4wLjlKazyR/KXMwXPCXQdRsP21mCaXXN1LDoQhFt2xH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1Lc2MDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1Lc2MDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEDF1F000E9;
	Tue, 21 Jul 2026 19:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663231;
	bh=UwiKY3HK1XbrdxRMb52k9mR/TVNhw7uiEqezWXmcgXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1Lc2MDdTIiG7kA3XGWuguW18MvzB+StFS3sh040tJzfVdmG0ArSkUUG0whh4stN1
	 LfK1l5humOU8JhVqZd6U6Npma3/PLdfGv8+dd+VZs9psiS4LjRQ8LxAs/SnFeFrIiJ
	 jGPfQmOpsTlLc5LtNX27GiEXsoVKxYR4WslKmwvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0746/1276] drm/xe/pt: Fix NULL pointer dereference in xe_pt_zap_ptes_entry()
Date: Tue, 21 Jul 2026 17:19:49 +0200
Message-ID: <20260721152502.775458797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9b8903ad6f0431..422dc351dc0e05 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -786,12 +786,20 @@ static int xe_pt_zap_ptes_entry(struct xe_ptw *parent, pgoff_t offset,
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



