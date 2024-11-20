Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188201AA783;
	Wed, 20 Nov 2024 12:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107523; cv=none; b=XaOacsvdTWlBCziHoKAOocClHkZ3etq3CeK++aqwVpCYos9cKGJ6ohk7WhHACUAjRorH76ZzgYPop9m9fI4jY1AbZ9lnZpzvGMhMIlR+mr59y8mww3TAY6WfAINnubjWF6ULge4QbpnCQTvEnhS2xrAh6bcaWF2qDWid1UKmf/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107523; c=relaxed/simple;
	bh=JPqR6rhf9ReEPqzufigOangaPXXzVrs6DIqcdQQ4qMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YL7uoszvuOTjfo11F0vo0PJSkpxRTuazQcPPBzrfFiwyXU74j3sP5VObsFce+9u/Lf7lgmVwBwQI2va/UnmotEekqgb4HuXmebieBgR8rWPBXJFO1uFI4WIZI15jjm5bTcpipyKP/JqC6aTy0wcpUh6UEkpfeQRKZ16AGsp5yGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsq9uqc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsq9uqc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB7BC4CED6;
	Wed, 20 Nov 2024 12:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107523;
	bh=JPqR6rhf9ReEPqzufigOangaPXXzVrs6DIqcdQQ4qMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsq9uqc8+UEYDDOohidDt56BSffSgDmz04uV5iol6fP5Kfc64u1z5H97FK9ecGJyR
	 d0MFumTOLK8SmzPd5BE7YHKghEkVN+Iul6Knflawu14/2zN2b3vyCvDy566l9abr4s
	 557vvDZswxgI7Kl5pmCanKgNZPunmgbu+id6l37I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 036/107] drm/amd/display: Run idle optimizations at end of vblank handler
Date: Wed, 20 Nov 2024 13:56:11 +0100
Message-ID: <20241120125630.492599855@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Leo Li <sunpeng.li@amd.com>

commit 17e68f89132b9ee4b144358b49e5df404b314181 upstream.

[Why & How]
1. After allowing idle optimizations, hw programming is disallowed.
2. Before hw programming, we need to disallow idle optimizations.

Otherwise, in scenario 1, we will immediately kick hw out of idle
optimizations with register access.

Scenario 2 is less of a concern, since any register access will kick
hw out of idle optimizations. But we'll do it early for correctness.

Signed-off-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -251,9 +251,10 @@ static void amdgpu_dm_crtc_vblank_contro
 	else if (dm->active_vblank_irq_count)
 		dm->active_vblank_irq_count--;
 
-	dc_allow_idle_optimizations(dm->dc, dm->active_vblank_irq_count == 0);
-
-	DRM_DEBUG_KMS("Allow idle optimizations (MALL): %d\n", dm->active_vblank_irq_count == 0);
+	if (dm->active_vblank_irq_count > 0) {
+		DRM_DEBUG_KMS("Allow idle optimizations (MALL): false\n");
+		dc_allow_idle_optimizations(dm->dc, false);
+	}
 
 	/*
 	 * Control PSR based on vblank requirements from OS
@@ -272,6 +273,11 @@ static void amdgpu_dm_crtc_vblank_contro
 			vblank_work->stream->link->replay_settings.replay_feature_enabled);
 	}
 
+	if (dm->active_vblank_irq_count == 0) {
+		DRM_DEBUG_KMS("Allow idle optimizations (MALL): true\n");
+		dc_allow_idle_optimizations(dm->dc, true);
+	}
+
 	mutex_unlock(&dm->dc_lock);
 
 	dc_stream_release(vblank_work->stream);


