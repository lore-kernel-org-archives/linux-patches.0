Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA7233B6FC;
	Thu, 28 May 2026 20:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000350; cv=none; b=a/vI4UZmDwLFTq/VfC00q+TMZbLQxhYytyAOHD8ou1ChLHrnKGytirfSHr9GdqdTn34WEoTcM2zgAyy4JNzd9C9NZRPCCJNefRP7SUzpTW8OGWlw5qNuM3xVK5wUj8bpjI0gfRDsZmNFzc0dgZgA/uZc2x9Mmcgosuh3gJt5BPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000350; c=relaxed/simple;
	bh=r5gdkHCaCdPKXjQaaJ15XaMsP+srt00TlG8o+NIjjsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKim2JcDs1IagwT8d4VWGdeMxXaXJXJmu841+BtmTicpVuHEvMdhhclG8vRP2oQUVhxcm1PNsV2ERxESV92qr64nfViJ/a1w06tfNk8RKabyrjNbLj8wg7HQtUnNwnLBOE3ect9wUcooY2lp1KmJ3HghFBqesBgpnjirn05AiFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9uqfyF7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9uqfyF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63FF1F000E9;
	Thu, 28 May 2026 20:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000349;
	bh=ubAfmvK40HAXnzA0DecTsiPi/oWu/uFPSgvM4Qm/5io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9uqfyF7GSsuvAQlc8qJAaZ4giA0AAcHGvZvcvAvkcCFo9eljYH9sgs6LmiRjNus/
	 wXJ/Rx8aTkgyAwoj+bQRek7cexNdcE6TuCuIscuBAxeV2XzxoHOad6OBqDlI64Ies2
	 Ic6Lq88LdGp2ILRgNnbGxu1tKb/Dkaiq2RbEfB6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/272] drm/xe/hdcp: Add NULL check for media_gt in intel_hdcp_gsc_check_status()
Date: Thu, 28 May 2026 21:46:20 +0200
Message-ID: <20260528194629.559857877@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_hdcp_gsc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
index f4332f06b6c80..695d625c83ee6 100644
--- a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
+++ b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
@@ -39,10 +39,18 @@ bool intel_hdcp_gsc_check_status(struct xe_device *xe)
 {
 	struct xe_tile *tile = xe_device_get_root_tile(xe);
 	struct xe_gt *gt = tile->media_gt;
-	struct xe_gsc *gsc = &gt->uc.gsc;
+	struct xe_gsc *gsc;
 	bool ret = true;
 
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



