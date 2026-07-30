Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D026C43B6D1;
	Thu, 30 Jul 2026 14:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422640; cv=none; b=rlno2qeFzW+L14PCnyVaYwz+6CiE/1WcgrSc9B6S85EkhM8vEC81TMMwb4tdHNcbf4s0LBh2JICxlarZRQh30gsQC7d6WWx8s5LKchy0XSl/S25W50Wxlzv58MoNuxDo4b/3wv5tFPwV4ZIWiR27K//vqLVGKBHKvGGltGi7CX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422640; c=relaxed/simple;
	bh=3OxUY1419+t94/+XUh1iTSkE6J25KLQ9QXBm98b+nzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuiWMDqNZTqkjeRcDcqDcAXAqx0cHCOqgQ0tZ5fAgrZhlWfHP3/wdxyuKyqJQu+o8SjnWSFq+75GMaais/zC8u26HL90rsILecJ3GLgke9cALLaGiNB2JLD4AguAJt2+dWFFNDaUAXnVyb5ZenphhmCDBEeWv+9d0ZRYjKOPgpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4qr6hol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4qr6hol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF48B1F000E9;
	Thu, 30 Jul 2026 14:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422638;
	bh=ZbKX3FDKNgDx2RcjYEFDB9Ie/GUN1z7Wf/tkTsH/uWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4qr6holIbQg13VrGGzyHYZ6+VIdxzlbx4KFlhVlMJyfuPNlugaRaK/bnlr3n3dHt
	 tD7QrnE6mjR47+w9VhWXm+L6ih/m9O/gCFWdPjqHucZqDH+GUq8Icb2rf1cwsqA1+3
	 Or3/A+XptvDY9Vz8dzi/d5ZTvExmzpjCIUhuQD8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 7.1 463/744] drm/amd/display: Fix flip-done timeouts on mode1 reset
Date: Thu, 30 Jul 2026 16:12:16 +0200
Message-ID: <20260730141454.137155560@linuxfoundation.org>
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
@@ -314,10 +314,19 @@ static inline int amdgpu_dm_crtc_set_vbl
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


