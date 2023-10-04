Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D87E1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD3DC433C9;
	Wed,  4 Oct 2023 18:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443219;
	bh=8So0780sD1MHZa3cSCKgXRo6FO8Mj6el8NKJ6xZhGyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1FuHcB+o/agfcmYMwgnj1qZF7BOybjIiNTVfcy1ZnGhtDv4hnYh7SlvKdFJSI/7P
	 YM1nxi3mer5Rx1wjvgGUzFYno5zMcmHG8hV3eMXA7bCO6eKmcVi0Cb0pgkMdfuh9BT
	 eCIaXUAR3iUB8YAyPgOiSlKIq/9eoh9LkRC7qUdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/259] i915/pmu: Move execlist stats initialization to execlist specific setup
Date: Wed,  4 Oct 2023 19:54:12 +0200
Message-ID: <20231004175221.003613161@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit c524cd40e8a2a1a36f4898eaf2024beefeb815f3 ]

engine->stats is a union of execlist and guc stat objects. When execlist
specific fields are initialized, the initial state of guc stats is
affected. This results in bad busyness values when using GuC mode. Move
the execlist initialization from common code to execlist specific code.

Fixes: 77cdd054dd2c ("drm/i915/pmu: Connect engine busyness stats from GuC to pmu")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230912212247.1828681-1-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 4485bd519f5d6d620a29d0547ff3c982bdeeb468)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c            | 1 -
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index b458547e1fc6e..07967adce16aa 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -541,7 +541,6 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id,
 		DRIVER_CAPS(i915)->has_logical_contexts = true;
 
 	ewma__engine_latency_init(&engine->latency);
-	seqcount_init(&engine->stats.execlists.lock);
 
 	ATOMIC_INIT_NOTIFIER_HEAD(&engine->context_status_notifier);
 
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index fc4a846289855..f903ee1ce06e7 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -3546,6 +3546,8 @@ int intel_execlists_submission_setup(struct intel_engine_cs *engine)
 	logical_ring_default_vfuncs(engine);
 	logical_ring_default_irqs(engine);
 
+	seqcount_init(&engine->stats.execlists.lock);
+
 	if (engine->flags & I915_ENGINE_HAS_RCS_REG_STATE)
 		rcs_submission_override(engine);
 
-- 
2.40.1



