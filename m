Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA6FBE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74928C433C8;
	Mon, 19 Jun 2023 10:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172260;
	bh=25fd95xrGYOnm/q61F4Ai1ieQ4iXieOV5tVedcMo9WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0jHg59ABy5VNkhrR6rq3dGfAg9PPufcwwk4913zjp8Ov1wu/3wzaLUJ5+3nIruXe
	 vXhLR4O/Md/NudY14C/doynJ7vYn+f7lTP9VPiD3AkD0P05yoi214QJSDkiy3gr9Eu
	 VBg0FIUP0OznyNMHa2vy7jj2TSCB7FJNqKqXJazw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clinton Taylor <Clinton.A.Taylor@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Henning Schild <henning.schild@siemens.com>
Subject: [PATCH 5.10 87/89] drm/i915/dg1: Wait for pcode/uncore handshake at startup
Date: Mon, 19 Jun 2023 12:31:15 +0200
Message-ID: <20230619102142.250414336@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit f9c730ede7d3f40900cb493890d94d868ff2f00f ]

DG1 does some additional pcode/uncore handshaking at
boot time; this handshaking must complete before various other pcode
commands are effective and before general work is submitted to the GPU.
We need to poll a new pcode mailbox during startup until it reports that
this handshaking is complete.

The bspec doesn't give guidance on how long we may need to wait for this
handshaking to complete.  For now, let's just set a really long timeout;
if we still don't get a completion status by the end of that timeout,
we'll just continue on and hope for the best.

v2 (Lucas): Rename macros to make clear the relation between command and
   result (requested by José)

Bspec: 52065
Cc: Clinton Taylor <Clinton.A.Taylor@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201001063917.3133475-2-lucas.demarchi@intel.com
Signed-off-by: Henning Schild <henning.schild@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_drv.c       |    3 +++
 drivers/gpu/drm/i915/i915_reg.h       |    3 +++
 drivers/gpu/drm/i915/intel_sideband.c |   15 +++++++++++++++
 drivers/gpu/drm/i915/intel_sideband.h |    2 ++
 4 files changed, 23 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -84,6 +84,7 @@
 #include "intel_gvt.h"
 #include "intel_memory_region.h"
 #include "intel_pm.h"
+#include "intel_sideband.h"
 #include "vlv_suspend.h"
 
 static struct drm_driver driver;
@@ -614,6 +615,8 @@ static int i915_driver_hw_probe(struct d
 	 */
 	intel_dram_detect(dev_priv);
 
+	intel_pcode_init(dev_priv);
+
 	intel_bw_init_hw(dev_priv);
 
 	return 0;
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -9235,6 +9235,9 @@ enum {
 #define     GEN9_SAGV_DISABLE			0x0
 #define     GEN9_SAGV_IS_DISABLED		0x1
 #define     GEN9_SAGV_ENABLE			0x3
+#define   DG1_PCODE_STATUS			0x7E
+#define     DG1_UNCORE_GET_INIT_STATUS		0x0
+#define     DG1_UNCORE_INIT_STATUS_COMPLETE	0x1
 #define GEN12_PCODE_READ_SAGV_BLOCK_TIME_US	0x23
 #define GEN6_PCODE_DATA				_MMIO(0x138128)
 #define   GEN6_PCODE_FREQ_IA_RATIO_SHIFT	8
--- a/drivers/gpu/drm/i915/intel_sideband.c
+++ b/drivers/gpu/drm/i915/intel_sideband.c
@@ -555,3 +555,18 @@ out:
 	return ret ? ret : status;
 #undef COND
 }
+
+void intel_pcode_init(struct drm_i915_private *i915)
+{
+	int ret;
+
+	if (!IS_DGFX(i915))
+		return;
+
+	ret = skl_pcode_request(i915, DG1_PCODE_STATUS,
+				DG1_UNCORE_GET_INIT_STATUS,
+				DG1_UNCORE_INIT_STATUS_COMPLETE,
+				DG1_UNCORE_INIT_STATUS_COMPLETE, 50);
+	if (ret)
+		drm_err(&i915->drm, "Pcode did not report uncore initialization completion!\n");
+}
--- a/drivers/gpu/drm/i915/intel_sideband.h
+++ b/drivers/gpu/drm/i915/intel_sideband.h
@@ -138,4 +138,6 @@ int sandybridge_pcode_write_timeout(stru
 int skl_pcode_request(struct drm_i915_private *i915, u32 mbox, u32 request,
 		      u32 reply_mask, u32 reply, int timeout_base_ms);
 
+void intel_pcode_init(struct drm_i915_private *i915);
+
 #endif /* _INTEL_SIDEBAND_H */


