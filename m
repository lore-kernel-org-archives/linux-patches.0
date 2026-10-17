Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABD92D73A6;
	Sat, 17 Oct 2026 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256955; cv=none; b=fizu3++ZX2kCFqCns5l4ly+VwH+b84TF3CprgfJApLdwGXUo3R5xyqEDSjdZ6QY9wQ7vPB0NvcUlqtNxIqqUxxbuSbC0dtRLSJKn/I1rQ319MGLZ291V/l0iyORsuuquZOLqahcbpEHB6ezCdtlyUQylwhfbvAiGhoZjhfeCsgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256955; c=relaxed/simple;
	bh=0VpaAxPbhiLPni+dtspJ3lGww6E7NV+e24UcmL+uJDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZPAM9ak+N9V5kNG/1pnZQFW/YKe6HPvGAlpwiVTaglAWUtQ28mgqbO9B04W9ixTzCu2SJtTdDE4nQUiPae6jL67WIn1UFnLtBWsCPBAcS5+G2XySeXfUq706Z5UHmWyJB03VfqdIUZPLpnbkHUpuoSCciCPxtVdn/v2gxvdL2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bjARSVu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bjARSVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C65D1F000C4;
	Sat, 17 Oct 2026 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256954;
	bh=JETce3qnTJyYBhn+XmlotjrkmU6FOlQjiY6rN88SC6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bjARSVuhaExtLS88bLv+2ONL1LFGSAHItNxc7FYYosOOlPUUz4ZYws4W/9wzFW9q
	 CwOMLh2Bb8P5KgXbraUruBDgQk4lgLOdYbtiuAb1qwXehNfQi3sHwsYlKBQr4JtzEo
	 YXubL6dXgdr3OQfNAAPh37h90/LAOExXLyZ6sun4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0388/1674] drm/amd/display: check dc_state_create_copy() for NULL in dm_suspend
Date: Sat, 17 Oct 2026 17:44:20 +0200
Message-ID: <20261017160441.069890589@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit 015e72cde567d2450e282c2790773463156b2d0a ]

dc_state_create_copy() can return NULL on allocation failure.
dm_suspend() only conditionally skips dm_gpureset_toggle_interrupts()
and continues execution, returning success.  dm_resume() then
dereferences the NULL cached_dc_state in link_enc_cfg_copy() and the
following dc_state->stream_count loop, crashing during GPU reset
recovery.

Return -ENOMEM immediately if the copy fails, so the caller aborts
suspend instead of leaving a NULL cached state for resume.

Fixes: 8092aa3ab8f7 ("drm/amd/display: Add null checker before passing variables")
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 84b6d7932fdd2857795a257f9f258562a3cddcab)
Cc: stable@vger.kernel.org
[ sashal: Adjusted context for dc_copy_state() instead of dc_state_create_copy(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4b03bb4b913f8..530b85a22222b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2639,9 +2639,14 @@ static int dm_suspend(void *handle)
 		dc_allow_idle_optimizations(adev->dm.dc, false);
 
 		dm->cached_dc_state = dc_copy_state(dm->dc->current_state);
+		if (!dm->cached_dc_state) {
+			drm_err(adev_to_drm(adev),
+				"Failed to allocate cached DC state during suspend\n");
+			mutex_unlock(&dm->dc_lock);
+			return -ENOMEM;
+		}
 
-		if (dm->cached_dc_state)
-			dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
+		dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
 
 		amdgpu_dm_commit_zero_streams(dm->dc);
 
-- 
2.53.0



