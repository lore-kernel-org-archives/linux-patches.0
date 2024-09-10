Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086BF1891A1;
	Tue, 10 Sep 2024 09:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961597; cv=none; b=WmC1e43qF4XNHBt5feSpB3wGReAfzED3SQ3vgGZUmd0JAGaGTFO2JJ8lap2400qmpvE33ffGe3RT75B0P/+fMT8x2LGVDPD0k8NTZ/BxCSnMNhTIjszAyhxKS7QULpBEN0ogbgXrs7N/0wUnoiMJXQQUnHn2GGlodTerHUHi4YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961597; c=relaxed/simple;
	bh=2mFhcHm8yPE2AGBE9e3O/amFqLbo5UsxBDRnHamiwlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rgbo5GsZCFrh/RCZv93QAGx3laT/a8HMYkxDdyq+a6ZTy44JC7MC4Eoz2h23IB59NVCe5r1VLAxDjoZ5IBJIZir/lK369mEDq9SM/IGsQSGxTZA2pch5Zby37KWnfIIyKmQKaJNA2A5Vdv4a+tta9rspJ/tmKZcg7sE+rgBfaE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxsTUYDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxsTUYDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD53C4CEC3;
	Tue, 10 Sep 2024 09:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961596;
	bh=2mFhcHm8yPE2AGBE9e3O/amFqLbo5UsxBDRnHamiwlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxsTUYDsQmPNFRm5ZWXfwWAG+y9MTxrwp/jXZSTaPLN2DSMYkvQgdwPAo4xlovLw3
	 KS51S/FSgOEYXCsAvg39TBqgnFFRRFmsZzTSFnPNclfDBm0X3sN5Riv+l5OaKZGO0F
	 znkp9xtZ/MUgdwV7fTClXTOkmiKikUSBX+ddNhmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 123/375] drm/amd/display: Run DC_LOG_DC after checking link->link_enc
Date: Tue, 10 Sep 2024 11:28:40 +0200
Message-ID: <20240910092626.569397432@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 3a82f62b0d9d7687eac47603bb6cd14a50fa718b ]

[WHAT]
The DC_LOG_DC should be run after link->link_enc is checked, not before.

This fixes 1 REVERSE_INULL issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_factory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_factory.c b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
index cf22b8f28ba6..72df9bdfb23f 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_factory.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
@@ -611,14 +611,14 @@ static bool construct_phy(struct dc_link *link,
 	link->link_enc =
 		link->dc->res_pool->funcs->link_enc_create(dc_ctx, &enc_init_data);
 
-	DC_LOG_DC("BIOS object table - DP_IS_USB_C: %d", link->link_enc->features.flags.bits.DP_IS_USB_C);
-	DC_LOG_DC("BIOS object table - IS_DP2_CAPABLE: %d", link->link_enc->features.flags.bits.IS_DP2_CAPABLE);
-
 	if (!link->link_enc) {
 		DC_ERROR("Failed to create link encoder!\n");
 		goto link_enc_create_fail;
 	}
 
+	DC_LOG_DC("BIOS object table - DP_IS_USB_C: %d", link->link_enc->features.flags.bits.DP_IS_USB_C);
+	DC_LOG_DC("BIOS object table - IS_DP2_CAPABLE: %d", link->link_enc->features.flags.bits.IS_DP2_CAPABLE);
+
 	/* Update link encoder tracking variables. These are used for the dynamic
 	 * assignment of link encoders to streams.
 	 */
-- 
2.43.0



