Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208EE1CCB32;
	Tue,  8 Oct 2024 12:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391898; cv=none; b=j+AZSOl3k4NphRpOkZZkp3niQOC1Ue17RGHLCLcmwbE+2NwoUwlOuyzkKMN24ClUsAXPYb1bHf4NgKeckfQAlFOFpTDo2YZRot1YEFEkf9MCjo+5HywHogXc67RTNy8UZ6ImIT9U/+Hhr13WZFifOx3/eAu4Dt/ez41CzRGms5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391898; c=relaxed/simple;
	bh=6eLIzxIxKu3XIfpWCZBmkqP3YJ8EeV5GUsJ0V3dKHaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKgP36/px8sANCpHSVACDEwf7nkeP2cUv2iN8saUwr8HmwT15uN+/p0i8PBNgPVN9PARcVbX67zQ5Y/Iu6H1CyHFDizaVM3F1aqbTjwIOaaBp2CogKFcDYUXKWGRe70lMHxhEYhfOdOLSwojDXJ6yPr4Lt4u1NjYpLRi55Z/mYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3eod+hj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3eod+hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5D6C4CEC7;
	Tue,  8 Oct 2024 12:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391898;
	bh=6eLIzxIxKu3XIfpWCZBmkqP3YJ8EeV5GUsJ0V3dKHaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3eod+hjf5Vo5dvnntiEG9LRajLKqQvnqPEABfwRMTDuD9+2wFwmBY/eTsRouOFxI
	 yXrwcq0LfHuSXdeTlQepOFbtP3eOdzSQqWvCn4CpieJ17LfONpirTSjUstlwsywzEg
	 lv4Hm1GVUIk75/bTwZeRWdVA6Gc9cTtvUgWl2pkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Aberback <joshua.aberback@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Chris Park <chris.park@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 256/558] drm/amd/display: Deallocate DML memory if allocation fails
Date: Tue,  8 Oct 2024 14:04:46 +0200
Message-ID: <20241008115712.408591278@linuxfoundation.org>
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

From: Chris Park <chris.park@amd.com>

[ Upstream commit 892abca6877a96c9123bb1c010cafccdf8ca1b75 ]

[Why]
When DC state create DML memory allocation fails, memory is not
deallocated subsequently, resulting in uninitialized structure
that is not NULL.

[How]
Deallocate memory if DML memory allocation fails.

Reviewed-by: Joshua Aberback <joshua.aberback@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Chris Park <chris.park@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_state.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_state.c b/drivers/gpu/drm/amd/display/dc/core/dc_state.c
index e990346e51f67..665157f8d4cbe 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_state.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_state.c
@@ -211,10 +211,16 @@ struct dc_state *dc_state_create(struct dc *dc, struct dc_state_create_params *p
 #ifdef CONFIG_DRM_AMD_DC_FP
 	if (dc->debug.using_dml2) {
 		dml2_opt->use_clock_dc_limits = false;
-		dml2_create(dc, dml2_opt, &state->bw_ctx.dml2);
+		if (!dml2_create(dc, dml2_opt, &state->bw_ctx.dml2)) {
+			dc_state_release(state);
+			return NULL;
+		}
 
 		dml2_opt->use_clock_dc_limits = true;
-		dml2_create(dc, dml2_opt, &state->bw_ctx.dml2_dc_power_source);
+		if (!dml2_create(dc, dml2_opt, &state->bw_ctx.dml2_dc_power_source)) {
+			dc_state_release(state);
+			return NULL;
+		}
 	}
 #endif
 
-- 
2.43.0



