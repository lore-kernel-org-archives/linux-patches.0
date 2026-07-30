Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8435930C618;
	Thu, 30 Jul 2026 15:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424419; cv=none; b=kV48QTReETVuY2/wUxqM39HElRciofvdi0fUIG999R6s3d5RC6fBc0IIDH7FWgm4dPqDU1Fyrp5xstBJxUjKfWPHUtud+tIQ3bH3WfEY20tAy7dnRym5V1Y4g9/JgiS2AsTNQXUhRrotNDX3LS3kupooIjPYLKxlNLb9DzL/Kus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424419; c=relaxed/simple;
	bh=XCpQZqItcD+rkAgKq+q81/I51kugmzzqaFUnbWJfL4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIXb8EsTMFEcZfnbV3MQBz8m9fmhmV0vSFYX5PpzXqOxuol3WZtDkrgray9IgORzhHg+qvrVbjMXde0HPjvHP0rFvZIvz50yX3pdKYkaSfxSlSW6DXi5CGYHmfbw3RVh79Ry94Xm/BQFLWt65z7w1FfQAH8uDVGTdUlYx5h1JgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b66quxm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b66quxm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFCB1F000E9;
	Thu, 30 Jul 2026 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424418;
	bh=d8H+MIBbChQlEfdI81zK0TjU2krxSrhzBCkw6siR+To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b66quxm2vqrOVxwgJtHkvAvT9EZSlFzpvDvB3kcgZr6fyz0qf0OP/k8dxPv5+gAJ0
	 ugg7gBWaNl7W1StH9BaRMU6KDTQ9rSi2/B4xXRWIoZBz5qmLjihhIrcRlsQ7f9TYuO
	 a5gsaHtMhIsDV7/7dNb01E92fxfNorbHVVIlmALM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.18 387/675] drm/amd/display: Fix flip-done timeouts on mode1 reset
Date: Thu, 30 Jul 2026 16:11:57 +0200
Message-ID: <20260730141453.360532876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Leo Li <sunpeng.li@amd.com>

commit 82730dba0cf9d9524af0ceeb7eb6b5c3ab1bdb87 upstream.

The vblank on/off callbacks mixed use of amdgpu_irq_get/put() and
amdgpu_dm_crtc_set_vupdate_irq() to enable and disable IRQs.

With get/put, base driver will callback into DC to disable IRQs when
refcount == 0. With set_vupdate_irq(), DC is called directly to disable
IRQs, bypassing base driver's refcount tracking.

During gpu reset, base driver can restore IRQs via
amdgpu_irq_gpu_reset_resume_helper() > amdgpu_irq_update(). So if
get/put() is not used (i.e. refcount == 0), then vupdate_irq will be
disabled.

This is problematic if DRM requests vblank on before amdgpu_irq_update()
is called: drm_vblank_on() > set_vupdate_irq() enables vupdate_irq, but
the refcount is still 0. gpu_reset_resume_helper() > irq_update() then
immediately disables it, thus leading to flip done timeouts.

This is made worse on DCN since VUPDATE_NO_LOCK is the only IRQ enabled.
Prior to 8382cd234981, a combination of GRPH_FLIP and VSTARTUP IRQs were
used, and they used get/put(). This explains why 8382cd234981 exposed
this issue.

Fix by using get/put() instead of set_vupdate_irq(). DCE is unchanged,
since it relies on unbalanced enable/disable calls based on VRR status,
and hence requires direct set_vupdate_irq(). Plus, it also uses
GRPH_FLIP and VLINE IRQs, which are properly tracked by get/put().

Cc: stable@vger.kernel.org
Fixes: 8382cd234981 ("drm/amd/display: consolidate DCN vblank/flip handling onto vupdate_no_lock")
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260723180159.52121-1-sunpeng.li@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -333,10 +333,19 @@ static inline int amdgpu_dm_crtc_set_vbl
 	 * is enabled. On DCE, vupdate is only needed in VRR mode.
 	 */
 	if (amdgpu_ip_version(adev, DCE_HWIP, 0) != 0) {
-		rc = amdgpu_dm_crtc_set_vupdate_irq(crtc, enable);
+		if (enable) {
+			rc = amdgpu_irq_get(adev, &adev->vupdate_irq, irq_type);
+			drm_dbg_vbl(crtc->dev, "Get vupdate_irq ret=%d\n", rc);
+		} else {
+			rc = amdgpu_irq_put(adev, &adev->vupdate_irq, irq_type);
+			drm_dbg_vbl(crtc->dev, "Put vupdate_irq ret=%d\n", rc);
+		}
 	} else if (dc_supports_vrr(dm->dc->ctx->dce_version)) {
 		if (enable) {
-			/* vblank irq on -> Only need vupdate irq in vrr mode */
+			/* vblank irq on -> Only need vupdate irq in vrr mode
+			 * Not ref-counted since we need explicit enable/disable
+			 * for DCE VRR handling
+			 */
 			if (amdgpu_dm_crtc_vrr_active(acrtc_state))
 				rc = amdgpu_dm_crtc_set_vupdate_irq(crtc, true);
 		} else {


