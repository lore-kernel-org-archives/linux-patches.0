Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCE02E9EBC;
	Tue, 30 Sep 2025 15:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244806; cv=none; b=RS1DBxiMSu9rgc11LrQJjsEKRvw14N00jkbELfviJYy2/joXdg+yZgnoKhyEqFMW0d/DIHvaAqLPO/QGU4fUskuZmI5Onc4YmKd6/d43p/7gMbdEnuwCsryDHvpg5N3l4aBscua4uHOWXwirvsZTuVjdqLxedVYug+hXnnFLHj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244806; c=relaxed/simple;
	bh=3UUwXsiwzQRw+GSbrj93YSdcG+wNN85Qticsa/eOlo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ndY7aFPN6F0ghVyg5RjiY+WMykGJYZ5QvqjhiJGprZoH9+7d4pzNOMEsR1LXZawv+N6cFk//ABZOxh+C2RrEawjk8xaOknqsRJkgsSeIq6ZDY6qYoBk1uCUJFaNkGAKGmCHam67nYVbquKazuEnEh52rjajk1LeWmuKPqql+KaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFZP7Qgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFZP7Qgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF020C4CEF0;
	Tue, 30 Sep 2025 15:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244806;
	bh=3UUwXsiwzQRw+GSbrj93YSdcG+wNN85Qticsa/eOlo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFZP7Qgpi5q1UThofRXqQVjX7+amXDJz5SF66cNWwN28v83ygqPnHs2Ju2fqmCHRK
	 q8qZ9ZUMLOvEw3ADSD5eKDiyDWGYhsLLD/7FnOeM2LpoCY3g7OowquO8WEuy9Z9oAf
	 QtxJKXYDEhibE6craGm+WHjT1lH2JouMJX8yz5ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.16 118/143] drm/xe: Dont copy pinned kernel bos twice on suspend
Date: Tue, 30 Sep 2025 16:47:22 +0200
Message-ID: <20250930143835.932042624@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 77c8ede611c6a70a95f7b15648551d0121b40d6c upstream.

We were copying the bo content the bos on the list
"xe->pinned.late.kernel_bo_present" twice on suspend.

Presumingly the intent is to copy the pinned external bos on
the first pass.

This is harmless since we (currently) should have no pinned
external bos needing copy since
a) exernal system bos don't have compressed content,
b) We do not (yet) allow pinning of VRAM bos.

Still, fix this up so that we copy pinned external bos on
the first pass. We're about to allow bos pinned in VRAM.

Fixes: c6a4d46ec1d7 ("drm/xe: evict user memory in PM notifier")
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v6.16+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250918092207.54472-2-thomas.hellstrom@linux.intel.com
(cherry picked from commit 9e69bafece43dcefec864f00b3ec7e088aa7fcbc)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo_evict.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo_evict.c b/drivers/gpu/drm/xe/xe_bo_evict.c
index 7484ce55a303..d5dbc51e8612 100644
--- a/drivers/gpu/drm/xe/xe_bo_evict.c
+++ b/drivers/gpu/drm/xe/xe_bo_evict.c
@@ -158,8 +158,8 @@ int xe_bo_evict_all(struct xe_device *xe)
 	if (ret)
 		return ret;
 
-	ret = xe_bo_apply_to_pinned(xe, &xe->pinned.late.kernel_bo_present,
-				    &xe->pinned.late.evicted, xe_bo_evict_pinned);
+	ret = xe_bo_apply_to_pinned(xe, &xe->pinned.late.external,
+				    &xe->pinned.late.external, xe_bo_evict_pinned);
 
 	if (!ret)
 		ret = xe_bo_apply_to_pinned(xe, &xe->pinned.late.kernel_bo_present,
-- 
2.51.0



