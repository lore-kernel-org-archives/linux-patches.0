Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAC71C3BE0;
	Mon, 12 May 2025 17:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072001; cv=none; b=uwIcpck01bnWTtw9D8AVpe3vJDVUoLVESXo4VongwdSM/5e8RtFis+fxzsdNygaMjtmNxe2bGOHU77LNCbf/8K7RPuctmmOrk9WD+res9gOnSvAVrLfEAoFpatX3pktNqHil4mnMQb/m8tRj5eYTpWievc1RlCrwjDwMStQdFUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072001; c=relaxed/simple;
	bh=kREj/TTFDvTcOZeCJ6YD1Qq5iIdxrCtTD7EkHM7VTH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XihjRJkuOA6Cf5JN5pKeBgfkh7fj/WDIyq45oXOeXBb3G3uRWSuFlCPyCe6fdHGTUW/5+OHLf3WZxA6ir+6iykJ25qlV15ZZ5hCStoXqIABCXT3dYFvvzgZlTAQRIr6sLLl4p8OQRHNDytSVRmWHfjDhecR1fRjZfdXq5ZPRDsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UymIJJq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UymIJJq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D802DC4CEE7;
	Mon, 12 May 2025 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072001;
	bh=kREj/TTFDvTcOZeCJ6YD1Qq5iIdxrCtTD7EkHM7VTH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UymIJJq15moT32K1t1R6KLmi4PLclxMkcrmpW2xHQDXO1lud9FY7Y5GNqfv0e55fh
	 1UHrqhm8QYOY8pL8IZJS2bb0JcfgdBjT5HSUAKpSCLYkWHE+Td7tXeJbMGK4bIwbny
	 FA3ZWLbka360MoYz4nuJ+AyTyi5Q0WFZAbvUgadI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 106/197] drm/amd/display: Fix invalid context error in dml helper
Date: Mon, 12 May 2025 19:39:16 +0200
Message-ID: <20250512172048.697284306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -969,7 +969,9 @@ static void populate_dml_surface_cfg_fro
 	}
 }
 
-static void get_scaler_data_for_plane(const struct dc_plane_state *in, struct dc_state *context, struct scaler_data *out)
+static struct scaler_data *get_scaler_data_for_plane(
+		const struct dc_plane_state *in,
+		struct dc_state *context)
 {
 	int i;
 	struct pipe_ctx *temp_pipe = &context->res_ctx.temp_pipe;
@@ -990,7 +992,7 @@ static void get_scaler_data_for_plane(co
 	}
 
 	ASSERT(i < MAX_PIPES);
-	memcpy(out, &temp_pipe->plane_res.scl_data, sizeof(*out));
+	return &temp_pipe->plane_res.scl_data;
 }
 
 static void populate_dummy_dml_plane_cfg(struct dml_plane_cfg_st *out, unsigned int location,
@@ -1053,11 +1055,7 @@ static void populate_dml_plane_cfg_from_
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
@@ -1122,8 +1120,6 @@ static void populate_dml_plane_cfg_from_
 	out->DynamicMetadataTransmittedBytes[location] = 0;
 
 	out->NumberOfCursors[location] = 1;
-
-	kfree(scaler_data);
 }
 
 static unsigned int map_stream_to_dml_display_cfg(const struct dml2_context *dml2,


