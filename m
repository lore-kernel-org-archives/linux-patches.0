Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACB51CAA7;
	Sat,  3 Feb 2024 04:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933860; cv=none; b=Okp8zUd1s4TQRLKM4tOURiGLheE1ae6nlKyhB2Xrv9QAqAlDSZL+jboHPwYANWplkeAal9iVopziQbYu9TIwskL17K+XQ8UEp3HIkCykES0rICEeKb6qmyCItVMx+n5DceSQ9KKGaiOAYszFaiUIrdS6lZT+JrasO62OnsqR1IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933860; c=relaxed/simple;
	bh=nfT+3jKhPr/rxaWsYQKrdYhdVarLwvzxp8IofjXTPDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/1C5UgWy0nhQosXnGRLbPlY6xCv/XPupHN76II3o84NLIalwAgdjBfOBDP/vzymiMPq0LaTBPf+ASyGS2N9G+EdPylghbhvJUPqbzGTQ2hDW1yfpYqMn42BZ9Wei//4Jd3DIf70ZUh/aKNzxs9oNLCqSvTjsKckUkyHEcTR/bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wykx7HSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wykx7HSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F5EC433F1;
	Sat,  3 Feb 2024 04:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933860;
	bh=nfT+3jKhPr/rxaWsYQKrdYhdVarLwvzxp8IofjXTPDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wykx7HSGfl1Rqw1jISf2NLZiimQy07ObOTPKNt3x1huJb4LmWKaOy+NKaBLu6UmiC
	 2XY4lYx/f6QUFJTilmXSXAjGyLVykaBvijylHPhqWsaDl/zDkg6nCz3pnP62bcsWDl
	 yTbGxx5kqBrKw6zdileEZ3o9gdFaQ7WnYHnaOXM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 171/353] drm/amd/display: Fix tiled display misalignment
Date: Fri,  2 Feb 2024 20:04:49 -0800
Message-ID: <20240203035409.048049845@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>

[ Upstream commit c4b8394e76adba4f50a3c2696c75b214a291e24a ]

[Why]
When otg workaround is applied during clock update, otgs of
tiled display went out of sync.

[How]
To call dc_trigger_sync() after clock update to sync otgs again.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index bc098098345c..bbdeda489768 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1964,6 +1964,10 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 		wait_for_no_pipes_pending(dc, context);
 		/* pplib is notified if disp_num changed */
 		dc->hwss.optimize_bandwidth(dc, context);
+		/* Need to do otg sync again as otg could be out of sync due to otg
+		 * workaround applied during clock update
+		 */
+		dc_trigger_sync(dc, context);
 	}
 
 	if (dc->hwss.update_dsc_pg)
-- 
2.43.0



