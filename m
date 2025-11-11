Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86CF26E706;
	Tue, 11 Nov 2025 01:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824778; cv=none; b=uRvHFfbdOlV4yGKAMw+hEU1G4GsdaMDYP5aRIJAGGqXDlGJByLFXgnECkBcxv/dQ6ruL2qw2ugzNdwV8JRGCU9BiEble1DIwEmRLYxnaKLk9V2bPaZAFdfzvPTPYJ7uOp2iqmmIawTaIked8+RVKrcvwv12qSaeyLdNkavLWTak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824778; c=relaxed/simple;
	bh=l734/eE6AmndzW+kiHjwol0fx+E82zsRAPMEsgbNDio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFLjYjz6NbqLLi9GBxqxLgrkbZRZVxfz8NGeljcyd+gvBn9qEJGmw+orPEkpeQZK4PrpGcIh2D5TK1n09gpJSsyU3yanAzIMPlbqa19YpwT8ourLS+KPWz1a1uIQVQIqPdIcWiD4GZ/Kjx8XJvIBnA1yhN3Ns0OJYwp5/N0w8w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZgW5WsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZgW5WsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68975C116D0;
	Tue, 11 Nov 2025 01:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824778;
	bh=l734/eE6AmndzW+kiHjwol0fx+E82zsRAPMEsgbNDio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZgW5WsHLfIVVa9yM8Y1b95h8QUEIZDlNTX+bWmCidVgdu7OfID3GdLgL8OXH2W3a
	 spYfnib17YABe0VDtigESoVkJWMomur7Dma1Qwds0tcdqoqVTlwcDGQDd97DeLSJHZ
	 DSONcfgYDgrjdZBgiqfB2Fxq8yb51sbOwmOtm7h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Matt Atwood <matthew.s.atwood@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 568/849] drm/xe/guc: Return an error code if the GuC load fails
Date: Tue, 11 Nov 2025 09:42:18 +0900
Message-ID: <20251111004550.144721191@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



