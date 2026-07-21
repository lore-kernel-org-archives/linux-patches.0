Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56A546D0A4;
	Tue, 21 Jul 2026 18:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658131; cv=none; b=X1HqmMS07oG3venhFN4N/RT2BkN/hKYKoMCQ2JCgj3XWXoAqKg66NVS7YLfDMlhQAmnqIE1sHlzj+oFocf5wPjkKB0bkz3/X9c1/m+iCdxc8Bk7pllp1rN+ZGTHHrt7ST2+4Csvrp7+1zz9H77Rl9g7kST2CxRuD6ojukAsJRwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658131; c=relaxed/simple;
	bh=YcW3yDXoqMyqAzbPK/540ph40f0+6L7AM79mU2iXsmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kk+v7/rFfLL1sajFU/3LuKN37Xg8XOO4WGgRBC6NkXYd+2x7t9lDFzpgtiwaf2gIJEEl1fNKOk4TeAtbi3CXUww0B60NWjap9a0nXEXnkRmobVUycEsB5sUIKbVSmB07mH/1Gon+/n0gaeSzFmtr8bs6iwu9Zg652JNsPO4d3RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrpW6WIX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrpW6WIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570D81F000E9;
	Tue, 21 Jul 2026 18:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658129;
	bh=dffPMasrmmEDKzYhMD0YtIFAIn12/wa9A54eoTIA1QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZrpW6WIXC98v17YQqqTDc5bWRaPHa062cRnJ37v+sPGi28sY3ZWX54g4tYYxR4Ok5
	 umijclfajiRfQY2seJvirb1rCBsPawMMVo6OkJN8HdCsClKrJAngfZAZT/HOS3Hkwa
	 UuXis0xaARbnEQd7882Bvk9ZX4NS22uMbrfBXP3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1020/1611] drm/xe/pt: Fix NULL pointer dereference in xe_pt_zap_ptes_entry()
Date: Tue, 21 Jul 2026 17:18:56 +0200
Message-ID: <20260721152538.334968374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a21383fba1e816..93c0a9d860f61b 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -860,12 +860,20 @@ static int xe_pt_zap_ptes_entry(struct xe_ptw *parent, pgoff_t offset,
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



