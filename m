Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1623E7BCC;
	Fri, 15 May 2026 16:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862531; cv=none; b=M3p/UCoO6SP+/umnJXtYdnZzZd+PU3FyzQ+JEMhpla0RwUoqeaYjfqxRGqxeQQDZDgNPJgpLcJtPiSvzqvP5gaXzb74ByKq7iQ7Tvf5XmOfKx7I1Mdw4mDudP5hqTAod+z3s+/hGj8doQkHH0jhPjRYEA+4JJFP1Yu+XGqNKGL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862531; c=relaxed/simple;
	bh=VluOG8gkyTo8POAhtczhTeB03+9jCcAou7+sXfMmRpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTXd91SL7a/raNzbgINvxTo8d64Y2qf1lm/alQh3apyeaobZ2bgbuye7S7RSDIKAR0DFrqf+AybtAQs2e5h2H30OaD375Gl/ORnl7ChM+gbBQcJD7ji/LH8eFa4V/q3wj5dm4KorhlLF4aPFFGiYIOjHq7iWioCcpmk5+NKAtVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2v6Gxz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2v6Gxz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D22C2BCB0;
	Fri, 15 May 2026 16:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862531;
	bh=VluOG8gkyTo8POAhtczhTeB03+9jCcAou7+sXfMmRpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2v6Gxz5+b/N6UYgMHuitiCFmEs/60NoNJvDIKCQjRAaXF4av442/WbZHjd6UaVAK
	 7/gUKdigS3SBRofFZuW/QDDuEJ37yZIpFz4JgpuUqoJevsjIf8GCHsPYrnEgZgtBa1
	 s/JDhcB36d6LTZ4jBYPHkJDLoR4mP32GQG8dbKxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 7.0 082/201] drm/xe/hdcp: Add NULL check for media_gt in intel_hdcp_gsc_check_status()
Date: Fri, 15 May 2026 17:48:20 +0200
Message-ID: <20260515154700.307193818@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/display/xe_hdcp_gsc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
+++ b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
@@ -37,9 +37,17 @@ static bool intel_hdcp_gsc_check_status(
 	struct xe_device *xe = to_xe_device(drm);
 	struct xe_tile *tile = xe_device_get_root_tile(xe);
 	struct xe_gt *gt = tile->media_gt;
-	struct xe_gsc *gsc = &gt->uc.gsc;
+	struct xe_gsc *gsc;
 
-	if (!gsc || !xe_uc_fw_is_available(&gsc->fw)) {
+	if (!gt) {
+		drm_dbg_kms(&xe->drm,
+			    "not checking GSC status for HDCP2.x: media GT not present or disabled\n");
+		return false;
+	}
+
+	gsc = &gt->uc.gsc;
+
+	if (!xe_uc_fw_is_available(&gsc->fw)) {
 		drm_dbg_kms(&xe->drm,
 			    "GSC Components not ready for HDCP2.x\n");
 		return false;


