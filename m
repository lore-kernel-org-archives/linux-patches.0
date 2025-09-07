Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA1017BB21;
	Sun,  7 Sep 2025 20:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276788; cv=none; b=joftdSq4BfI27ymmYNgS35BITlSxZVjBYIWeUZjlkkb3mu2/63Qc4Q9sij7KtbkDUgCk6ZGbah2AVJlMqMcTSUJsAmSyX6yJbr34sffgvC4CTodRGTrQI0FG47MilJBXqubeUSUxmQbn+LUtWH7iSwDhyvWtdyUo4y+ay7jpajM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276788; c=relaxed/simple;
	bh=LeTBdRjHCyARXTHGVW39E6mrapaDBCn2413WF5moaVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boWkysnDahFcy5oUvyT29fUkQ9iIouUpjuPyC839RhLx9ZqmZVLggQvaRyo384iOHLaaHyPcgdzpk5QeiXwy0YjhEJaoR19qgOtqvg7ci8KIvc8AhLGfiOfU19/8ARVivUVOYicRuIFosDgQ6C4/61jAgCNyAV4OgjYOZAvrLno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po4TokM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po4TokM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB334C4CEF0;
	Sun,  7 Sep 2025 20:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276788;
	bh=LeTBdRjHCyARXTHGVW39E6mrapaDBCn2413WF5moaVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po4TokM/R7XpAyjmCGDcQA3a7eGRBDx+8G04IjlXk+5BqijdEDElHw7CFTGeQadK1
	 WlIGKqZ/FzgLZ6uXUa+8XjfS8VTbLV+UCOuBzRYb0p5HPc9XGcMlJk9uikguM+lE91
	 +43nxRh7ERemVTtNhdjkma9k2mOGqmu+um08DXRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/121] drm/amd/amdgpu: Fix missing error return on kzalloc failure
Date: Sun,  7 Sep 2025 21:59:07 +0200
Message-ID: <20250907195612.696343206@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 467e00b30dfe75c4cfc2197ceef1fddca06adc25 ]

Currently the kzalloc failure check just sets reports the failure
and sets the variable ret to -ENOMEM, which is not checked later
for this specific error. Fix this by just returning -ENOMEM rather
than setting ret.

Fixes: 4fb930715468 ("drm/amd/amdgpu: remove redundant host to psp cmd buf allocations")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1ee9d1a0962c13ba5ab7e47d33a80e3b8dc4b52e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index e9a83865ae012..c83445c2e37f3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -409,7 +409,7 @@ static int psp_sw_init(void *handle)
 	psp->cmd = kzalloc(sizeof(struct psp_gfx_cmd_resp), GFP_KERNEL);
 	if (!psp->cmd) {
 		dev_err(adev->dev, "Failed to allocate memory to command buffer!\n");
-		ret = -ENOMEM;
+		return -ENOMEM;
 	}
 
 	adev->psp.xgmi_context.supports_extended_data =
-- 
2.51.0



