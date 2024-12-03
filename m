Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4E21E47AD;
	Tue,  3 Dec 2024 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242183; cv=none; b=USgM3rG0NBubBXo+91Jptk4mXC4PGbfHRocpo4XneFy9HaQU0nNPIQ7wA+soMZvFzvMNZI+R7BPE7VmFKwARK+7THwSUz8kgMLggrBpnRaxoAUDRragLwBCaHKY4U5OvWEDD4exG+rNFvBtiARXBnDH6KZ2UiZnTgm/NjW8KRrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242183; c=relaxed/simple;
	bh=UObyBiRxMIyGIitS+Sd9G3/rUnsAsOz6B+EQrALmWsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDoFNMIt1dB69Y6YIG8wWkqrHt5ecLULm3NqiOJP6a2EE92qw/2Tju4uV8bDhjL6aBQ8X8R4bHkN94NZdeWD9lUUgjXNQFYhGEECh+0LRgTsk8/zRcnXs7zvnhF6hUj2GWBgajxfjbCPWMCyxMdQ0DUtWwoY6xkGI1NYBjIzIdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNiZj6GN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNiZj6GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394DFC4CECF;
	Tue,  3 Dec 2024 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242183;
	bh=UObyBiRxMIyGIitS+Sd9G3/rUnsAsOz6B+EQrALmWsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNiZj6GN3TRMMzWvdyamXbLmBiRp0y/ppONCoqFUJ+RQAaA2RnzrdjIlNBQXhjFtZ
	 PAGnpAQtEqMwE2F2xx1FDojMaPkVmtOgG4wocj5ue6CoCD9WHVV+7A/t2xIG9aEipC
	 w+wVTNfJbRg0FCIY/fynqs6poGSEO3yQ2Ln83bGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 614/826] drm/amd/display: Fix null check for pipe_ctx->plane_state in hwss_setup_dpp
Date: Tue,  3 Dec 2024 15:45:41 +0100
Message-ID: <20241203144807.703627436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7ee2be8f82c46..bb766c2a74176 100644
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



