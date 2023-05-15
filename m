Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC55FFBFD
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D837C4339B;
	Mon, 15 May 2023 17:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170538;
	bh=Ij2MPBpicVaoUxHh4iI46HT+B/nAyHsmpx57MDj6Woo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRsREMEp3mOV5LtZ0+/EOQCy8xMrRiyZ52se9SIcEK2lqzbHx9pA+eH7AXQogBcvF
	 UlxHgvhr4SgVLTZprSorZ9u4dSHWRTvbiZrIQtsB6OnbfpNtLlxCl2hwtyv8ahJYI0
	 /TH7bxLO1xgpewK5X8fQ8DMmw8aurhspkJFh/gu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Samson Tam <Samson.Tam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 163/239] drm/amd/display: filter out invalid bits in pipe_fuses
Date: Mon, 15 May 2023 18:27:06 +0200
Message-Id: <20230515161726.562064875@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samson Tam <Samson.Tam@amd.com>

commit 682439fffad9fa9a38d37dd1b1318e9374232213 upstream.

[Why]
Reading pipe_fuses from register may have invalid bits set, which may
 affect the num_pipes erroneously.

[How]
Add read_pipes_fuses() call and filter bits based on expected number
 of pipes.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c   |   10 +++++++++-
 drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c |   10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -2037,6 +2037,14 @@ static struct resource_funcs dcn32_res_p
 	.remove_phantom_pipes = dcn32_remove_phantom_pipes,
 };
 
+static uint32_t read_pipe_fuses(struct dc_context *ctx)
+{
+	uint32_t value = REG_READ(CC_DC_PIPE_DIS);
+	/* DCN32 support max 4 pipes */
+	value = value & 0xf;
+	return value;
+}
+
 
 static bool dcn32_resource_construct(
 	uint8_t num_virtual_links,
@@ -2079,7 +2087,7 @@ static bool dcn32_resource_construct(
 	pool->base.res_cap = &res_cap_dcn32;
 	/* max number of pipes for ASIC before checking for pipe fuses */
 	num_pipes  = pool->base.res_cap->num_timing_generator;
-	pipe_fuses = REG_READ(CC_DC_PIPE_DIS);
+	pipe_fuses = read_pipe_fuses(ctx);
 
 	for (i = 0; i < pool->base.res_cap->num_timing_generator; i++)
 		if (pipe_fuses & 1 << i)
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -1621,6 +1621,14 @@ static struct resource_funcs dcn321_res_
 	.remove_phantom_pipes = dcn32_remove_phantom_pipes,
 };
 
+static uint32_t read_pipe_fuses(struct dc_context *ctx)
+{
+	uint32_t value = REG_READ(CC_DC_PIPE_DIS);
+	/* DCN321 support max 4 pipes */
+	value = value & 0xf;
+	return value;
+}
+
 
 static bool dcn321_resource_construct(
 	uint8_t num_virtual_links,
@@ -1663,7 +1671,7 @@ static bool dcn321_resource_construct(
 	pool->base.res_cap = &res_cap_dcn321;
 	/* max number of pipes for ASIC before checking for pipe fuses */
 	num_pipes  = pool->base.res_cap->num_timing_generator;
-	pipe_fuses = REG_READ(CC_DC_PIPE_DIS);
+	pipe_fuses = read_pipe_fuses(ctx);
 
 	for (i = 0; i < pool->base.res_cap->num_timing_generator; i++)
 		if (pipe_fuses & 1 << i)


