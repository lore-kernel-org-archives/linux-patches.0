Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2001519B8;
	Mon, 12 May 2025 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072904; cv=none; b=O1LQGok65u8m3sa6SpmPIbLpFlKBeZmVbggayiUJ0T1VULooJLvu2lnzwMgG6R7oW0hdDjtM/r6FIoGuOAidy7n8HhnJudkqh2xb9SB16l7LjXFJ+Ca4SoZ+xqn4euWZzSyEmxOpcsjJ2UymR089NJj8yqBtek17nhYKSStMIfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072904; c=relaxed/simple;
	bh=YvgcFNPCv+l59RB1pDUWJ4TUd5lJFJKH3lSE14giwzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+zXVvrN88+Ebg3HhIqEirlV/0osKZpTJP15+0vQbvzl1itjs2ZVZzGKF1olx5qHxr7AnX9nDrhoZKb8zhreIbNMmH5zAQBunYm4DkgBnGqIzzzjcvcD1bQF86KobBM4xPFdv/AL0GjNOGBBF6/XbyWpWUm8E0l4w6xgk5e9048=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPe2ieWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPe2ieWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A950C4CEE7;
	Mon, 12 May 2025 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072903;
	bh=YvgcFNPCv+l59RB1pDUWJ4TUd5lJFJKH3lSE14giwzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPe2ieWmGDQQmgYz4CkbM5IO/ty9le/toulNAxBQHXBHVDdeMTX2afnvTMXHhMjOb
	 IYWQtvTpuaHdv+li2j7KGHBgVF1Kdoz85F7kTqzLIFFr0dqLpd+wX/5St9ugBmnGoi
	 n0tcuXIL0EiUljM0LFgl95n7LCKnekefw7und7GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 091/184] drm/amd/display: Fix invalid context error in dml helper
Date: Mon, 12 May 2025 19:44:52 +0200
Message-ID: <20250512172045.534123285@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

commit 9984db63742099ee3f3cff35cf71306d10e64356 upstream.

[Why]
"BUG: sleeping function called from invalid context" error.
after:
"drm/amd/display: Protect FPU in dml2_validate()/dml21_validate()"

The populate_dml_plane_cfg_from_plane_state() uses the GFP_KERNEL flag
for memory allocation, which shouldn't be used in atomic contexts.

The allocation is needed only for using another helper function
get_scaler_data_for_plane().

[How]
Modify helpers to pass a pointer to scaler_data within existing context,
eliminating the need for dynamic memory allocation/deallocation
and copying.

Fixes: 366e77cd4923 ("drm/amd/display: Protect FPU in dml2_validate()/dml21_validate()")
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bd3e84bc98f81b44f2c43936bdadc3241d654259)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c |   14 +++-------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -929,7 +929,9 @@ static void populate_dml_surface_cfg_fro
 	}
 }
 
-static void get_scaler_data_for_plane(const struct dc_plane_state *in, struct dc_state *context, struct scaler_data *out)
+static struct scaler_data *get_scaler_data_for_plane(
+		const struct dc_plane_state *in,
+		struct dc_state *context)
 {
 	int i;
 	struct pipe_ctx *temp_pipe = &context->res_ctx.temp_pipe;
@@ -950,7 +952,7 @@ static void get_scaler_data_for_plane(co
 	}
 
 	ASSERT(i < MAX_PIPES);
-	memcpy(out, &temp_pipe->plane_res.scl_data, sizeof(*out));
+	return &temp_pipe->plane_res.scl_data;
 }
 
 static void populate_dummy_dml_plane_cfg(struct dml_plane_cfg_st *out, unsigned int location,
@@ -1013,11 +1015,7 @@ static void populate_dml_plane_cfg_from_
 						    const struct dc_plane_state *in, struct dc_state *context,
 						    const struct soc_bounding_box_st *soc)
 {
-	struct scaler_data *scaler_data = kzalloc(sizeof(*scaler_data), GFP_KERNEL);
-	if (!scaler_data)
-		return;
-
-	get_scaler_data_for_plane(in, context, scaler_data);
+	struct scaler_data *scaler_data = get_scaler_data_for_plane(in, context);
 
 	out->CursorBPP[location] = dml_cur_32bit;
 	out->CursorWidth[location] = 256;
@@ -1082,8 +1080,6 @@ static void populate_dml_plane_cfg_from_
 	out->DynamicMetadataTransmittedBytes[location] = 0;
 
 	out->NumberOfCursors[location] = 1;
-
-	kfree(scaler_data);
 }
 
 static unsigned int map_stream_to_dml_display_cfg(const struct dml2_context *dml2,


