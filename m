Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BDE372EED;
	Fri,  7 Aug 2026 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115762; cv=none; b=nGZCH3QZWSB3g1yPaD2scvkGISz6j14kpGqOe9kXGvdEUESS0HLmp4SjXpGjMWYsz6+rXJUblipQ7C1VQXrfzG6mxAC8REq7sKd47Bk8Po4t97nW/leWL/aHRS6jHfQ5X857g1aeTJbkqsP/cllYvdmdesPM4AAOeGm+NCuEv58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115762; c=relaxed/simple;
	bh=HfiKG8LIZRSedPbs6RWcW6AWW6DTbPHCn7Svu8yWsew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgCnAEhOcIGxQLpeyfCUE8zKpM3aLcS2gtxfU2cxaiiO/BEpi3zV3DUWnIBR5uyVzDWnzbP59mxlofdbGAHXJq1TyKYtQ0ysK7nxHK3+0O4LUof0uVMRoKrixTgiQaPWGffbd7EZIyKSmQsT+a5AcjmAH4FpNy4AoKkUtWB8OKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6fd9YZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6fd9YZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62571F000E9;
	Fri,  7 Aug 2026 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115761;
	bh=QcbbIWZ+Qms3sIGTCuVhTvRe5bLZGXIg7RjGsJQslek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6fd9YZhY3dlV66nABwcxd9PJCybsIXvTrL8vvlovZ2TjCOpL7XUcN2B75EVQ/YM0
	 nSiVYmevuzjvAEqBPgx8elxlQ4Dq3SkNmGjJDStDmBh2eWM74ngvmt3SxKHyl8j2UG
	 jaN71dCv3XEojAAqjuqxWvYCBsGN3oiTfzBoDndI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 376/396] drm/xe/guc: Fix buffer overflow in steered register list allocation
Date: Fri,  7 Aug 2026 16:38:56 +0200
Message-ID: <20260807143432.393615704@linuxfoundation.org>
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

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 632ecc90e1ca5d3b6822bb4d08f84a175b6c42c0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_capture.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_capture.c
+++ b/drivers/gpu/drm/xe/xe_guc_capture.c
@@ -437,8 +437,15 @@ static void guc_capture_alloc_steered_li
 	if (!list || guc->capture->extlists)
 		return;
 
-	total = bitmap_weight(gt->fuse_topo.g_dss_mask, sizeof(gt->fuse_topo.g_dss_mask) * 8) *
-		guc_capture_get_steer_reg_num(guc_to_xe(guc));
+	{
+		xe_dss_mask_t all_dss;
+
+		bitmap_or(all_dss, gt->fuse_topo.g_dss_mask, gt->fuse_topo.c_dss_mask,
+			  XE_MAX_DSS_FUSE_BITS);
+
+		total = bitmap_weight(all_dss, XE_MAX_DSS_FUSE_BITS) *
+			guc_capture_get_steer_reg_num(guc_to_xe(guc));
+	}
 
 	if (!total)
 		return;


