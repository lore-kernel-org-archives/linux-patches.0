Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294BF4FE2F5;
	Tue, 13 Oct 2026 12:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895509; cv=none; b=OkyIDtgEMA4QqCwk2qG/pCUaugiXb9MeL+KrXspcM/jzqfpDfO8e7+0JjD0mNapy7carI125/EmNin75/Sey79GslpOUlo7aiio7aZUrUECzHSxnXr6N6JkeZZgCOXN1i7JlnvuNeX0wSkrwiG2uPUSFkwd3+gm4sTDQh5EFySI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895509; c=relaxed/simple;
	bh=pBXJ33wWzFaIPGwv8ytSUy2QlJ6ybpCUrlfgfmbYsKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glV67QuPDwLdplJeAhX75noeNXe8y/y7d/3F488ezjiOdENDBV1T1de1ThdIfE82K+/sQKsMOiVgMwRc/BhbY9vJzzPA/h99m8Res6H2MmtUHe6P9ngrm7BKCKQIiRUQ3xhjAh1zsicIn0CGMVbpcpXtROcU19BLCUs1YdYjqmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxqexgyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxqexgyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2451F000FF;
	Tue, 13 Oct 2026 12:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895507;
	bh=MV79xvOTDqKLF5yrIDrIeVsct6Vpb+oumBGrrzTlSGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yxqexgyE9zoNrJuzRfKGUOYW8tBysckKNExuIv5fIiCZrQvr4p9hHFzjummrvL2ar
	 qWqTXEzQnysVwFciF9acuSBMw4u+vAM/ApqD1vSd0Bh7qKL7cudbWBeSechxJVHnAk
	 IcDbE7u6yduuYEQc/1q4REAcvcSezfxSSMD/A3Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Arthur Heymans <arthur@aheymans.xyz>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 298/497] drm/amd/display: Preserve eDP mode on initial ASSR failure
Date: Tue, 13 Oct 2026 13:37:45 +0200
Message-ID: <20261013112914.969821576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arthur Heymans <arthur@aheymans.xyz>

[ Upstream commit 5e08102d1d336593160d1434261d50b0c0f6cbe6 ]

Commit 56d8ce9d8c17 ("drm/amd/display: Apply correct panel mode when
reinitializing hardware") made ASSR failure fall back to the default panel
mode unless eDP mode had previously been applied.

However, dc_link is zero-initialized and DP_PANEL_MODE_DEFAULT is zero.
Before the first call to dp_set_panel_mode(), panel_mode therefore looks
like a previously applied default mode. If ASSR setup fails during the
first link training attempt, the driver incorrectly trains the eDP link
using the default scrambling mode.

On a Google Vilboz Chromebook running self-built coreboot firmware and
PSP verstage, this leaves the panel mostly black with corrupted output
along the top edge.

Track whether panel_mode has actually been initialized, and only consult
the saved mode after it has been applied. This retains the recovery
behavior while preserving eDP mode during initial link training.

Fixes: 56d8ce9d8c17 ("drm/amd/display: Apply correct panel mode when reinitializing hardware")
Assisted-by: Pi:gpt-5.6-sol
Reviewed-by: George Zhang <george.zhang@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Arthur Heymans <arthur@aheymans.xyz>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ccb6c2702033f1002b45807fb3cc938760f26f78)
Cc: stable@vger.kernel.org # 6.4.x
[ sashal: Adjusted context for the different eDP panel-mode logging format. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                           | 1 +
 .../amd/display/dc/link/protocols/link_edp_panel_control.c    | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index a4f6ff7155c2a..f7cd6cb06638b 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1721,6 +1721,7 @@ struct dc_link {
 	struct ddc_service *ddc;
 
 	enum dp_panel_mode panel_mode;
+	bool panel_mode_initialized;
 	bool aux_mode;
 
 	/* Private to DC core */
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
index fa642f4b88c2d..17220177479a3 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
@@ -91,6 +91,7 @@ void dp_set_panel_mode(struct dc_link *link, enum dp_panel_mode panel_mode)
 	}
 
 	link->panel_mode = panel_mode;
+	link->panel_mode_initialized = true;
 	DC_LOG_DETECTION_DP_CAPS("Link: %d eDP panel mode supported: %d "
 		 "eDP panel mode enabled: %d \n",
 		 link->link_index,
@@ -1231,7 +1232,8 @@ void edp_set_panel_assr(struct dc_link *link, struct pipe_ctx *pipe_ctx,
 
 		result = cp_psp->funcs.enable_assr(cp_psp->handle, link);
 
-		if (!result && link->panel_mode != DP_PANEL_MODE_EDP)
+		if (!result && link->panel_mode_initialized &&
+		    link->panel_mode != DP_PANEL_MODE_EDP)
 			*panel_mode = DP_PANEL_MODE_DEFAULT;
 	}
 }
-- 
2.53.0



