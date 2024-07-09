Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F23D27713;
	Tue,  9 Jul 2024 11:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524530; cv=none; b=CUej05KFDWW9g6uKrwVnRQvpM+v0s3Uofepc8vRVZFFiISDwo4jaG61Gl68yWmqh+vRX62n8dZCwaD1hTJRxd6aQnKjfPTNenxmnFrI/qVC+nwNMwmjORVD1WJyfrZRFMLwzdlcDOJLx6gdgvJ9GowS/uLyLdgtRIs6LhVeA3aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524530; c=relaxed/simple;
	bh=iLMgO2Ekka3C0lWIyrhqUYUkVVcolbONhYfjJRkA9hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kz4m7ICQYiLSCh7LyinGAELJzKfPRDo8V3RkXOhsuv2IpPIZZWWOa75CJHidF95PJeZTfV1AxQ6+BN0uwwf9QepwocH3MI3dfwoZ2bUuP/tlogQSNT2M+t2fuaOjjt2xSqLZighJhp9AtKHT7vY7PGsYg2W/bxlxgOdjMqEERxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GniwqUo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GniwqUo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95307C3277B;
	Tue,  9 Jul 2024 11:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524530;
	bh=iLMgO2Ekka3C0lWIyrhqUYUkVVcolbONhYfjJRkA9hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GniwqUo0jS8A31aUi9DX2H8gqBKKC6jRAHraCthkXyF2270/UsaaYtoKWtbS356Zt
	 l/yNx9I52WsRWfseQavhDloYbCXU+VKCBaMjxwINEmouh5UWeWyasobYSkAtko+tSr
	 4MkZZKsAQXJ0fDB9sOowSC2Weos00uChI8MfoJ2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/102] drm/amd/display: Check pipe offset before setting vblank
Date: Tue,  9 Jul 2024 13:09:37 +0200
Message-ID: <20240709110651.923065796@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 5396a70e8cf462ec5ccf2dc8de103c79de9489e6 ]

pipe_ctx has a size of MAX_PIPES so checking its index before accessing
the array.

This fixes an OVERRUN issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/irq/dce110/irq_service_dce110.c    | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/irq/dce110/irq_service_dce110.c b/drivers/gpu/drm/amd/display/dc/irq/dce110/irq_service_dce110.c
index 44649db5f3e32..5646b7788f02e 100644
--- a/drivers/gpu/drm/amd/display/dc/irq/dce110/irq_service_dce110.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dce110/irq_service_dce110.c
@@ -211,8 +211,12 @@ bool dce110_vblank_set(struct irq_service *irq_service,
 						   info->ext_id);
 	uint8_t pipe_offset = dal_irq_src - IRQ_TYPE_VBLANK;
 
-	struct timing_generator *tg =
-			dc->current_state->res_ctx.pipe_ctx[pipe_offset].stream_res.tg;
+	struct timing_generator *tg;
+
+	if (pipe_offset >= MAX_PIPES)
+		return false;
+
+	tg = dc->current_state->res_ctx.pipe_ctx[pipe_offset].stream_res.tg;
 
 	if (enable) {
 		if (!tg || !tg->funcs->arm_vert_intr(tg, 2)) {
-- 
2.43.0



