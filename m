Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE42208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGkv1Fpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14754C433C7;
	Tue, 31 Oct 2023 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774530;
	bh=0EpyeYaqOJ9K9NdtFxAKL7CCPnX2lc/hFiMVYmy61vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGkv1FpwmndypNQX+BTEuaI2EJqyBBFyAXHXjBcEOt8OIjF7BcQ1ugCaBrj9U/Eoy
	 VIDKK1x213YxKwr4qD1Bxegq072S28hHeoj2Km6Vx5pl3Acg68gbg++MU8RN5Frk9p
	 9HdyNAWrGUMDZfwUIqYOlQvn6DNsbn1ziidW6GF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 078/112] drm/i915/mcr: Hold GT forcewake during steering operations
Date: Tue, 31 Oct 2023 18:01:19 +0100
Message-ID: <20231031165903.780681058@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 78cc55e0b64c820673a796635daf82c7eadfe152 ]

The steering control and semaphore registers are inside an "always on"
power domain with respect to RC6.  However there are some issues if
higher-level platform sleep states are entering/exiting at the same time
these registers are accessed.  Grabbing GT forcewake and holding it over
the entire lock/steer/unlock cycle ensures that those sleep states have
been fully exited before we access these registers.

This is expected to become a formally documented/numbered workaround
soon.

Note that this patch alone isn't expected to have an immediately
noticeable impact on MCR (mis)behavior; an upcoming pcode firmware
update will also be necessary to provide the other half of this
workaround.

v2:
 - Move the forcewake inside the Xe_LPG-specific IP version check.  This
   should only be necessary on platforms that have a steering semaphore.

Fixes: 3100240bf846 ("drm/i915/mtl: Add hardware-level lock for steering")
Cc: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231019170241.2102037-2-matthew.d.roper@intel.com
(cherry picked from commit 8fa1c7cd1fe9cdfc426a603e1f1eecd3f463c487)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_mcr.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_mcr.c b/drivers/gpu/drm/i915/gt/intel_gt_mcr.c
index 0b414eae16831..2c0f1f3e28ff8 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_mcr.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_mcr.c
@@ -376,9 +376,26 @@ void intel_gt_mcr_lock(struct intel_gt *gt, unsigned long *flags)
 	 * driver threads, but also with hardware/firmware agents.  A dedicated
 	 * locking register is used.
 	 */
-	if (GRAPHICS_VER_FULL(gt->i915) >= IP_VER(12, 70))
+	if (GRAPHICS_VER_FULL(gt->i915) >= IP_VER(12, 70)) {
+		/*
+		 * The steering control and semaphore registers are inside an
+		 * "always on" power domain with respect to RC6.  However there
+		 * are some issues if higher-level platform sleep states are
+		 * entering/exiting at the same time these registers are
+		 * accessed.  Grabbing GT forcewake and holding it over the
+		 * entire lock/steer/unlock cycle ensures that those sleep
+		 * states have been fully exited before we access these
+		 * registers.  This wakeref will be released in the unlock
+		 * routine.
+		 *
+		 * This is expected to become a formally documented/numbered
+		 * workaround soon.
+		 */
+		intel_uncore_forcewake_get(gt->uncore, FORCEWAKE_GT);
+
 		err = wait_for(intel_uncore_read_fw(gt->uncore,
 						    MTL_STEER_SEMAPHORE) == 0x1, 100);
+	}
 
 	/*
 	 * Even on platforms with a hardware lock, we'll continue to grab
@@ -415,8 +432,11 @@ void intel_gt_mcr_unlock(struct intel_gt *gt, unsigned long flags)
 {
 	spin_unlock_irqrestore(&gt->mcr_lock, flags);
 
-	if (GRAPHICS_VER_FULL(gt->i915) >= IP_VER(12, 70))
+	if (GRAPHICS_VER_FULL(gt->i915) >= IP_VER(12, 70)) {
 		intel_uncore_write_fw(gt->uncore, MTL_STEER_SEMAPHORE, 0x1);
+
+		intel_uncore_forcewake_put(gt->uncore, FORCEWAKE_GT);
+	}
 }
 
 /**
-- 
2.42.0



