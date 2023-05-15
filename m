Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9585DFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B61C4339B;
	Mon, 15 May 2023 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169853;
	bh=8JDlbxaHCXppQq+a//4xQ21vo96uMP4M8S8H5M7uD7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJeG3loql8oJC7YkVZs3e3GwIUWRxRkzsfiGC6+Xg7/htPJTVjpfBpkPnFkmlGnmw
	 WkFVGA5F9Qk9AfgbXW4nbVhhwbA1rBklN0slSQfuap3WM6CSkH5JZViPCdwvfRxWyh
	 9Mh2GQuPD0dJ5fsh7A3tEIsOSzvMkUAYV4jg9AnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Samson Tam <Samson.Tam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 192/246] drm/amd/display: filter out invalid bits in pipe_fuses
Date: Mon, 15 May 2023 18:26:44 +0200
Message-Id: <20230515161728.376460027@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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
@@ -2077,6 +2077,14 @@ static struct resource_funcs dcn32_res_p
 	.restore_mall_state = dcn32_restore_mall_state,
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
@@ -2119,7 +2127,7 @@ static bool dcn32_resource_construct(
 	pool->base.res_cap = &res_cap_dcn32;
 	/* max number of pipes for ASIC before checking for pipe fuses */
 	num_pipes  = pool->base.res_cap->num_timing_generator;
-	pipe_fuses = REG_READ(CC_DC_PIPE_DIS);
+	pipe_fuses = read_pipe_fuses(ctx);
 
 	for (i = 0; i < pool->base.res_cap->num_timing_generator; i++)
 		if (pipe_fuses & 1 << i)
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -1626,6 +1626,14 @@ static struct resource_funcs dcn321_res_
 	.restore_mall_state = dcn32_restore_mall_state,
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
@@ -1668,7 +1676,7 @@ static bool dcn321_resource_construct(
 	pool->base.res_cap = &res_cap_dcn321;
 	/* max number of pipes for ASIC before checking for pipe fuses */
 	num_pipes  = pool->base.res_cap->num_timing_generator;
-	pipe_fuses = REG_READ(CC_DC_PIPE_DIS);
+	pipe_fuses = read_pipe_fuses(ctx);
 
 	for (i = 0; i < pool->base.res_cap->num_timing_generator; i++)
 		if (pipe_fuses & 1 << i)


