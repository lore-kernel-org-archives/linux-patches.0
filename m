Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B86441614;
	Thu, 30 Jul 2026 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422273; cv=none; b=XPNrMDZxh27aZfGs4m00v5TOEwXif8fN8TuhoeQYgB3cYSDQ+j01/996PKZ/vaHKd0qhTUS80YMF6W/loYHYTpA2htTyuCepBw3GBQyhqlWUXPs5h1obgQth63MykCkjYLLi7R/baxnd6VZBkwOMZmn45UR+NHCwQ78UehZsoIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422273; c=relaxed/simple;
	bh=oqx+zpcxU8J4t5kiWOinUKNPHuXE3ugz6jdeCd+f5eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIDTsK7rbgMzZmwOad6O56ZoR921YaCvx3g0AHRla3Mo0VMKXPttlrNHj2baI5jEIX9L+3BhYVb+BjhQ9uZ7x5IyvOl5FtONKrgGk+GinWcWJfxRkhIPGXuGihV1wTqhHeKLDdSBglHtIThCfLnDq3iPBe9yGgEh53pBuJD26TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SN1yO+X/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SN1yO+X/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4ACD1F000E9;
	Thu, 30 Jul 2026 14:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422272;
	bh=8qvtEY5isKd55sUM/JuOPHWG8mgKz8M4jl5mK0ZcOic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SN1yO+X/I82Rh+8gAslOEn3ZO5MIOZrlmip5X3Gluheabxm/Va1EAuZpP7VqVhVp2
	 DVJ1VY2QRFKLk+c7NivgiCZR1E5FYbVfm8tc9k6gX+QmwtM/7/6sQFjtQVL6A1DjM+
	 N/GByWEK4SAG6stuAyBkxBmxnqwtVk7vEaFhau9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 382/744] drm/amd/display: Restore periodic detection for DCN35
Date: Thu, 30 Jul 2026 16:10:55 +0200
Message-ID: <20260730141452.404987743@linuxfoundation.org>
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

From: Ivan Lipski <ivan.lipski@amd.com>

commit 5cc0f35d83e2c72f70edaf7478db350af3082a17 upstream.

[Why&How]
Periodic detection callbacks from DCN35 was removed for higher IPS
residency causing some displays to fail to recover after DPMS sleep. The
monitors bounces HPD ~1.2s after link training, and without periodic
detection the system enters IPS with no mechanism to wake and rediscover
the display.

Restore the periodic detection calls in dcn35_clk_mgr for now. It should
be replaced with a proper IPS-aware solution long term using DMUB.

Also remove it from dcn31 and dcn314_clk_mgr.c since they do not have IPS,
thus should not affect them.

Fixes: 3f6c060846be ("drm/amd/display: Remove periodic detection callbacks from dcn35+")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5318
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0c300e6a76916e944b6b18a64c73f7895a0fee87)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c   |    2 --
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c |    2 --
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c   |    2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
@@ -155,7 +155,6 @@ void dcn31_update_clocks(struct clk_mgr
 		if (new_clocks->zstate_support != DCN_ZSTATE_SUPPORT_DISALLOW &&
 				new_clocks->zstate_support != clk_mgr_base->clks.zstate_support) {
 			dcn31_smu_set_zstate_support(clk_mgr, new_clocks->zstate_support);
-			dm_helpers_enable_periodic_detection(clk_mgr_base->ctx, true);
 			clk_mgr_base->clks.zstate_support = new_clocks->zstate_support;
 		}
 
@@ -181,7 +180,6 @@ void dcn31_update_clocks(struct clk_mgr
 		if (new_clocks->zstate_support == DCN_ZSTATE_SUPPORT_DISALLOW &&
 				new_clocks->zstate_support != clk_mgr_base->clks.zstate_support) {
 			dcn31_smu_set_zstate_support(clk_mgr, DCN_ZSTATE_SUPPORT_DISALLOW);
-			dm_helpers_enable_periodic_detection(clk_mgr_base->ctx, false);
 			clk_mgr_base->clks.zstate_support = new_clocks->zstate_support;
 		}
 
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
@@ -227,7 +227,6 @@ void dcn314_update_clocks(struct clk_mgr
 		if (new_clocks->zstate_support != DCN_ZSTATE_SUPPORT_DISALLOW &&
 				new_clocks->zstate_support != clk_mgr_base->clks.zstate_support) {
 			dcn314_smu_set_zstate_support(clk_mgr, new_clocks->zstate_support);
-			dm_helpers_enable_periodic_detection(clk_mgr_base->ctx, true);
 			clk_mgr_base->clks.zstate_support = new_clocks->zstate_support;
 		}
 
@@ -252,7 +251,6 @@ void dcn314_update_clocks(struct clk_mgr
 		if (new_clocks->zstate_support == DCN_ZSTATE_SUPPORT_DISALLOW &&
 				new_clocks->zstate_support != clk_mgr_base->clks.zstate_support) {
 			dcn314_smu_set_zstate_support(clk_mgr, DCN_ZSTATE_SUPPORT_DISALLOW);
-			dm_helpers_enable_periodic_detection(clk_mgr_base->ctx, false);
 			clk_mgr_base->clks.zstate_support = new_clocks->zstate_support;
 		}
 
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -405,6 +405,7 @@ void dcn35_update_clocks(struct clk_mgr
 		if (new_clocks->zstate_support != DCN_ZSTATE_SUPPORT_DISALLOW &&
 				new_clocks->zstate_support != clk_mgr_base->clks.zstate_support) {
 			dcn35_smu_set_zstate_support(clk_mgr, new_clocks->zstate_support);
+			dm_helpers_enable_periodic_detection(clk_mgr_base->ctx, true);
 			clk_mgr_base->clks.zstate_support = new_clocks->zstate_support;
 		}
 
@@ -424,6 +425,7 @@ void dcn35_update_clocks(struct clk_mgr
 		if (new_clocks->zstate_support == DCN_ZSTATE_SUPPORT_DISALLOW &&
 				new_clocks->zstate_support != clk_mgr_base->clks.zstate_support) {
 			dcn35_smu_set_zstate_support(clk_mgr, DCN_ZSTATE_SUPPORT_DISALLOW);
+			dm_helpers_enable_periodic_detection(clk_mgr_base->ctx, false);
 			clk_mgr_base->clks.zstate_support = new_clocks->zstate_support;
 		}
 


