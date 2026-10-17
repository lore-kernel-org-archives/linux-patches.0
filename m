Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4A136195A;
	Sat, 17 Oct 2026 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258000; cv=none; b=XjbytxgR/7MyQyRQ944qoXE5Uc6s2Y7kTgVnIoKELuubxzv+jtCH6wTL8XYs5z7fcgmOByqKNTggOc5JWNVvhG1fIx6P+cJnkf4v2KGB+4smF+ikQJ/zdd8o3ckS3Z6Jb3+OU5PBT4BBIfJfGhUsnmACV4Q040YSfQuCYEY0B+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258000; c=relaxed/simple;
	bh=XWluqMlhRhiExXbs/amxg+Kd+TqHED2hWx+hecxiidE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jg0Q7Ho6W8r3Tlc7zjSMyz6l7u1aF8wKVMGcPM8Akrp8liwDKBdEC33+llSQ2+LRwVec4ok2FY+unpBchWY3ek0kQD+hgxxHk3VuGEpYmQJJr3QI+/YiGFq4AtBL21vlg+dFXQMnzUMWZDB1lwxfgX00FlGFV+mLE0RPeDIKXLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsn9c6g/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsn9c6g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955501F000C4;
	Sat, 17 Oct 2026 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257999;
	bh=Nb6gqnNQwr3fqSUJQGaFQhRbSdd9kTFjtAAULf0JmxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsn9c6g/5K8u4k8aa6o4dWS3z+CmsBPIbleKFjT5BCHagxvJKo+lU7tQB+fK5urZ0
	 kcr6uOeYupwq3b+iR2w1cvfvP60yG/HonxKMKlcJidEL8n/Vbstq7jg54D1+XiReS2
	 CeqIsgaHALjjfpmnNb+HoxrGOsjSGXdTR0uidK68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Brendan Tam <Brendan.Tam@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0738/1674] drm/amd/display: prevent hang on link training fail
Date: Sat, 17 Oct 2026 17:50:10 +0200
Message-ID: <20261017160450.042946033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan Tam <Brendan.Tam@amd.com>

[ Upstream commit 8058061ed9d6bc259d1e678607b07d259342c08f ]

[Why]
When link training fails, the phy clock will be disabled. However, in
enable_streams, it is assumed that link training succeeded and the
mux selects the phy clock, causing a hang when a register write is made.

[How]
When enable_stream is hit, check if link training failed. If it did, fall
back to the ref clock to avoid a hang and keep the system in a recoverable
state.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Brendan Tam <Brendan.Tam@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 148609f601628..87d19b64d4ed5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -2754,7 +2754,11 @@ void dcn20_enable_stream(struct pipe_ctx *pipe_ctx)
 		dccg->funcs->set_dpstreamclk(dccg, DTBCLK0, tg->inst, dp_hpo_inst);
 
 		phyd32clk = get_phyd32clk_src(link);
-		dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
+		if (link->cur_link_settings.link_rate == LINK_RATE_UNKNOWN) {
+			dccg->funcs->disable_symclk32_se(dccg, dp_hpo_inst);
+		} else {
+			dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
+		}
 	} else {
 		}
 	if (hws->funcs.calculate_dccg_k1_k2_values && dc->res_pool->dccg->funcs->set_pixel_rate_div) {
-- 
2.53.0



