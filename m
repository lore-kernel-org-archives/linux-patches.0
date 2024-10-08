Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207261DE4CC;
	Tue,  8 Oct 2024 12:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391931; cv=none; b=WUbvUL86OT1NpT7HlEff5IjSJsGX4cIuCLm6OcdNJGLxe+e/W/0mL7ifscsWUp2aL4hCmjeDp4Rus18biAFs52lgu+Hkuvrpw9C7Y+Y0k6qQ0IG7KHqyUCCFFgSMx8OYqt2Tf42VCsABIoyiwrlWJeO8QSZKpqY45zVlQ1XeHu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391931; c=relaxed/simple;
	bh=TsPXmKDxIM2uZAqH92l/kQw6ub9pf/06GxFWDwLT2Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUgdc5E3LB68+xk0RcH+DQ2gOJoiSwVQymO7rkbj8UN6B1R+R0tml+txFXBj0S1oM5O5Xt+ncP9GdAX9y/O86Ke05ehXa1QEYX7Rby4uR1ssZXDKRbhfcfxxy3/zRMI5Q5lTBp5SMH5cz7ubqI6+eUrxtMIdFexAC68jyAQLmwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNc98QRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNc98QRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C945C4CEC7;
	Tue,  8 Oct 2024 12:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391931;
	bh=TsPXmKDxIM2uZAqH92l/kQw6ub9pf/06GxFWDwLT2Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNc98QRtWoSEBwUBb7hqyS6nKWcquBH9jpXX7bDaBicaZ5GVTk16QupiI1vLjDm6s
	 bZB4HQuZ/2LUtkhD8fZTWzLvadQJh9gS6d/hUNAkJEw3EJU/hJc68wJm/j98x6cZPC
	 IMjg5fkbleZ/qTwawINq+EAky6uHu5K6y4XAClbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 265/558] drm/amd/display: Check stream_status before it is used
Date: Tue,  8 Oct 2024 14:04:55 +0200
Message-ID: <20241008115712.760754059@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 58a8ee96f84d2c21abb85ad8c22d2bbdf59bd7a9 ]

[WHAT & HOW]
dc_state_get_stream_status can return null, and therefore null must be
checked before stream_status is used.

This fixes 1 NULL_RETURNS issue reported by Coverity.

Signed-off-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 81fab62ef38eb..9e05d77453ac3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3739,7 +3739,7 @@ static void commit_planes_for_stream_fast(struct dc *dc,
 				surface_count,
 				stream,
 				context);
-	} else {
+	} else if (stream_status) {
 		build_dmub_cmd_list(dc,
 				srf_updates,
 				surface_count,
-- 
2.43.0



