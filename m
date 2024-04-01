Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05C4446AC;
	Mon,  1 Apr 2024 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987817; cv=none; b=Tr9ro5JhH4bWRvT2KgErCsHB6jYOjQ2o6sHIv91QcBsZt3PDsWNoLbkxeMKXngKiMsjTaMgc7Q0Mch28FHrDC6BLpTh2Xsdkm4D6u3PIMWddwn3AG1I8BddKUbFMiBcG/MvAG+KDW2AdZVgsVrJ5R5/AnDWTOVwqXzh6nGMr4fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987817; c=relaxed/simple;
	bh=bZ1NYrgbzca19/cQTa391ZQ2PqL3gtXGaSqZQzpJOig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwbmJsaRLmB2DFE5QiGzFxqxCjZGKV0/fhbZUk1K+TtwGt6skl4z45y+l6vIYpNaYAyglvcElbES+f3ADzimXi6TDbwvEmS5sDByikfIedr5FkJ6nlip9Z/1ZmnDRQH+HS4t1CyiGLTyZcD04jgJU3fzqCjIjrYVIqmwop0RYQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dQ0fubT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dQ0fubT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2CCC433C7;
	Mon,  1 Apr 2024 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987817;
	bh=bZ1NYrgbzca19/cQTa391ZQ2PqL3gtXGaSqZQzpJOig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dQ0fubT3y/F7lC0+arMNmklNJ6wYUa6UHNQBymAmE2J+EGMUx05FlkzPLs0I+vTd
	 0TE9BcO4jnygQkG8GNUHYzk2ayGpJ1DDkOiHVvePGO8TZw+YY0joLHa5kCEoZqpNF+
	 i+dRJBvy2mMW4Cliwn6KB/LbUDXfehYiG7FFtgiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Broadworth <mark.broadworth@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 389/399] drm/amd/display: fix IPX enablement
Date: Mon,  1 Apr 2024 17:45:55 +0200
Message-ID: <20240401152600.782939629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit 1202f794cdaa4f0ba6a456bc034f2db6cfcf5579 upstream.

We need to re-enable idle power optimizations after entering PSR. Since,
we get kicked out of idle power optimizations before entering PSR
(entering PSR requires us to write to DCN registers, which isn't allowed
while we are in IPS).

Fixes: a9b1a4f684b3 ("drm/amd/display: Add more checks for exiting idle in DC")
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c |    8 +++++---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.h |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -141,9 +141,8 @@ bool amdgpu_dm_link_setup_psr(struct dc_
  * amdgpu_dm_psr_enable() - enable psr f/w
  * @stream: stream state
  *
- * Return: true if success
  */
-bool amdgpu_dm_psr_enable(struct dc_stream_state *stream)
+void amdgpu_dm_psr_enable(struct dc_stream_state *stream)
 {
 	struct dc_link *link = stream->link;
 	unsigned int vsync_rate_hz = 0;
@@ -190,7 +189,10 @@ bool amdgpu_dm_psr_enable(struct dc_stre
 	if (link->psr_settings.psr_version < DC_PSR_VERSION_SU_1)
 		power_opt |= psr_power_opt_z10_static_screen;
 
-	return dc_link_set_psr_allow_active(link, &psr_enable, false, false, &power_opt);
+	dc_link_set_psr_allow_active(link, &psr_enable, false, false, &power_opt);
+
+	if (link->ctx->dc->caps.ips_support)
+		dc_allow_idle_optimizations(link->ctx->dc, true);
 }
 
 /*
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.h
@@ -32,7 +32,7 @@
 #define AMDGPU_DM_PSR_ENTRY_DELAY 5
 
 void amdgpu_dm_set_psr_caps(struct dc_link *link);
-bool amdgpu_dm_psr_enable(struct dc_stream_state *stream);
+void amdgpu_dm_psr_enable(struct dc_stream_state *stream);
 bool amdgpu_dm_link_setup_psr(struct dc_stream_state *stream);
 bool amdgpu_dm_psr_disable(struct dc_stream_state *stream);
 bool amdgpu_dm_psr_disable_all(struct amdgpu_display_manager *dm);


