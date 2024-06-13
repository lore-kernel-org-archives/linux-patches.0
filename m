Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7BE142911;
	Thu, 13 Jun 2024 11:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279242; cv=none; b=o5g4SEB86CuE6rrF//xKT/PVqbtDLG14AwnH6e6aAaeBG7pVGnHzqNrsrSVCZavKARNhb0k1sDD83Pm1zACdVWPeE6ZfRe41AAr/jXMI8wPB/g0SSNYkQlrQliBi5jTX/+k+H6sOkVU/Klq1AKPDawiAbAxlOavbGr1PkCuVDIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279242; c=relaxed/simple;
	bh=IMz131Mufr/t7m/cTvW2pigY4ZvLl1HToqobj+bwTRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6QPGmkuim+dO76J2oTjc4OcSM3L5v4T1tL24si0Wlu004V5GZBLcGKreQ4S+Zt6mI1+Pd/gPaLazgggDVrY2i6V4p0fWUfuPdjwlDscO/hgLAB1FnHYa5lsWxIoKSTxo/IKow/VSNk5XcmtRgnalwcm/j90NYgEQPtcWj6F43o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q94lAQze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q94lAQze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241A2C2BBFC;
	Thu, 13 Jun 2024 11:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279242;
	bh=IMz131Mufr/t7m/cTvW2pigY4ZvLl1HToqobj+bwTRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q94lAQzegtq1+NoA/HlazVK2tOZEFozOZWTt7tZUlIe4kk6kvL9fhQdZFAN4VUiC2
	 xwdmp1YP0zHkcfU3kisJB9hTKPL8eRQG4zADfLjoJznhYOz6+uJ5XNs1WdEqnN7JDv
	 qrev/543luClDTIMj6Ft1mqYbtj/3gFcmFaE7oZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>
Subject: [PATCH 6.9 010/157] drm/xe/bb: assert width in xe_bb_create_job()
Date: Thu, 13 Jun 2024 13:32:15 +0200
Message-ID: <20240613113227.801142631@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 1008368e1c7e36bdec01b3cce1e76606dc3ad46f upstream.

The queue width will determine the number of batch buffer emitted into
the ring. In the case of xe_bb_create_job() we pass exactly one batch
address, therefore add an assert for the width to make sure we don't go
out of bounds. While here also convert to the helper to determine if the
queue is migration based.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240320112730.219854-3-matthew.auld@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_bb.c
+++ b/drivers/gpu/drm/xe/xe_bb.c
@@ -96,7 +96,8 @@ struct xe_sched_job *xe_bb_create_job(st
 {
 	u64 addr = xe_sa_bo_gpu_addr(bb->bo);
 
-	xe_gt_assert(q->gt, !(q->vm && q->vm->flags & XE_VM_FLAG_MIGRATION));
+	xe_gt_assert(q->gt, !xe_sched_job_is_migration(q));
+	xe_gt_assert(q->gt, q->width == 1);
 	return __xe_bb_create_job(q, bb, &addr);
 }
 


