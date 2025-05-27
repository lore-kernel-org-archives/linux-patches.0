Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020D7154C15;
	Tue, 27 May 2025 17:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365310; cv=none; b=OWyTd/ds533imL9C8BPcT2etDNOw4dkqlOXUdjfF6I9q5DBPbFPygrvGFsPI8XYNm5qzVizd3yeHVnznzKZKrGLmiRb66u9M+KLlk/Hvnma+Gd1THZWRe1Uz1wmwm+LRMIAWB142mvIkaCh5J2+W3EghqSSHPx4ihuc6lLN+Ne4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365310; c=relaxed/simple;
	bh=a/b88L3h9MvH/d0F6viAf9peqLlCO651VB6l+SXxEKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shSbnhZmWzSq2tIPLnNorK07AddvjytGTWLuRGCdb0aGApnP0j2uXC7PTX8zdtDvjXBzmEGyqWOAeg78YNvmnl13BGb6uiG7G/iWeFBMB4bUXXdY7UOqSWgzWnq1ZsE8xexP/UWOEQELd0H0cOvQ8jgd3cWolYHLjES6x+O/4oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2l/mX0aM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2l/mX0aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7183EC4CEE9;
	Tue, 27 May 2025 17:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365309;
	bh=a/b88L3h9MvH/d0F6viAf9peqLlCO651VB6l+SXxEKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2l/mX0aMZsImUIOPskVZmHzCq6/JXFvY1EWothFGUZEpolJoVmSo37MfVfDDhsVIL
	 nqnThg7d8wkpldU1A/wCzXsDswhezNZ5htfZ+HZkAmrhkW8Xp1yOLefsWuNfUl1UMV
	 nr45009YNNtzw5WnSBSQ465+ypJC9uHWtQyXLeaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabe Teeger <gabe.teeger@amd.com>,
	Leo Chen <leo.chen@amd.com>,
	Syed Hassan <syed.hassan@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/626] drm/amd/display: Guard against setting dispclk low when active
Date: Tue, 27 May 2025 18:23:47 +0200
Message-ID: <20250527162458.592451390@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 72d7a7fa1f2404fd31c84a8f808b1b37021a3a9e ]

[Why]
We should never apply a minimum dispclk value while in prepare_bandwidth
or while displays are active. This is always an optimization for when
all displays are disabled.

[How]
Defer dispclk optimization until safe_to_lower = true and display_count
reaches 0.

Since 0 has a special value in this logic (ie. no dispclk required)
we also need adjust the logic that clamps it for the actual request
to PMFW.

Reviewed-by: Gabe Teeger <gabe.teeger@amd.com>
Reviewed-by: Leo Chen <leo.chen@amd.com>
Reviewed-by: Syed Hassan <syed.hassan@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c    | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
index 7d0d8852ce8d2..a4ac601a30c35 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -452,14 +452,19 @@ void dcn35_update_clocks(struct clk_mgr *clk_mgr_base,
 		update_dppclk = true;
 	}
 
-	if (should_set_clock(safe_to_lower, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz)) {
+	if (should_set_clock(safe_to_lower, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz) &&
+	    (new_clocks->dispclk_khz > 0 || (safe_to_lower && display_count == 0))) {
+		int requested_dispclk_khz = new_clocks->dispclk_khz;
+
 		dcn35_disable_otg_wa(clk_mgr_base, context, safe_to_lower, true);
 
-		if (dc->debug.min_disp_clk_khz > 0 && new_clocks->dispclk_khz < dc->debug.min_disp_clk_khz)
-			new_clocks->dispclk_khz = dc->debug.min_disp_clk_khz;
+		/* Clamp the requested clock to PMFW based on their limit. */
+		if (dc->debug.min_disp_clk_khz > 0 && requested_dispclk_khz < dc->debug.min_disp_clk_khz)
+			requested_dispclk_khz = dc->debug.min_disp_clk_khz;
 
+		dcn35_smu_set_dispclk(clk_mgr, requested_dispclk_khz);
 		clk_mgr_base->clks.dispclk_khz = new_clocks->dispclk_khz;
-		dcn35_smu_set_dispclk(clk_mgr, clk_mgr_base->clks.dispclk_khz);
+
 		dcn35_disable_otg_wa(clk_mgr_base, context, safe_to_lower, false);
 
 		update_dispclk = true;
-- 
2.39.5



