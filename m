Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E12212B3D;
	Sun,  7 Sep 2025 20:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276341; cv=none; b=jUAgk238Ghoyp/D0U/DdkAj/ANQJiytbqWKSdrZZG1A4dPnqO6uf/CMgm6L5aWQxPHaXnrQbXQwL7uyr2xG/b4pykFHVjF8IPoWxK0frjRB98ReJDkORS0BeescyWj5vPE0zJMNHsLB9BgpW7+ELgT+/Dt6fdrqazyCer4SCszA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276341; c=relaxed/simple;
	bh=/oifftiKl62f21GY+POulFhnS75HbT/t4okkbi5A2UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2dQ1Nk5E4faqveBx2hRz38+rUXylSvbGXBs81jN4pjrMfVHoJAqp7GljraSrozjI/clgxLENhKbTQqnmMNQAhR72XcVoG9DpQrMTswpb99hHkYFMMbJcmSst75GYEztK90QWi5OmPbhNTh3okn2l1w8tEOZsXRZVYgU991JVPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmAHGEUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmAHGEUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FDFC4CEF0;
	Sun,  7 Sep 2025 20:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276341;
	bh=/oifftiKl62f21GY+POulFhnS75HbT/t4okkbi5A2UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmAHGEUHI2LTCstTNaalv8vanfSX74Qgq0OuOfH64tAlf/gSecIU17rKBU5Ou2T7f
	 tzEAewaL++HpVFJDuImO2RtSIJjA6Q3NZSIHwuxxhe/s5m7Sh1lh06tXeNGRhv0V61
	 26Yzjgi3Pvd3aKUEYsyN4gEeeq/3jZsGZ2sUx8nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.1 075/104] drm/amd/display: Check link_res->hpo_dp_link_enc before using it
Date: Sun,  7 Sep 2025 21:58:32 +0200
Message-ID: <20250907195609.625253436@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit 0beca868cde8742240cd0038141c30482d2b7eb8 upstream.

[WHAT & HOW]
Functions dp_enable_link_phy and dp_disable_link_phy can pass link_res
without initializing hpo_dp_link_enc and it is necessary to check for
null before dereferencing.

This fixes 2 FORWARD_NULL issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ Minor context change fixed. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_hwss_hpo_dp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/link/link_hwss_hpo_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_hwss_hpo_dp.c
@@ -29,6 +29,8 @@
 #include "dc_link_dp.h"
 #include "clk_mgr.h"
 
+#define DC_LOGGER link->ctx->logger
+
 static enum phyd32clk_clock_source get_phyd32clk_src(struct dc_link *link)
 {
 	switch (link->link_enc->transmitter) {
@@ -224,6 +226,11 @@ static void disable_hpo_dp_link_output(s
 		const struct link_resource *link_res,
 		enum signal_type signal)
 {
+	if (!link_res->hpo_dp_link_enc) {
+		DC_LOG_ERROR("%s: invalid hpo_dp_link_enc\n", __func__);
+		return;
+	}
+
 	if (IS_FPGA_MAXIMUS_DC(link->dc->ctx->dce_environment)) {
 		disable_hpo_dp_fpga_link_output(link, link_res, signal);
 	} else {


