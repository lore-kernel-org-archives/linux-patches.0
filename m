Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E40286D4B;
	Wed, 28 Jan 2026 16:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616125; cv=none; b=jDlclzKGuV3ckEaTGTHjpi4X1CeUWH6FnAoLV35P4Zi/UGCbzgzoqpSTcXS0uFDOhUM5OVxzHYwbbYlm7bkwqgE0oEypsztSgXBdIavywucu+aimULGu6qtZquncfHHzb8wW1L7aye3Xj65kWZYfy0DAl5ancYxpc2dhXoeLD3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616125; c=relaxed/simple;
	bh=jiULuhU/afeYb0N0Ff9BfYrWy8aqZHyGbWBTJUwhAuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ev+XtI12hFenHsf7MXQ+778ZCsIHT2rJV2RRDSkN12DY9o5alQZ6vTDWCWdGSQa8FO8tHlCECDPRm0or1K2hNDUWm6EYey64vCn3kw4vlCiBBQUZ8ngmt+YLWx6dQ3Ngk1ZxFPxfAJFRPOymRmExKXSLwTC9hb382JvS1O6nrCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zxd9HhTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zxd9HhTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF3CC4CEF1;
	Wed, 28 Jan 2026 16:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616124;
	bh=jiULuhU/afeYb0N0Ff9BfYrWy8aqZHyGbWBTJUwhAuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zxd9HhTB1Px/ciuCsj9Q/4PMThm/eKP9PLsFvBd0wZO9VZm8UblIsb4Yq6UTQIthu
	 3fU22G2JiobvQGSD1lNqw3gH5OLi1MdwFf3ffYZFdYnvoLG4B1aKATd4D7w1nWrlch
	 BkeUa/BWw6G6gWOnC9wzzRz7AyflxAt5at1YwBjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 214/227] drm/xe: Adjust page count tracepoints in shrinker
Date: Wed, 28 Jan 2026 16:24:19 +0100
Message-ID: <20260128145352.135359598@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit ca9e5115e870b9a531deb02752055a8a587904e3 upstream.

Page accounting can change via the shrinker without calling
xe_ttm_tt_unpopulate(), which normally updates page count tracepoints
through update_global_total_pages. Add a call to
update_global_total_pages when the shrinker successfully shrinks a BO.

v2:
 - Don't adjust global accounting when pinning (Stuart)

Cc: stable@vger.kernel.org
Fixes: ce3d39fae3d3 ("drm/xe/bo: add GPU memory trace points")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://patch.msgid.link/20260107205732.2267541-1-matthew.brost@intel.com
(cherry picked from commit cc54eabdfbf0c5b6638edc50002cfafac1f1e18b)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1008,6 +1008,7 @@ static long xe_bo_shrink_purge(struct tt
 			       unsigned long *scanned)
 {
 	struct xe_device *xe = ttm_to_xe_device(bo->bdev);
+	struct ttm_tt *tt = bo->ttm;
 	long lret;
 
 	/* Fake move to system, without copying data. */
@@ -1032,8 +1033,10 @@ static long xe_bo_shrink_purge(struct tt
 			      .writeback = false,
 			      .allow_move = false});
 
-	if (lret > 0)
+	if (lret > 0) {
 		xe_ttm_tt_account_subtract(xe, bo->ttm);
+		update_global_total_pages(bo->bdev, -(long)tt->num_pages);
+	}
 
 	return lret;
 }
@@ -1119,8 +1122,10 @@ long xe_bo_shrink(struct ttm_operation_c
 	if (needs_rpm)
 		xe_pm_runtime_put(xe);
 
-	if (lret > 0)
+	if (lret > 0) {
 		xe_ttm_tt_account_subtract(xe, tt);
+		update_global_total_pages(bo->bdev, -(long)tt->num_pages);
+	}
 
 out_unref:
 	xe_bo_put(xe_bo);


