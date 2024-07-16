Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FEE19DF78;
	Tue, 16 Jul 2024 15:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144570; cv=none; b=Y4hBEUwnYyMLSThuFg6sOIG7r5es/r37UpnjPTm0EMP9mMrAVPx7DfIeutESt71fG4HgU3CfbqjviNJffnUaBH/kWRORqIo11zWF+mpmwB6dOeFx3V054ScBXBj5g4PeNhP7SkJ9fYEIzMAQgzVxRu/qMrLCh4R1QAmWFKBvYxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144570; c=relaxed/simple;
	bh=MdMSa0kKWfq4f8pSg5dppsN7fMfvAcKtMb2tqOKoSIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCzmex3+ZOT+g5blq7R3bBEFugeqwDYEhHtMESXj+MB+rDhNUcKdzFK9R/Xtrpkjgr4e5vwsbTUEEezyLGkLIvcFWSiI8QXCZ3X5DS4fmHVUghXgf9mjAnHklkau+jh3t/ILh6e5V6CGUXQgYteJ+Re6/1kWTVV+WUn2+XilnlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbYJm6Ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbYJm6Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E6FC4AF0D;
	Tue, 16 Jul 2024 15:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144569;
	bh=MdMSa0kKWfq4f8pSg5dppsN7fMfvAcKtMb2tqOKoSIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbYJm6OkH/ECtWlkpzlDSCCIDk6y1TyXVnvy5OBuwj+NVvbRYTFFFdiirGd41mMPr
	 03AL5RdDyr1BVEehkzgG8o/WyesMGgD6jdduYNX/S8Ming3YCER4HTUhVzK4he3e3B
	 zwWImtsjX7hz8aP1EpxL2ShSZcpyOMfxRiUl3BF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/108] drm/amd/display: Check pipe offset before setting vblank
Date: Tue, 16 Jul 2024 17:30:24 +0200
Message-ID: <20240716152746.355415726@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 378cc11aa0476..3d8b2b127f3f5 100644
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



