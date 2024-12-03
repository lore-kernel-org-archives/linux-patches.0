Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949CB1F472A;
	Tue,  3 Dec 2024 15:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239448; cv=none; b=uBVPfhZi82P8e6NgqRE5bMacrG2LMsUGLtV6JZA2EJ2dokwmF7Ypu8wjYv5wA5QyxNQr0lix6LRF6B50kbqpr3lUXuTyPtATAJeWYvm2kxrCjAKG/fgncN/rT0qfUtOXz3kZRv7adWBvD6FznHitUJd69N+/kpqDzSCAILMS+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239448; c=relaxed/simple;
	bh=YzScBklpA51fFJpIZQuXIiEEE3KM6bVASi/hgfh5Mm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViYOE3ay9vNkX/7jjNA/gDkvpAWG+C1IeL3gCLMry/2YpyvtiKb22T/GBbS4qP9YNjQoSngCP3//VRheO4aKXyBnO3L06mBsgZiI15T4yFL/svz+PbEd7rpCiMufH3pDix8j0q1kVxzbXfwJr9jnNWNYyZD/oY2t3GT4IR23bLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Snb8Roh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Snb8Roh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEAAC4CECF;
	Tue,  3 Dec 2024 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239448;
	bh=YzScBklpA51fFJpIZQuXIiEEE3KM6bVASi/hgfh5Mm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Snb8Roh1JbxbLq4iKh+NkrGl1GqS3x6zPfksNpjjEJz0nKbQ5HojwahtbiRlbHJ/4
	 6WXHAt3c+Qd7uGhO7AYffumaWRu6RUea/mCRT2zJDPlIWGcXAr61eigR9YFuHfxb1I
	 4rXJV2YOPxnDjfxC693Jmzi6ltT7CE05dyEEIMiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 618/817] drm/amd/display: Fix null check for pipe_ctx->plane_state in hwss_setup_dpp
Date: Tue,  3 Dec 2024 15:43:10 +0100
Message-ID: <20241203144020.057254132@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Zicheng Qu <quzicheng@huawei.com>

[ Upstream commit 2bc96c95070571c6c824e0d4c7783bee25a37876 ]

This commit addresses a null pointer dereference issue in
hwss_setup_dpp(). The issue could occur when pipe_ctx->plane_state is
null. The fix adds a check to ensure `pipe_ctx->plane_state` is not null
before accessing. This prevents a null pointer dereference.

Fixes: 0baae6246307 ("drm/amd/display: Refactor fast update to use new HWSS build sequence")
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index 4a88412fdfab1..29ef24f9a40f2 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -881,6 +881,9 @@ void hwss_setup_dpp(union block_sequence_params *params)
 	struct dpp *dpp = pipe_ctx->plane_res.dpp;
 	struct dc_plane_state *plane_state = pipe_ctx->plane_state;
 
+	if (!plane_state)
+		return;
+
 	if (dpp && dpp->funcs->dpp_setup) {
 		// program the input csc
 		dpp->funcs->dpp_setup(dpp,
-- 
2.43.0



