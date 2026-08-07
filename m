Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C9E472771;
	Fri,  7 Aug 2026 15:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117693; cv=none; b=TJF4tdkyiupCUKQH2vKioX+eejqIkvUdg1WGduPuMfbv1xd/oQOeYxlESKXzLQJxPbYcXjaRBgmVJDfIF4SMn9AbDcIF7BIArdhu+FqwhBrKq8nO3FVflpNg8o5p7pn7JJhl8qSYrAzuy+yctavjQkteV2c2lDLhjaDZlew+jqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117693; c=relaxed/simple;
	bh=Bi/Gt51bPO5qymL2Uy/S41KcWEPIW15uJfRfksPaJ0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plqcX2vZAgeXwiMoUJ5ptGX/X4MLxaplqnxj/qodSznzMMb/SbE1GyWYwMETgP/WX9SadK49DIgR0G28kxbh2LLagFZUlD/Xkz6uOf8dTcoVn7M94uugdiqEJ9Ecjq1b4X3H8atVTdV3ArMj8nY7HGEjJ73yddcPUFdYoz5vcYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aYgvXs4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aYgvXs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592A91F000E9;
	Fri,  7 Aug 2026 15:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117691;
	bh=S1IpGyl1oj4HTykcRhm0sRLp7S53R8Hc8l8WXpuO/fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aYgvXs4DIh5Ieo77Sem8bULuqIYJFv6ZZ5splsqZjL1Zekzpwkq9DjlHrOflatV1
	 kHRPpA73Gdo4BY0kPehoMREcKO+eHii7ET8xRoQBASuA9drrcnCVG0V7q2cWbxeMhR
	 3YBsXtSbvy3t6AbyMPMyiiLk+gijECS9T+UIhYZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 7.1 409/438] drm/vmwgfx: clamp dirty-page range with min, not max
Date: Fri,  7 Aug 2026 16:40:05 +0200
Message-ID: <20260807143436.685789005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

commit f47d542d5912f236273399d7139b522f6950e2e4 upstream.

vmw_bo_dirty_transfer_to_res() and vmw_bo_dirty_clear() compute the
intersection of a resource's page range with the BO's tracked dirty
range, but clamp res_end against dirty->end with max() instead of
min().  When dirty->end exceeds the resource end, the loop walks past
the resource's pages, calls vmw_resource_dirty_update() for ranges
owned by other resources sharing the same backing MOB and clears
their pending dirty bits via bitmap_clear().  The result is silent
loss of writeback for unrelated resources whenever two resources
share a MOB.

Use min() in both functions so the loop is bounded to the
intersection of the resource and dirty ranges.

Fixes: b7468b15d271 ("drm/vmwgfx: Implement an infrastructure for write-coherent resources")
Fixes: 965544150d1c ("drm/vmwgfx: Refactor cursor handling")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-4-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
@@ -311,7 +311,7 @@ void vmw_bo_dirty_transfer_to_res(struct
 		return;
 
 	cur = max(res_start, dirty->start);
-	res_end = max(res_end, dirty->end);
+	res_end = min(res_end, dirty->end);
 	while (cur < res_end) {
 		unsigned long num;
 
@@ -347,7 +347,7 @@ void vmw_bo_dirty_clear(struct vmw_bo *v
 		return;
 
 	cur = max(res_start, dirty->start);
-	res_end = max(res_end, dirty->end);
+	res_end = min(res_end, dirty->end);
 	while (cur < res_end) {
 		unsigned long num;
 


