Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DFA2E6CA4;
	Tue, 11 Nov 2025 01:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824709; cv=none; b=oy73SmFPvPKC1o930i1C2A1mvNuAmIhIA/wieNEuHWUVS52oZ+yBBfxqvtiuJXrxpHjL3m7UCZQBlf/3v0XDZlqoGflCvM1CBktbAWfsdBmpOk7NMD8hOlh/FKCg2ojzqb4EWpO+VWlppI+ZXvBPefMxKC+5mg39WllM6lMALSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824709; c=relaxed/simple;
	bh=v8hhlNAEzzFNB37lhW6lj9D3cIIpwD6ONPK915jcUF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTzUSndcwBC+MSVU0pP50q6o293ThIbGRcJqEUNr/k5d4beYzpIU+fhg3nc3DchD5fhC+YEfAZUzsQ05Jhvw1TkUvXOwzbhplxMSlpHm2BH0J12MJflyVs18q0nG5c96aNDblSDWUpIcvw4jm+fP7t+Suax7CYeq7ot2CNbgD6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ob0sNbnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ob0sNbnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D66C4CEF5;
	Tue, 11 Nov 2025 01:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824709;
	bh=v8hhlNAEzzFNB37lhW6lj9D3cIIpwD6ONPK915jcUF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ob0sNbnuVuZhit8nnPb2RnDnIybru7TIwGYDcR8xXORBPg9xzhuHhIn1s8ajXR2/X
	 bow3DmrlP9hoE6gd0O2NZ2x+HeQOojrPw5mFtMDYH2sWqqWmep1tBOdNX6teQPvZz1
	 8EPnE2tVMnHEg/396+wKRuyg9rdvOE01nZjP8HRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 555/849] drm/amd/display: Dont use non-registered VUPDATE on DCE 6
Date: Tue, 11 Nov 2025 09:42:05 +0900
Message-ID: <20251111004549.826037244@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 6cbe6e072c5d088101cd542ad8ef8541edeea5c3 ]

The VUPDATE interrupt isn't registered on DCE 6, so don't try
to use that.

This fixes a page flip timeout after sleep/resume on DCE 6.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 22 ++++++++++++-------
 .../amd/display/amdgpu_dm/amdgpu_dm_crtc.c    | 16 +++++++++-----
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3762b3c0ef983..f450bcb43c9c1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3050,14 +3050,20 @@ static void dm_gpureset_toggle_interrupts(struct amdgpu_device *adev,
 				drm_warn(adev_to_drm(adev), "Failed to %s pflip interrupts\n",
 					 enable ? "enable" : "disable");
 
-			if (enable) {
-				if (amdgpu_dm_crtc_vrr_active(to_dm_crtc_state(acrtc->base.state)))
-					rc = amdgpu_dm_crtc_set_vupdate_irq(&acrtc->base, true);
-			} else
-				rc = amdgpu_dm_crtc_set_vupdate_irq(&acrtc->base, false);
-
-			if (rc)
-				drm_warn(adev_to_drm(adev), "Failed to %sable vupdate interrupt\n", enable ? "en" : "dis");
+			if (dc_supports_vrr(adev->dm.dc->ctx->dce_version)) {
+				if (enable) {
+					if (amdgpu_dm_crtc_vrr_active(
+							to_dm_crtc_state(acrtc->base.state)))
+						rc = amdgpu_dm_crtc_set_vupdate_irq(
+							&acrtc->base, true);
+				} else
+					rc = amdgpu_dm_crtc_set_vupdate_irq(
+							&acrtc->base, false);
+
+				if (rc)
+					drm_warn(adev_to_drm(adev), "Failed to %sable vupdate interrupt\n",
+						enable ? "en" : "dis");
+			}
 
 			irq_source = IRQ_TYPE_VBLANK + acrtc->otg_inst;
 			/* During gpu-reset we disable and then enable vblank irq, so
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 80205c9bc9403..2047ac51f1b66 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -321,13 +321,17 @@ static inline int amdgpu_dm_crtc_set_vblank(struct drm_crtc *crtc, bool enable)
 			dc->config.disable_ips != DMUB_IPS_DISABLE_ALL &&
 			sr_supported && vblank->config.disable_immediate)
 			drm_crtc_vblank_restore(crtc);
+	}
 
-		/* vblank irq on -> Only need vupdate irq in vrr mode */
-		if (amdgpu_dm_crtc_vrr_active(acrtc_state))
-			rc = amdgpu_dm_crtc_set_vupdate_irq(crtc, true);
-	} else {
-		/* vblank irq off -> vupdate irq off */
-		rc = amdgpu_dm_crtc_set_vupdate_irq(crtc, false);
+	if (dc_supports_vrr(dm->dc->ctx->dce_version)) {
+		if (enable) {
+			/* vblank irq on -> Only need vupdate irq in vrr mode */
+			if (amdgpu_dm_crtc_vrr_active(acrtc_state))
+				rc = amdgpu_dm_crtc_set_vupdate_irq(crtc, true);
+		} else {
+			/* vblank irq off -> vupdate irq off */
+			rc = amdgpu_dm_crtc_set_vupdate_irq(crtc, false);
+		}
 	}
 
 	if (rc)
-- 
2.51.0



