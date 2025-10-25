Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDACA3043BE;
	Sat, 25 Oct 2025 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409477; cv=none; b=hNUC4kTqeji33Nr/x82B3xpmoi1hnwDVz9vCA+Py0jfefJer0Jmi1RJzUTy/8lKBhlDYK7Fje4SGDUS4IQbK9Px9r82W7SKzzUn0baEI3RXpXGI/TUijJDNmhyI60moqlkrK/ajEAm/xkw01RLxyK8gLPTdBUCRWuIwVNa7O56E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409477; c=relaxed/simple;
	bh=JhfTnhLiMzYvs81BeHSBK+8cAnH6/mIbHjpSeDXsAUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urWEnJT0AwHdXO3P98xQImn0dyiJnjQt7U0M6yfa7u8CHyLxaFPmYVfrEblqYxwsFyvOwdsWSkIpMU5CntYGE8DcdK2jn4JmAHwPBiwi+N+OPGbLzIxAigCvY4xPX3ZpM/cztFgEHHQeVAPt5z5YOIK6ZMJKrKaY1ACHzLoVZRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JwbVIbkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JwbVIbkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A74C4CEF5;
	Sat, 25 Oct 2025 16:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409476;
	bh=JhfTnhLiMzYvs81BeHSBK+8cAnH6/mIbHjpSeDXsAUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwbVIbkUy0DOQrUF+sRB8305cxpSQrcABiqPfY7p3Ag51XK2StdimaoIFqDp5vd8Q
	 P1dv/UIOYZi08gM/ClRskWQ76whsbJPf7JBnpobGtYVgoAmInUPjpJa6MunoinXMnR
	 FXsICynDef1wTCtS4ihwKDELUJTjLzIkR4TBr7JKJk8yVH9DzlGsyV6/0LFgTrlemg
	 m7QvtLrxx+m7lHDsDWofaMLyZQ9hAv4ecHbFoD5cekcnKL7dBEi09LAqOLgVg2Rmmu
	 9HehW09+lnNKKJGPpJqgwy/TfvG+tYHtc/RglSPaFSFpSLONQU6f9h88dPejHzrkeC
	 mx3NFJpCAhLZw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Harrison <John.C.Harrison@Intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matt Atwood <matthew.s.atwood@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.12] drm/xe/guc: Return an error code if the GuC load fails
Date: Sat, 25 Oct 2025 11:59:31 -0400
Message-ID: <20251025160905.3857885-340-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 3b09b11805bfee32d5a0000f5ede42c07237a6c4 ]

Due to multiple explosion issues in the early days of the Xe driver,
the GuC load was hacked to never return a failure. That prevented
kernel panics and such initially, but now all it achieves is creating
more confusing errors when the driver tries to submit commands to a
GuC it already knows is not there. So fix that up.

As a stop-gap and to help with debug of load failures due to invalid
GuC init params, a wedge call had been added to the inner GuC load
function. The reason being that it leaves the GuC log accessible via
debugfs. However, for an end user, simply aborting the module load is
much cleaner than wedging and trying to continue. The wedge blocks
user submissions but it seems that various bits of the driver itself
still try to submit to a dead GuC and lots of subsequent errors occur.
And with regards to developers debugging why their particular code
change is being rejected by the GuC, it is trivial to either add the
wedge back in and hack the return code to zero again or to just do a
GuC log dump to dmesg.

v2: Add support for error injection testing and drop the now redundant
wedge call.

CC: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
Link: https://lore.kernel.org/r/20250909224132.536320-1-John.C.Harrison@Intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this is a pure bug-fix that should go to stable.

- `guc_wait_ucode()` now returns `-EPROTO` when the firmware never
  reaches the “done” state and stops calling
  `xe_device_declare_wedged()` (`drivers/gpu/drm/xe/xe_guc.c:1058` and
  `drivers/gpu/drm/xe/xe_guc.c:1165`). Combined with
  `ALLOW_ERROR_INJECTION(guc_wait_ucode, ERRNO)`
  (`drivers/gpu/drm/xe/xe_guc.c:1180`), the driver can finally detect
  and test the failure path instead of pretending the load succeeded.
- `__xe_guc_upload()` propagates that failure
  (`drivers/gpu/drm/xe/xe_guc.c:1211` and
  `drivers/gpu/drm/xe/xe_guc.c:1221`), so both the early init
  (`drivers/gpu/drm/xe/xe_uc.c:81`) and the regular load/reset flow
  (`drivers/gpu/drm/xe/xe_uc.c:195`) bail out immediately when
  authentication fails. Previously the hard-coded `return 0 /* FIXME */`
  let probe continue, leaving the module “wedged” while still trying to
  talk to a GuC that never booted—exactly the noisy, misleading
  behaviour the commit message describes.
- The change is tightly scoped to the Xe GuC bring-up path; no ABI or
  architectural behaviour changes elsewhere. Failing a GuC load already
  leaves the GPU unusable, so probing failure instead of a half-alive
  wedged device is the safer outcome for end users.
- Dependencies are limited to the existing GuC timing/logging helpers
  that have been in mainline since mid-2024, so current stable trees
  that carry Xe already have the required context.

The only observable difference for users is that a fatal firmware load
failure now aborts driver probe instead of letting the system thrash a
dead GuC, which matches expectations and avoids secondary errors.

 drivers/gpu/drm/xe/xe_guc.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 62c76760fd26f..ab5b69cee3bff 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -1056,7 +1056,7 @@ static s32 guc_pc_get_cur_freq(struct xe_guc_pc *guc_pc)
 #endif
 #define GUC_LOAD_TIME_WARN_MS      200
 
-static void guc_wait_ucode(struct xe_guc *guc)
+static int guc_wait_ucode(struct xe_guc *guc)
 {
 	struct xe_gt *gt = guc_to_gt(guc);
 	struct xe_mmio *mmio = &gt->mmio;
@@ -1163,7 +1163,7 @@ static void guc_wait_ucode(struct xe_guc *guc)
 			break;
 		}
 
-		xe_device_declare_wedged(gt_to_xe(gt));
+		return -EPROTO;
 	} else if (delta_ms > GUC_LOAD_TIME_WARN_MS) {
 		xe_gt_warn(gt, "excessive init time: %lldms! [status = 0x%08X, timeouts = %d]\n",
 			   delta_ms, status, count);
@@ -1175,7 +1175,10 @@ static void guc_wait_ucode(struct xe_guc *guc)
 			  delta_ms, xe_guc_pc_get_act_freq(guc_pc), guc_pc_get_cur_freq(guc_pc),
 			  before_freq, status, count);
 	}
+
+	return 0;
 }
+ALLOW_ERROR_INJECTION(guc_wait_ucode, ERRNO);
 
 static int __xe_guc_upload(struct xe_guc *guc)
 {
@@ -1207,14 +1210,16 @@ static int __xe_guc_upload(struct xe_guc *guc)
 		goto out;
 
 	/* Wait for authentication */
-	guc_wait_ucode(guc);
+	ret = guc_wait_ucode(guc);
+	if (ret)
+		goto out;
 
 	xe_uc_fw_change_status(&guc->fw, XE_UC_FIRMWARE_RUNNING);
 	return 0;
 
 out:
 	xe_uc_fw_change_status(&guc->fw, XE_UC_FIRMWARE_LOAD_FAIL);
-	return 0	/* FIXME: ret, don't want to stop load currently */;
+	return ret;
 }
 
 static int vf_guc_min_load_for_hwconfig(struct xe_guc *guc)
-- 
2.51.0

