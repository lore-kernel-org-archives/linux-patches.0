Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70173909B5;
	Sat, 17 Oct 2026 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254080; cv=none; b=CrjQEeRxoFAQ8AyV0X183X0QsWWbVryHwkCjvZbe27sCgduTSKHWgPq1F3vexShj+8mr8jaY5vfreqHSf0ozosYzMHEqqAtwx4uL1vl7I1cABoZhSrIt7k9eMz83PFm6QULad7gxvAGutrfHomShiIp/b/zXODyBJE4nRW2s6yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254080; c=relaxed/simple;
	bh=sp7yLAAVgTJEmYfud4q6/OpXT4y1V36gAfhKNtI3vho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+GcmEjbi6QhprAEcTtNZHrltFP6+tUp9/uVrm61wRKe/qfvkDvdhD1WoJ/+15ZjlpP45KfuMKMUqx+UdkwKD9bRnlty4mxrrBk6QGTuXiuqBsXiHFW+hTc67AC9DXucX6H7QQRKNXmyUe4q5l0iEkN6FhxYiK6Se0xysleLqrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdsPYk8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdsPYk8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A861F000C4;
	Sat, 17 Oct 2026 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254079;
	bh=PvNM06ab/NBmEcDz1SEbuj5GfRWwCJO8ha/akPM25QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdsPYk8GpHm84qibrxn0htP4m1Ps/dH7HN8E8Kqk03AocC5jC+TJQaZlc8EGh1kw9
	 dC6na+dPHVegeSw2N+PV5AOrBcpD5rSTjG+GSSyg35iS1woP1fiSMtiSL0CZyNnEQ2
	 RfjnfUIJcTa3p3RZiz9wcv6Yz30LBHObNtR8KVw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	James Lin <pinglei.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/869] drm/amd/display: Wrap DCN32 phantom-plane allocation in DC_RUN_WITH_PREEMPTION_ENABLED
Date: Sat, 17 Oct 2026 17:52:48 +0200
Message-ID: <20261017160045.462218897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[ Upstream commit 183182235f6d53bac62c6c39014738a54a68dfa6 ]

[Why]
dcn32_validate_bandwidth() wraps dcn32_internal_validate_bw() with
DC_FP_START()/DC_FP_END(). In x86 non-RT, DC_FP_START takes fpregs_lock(),
which disables local softirqs.

The DML1 path through dcn32_enable_phantom_plane() calls kvzalloc() to
allocate ~335 KiB for dc_plane_state. This triggers the vmalloc path,
which calls BUG_ON(in_interrupt()) because it's invoked within the
FPU-enabled (softirq disabled) region, leading to a kernel crash.

[How]
Wrap the dc_state_create_phantom_plane() call with the
DC_RUN_WITH_PREEMPTION_ENABLED() macro to allow preemption during
this memory allocation.

Fixes: 235c67634230 ("drm/amd/display: add DCN32/321 specific files for Display Core")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/4470
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: James Lin <pinglei.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 885ccbef7b94a8b38f69c4211c679021aa27ad11)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/resource/dcn32/dcn32_resource.c    | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index ccfdca7c83f66..1fa4d32ce0be7 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -90,9 +90,14 @@
 #include "dml/dcn32/dcn32_fpu.h"
 
 #include "dc_state_priv.h"
+#include "dc_fpu.h"
 
 #include "dml2/dml2_wrapper.h"
 
+#if !defined(DC_RUN_WITH_PREEMPTION_ENABLED)
+#define DC_RUN_WITH_PREEMPTION_ENABLED(code) code
+#endif
+
 #define DC_LOGGER_INIT(logger)
 
 enum dcn32_clk_src_array_id {
@@ -1649,7 +1654,8 @@ static void dcn32_enable_phantom_plane(struct dc *dc,
 		if (curr_pipe->top_pipe && curr_pipe->top_pipe->plane_state == curr_pipe->plane_state)
 			phantom_plane = prev_phantom_plane;
 		else
-			phantom_plane = dc_state_create_phantom_plane(dc, context, curr_pipe->plane_state);
+			DC_RUN_WITH_PREEMPTION_ENABLED(phantom_plane =
+				dc_state_create_phantom_plane(dc, context, curr_pipe->plane_state));
 
 		if (!phantom_plane)
 			continue;
-- 
2.53.0



