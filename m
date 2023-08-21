Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0F511703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29E7C433C8;
	Mon, 21 Aug 2023 19:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647948;
	bh=NFioXjB4EkUAqf/svMdM9kNpGGfusDOLZ972obtPanI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyB48dIowsoJnpjP5g90kDQRZuTqej9mTtiKwCAyqe0+9eSUAbgyKpibIbUBCbUSo
	 YC0z/U32a6hwyPD7/GfbZZvPdNjO9J9aE3M57m2Cxbsjo4qdfMe40OSmW+uCszGhXb
	 pQRz75eXialLp+IxZvOI5UfP1ErSjfi6oBtJpvLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Daniel Miess <daniel.miess@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 166/194] drm/amd/display: disable RCO for DCN314
Date: Mon, 21 Aug 2023 21:42:25 +0200
Message-ID: <20230821194130.000941520@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Miess <daniel.miess@amd.com>

commit 85e41f1ed5d94a26fe4e57003c399936d291ed70 upstream.

[Why]
RCO is causing error messages on some DCN314 systems

[How]
Force disable RCO for DCN314

Fixes: 17fbdbda9cc8 ("drm/amd/display: Enable dcn314 DPP RCO")
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Daniel Miess <daniel.miess@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c     |    2 +-
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
@@ -296,7 +296,7 @@ static void dccg314_dpp_root_clock_contr
 {
 	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
 
-	if (dccg->dpp_clock_gated[dpp_inst] == clock_on)
+	if (dccg->dpp_clock_gated[dpp_inst] != clock_on)
 		return;
 
 	if (clock_on) {
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -1933,6 +1933,10 @@ static bool dcn314_resource_construct(
 		dc->debug = debug_defaults_drv;
 	else
 		dc->debug = debug_defaults_diags;
+
+	/* Disable root clock optimization */
+	dc->debug.root_clock_optimization.u32All = 0;
+
 	// Init the vm_helper
 	if (dc->vm_helper)
 		vm_helper_init(dc->vm_helper, 16);


