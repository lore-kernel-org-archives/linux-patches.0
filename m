Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00EA1DE4CD;
	Tue,  8 Oct 2024 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394224; cv=none; b=eWka0KWCXU3Gozya41YKFZgsL9ovfwMEjjPtUJJRn8repVc0aOBcZ17BAV4YVqy8PjoAA3MefvPY88FaCeeOlCovKlySZbN5DSGdYAJckIq0ZXDdATRTrZ//Kmsc54b2U3Vt6oOPR0ylnP1SNPhYtKFKMHYXidZRLH2CJtm0fKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394224; c=relaxed/simple;
	bh=m0WtLAzV/3l/JOiTsp5fpFV8qXsGn8PAy3bSgLDowgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPtB2asW3LtIjahyFxNj8KyMXgA0oK1aBRyhgi8peYrJVOs8rsaEVY6jwqMClIz9UBjjkx66SksBnQBs9FJ8a/Z+pqVV8jOsDe9J48/0tY1AQJI3jUHfj/KKF1jVGZP6Z2ZonezXQcAg/8pmTgsDY8AIXaqh7Ap+dxiBoV0Wuus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzr9ePKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzr9ePKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF7FC4CEC7;
	Tue,  8 Oct 2024 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394223;
	bh=m0WtLAzV/3l/JOiTsp5fpFV8qXsGn8PAy3bSgLDowgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzr9ePKMBDwwn7braDpAELpLGanGeGX65dnrlLqGFK/1JSSPOG79O5/Snb7BqyaNo
	 aSnc2MIVOaBat4dZDYJ+M82OtmleA1pmtqvfXR3UzZJrBnKgniaVJYJRUgTeRuB8I9
	 cRDXKV6mls1li4sdpv9F7heDURd4orpFcJkqZoPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 384/386] drm/amd/display: enable_hpo_dp_link_output: Check link_res->hpo_dp_link_enc before using it
Date: Tue,  8 Oct 2024 14:10:29 +0200
Message-ID: <20241008115644.504125606@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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


