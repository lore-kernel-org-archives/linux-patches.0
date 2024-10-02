Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2321D0945;
	Wed,  2 Oct 2024 13:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876621; cv=none; b=qlipcqaw/jwIqstrYj0EFw3HTmE6MetnD7DZfpRB4PyHC15/Cn3z9ohhYGJGE72hgFYNvD2D+jI3TbtwF5dolFrwL4G5xoCVWRQzhk6CXYMOYZvgdBJ6p+p554uGig0WiGGHqfiKgkkFEkWkIjhfdB7lAVXV/FTxoM5EUy1Q/6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876621; c=relaxed/simple;
	bh=tcMr3vDA9NZc9ilx/n8Y76Tysb1ePn867tcyvv7h/FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2H96qJyKRj+huDCHjtDPSitapDhuXah5vhXDuPUc59138G+3uEE4wmPt/n53h0dBXiXVoEBeHXBV2BVYetg+nZjncomzSs9fKBPgIrMaAqRfzbhrb9B2jXE2sSdH0KZC0h/5vsDKCOQb2D/8W/RD/x9NxUziOb9qXiXX3vbzxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G59NrTeU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G59NrTeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED51C4CEC5;
	Wed,  2 Oct 2024 13:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876621;
	bh=tcMr3vDA9NZc9ilx/n8Y76Tysb1ePn867tcyvv7h/FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G59NrTeU20W2c8Pd9YT+BQe2nrjViTpXXTWHs+UjN5Oa5Led5NuAc3xhpmm2ZRmi2
	 brrwXgq1+QPwzc/mUgu7UqNPf/LplyXQ+VBHFe+Fdb2Osdi9bPwfH7gtOfsqy4pqbS
	 tH3/WWJrHVlpKtfauwIViNCVvBnCxvLua2d265gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 507/695] drm/amd/display: disable_hpo_dp_link_output: Check link_res->hpo_dp_link_enc before using it
Date: Wed,  2 Oct 2024 14:58:25 +0200
Message-ID: <20241002125842.719172568@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit d925c04d974c657d10471c0c2dba3bc9c7d994ee upstream.

[WHAT & HOW]
Functions dp_enable_link_phy and dp_disable_link_phy can pass link_res
without initializing hpo_dp_link_enc and it is necessary to check for
null before dereferencing.

This fixes 1 FORWARD_NULL issue reported by Coverity.

Fixes: 0beca868cde8 ("drm/amd/display: Check link_res->hpo_dp_link_enc before using it")
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c
@@ -110,6 +110,11 @@ void enable_hpo_dp_link_output(struct dc
 		enum clock_source_id clock_source,
 		const struct dc_link_settings *link_settings)
 {
+	if (!link_res->hpo_dp_link_enc) {
+		DC_LOG_ERROR("%s: invalid hpo_dp_link_enc\n", __func__);
+		return;
+	}
+
 	if (link->dc->res_pool->dccg->funcs->set_symclk32_le_root_clock_gating)
 		link->dc->res_pool->dccg->funcs->set_symclk32_le_root_clock_gating(
 				link->dc->res_pool->dccg,


