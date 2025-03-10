Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BE22356D1;
	Mon, 10 Mar 2025 17:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627489; cv=none; b=JuzhPsI+myCyA6aFRxJoTLOf4OhVMcqZ2UyNkSMAWcUitzINcUZrZDGMobjFv2hQoGbRUIiuA4UK5dnveaoUlXISN5uuFj9Xfi6CdOnOC/pnFVO/+xIpiv44tJpCp2+eiMQKEu/KDewilAgFXKfzCouy+x6XsCXm2ww8CBb9P08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627489; c=relaxed/simple;
	bh=gfe00VXttz7BGADwFSx0NnZ0BzxAlMfoQhMJwwC4IXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNx5cYPcI2Ne45vAeChrG4UW34+rYu05Pe20uX1cc4GQff5PlAHHiyfDghew542EWsW8ZMWQwabx59iGoLvsS05rIbfjLlpctIv0WMgqhbpEMdwq0gAR0fIl3FSU51w1YIALKQZ7F0UO/lT2ay9Csi0i8Z7TCB+2baPRXbHo07Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVkwO26v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVkwO26v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0984AC4CEE5;
	Mon, 10 Mar 2025 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627489;
	bh=gfe00VXttz7BGADwFSx0NnZ0BzxAlMfoQhMJwwC4IXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVkwO26vONkTC1EBlu3xAYHRCtPw4H9qHeEpPf5OsCrGUXqs0YC368WfE6gNNYnsW
	 tsMlhI3m4LaS6WhH1Kr28WOmvyw8VnCEwVoURptqR3OAPiPwJjoRf1onWTsot8Oryu
	 PYGzMOqBjvFcQ/xoGn3bw0VXCRGCdA7FCAe4NuZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 115/269] drm/xe: Fix GT "for each engine" workarounds
Date: Mon, 10 Mar 2025 18:04:28 +0100
Message-ID: <20250310170502.303514757@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 54f94dc7f6b4db45dbc23b4db3d20c7194e2c54f upstream.

Any rules using engine matching are currently broken due RTP processing
happening too in early init, before the list of hardware engines has been
initialised.

Fix this by moving workaround processing to later in the driver probe
sequence, to just before the processed list is used for the first time.

Looking at the debugfs gt0/workarounds on ADL-P we notice 14011060649
should be present while we see, before:

 GT Workarounds
     14011059788
     14015795083

And with the patch:

 GT Workarounds
     14011060649
     14011059788
     14015795083

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: stable@vger.kernel.org # v6.11+
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250227101304.46660-2-tvrtko.ursulin@igalia.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 25d434cef791e03cf40680f5441b576c639bfa84)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -379,9 +379,7 @@ int xe_gt_init_early(struct xe_gt *gt)
 	if (err)
 		return err;
 
-	xe_wa_process_gt(gt);
 	xe_wa_process_oob(gt);
-	xe_tuning_process_gt(gt);
 
 	xe_force_wake_init_gt(gt, gt_to_fw(gt));
 	spin_lock_init(&gt->global_invl_lock);
@@ -469,6 +467,8 @@ static int all_fw_domain_init(struct xe_
 		goto err_hw_fence_irq;
 
 	xe_gt_mcr_set_implicit_defaults(gt);
+	xe_wa_process_gt(gt);
+	xe_tuning_process_gt(gt);
 	xe_reg_sr_apply_mmio(&gt->reg_sr, gt);
 
 	err = xe_gt_clock_init(gt);


