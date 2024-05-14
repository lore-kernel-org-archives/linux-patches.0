Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31E554903;
	Tue, 14 May 2024 11:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684673; cv=none; b=R4yeKCJ+0Hyk9Ym+DoK243pJ5uAvAZjk9s700g55+0QgUVqZCk6kJO6XW+Cqr3bMApMIkCvPKyVp2z6+NObcIkk8OBo3zMO7+GDW9pLliHttmVxHKfjLiJdQYWJFg4CxbcEevPh5zV2l6EOPCxjs+6T8FtWB+kRz2WbiFJHYy0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684673; c=relaxed/simple;
	bh=/XmU+kbw3CghCQn0TzqMN7HoJT3U6YuBep/VTkXd4/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=So8i550481FJBtGIVeMpZzvAr8a3xXsUiIQkKWY7o8aRzPVOeayUhdMeREDOopzDPSqdETM1r4rQCqGj12rg4kHvTzzPuRQOkMjrUhqQdES0QoYAmu50GJ0PlwynSb77PRG71qn2TFvFk7P21zMI4PqJGAcff8LT8SFb4MF9N0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiCDpoj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiCDpoj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F51C2BD10;
	Tue, 14 May 2024 11:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684673;
	bh=/XmU+kbw3CghCQn0TzqMN7HoJT3U6YuBep/VTkXd4/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiCDpoj1sk+brVpO61mwOxV+MUf4FFen0Ui4a2hxFE0mbwmzXerbaed3T5RNhP9Zx
	 +m3he9PY73/K6AwgUSzyv9H0bC6DEFJoHrEoLUf+xhEOGv7Rna6idDrzPenfOpadyL
	 MIGL1plCCo17kPmt9gYL9FkjUO+wM09wUD7ezuaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Koenig <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Shashank Sharma <shashank.sharma@amd.com>,
	Arvind Yadav <arvind.yadav@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/301] drm/amdgpu: fix doorbell regression
Date: Tue, 14 May 2024 12:15:45 +0200
Message-ID: <20240514101035.044863432@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Shashank Sharma <shashank.sharma@amd.com>

[ Upstream commit 705d0480e6ae5a73ca3a9c04316d0678e19a46ed ]

This patch adds a missed handling of PL domain doorbell while
handling VRAM faults.

Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Fixes: a6ff969fe9cb ("drm/amdgpu: fix visible VRAM handling during faults")
Reviewed-by: Christian Koenig <christian.koenig@amd.com>
Signed-off-by: Shashank Sharma <shashank.sharma@amd.com>
Signed-off-by: Arvind Yadav <arvind.yadav@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index d1687b5725693..b95018b1d2ae6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -424,7 +424,7 @@ bool amdgpu_res_cpu_visible(struct amdgpu_device *adev,
 		return false;
 
 	if (res->mem_type == TTM_PL_SYSTEM || res->mem_type == TTM_PL_TT ||
-	    res->mem_type == AMDGPU_PL_PREEMPT)
+	    res->mem_type == AMDGPU_PL_PREEMPT || res->mem_type == AMDGPU_PL_DOORBELL)
 		return true;
 
 	if (res->mem_type != TTM_PL_VRAM)
-- 
2.43.0



