Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E0121578E;
	Thu, 12 Dec 2024 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015919; cv=none; b=p/0QgI/LJEZomZSqyhr+TKt0gKFifCYFSzNRUDHTpx60E2RtCI2TBkimHNrhY1GH1V6gbJ+cqkHMReyWtCXYxjKe3uXLWZHOz7il40CAmor5iZlFzjJxfVCMK7XZwu8fuuaG/JRywAMOasHECYvQkA+yaGdiQa6xjQtTqQs0FPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015919; c=relaxed/simple;
	bh=4sV9nkzMdFXu486+O3PE5nT6Xi3oL2OBz3wnWzZW/Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQf5nIhJVH7/NL2Ge1+3CFUh7fLeuvR1VPzYSUGvDMfTVbVYZJ+5V7emPv6oT/6t2GPSegngBmovjLmPYouOH1iL05n/1teIsJD+wtflenZXstuEk0xclgS6YeH5AEYiCrHQb93QRtaBM1e916YFGeUB268ix/I03QICJxqi5Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcqLklla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcqLklla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DE0C4CECE;
	Thu, 12 Dec 2024 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015919;
	bh=4sV9nkzMdFXu486+O3PE5nT6Xi3oL2OBz3wnWzZW/Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcqLklla3FH5TmcKb/JIuwJPAT3bTonMoVpm9ZEsp2OX/ENaA45pWhP3igt2IvFtt
	 TiyzARW4SeC3V8M9Wi9O/WFs1vQxmXPITyJ98EbrJY5iOTklCE4f3i+tSW8yk6pnng
	 hTxYu48qfNNmWHm16GGFfnmMOihBcpDSRMtiBG6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Chris Park <chris.park@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/466] drm/amd/display: Ignore scalar validation failure if pipe is phantom
Date: Thu, 12 Dec 2024 15:54:09 +0100
Message-ID: <20241212144309.973306355@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Chris Park <chris.park@amd.com>

[ Upstream commit c33a93201ca07119de90e8c952fbdf65920ab55d ]

[Why]
There are some pipe scaler validation failure when the pipe is phantom
and causes crash in DML validation. Since, scalar parameters are not
as important in phantom pipe and we require this plane to do successful
MCLK switches, the failure condition can be ignored.

[How]
Ignore scalar validation failure if the pipe validation is marked as
phantom pipe.

Cc: stable@vger.kernel.org # 6.11+
Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Chris Park <chris.park@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index df513dbd32bdf..d915020a42958 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1501,6 +1501,10 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 		res = spl_calculate_scaler_params(spl_in, spl_out);
 		// Convert respective out params from SPL to scaler data
 		translate_SPL_out_params_to_pipe_ctx(pipe_ctx, spl_out);
+
+		/* Ignore scaler failure if pipe context plane is phantom plane */
+		if (!res && plane_state->is_phantom)
+			res = true;
 	} else {
 #endif
 	/* depends on h_active */
@@ -1571,6 +1575,10 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 					&plane_state->scaling_quality);
 	}
 
+	/* Ignore scaler failure if pipe context plane is phantom plane */
+	if (!res && plane_state->is_phantom)
+		res = true;
+
 	if (res && (pipe_ctx->plane_res.scl_data.taps.v_taps != temp.v_taps ||
 		pipe_ctx->plane_res.scl_data.taps.h_taps != temp.h_taps ||
 		pipe_ctx->plane_res.scl_data.taps.v_taps_c != temp.v_taps_c ||
-- 
2.43.0



