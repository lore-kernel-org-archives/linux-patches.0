Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B151774B;
	Thu, 18 Jan 2024 10:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575388; cv=none; b=gsSGyz0fzi43xnzaKGavDdeOQirmiR+wQ8PF7df+dsSJVSVvD10PSBou+XTEjtxgBkHLyOdHEvC9tK1aRVaHE/HlzHhkCF3MqX4WNo+kj1Tts2nb1hE+7HVlUWeZHJVusT5gZloUwN0LOG8dYuxgfq6+JmerQeBXUlEMS4iCfUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575388; c=relaxed/simple;
	bh=eS0tUIi1U3IBKT11h2lTnF93wWY30EZsd/nTI1gncMg=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=SaXW33HbKdSXCD6PZneyzeVioBM4QtrkxLHHJXIqf8sSuthM7z+vW9Pd9yuBJhSZP3Vs/dHDOCjDrAZh8XNff6EMfON6txE8uazHhbuKG8xVn6oEtA7NfOVxVamqubGlJxSapOrkmhX8PLSDzD+luQJoWb+T2WKBLwvqtg6LykE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4tocwk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4tocwk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E8FC433C7;
	Thu, 18 Jan 2024 10:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575388;
	bh=eS0tUIi1U3IBKT11h2lTnF93wWY30EZsd/nTI1gncMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4tocwk62zouV2Qj9CmussfACRxN/OHufLlROKTkWFolOhoiNXTehqbkTHZuqvvbr
	 Sitml7O+O7fD/oiTgkz3N0zODFbkwzd+k8Hez8vEeuL4bXOAV/y5LEbK6U1d9pc1Bf
	 5MBCfcw+l8gJTnXsSt/ZkwDsKgRcVYYGB++Pey10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Jun Lei <jun.lei@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/150] drm/amd/display: Add case for dcn35 to support usb4 dmub hpd event
Date: Thu, 18 Jan 2024 11:48:56 +0100
Message-ID: <20240118104325.327202901@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <wayne.lin@amd.com>

[ Upstream commit 989824589f793120833bef13aa4e21f5a836a707 ]

[Why & how]
Refactor dc_is_dmub_outbox_supported() a bit and add case for dcn35 to
register dmub outbox notification irq to handle usb4 relevant hpd event.

Reviewed-by: Roman Li <roman.li@amd.com>
Reviewed-by: Jun Lei <jun.lei@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 26 ++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index a1be93f6385c..8cdf380bf366 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -4865,18 +4865,28 @@ void dc_mclk_switch_using_fw_based_vblank_stretch_shut_down(struct dc *dc)
  */
 bool dc_is_dmub_outbox_supported(struct dc *dc)
 {
-	/* DCN31 B0 USB4 DPIA needs dmub notifications for interrupts */
-	if (dc->ctx->asic_id.chip_family == FAMILY_YELLOW_CARP &&
-	    dc->ctx->asic_id.hw_internal_rev == YELLOW_CARP_B0 &&
-	    !dc->debug.dpia_debug.bits.disable_dpia)
-		return true;
+	switch (dc->ctx->asic_id.chip_family) {
 
-	if (dc->ctx->asic_id.chip_family == AMDGPU_FAMILY_GC_11_0_1 &&
-	    !dc->debug.dpia_debug.bits.disable_dpia)
-		return true;
+	case FAMILY_YELLOW_CARP:
+		/* DCN31 B0 USB4 DPIA needs dmub notifications for interrupts */
+		if (dc->ctx->asic_id.hw_internal_rev == YELLOW_CARP_B0 &&
+		    !dc->debug.dpia_debug.bits.disable_dpia)
+			return true;
+	break;
+
+	case AMDGPU_FAMILY_GC_11_0_1:
+	case AMDGPU_FAMILY_GC_11_5_0:
+		if (!dc->debug.dpia_debug.bits.disable_dpia)
+			return true;
+	break;
+
+	default:
+		break;
+	}
 
 	/* dmub aux needs dmub notifications to be enabled */
 	return dc->debug.enable_dmub_aux_for_legacy_ddc;
+
 }
 
 /**
-- 
2.43.0



