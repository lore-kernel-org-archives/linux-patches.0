Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350E614B094;
	Mon, 16 Sep 2024 12:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488684; cv=none; b=NZNEYhXHTsgNDOgt+kQC0EfDJdqttthxw8c3MBUQ4XPhcNZp7EzsMhaZfERywso48kh0Q+Yr4OvTRLCjL7HWXi+E+gvjp3TLMDoQgIf95dkYlrK0qbZ6w2mGa2iRHYIX02vql8Mtv7+CI4LjIdGpVrKEhLQlfwtRb8we5NMaBgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488684; c=relaxed/simple;
	bh=XVnDoaI3UMouNnGqaEgESryWQESTHmay8tcMxrGGFxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qd3zsrTVjoru3i94mT3hjZcYadIJCmK825TEhN2EFeMRueEJAl92IGLIcYiTzrMutpLgolPsp7BJL/xDmwckb9jVKKoA0iG6lCinkglXa1M3OnD1xmaMx7OXMCk7e2aq6YWxPThhKNa52uMvOYnDlxy4mbMrPhQdYpKuUXzI6Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IEZW4Ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IEZW4Ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A904FC4CEC4;
	Mon, 16 Sep 2024 12:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488684;
	bh=XVnDoaI3UMouNnGqaEgESryWQESTHmay8tcMxrGGFxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IEZW4Ca6bEGV7P/XpDtRcf2fHHZ7XUIMJXa2hBUGmKP/5hfwA837dY/A04djcbRB
	 kA/gDU95Vj0mrGOPI6DhyTM2BfjjJrVTuAWv2xqP106nC1fO5C0i8Bb/KOUerY08/S
	 S677pqgqxJZEX4kfkvBmwMSrZrTCZ2HHM9xVmnbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Ilya Bakoulin <ilya.bakoulin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 50/91] drm/amd/display: Fix FEC_READY write on DP LT
Date: Mon, 16 Sep 2024 13:44:26 +0200
Message-ID: <20240916114226.159094345@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

From: Ilya Bakoulin <ilya.bakoulin@amd.com>

[ Upstream commit a8baec4623aedf36d50767627f6eae5ebf07c6fb ]

[Why/How]
We can miss writing FEC_READY in some cases before LT start, which
violates DP spec. Remove the condition guarding the DPCD write so that
the write happens unconditionally.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Ilya Bakoulin <ilya.bakoulin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/link/protocols/link_dp_phy.c    | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c
index f06f708ba5c8..9bde0c8bf914 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_phy.c
@@ -147,16 +147,14 @@ enum dc_status dp_set_fec_ready(struct dc_link *link, const struct link_resource
 		return DC_NOT_SUPPORTED;
 
 	if (ready && dp_should_enable_fec(link)) {
-		if (link->fec_state == dc_link_fec_not_ready) {
-			fec_config = 1;
+		fec_config = 1;
 
-			status = core_link_write_dpcd(link, DP_FEC_CONFIGURATION,
-					&fec_config, sizeof(fec_config));
+		status = core_link_write_dpcd(link, DP_FEC_CONFIGURATION,
+				&fec_config, sizeof(fec_config));
 
-			if (status == DC_OK) {
-				link_enc->funcs->fec_set_ready(link_enc, true);
-				link->fec_state = dc_link_fec_ready;
-			}
+		if (status == DC_OK) {
+			link_enc->funcs->fec_set_ready(link_enc, true);
+			link->fec_state = dc_link_fec_ready;
 		}
 	} else {
 		if (link->fec_state == dc_link_fec_ready) {
-- 
2.43.0



