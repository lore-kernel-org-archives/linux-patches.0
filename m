Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BA3335BA3;
	Mon, 18 Aug 2025 13:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523976; cv=none; b=ok8irUM4lxgtdSkh//nG7BRWwHldv3HOpOogCf76LDKK5q5rqT8unPHW1Fopxng2Vwr70MFEqPI8Wh4xCfauRVeef71RnTZejBXAf5mr9XSkqK73wFO5RCRd4lqEFz2QDPUtJ5KeK9hkW7phrdDJ2I/h3GvtJwdZII7K/OixF0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523976; c=relaxed/simple;
	bh=/gKp8Gg4ihZjzZhUUI90FL/95UvXrrihM1Hc/z6MMYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe2xKXz65YwzPbLz2ECuhRxeSxHEFoWCnyy0fjz1OheSzs5bPHa62OLX90djQj0+GQVxYH16OyyUs8+WaC6DRfW5SSEPDfj+IgBEwOIGgvVfGG+5y6re2biWUYryTKWuNCis1tQrq+94dIU4/kYBcfpDr3lcvWT/9YGfCiaA6N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwuFpMkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwuFpMkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC8AC4CEEB;
	Mon, 18 Aug 2025 13:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523976;
	bh=/gKp8Gg4ihZjzZhUUI90FL/95UvXrrihM1Hc/z6MMYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwuFpMkLVJIC3I42j05IbBUEmYYmaE9gbQEnS2f2Fgyd+iaWo8LBsVBnpkJqvB6ZT
	 VUomJ3NvSUsT1utpGtaA5hacjhZ7lIqE9IdAFmIa1i5Ah04l9Ohn2GwUCsw360MR50
	 mZAiu8jbpRJVnI1Dao3brwVkn1icBbn5lKLgvL40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 298/515] drm/amdgpu: Suspend IH during mode-2 reset
Date: Mon, 18 Aug 2025 14:44:44 +0200
Message-ID: <20250818124509.894664974@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 3f1e81ecb61923934bd11c3f5c1e10893574e607 ]

On multi-aid SOCs, there could be a continuous stream of interrupts from
GC after poison consumption. Suspend IH to disable them before doing
mode-2 reset. This avoids conflicts in hardware accesses during
interrupt handlers while a reset is ongoing.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aldebaran.c | 33 ++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aldebaran.c b/drivers/gpu/drm/amd/amdgpu/aldebaran.c
index e13fbd974141..9569dc16dd3d 100644
--- a/drivers/gpu/drm/amd/amdgpu/aldebaran.c
+++ b/drivers/gpu/drm/amd/amdgpu/aldebaran.c
@@ -71,18 +71,29 @@ aldebaran_get_reset_handler(struct amdgpu_reset_control *reset_ctl,
 	return NULL;
 }
 
+static inline uint32_t aldebaran_get_ip_block_mask(struct amdgpu_device *adev)
+{
+	uint32_t ip_block_mask = BIT(AMD_IP_BLOCK_TYPE_GFX) |
+				 BIT(AMD_IP_BLOCK_TYPE_SDMA);
+
+	if (adev->aid_mask)
+		ip_block_mask |= BIT(AMD_IP_BLOCK_TYPE_IH);
+
+	return ip_block_mask;
+}
+
 static int aldebaran_mode2_suspend_ip(struct amdgpu_device *adev)
 {
+	uint32_t ip_block_mask = aldebaran_get_ip_block_mask(adev);
+	uint32_t ip_block;
 	int r, i;
 
 	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
 	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 
 	for (i = adev->num_ip_blocks - 1; i >= 0; i--) {
-		if (!(adev->ip_blocks[i].version->type ==
-			      AMD_IP_BLOCK_TYPE_GFX ||
-		      adev->ip_blocks[i].version->type ==
-			      AMD_IP_BLOCK_TYPE_SDMA))
+		ip_block = BIT(adev->ip_blocks[i].version->type);
+		if (!(ip_block_mask & ip_block))
 			continue;
 
 		r = amdgpu_ip_block_suspend(&adev->ip_blocks[i]);
@@ -200,8 +211,10 @@ aldebaran_mode2_perform_reset(struct amdgpu_reset_control *reset_ctl,
 static int aldebaran_mode2_restore_ip(struct amdgpu_device *adev)
 {
 	struct amdgpu_firmware_info *ucode_list[AMDGPU_UCODE_ID_MAXIMUM];
+	uint32_t ip_block_mask = aldebaran_get_ip_block_mask(adev);
 	struct amdgpu_firmware_info *ucode;
 	struct amdgpu_ip_block *cmn_block;
+	struct amdgpu_ip_block *ih_block;
 	int ucode_count = 0;
 	int i, r;
 
@@ -243,6 +256,18 @@ static int aldebaran_mode2_restore_ip(struct amdgpu_device *adev)
 	if (r)
 		return r;
 
+	if (ip_block_mask & BIT(AMD_IP_BLOCK_TYPE_IH)) {
+		ih_block = amdgpu_device_ip_get_ip_block(adev,
+							 AMD_IP_BLOCK_TYPE_IH);
+		if (unlikely(!ih_block)) {
+			dev_err(adev->dev, "Failed to get IH handle\n");
+			return -EINVAL;
+		}
+		r = amdgpu_ip_block_resume(ih_block);
+		if (r)
+			return r;
+	}
+
 	/* Reinit GFXHUB */
 	adev->gfxhub.funcs->init(adev);
 	r = adev->gfxhub.funcs->gart_enable(adev);
-- 
2.39.5



