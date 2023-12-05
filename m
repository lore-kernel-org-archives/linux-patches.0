Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724CA6FAF;
	Tue,  5 Dec 2023 03:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxdHWtRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D11C433C8;
	Tue,  5 Dec 2023 03:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746689;
	bh=ul/emZVqheaehR4hmy0VgBgSwEBGaOS9HD6fIyLhBfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxdHWtRnEWU5Ap6yyAzwrxYfBrMCitzyPmgRTTpduxmj1fY9sQzJGwV1u7QuSwgG5
	 FJSuNeK+VP5T7yw3daRMNUKSgVJiz6ObLB9JBo7yVdYa6Xlt3L/eiBWTXlmrfRTmjA
	 5vc1N2jlBqpvhAlIsRkIOi2MExvjRC/fOpofvgQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/134] drm/i915/gsc: Mark internal GSC engine with reserved uabi class
Date: Tue,  5 Dec 2023 12:16:32 +0900
Message-ID: <20231205031543.071408679@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

[ Upstream commit 503579448db93f9fbcc93cd99a1f2d5aa4b2cda6 ]

The GSC CS is not exposed to the user, so we skipped assigning a uabi
class number for it. However, the trace logs use the uabi class and
instance to identify the engine, so leaving uabi class unset makes the
GSC CS show up as the RCS in those logs.

Given that the engine is not exposed to the user, we can't add a new
case in the uabi enum, so we insted internally define a kernel
internal class as -1.

At the same time remove special handling for the name and complete
the uabi_classes array so internal class is automatically correctly
assigned.

Engine will show as 65535:0 other0 in the logs/traces which should
be unique enough.

v2:
 * Fix uabi class u8 vs u16 type confusion.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: 194babe26bdc ("drm/i915/mtl: don't expose GSC command streamer to the user")
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231116084456.291533-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit dfed6b58d54f3a5d7e6bc1fb060e2c936330eba2)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_user.c | 39 ++++++++++++---------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_user.c b/drivers/gpu/drm/i915/gt/intel_engine_user.c
index dcedff41a825f..d304e0a948f0d 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_user.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_user.c
@@ -42,12 +42,15 @@ void intel_engine_add_user(struct intel_engine_cs *engine)
 		  (struct llist_head *)&engine->i915->uabi_engines);
 }
 
-static const u8 uabi_classes[] = {
+#define I915_NO_UABI_CLASS ((u16)(-1))
+
+static const u16 uabi_classes[] = {
 	[RENDER_CLASS] = I915_ENGINE_CLASS_RENDER,
 	[COPY_ENGINE_CLASS] = I915_ENGINE_CLASS_COPY,
 	[VIDEO_DECODE_CLASS] = I915_ENGINE_CLASS_VIDEO,
 	[VIDEO_ENHANCEMENT_CLASS] = I915_ENGINE_CLASS_VIDEO_ENHANCE,
 	[COMPUTE_CLASS] = I915_ENGINE_CLASS_COMPUTE,
+	[OTHER_CLASS] = I915_NO_UABI_CLASS, /* Not exposed to users, no uabi class. */
 };
 
 static int engine_cmp(void *priv, const struct list_head *A,
@@ -202,6 +205,7 @@ static void engine_rename(struct intel_engine_cs *engine, const char *name, u16
 
 void intel_engines_driver_register(struct drm_i915_private *i915)
 {
+	u16 name_instance, other_instance = 0;
 	struct legacy_ring ring = {};
 	struct list_head *it, *next;
 	struct rb_node **p, *prev;
@@ -219,27 +223,28 @@ void intel_engines_driver_register(struct drm_i915_private *i915)
 		if (intel_gt_has_unrecoverable_error(engine->gt))
 			continue; /* ignore incomplete engines */
 
-		/*
-		 * We don't want to expose the GSC engine to the users, but we
-		 * still rename it so it is easier to identify in the debug logs
-		 */
-		if (engine->id == GSC0) {
-			engine_rename(engine, "gsc", 0);
-			continue;
-		}
-
 		GEM_BUG_ON(engine->class >= ARRAY_SIZE(uabi_classes));
 		engine->uabi_class = uabi_classes[engine->class];
+		if (engine->uabi_class == I915_NO_UABI_CLASS) {
+			name_instance = other_instance++;
+		} else {
+			GEM_BUG_ON(engine->uabi_class >=
+				   ARRAY_SIZE(i915->engine_uabi_class_count));
+			name_instance =
+				i915->engine_uabi_class_count[engine->uabi_class]++;
+		}
+		engine->uabi_instance = name_instance;
 
-		GEM_BUG_ON(engine->uabi_class >=
-			   ARRAY_SIZE(i915->engine_uabi_class_count));
-		engine->uabi_instance =
-			i915->engine_uabi_class_count[engine->uabi_class]++;
-
-		/* Replace the internal name with the final user facing name */
+		/*
+		 * Replace the internal name with the final user and log facing
+		 * name.
+		 */
 		engine_rename(engine,
 			      intel_engine_class_repr(engine->class),
-			      engine->uabi_instance);
+			      name_instance);
+
+		if (engine->uabi_class == I915_NO_UABI_CLASS)
+			continue;
 
 		rb_link_node(&engine->uabi_node, prev, p);
 		rb_insert_color(&engine->uabi_node, &i915->uabi_engines);
-- 
2.42.0



