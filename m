Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4736832253D;
	Mon, 18 Aug 2025 13:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525537; cv=none; b=PD4IBJRDZWQGApTmK0DKq/UMVhmiqF1AfU/OQrAzPX4M0QRCWHvCgH+Ka5bNXcC3EQBtC2ciaaHdFBmtv/BCqDJ1zvX3Tli7slxvGyWu0VATdRhEXuTfz+XRMVJ/J1tlqYL+hai3FfvDRXVz7IMbhguTrXxEIaceO54ELJTn+Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525537; c=relaxed/simple;
	bh=/YCvjB9cMdprqPllw/zqgG6uLkL1yw/Ve4wKzfEb0ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZL2NRyzwXg3PmD24sOdNe9zMhJbDcecqpzdprgKpsgaCP5ZO20mgM7lp6BktRKQ2ZrRK+Ix4UosknfX3ldLUUHGAlt9K8yH4MbC7umoIEOvRKJamJf+rukBD1qDv/ddjgjFBMPEZbUW/M4y1o3vM/B1dnIwHyy9YV4YuV7NGjK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OugSTh7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OugSTh7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749F7C4CEEB;
	Mon, 18 Aug 2025 13:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525536;
	bh=/YCvjB9cMdprqPllw/zqgG6uLkL1yw/Ve4wKzfEb0ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OugSTh7jmO9cgtFdgORH+GhATJ42g6rdvh1P/iU2tisvPV12NjE688EDwHCzzJjTu
	 VM2RzDIRArLn5kU+j/AEpMRate0g5ANFmR2TPKloN/hQOoeV8Dl5YYBTHwhqgifTPm
	 yw2CWrK0RQ+amfWngDhqHJiQNLz79Ni+jUg0vd50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nevenko Stupar <nevenko.stupar@amd.com>,
	Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 292/570] drm/amd/display: Separate set_gsl from set_gsl_source_select
Date: Mon, 18 Aug 2025 14:44:39 +0200
Message-ID: <20250818124517.096981602@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit 660a467a5e7366cd6642de61f1aaeaf0d253ee68 ]

[Why/How]
Separate the checks for set_gsl and set_gsl_source_select, since
source_select may not be implemented/necessary.

Reviewed-by: Nevenko Stupar <nevenko.stupar@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index c277df12c817..a93282d6e5a4 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -283,14 +283,13 @@ void dcn20_setup_gsl_group_as_lock(
 	}
 
 	/* at this point we want to program whether it's to enable or disable */
-	if (pipe_ctx->stream_res.tg->funcs->set_gsl != NULL &&
-		pipe_ctx->stream_res.tg->funcs->set_gsl_source_select != NULL) {
+	if (pipe_ctx->stream_res.tg->funcs->set_gsl != NULL) {
 		pipe_ctx->stream_res.tg->funcs->set_gsl(
 			pipe_ctx->stream_res.tg,
 			&gsl);
-
-		pipe_ctx->stream_res.tg->funcs->set_gsl_source_select(
-			pipe_ctx->stream_res.tg, group_idx,	enable ? 4 : 0);
+		if (pipe_ctx->stream_res.tg->funcs->set_gsl_source_select != NULL)
+			pipe_ctx->stream_res.tg->funcs->set_gsl_source_select(
+				pipe_ctx->stream_res.tg, group_idx, enable ? 4 : 0);
 	} else
 		BREAK_TO_DEBUGGER();
 }
-- 
2.39.5



