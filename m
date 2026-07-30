Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0310D43C7C4;
	Thu, 30 Jul 2026 14:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422533; cv=none; b=LPiisdjgwyiM5fx7ne+AiX5gOXOBpepjFfv+hERPZtJK0QIh9OnEBVZC5tc/7R892WdvgydOvaEUOnmO13MS+yGsiCFf6y80weLWZroa2x/80pWBkZOr+x6fAUsWkH+OA9kV2McZow5LRUW1R3Rf1lUqmJUpx6Gmi2wAd+vPbyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422533; c=relaxed/simple;
	bh=FL0u0ZCHNcEnjzLRepaE67RA5sy0pHB4QJehNq9oYWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmTTOtPWbkr2br3Gaw/eGbKMtDR3kXQt9xRh/lXk+WJQoMEA4l9Ms/wulhtdqY2JsQWHUfFUut76S6Eis6MCqLtRQq3w3efvFaU3yryF5uvKHYtDW/45M4TXNO3rVc+yK28fbJPazJ5FJSLfJiK7P6YnCNA5cYlKD0b7OWulcGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnp1sIUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnp1sIUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A5D1F000E9;
	Thu, 30 Jul 2026 14:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422531;
	bh=VCratDyy1xP4dkCwpsrVPpWTNiNImVpOoSZxNnNPGuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnp1sIUpZpwSkilGNVc1plS0/svWkmb3KJqRt1OecdWTvMAByRo7kHsVJgRGR6p+k
	 ioA/0u8lXqOH3udrHZOrBJNsLdT7/Q+QsB2mQZbSY/RI54JtTGENTrXnRLxMd2OKU/
	 NSSstXZuFNdXFqXlhHYcE1Lx3BIWtWl6f1AnFfsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Subject: [PATCH 7.1 472/744] drm/gpusvm: Fix MM reference leak in drm_gpusvm_range_evict
Date: Thu, 30 Jul 2026 16:12:25 +0200
Message-ID: <20260730141454.328345841@linuxfoundation.org>
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

commit 847b371debf3c8c72384ab7b9a0c4123a74cc925 upstream.

If kvmalloc_array() fails in drm_gpusvm_range_evict(), the MM
reference acquired earlier is not released, resulting in a reference
leak.

Fix this by dropping the MM reference on the kvmalloc_array()
failure path.

Fixes: 99624bdff867 ("drm/gpusvm: Add support for GPU Shared Virtual Memory")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patch.msgid.link/20260714170025.3487974-1-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gpusvm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1704,8 +1704,10 @@ int drm_gpusvm_range_evict(struct drm_gp
 		return -EFAULT;
 
 	pfns = kvmalloc_array(npages, sizeof(*pfns), GFP_KERNEL);
-	if (!pfns)
+	if (!pfns) {
+		mmput(mm);
 		return -ENOMEM;
+	}
 
 	hmm_range.hmm_pfns = pfns;
 	while (!time_after(jiffies, timeout)) {


