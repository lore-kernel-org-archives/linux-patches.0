Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE44733F5B4;
	Thu, 28 May 2026 20:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999275; cv=none; b=HG1kzPv4qoivyAboVwJ2OfMPziG8E2WZaWy0seHOWy0y8LbNbqERnhsfY145WhNUaazvLcOy9JirUq4tHm0LLXatev1XmUbmn8KgO7+2LAPY2WjVv6IIVkmA4ou2YgaI861U9Ha2YYHWCFR+L/WK0ycDX+Wg2sPYBlyfZM2k6eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999275; c=relaxed/simple;
	bh=BVn/itGRbToTIf2FCsM2nGUDZCicfVb4PVQ0cm/ykfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmFMfUEEGLBVvpxuGxLHvLIT5jxCSisiB4QuqDGjrSXFuqjXFB448mr7OOmLAMzY/HLOn9W82ORdc5e7I/WxpolOpPqoVSsx32QjN/T3rQs0ET7w3ArngZBoE/j6vF4Vpqb12qmNhTblFr5cu0+h5l9FlvRHdEHroDKj4dW+dIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqNx2vi2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqNx2vi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C2D1F000E9;
	Thu, 28 May 2026 20:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999274;
	bh=MrlwMG6hLm3X/bsdOiBItSaxkJtcbZ3VZjkAnXwNLuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqNx2vi2vCILoVnPTH6u4zgYB5l8pQBfwyra9hKge+6V4PwyhAGMa2OE3xbZefuIl
	 sI7wCrCTV4XrB8y5VdwV++22ZXc1A6BX5prS7URkB+0aapBGj/f5DNpRonzq50Z4FZ
	 QgaLlrAAUFbLKQ1EkayCIblhaObZx5KLnRR2I5R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/377] drm/xe/hdcp: Add NULL check for media_gt in intel_hdcp_gsc_check_status()
Date: Thu, 28 May 2026 21:43:59 +0200
Message-ID: <20260528194638.421602294@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Gustavo Sousa <gustavo.sousa@intel.com>

commit 60a1e131a811b68703da58fd805ab359b704ab03 upstream.

When media GT is disabled via configfs, there is no allocation for
media_gt, which is kept as NULL.  In such scenario,
intel_hdcp_gsc_check_status() results in a kernel pagefault error due to
&gt->uc.gsc being evaluated as an invalid memory address.

Fix that by introducing a NULL check on media_gt and bailing out early
if so.

While at it, also drop the NULL check for gsc, since it can't be NULL if
media_gt is not NULL.

v2:
  - Get address for gsc only after checking that gt is not NULL.
    (Shuicheng)
  - Drop the NULL check for gsc. (Shuicheng)
v3:
  - Add "Fixes" and "Cc: <stable...>" tags. (Matt)

Fixes: 4af50beb4e0f ("drm/xe: Use gsc_proxy_init_done to check proxy status")
Cc: <stable@vger.kernel.org> # v6.10+
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260416-check-for-null-media_gt-in-intel_hdcp_gsc_check_status-v2-1-9adb9fd3b621@intel.com
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
(cherry picked from commit bfaf87e84ca3ca3f6e275f9ae56da47a8b55ffd1)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_hdcp_gsc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
index 4ae847b628e23..6324f526dcfab 100644
--- a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
+++ b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
@@ -35,11 +35,19 @@ bool intel_hdcp_gsc_check_status(struct drm_device *drm)
 	struct xe_device *xe = to_xe_device(drm);
 	struct xe_tile *tile = xe_device_get_root_tile(xe);
 	struct xe_gt *gt = tile->media_gt;
-	struct xe_gsc *gsc = &gt->uc.gsc;
+	struct xe_gsc *gsc;
 	bool ret = true;
 	unsigned int fw_ref;
 
-	if (!gsc || !xe_uc_fw_is_enabled(&gsc->fw)) {
+	if (!gt) {
+		drm_dbg_kms(&xe->drm,
+			    "not checking GSC status for HDCP2.x: media GT not present or disabled\n");
+		return false;
+	}
+
+	gsc = &gt->uc.gsc;
+
+	if (!xe_uc_fw_is_enabled(&gsc->fw)) {
 		drm_dbg_kms(&xe->drm,
 			    "GSC Components not ready for HDCP2.x\n");
 		return false;
-- 
2.53.0



