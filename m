Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D305435BDAA;
	Thu, 30 Jul 2026 14:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422264; cv=none; b=fO6bBQ9fUpKXsBNdaQATKUUvpetE35QTzWLK+U+tF6Ns7s4iBw1USN+ANpF1wmZdcveFsB7EDkP8yJd4rN4SFTL/bnnvR/AB4uuRrg0VA8hrQUqBpMSkvr4TJ+ivHCPTj6C+dcjWx1QepEnz6TtVBa9SwFF+PpWoKF9qu5HMIKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422264; c=relaxed/simple;
	bh=F5at1Myw7E6SsOMgnLGqsnpcy8AtBxj8OtE4nrFL0bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrNCME8cAEgJiqkNPy7oxQeVzN3H/oZWbeXu32A53mNc6mq4kSDtZk8DY2mLI2QdauERmZdV8X/3XRhKnZOh6hRq7hh7ZFowBlDyzRNdfI7rx8GEP2KN273alkxVEpaLYZ4/3md0jfENAs/bPwXlkHvv0ubHBoAwN9JYV1U4+wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNZUFFEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNZUFFEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4E41F000E9;
	Thu, 30 Jul 2026 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422262;
	bh=rO5ZrFYdpkXTIq6xkLaQt0CUN9KdL6hXG40Ope7Vyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FNZUFFEW2veZYwdLFzKoXi2sLOsf+NZ7iySycqRFRrAepEYMDoyTBFNZcIP0piECA
	 3Xfzm7Z1Thq8uA/b9XqXLDvVH0IMOzXxJOtIZdoG+Dkl3M3X+rg77APife1p6Dtm0z
	 QdaHydI3V7U+rDeoFVsExo0lflweEy0XxZgm07H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 7.1 380/744] drm/xe/guc: Fix buffer overflow in steered register list allocation
Date: Thu, 30 Jul 2026 16:10:53 +0200
Message-ID: <20260730141452.363531620@linuxfoundation.org>
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

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

commit 632ecc90e1ca5d3b6822bb4d08f84a175b6c42c0 upstream.

The size calculation for the steered register extarray uses only the
geometry DSS mask (g_dss_mask) to determine the number of entries to
allocate:

  total = bitmap_weight(gt->fuse_topo.g_dss_mask, ...) * steer_reg_num;

However, the filling loop uses for_each_dss_steering(), which iterates
over for_each_dss(), defined as the union of g_dss_mask and c_dss_mask
(geometry + compute DSS). On platforms with compute-only DSS bits, the
loop writes past the allocated buffer, corrupting adjacent slab objects.

This manifests as list_del corruption and SLUB redzone overwrites during
drm_managed_release on device unbind, since the overflow corrupts the
drmres list_head of neighboring allocations.

Fix by computing the allocation size using the union of both DSS masks,
matching the iteration pattern of for_each_dss_steering().

--
v2:
- use bitmap_weighted_or() (Zhanjun)

Fixes: b170d696c1e2 ("drm/xe/guc: Add XE_LP steered register lists")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/8049
Cc: Zhanjun Dong <zhanjun.dong@intel.com>
Cc: stable@vger.kernel.org
Assisted-by: GitHub-Copilot:claude-opus-4.6
Reviewed-by: Zhanjun Dong <zhanjun.dong@intel.com>
Link: https://patch.msgid.link/20260612070401.543305-2-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 0a78a44f4901aa6c9263e66be7fce02282f1109f)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_capture.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_capture.c
+++ b/drivers/gpu/drm/xe/xe_guc_capture.c
@@ -461,8 +461,14 @@ static void guc_capture_alloc_steered_li
 	if (!list || guc->capture->extlists)
 		return;
 
-	total = bitmap_weight(gt->fuse_topo.g_dss_mask, sizeof(gt->fuse_topo.g_dss_mask) * 8) *
-		guc_capture_get_steer_reg_num(guc_to_xe(guc));
+	{
+		xe_dss_mask_t all_dss;
+
+		total = bitmap_weighted_or(all_dss, gt->fuse_topo.g_dss_mask,
+					   gt->fuse_topo.c_dss_mask,
+					   XE_MAX_DSS_FUSE_BITS) *
+			guc_capture_get_steer_reg_num(guc_to_xe(guc));
+	}
 
 	if (!total)
 		return;


