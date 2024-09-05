Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0630E19755E;
	Thu,  5 Sep 2024 09:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529886; cv=none; b=HiKCu8Iauo4RNwSyoBFY9uIrtP2tq3RAXzTxWTNd0Sj+3kNoe7F2e9Vh8Gw4IDuMHPTEukyBuLKdRAmbRk+lRELCPdrDg9PjBKJr8kTx7epdF2c/B2VAMYSS3KRdUa6QSjanASVJFILYRyorWw7EeZaRgMdXT3Eh0GHktudveXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529886; c=relaxed/simple;
	bh=ia9uwI/TcZjaodgDU6zhg9lwQJp36Hk6QD5/IDCbReI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFsTr0pVfKbEarUThL997IylefuKDKNLvv9VyLmQQe0bfJB8W0pFG560/0QTG4/y2GXqBfXpVmgTo0J1dcRTnY3qyAYHIsbazVwja4rK1BF8triCElspOLJ3uZRMLFZcnKXfEwp+6gCY5AqMfWvfdIuVIdRrOdW2mD324oFLAhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udpSkbi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udpSkbi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE17C4CEC3;
	Thu,  5 Sep 2024 09:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529885;
	bh=ia9uwI/TcZjaodgDU6zhg9lwQJp36Hk6QD5/IDCbReI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udpSkbi2jcgU1lDKTc5lirD6hOVXO7aq1nmjWiGRw/x0d9dHo7UuQa7gmpWlSvDmL
	 cGvipOdSdvmxa6Yb+cO5NQxfPH2byRbto66gY4o1NhS47QpKyCoxulTGxILnEIjJ0z
	 bsrIZy8DmYWIySX/0S7c79xQJTx7uDEjV6AWx4TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 173/184] drm/amd/display: Avoid overflow from uint32_t to uint8_t
Date: Thu,  5 Sep 2024 11:41:26 +0200
Message-ID: <20240905093739.090832903@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit d6b54900c564e35989cf6813e4071504fa0a90e0 ]

[WHAT & HOW]
dmub_rb_cmd's ramping_boundary has size of uint8_t and it is assigned
0xFFFF. Fix it by changing it to uint8_t with value of 0xFF.

This fixes 2 INTEGER_OVERFLOW issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c       | 2 +-
 drivers/gpu/drm/amd/display/dc/hwss/dcn21/dcn21_hwseq.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c
index b851fc65f5b7..5c2d6642633d 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c
@@ -258,7 +258,7 @@ bool dmub_abm_set_pipe(struct abm *abm,
 {
 	union dmub_rb_cmd cmd;
 	struct dc_context *dc = abm->ctx;
-	uint32_t ramping_boundary = 0xFFFF;
+	uint8_t ramping_boundary = 0xFF;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.abm_set_pipe.header.type = DMUB_CMD__ABM;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn21/dcn21_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn21/dcn21_hwseq.c
index 804be977ea47..3de65a9f0e6f 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn21/dcn21_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn21/dcn21_hwseq.c
@@ -142,7 +142,7 @@ static bool dmub_abm_set_pipe(struct abm *abm, uint32_t otg_inst,
 {
 	union dmub_rb_cmd cmd;
 	struct dc_context *dc = abm->ctx;
-	uint32_t ramping_boundary = 0xFFFF;
+	uint8_t ramping_boundary = 0xFF;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.abm_set_pipe.header.type = DMUB_CMD__ABM;
-- 
2.43.0



