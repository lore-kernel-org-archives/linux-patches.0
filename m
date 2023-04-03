Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D566FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2052CC433D2;
	Mon,  3 Apr 2023 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533205;
	bh=JN9YqzKVUHlvafYfS95SQ1f8FKGv2UnGqBIudw//A0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3dVM229AwAhLIRU4MZ3TqrX/ltsvfhLzefuEWoM27shkKwlhN9P8qDr4RVe97VZi
	 zdm1NRZLugF4A9s1+gpl+Rk6SdZB9iIll1xFC+tQ9Ny6E4/xZI/uyxyPGzfwDmByPf
	 /8rTrLVz8PdmuiRC4fFn+i58WDmXTuPWylfWNx1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 095/187] drm/i915/perf: Drop wakeref on GuC RC error
Date: Mon,  3 Apr 2023 16:09:00 +0200
Message-Id: <20230403140419.110969504@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Wilson <chris.p.wilson@linux.intel.com>

[ Upstream commit 5c95b2d5d44fa250ce8aeee27bdb39b381d03857 ]

If we fail to adjust the GuC run-control on opening the perf stream,
make sure we unwind the wakeref just taken.

v2: Retain old goto label names (Ashutosh)
v3: Drop bitfield boolean

Fixes: 01e742746785 ("drm/i915/guc: Support OA when Wa_16011777198 is enabled")
Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230323225901.3743681-2-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 2810ac6c753d17ee2572ffb57fe2382a786a080a)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_perf.c       | 14 +++++++++-----
 drivers/gpu/drm/i915/i915_perf_types.h |  6 ++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 125b6ca25a756..7d5e2c53c23a7 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1592,9 +1592,7 @@ static void i915_oa_stream_destroy(struct i915_perf_stream *stream)
 	/*
 	 * Wa_16011777198:dg2: Unset the override of GUCRC mode to enable rc6.
 	 */
-	if (intel_uc_uses_guc_rc(&gt->uc) &&
-	    (IS_DG2_GRAPHICS_STEP(gt->i915, G10, STEP_A0, STEP_C0) ||
-	     IS_DG2_GRAPHICS_STEP(gt->i915, G11, STEP_A0, STEP_B0)))
+	if (stream->override_gucrc)
 		drm_WARN_ON(&gt->i915->drm,
 			    intel_guc_slpc_unset_gucrc_mode(&gt->uc.guc.slpc));
 
@@ -3293,8 +3291,10 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 		if (ret) {
 			drm_dbg(&stream->perf->i915->drm,
 				"Unable to override gucrc mode\n");
-			goto err_config;
+			goto err_gucrc;
 		}
+
+		stream->override_gucrc = true;
 	}
 
 	ret = alloc_oa_buffer(stream);
@@ -3333,11 +3333,15 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 	free_oa_buffer(stream);
 
 err_oa_buf_alloc:
-	free_oa_configs(stream);
+	if (stream->override_gucrc)
+		intel_guc_slpc_unset_gucrc_mode(&gt->uc.guc.slpc);
 
+err_gucrc:
 	intel_uncore_forcewake_put(stream->uncore, FORCEWAKE_ALL);
 	intel_engine_pm_put(stream->engine);
 
+	free_oa_configs(stream);
+
 err_config:
 	free_noa_wait(stream);
 
diff --git a/drivers/gpu/drm/i915/i915_perf_types.h b/drivers/gpu/drm/i915/i915_perf_types.h
index ca150b7af3f29..4d5d8c365d9e2 100644
--- a/drivers/gpu/drm/i915/i915_perf_types.h
+++ b/drivers/gpu/drm/i915/i915_perf_types.h
@@ -316,6 +316,12 @@ struct i915_perf_stream {
 	 * buffer should be checked for available data.
 	 */
 	u64 poll_oa_period;
+
+	/**
+	 * @override_gucrc: GuC RC has been overridden for the perf stream,
+	 * and we need to restore the default configuration on release.
+	 */
+	bool override_gucrc;
 };
 
 /**
-- 
2.39.2



