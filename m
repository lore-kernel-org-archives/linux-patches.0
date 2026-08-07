Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355DD46D0B0;
	Fri,  7 Aug 2026 15:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115674; cv=none; b=TiTv37ZkLvHUly+jZw9unNa5OJxE6roR6sbCLxLOXJZRp+qLctFkd+DIQ6PFD2ATItN3WcU3r8cqTQwQ0k30awJVHxDMmgaLQ6yoBln1CqDxECwF3Hv3kYBJ6CJpOFCvFyWBdTXDlwW7ExlnYnGucvaNQOX/uVyiHJJwkum2EyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115674; c=relaxed/simple;
	bh=H3HNkzBBZ115MwH+Gqqd3PGuWTvUsMCek39akB1jOys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGVehOou4GxqruXocjN5UIB8ucS/CAbXpZyd6CDBK8FQbngDl/0WJ60saWvW/SX6koieiSCX331+TXbjNM3nGAIDTNQKpDGWCZa2md96KH1uEsXFlQToXGqxo4XpNUhWCwca2RZT3QT/HXDhRcwL6Z4Chz4xQ1U2DX5+GLMm9tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khNa/5JW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khNa/5JW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D551F000E9;
	Fri,  7 Aug 2026 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115673;
	bh=x7vXA67tDmBrgAPsex5lNdCTuQcRajP3CsqyfE9ctx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khNa/5JW5EyjFhot7zn0qXd4dSmIq2m5Xgrfk//diRmXE4nzyEyuxd+A6tfqaREwn
	 RDsCZPC824JGk3p56QcruuBlPFBjKrIyqbsP5l5CSni3nJxaDEpYcqYUQznmh22x6f
	 rANm1f/FTCwZzHrIVfTwViECuB+yw/obK3clDB9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.18 332/396] drm/vmwgfx: clamp dirty-page range with min, not max
Date: Fri,  7 Aug 2026 16:38:12 +0200
Message-ID: <20260807143431.450931322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


