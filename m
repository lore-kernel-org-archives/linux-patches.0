Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841BB1F7572;
	Tue,  3 Dec 2024 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237710; cv=none; b=cua34Jak7jLvJ2JJzy4sR65dpyOCO4ESGVM9iyDG7aaj3CiC1b8CE7mSGQyoF7uLlx0U7mFluOBpw12bULHqWfMfMyt7MXmr1VfgXUKUZkiv0q/510msJyt3T+DNIzR9xuwPxuwkyWhbVDz92cB504YN+QhXWcI0IusvLsADFPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237710; c=relaxed/simple;
	bh=rLfXDwoZowifBqK93eTpec9i5xxy6oSIyp218NKRl1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0vch+FDXnY+aOZ04qAXuFEK4DQGXd1HpimElBmQSXIPrAzw+Olg4XB87MCrzYhHH+Kzt70JLjTCrWYr48UNZzancoBMaxTbK+b8CeMsh+lntQK6HS2xS+ywdbuhTpcM9wFY5SFUSRoB7wnN28z36FSelouVXKmTIMB3JPrcLBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoNijEqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoNijEqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC098C4CED6;
	Tue,  3 Dec 2024 14:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237710;
	bh=rLfXDwoZowifBqK93eTpec9i5xxy6oSIyp218NKRl1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoNijEqWwUDQ4G0pnQqDqAEkNVd6nV7mnmEqX9w2bEz6bSMNBkcFmpKZ5jR8ICGCx
	 Y202lqcy3/VWEtQ1Yy2PUNLNsVgpPqm2FUJ+LxsTQCFZTWfyd7Z1LNlp9qsTbVqWyS
	 0Js4G1cQPQ0xZf7yP5UBgnVEV6s5G48t1KPZb1AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 048/817] drm/amd/display: Fix incorrect DSC recompute trigger
Date: Tue,  3 Dec 2024 15:33:40 +0100
Message-ID: <20241203143957.545647191@linuxfoundation.org>
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

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 4641169a8c95d9efc35d2d3c55c3948f3b375ff9 ]

A stream without dsc_aux should not be eliminated from
the dsc determination. Whether it needs a dsc recompute depends on
whether its mode has changed or not. Eliminating such a no-dsc stream
from the dsc determination policy will end up with inconsistencies
in the new dc_state when compared to the current dc_state,
triggering a dsc recompute that should not have happened.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 0fa922f60ac0a..c6865851e7325 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1313,7 +1313,7 @@ static bool is_dsc_need_re_compute(
 			continue;
 
 		aconnector = (struct amdgpu_dm_connector *) stream->dm_stream_context;
-		if (!aconnector || !aconnector->dsc_aux)
+		if (!aconnector)
 			continue;
 
 		stream_on_link[new_stream_on_link_num] = aconnector;
-- 
2.43.0



