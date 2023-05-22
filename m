Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793BD168DC
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF05BC433D2;
	Mon, 22 May 2023 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784388;
	bh=6anfZKSvwQTDrRBdBae+lWkNBHZlBw0TYWc1NmZRF4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNGsV9ZOVNkErxst4vArX9opakXu/j//Tdag7hTWX65120I6dX3zW11fYacaeGkiZ
	 r2xGC8RW2kka+wVtRxk45Y57LdvTcdttzP+tVZ/o/WvmI0vrNtZIGjxqn79MIpPj5K
	 Lwu6UGhZ2wRCb4c+YYEwRTOqhGyBfgJQt6Hcdjss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 034/364] drm/i915: taint kernel when force probing unsupported devices
Date: Mon, 22 May 2023 20:05:39 +0100
Message-Id: <20230522190413.685598306@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 79c901c93562bdf1c84ce6c1b744fbbe4389a6eb ]

For development and testing purposes, the i915.force_probe module
parameter and DRM_I915_FORCE_PROBE kconfig option allow probing of
devices that aren't supported by the driver.

The i915.force_probe module parameter is "unsafe" and setting it taints
the kernel. However, using the kconfig option does not.

Always taint the kernel when force probing a device that is not
supported.

v2: Drop "depends on EXPERT" to avoid build breakage (kernel test robot)

Fixes: 7ef5ef5cdead ("drm/i915: add force_probe module parameter to replace alpha_support")
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230504103508.1818540-1-jani.nikula@intel.com
(cherry picked from commit 3312bb4ad09ca6423bd4a5b15a94588a8962fb8e)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/Kconfig    | 12 +++++++-----
 drivers/gpu/drm/i915/i915_pci.c |  6 ++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index 98f4e44976e09..9c9bb0a0dcfca 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -62,10 +62,11 @@ config DRM_I915_FORCE_PROBE
 	  This is the default value for the i915.force_probe module
 	  parameter. Using the module parameter overrides this option.
 
-	  Force probe the i915 for Intel graphics devices that are
-	  recognized but not properly supported by this kernel version. It is
-	  recommended to upgrade to a kernel version with proper support as soon
-	  as it is available.
+	  Force probe the i915 driver for Intel graphics devices that are
+	  recognized but not properly supported by this kernel version. Force
+	  probing an unsupported device taints the kernel. It is recommended to
+	  upgrade to a kernel version with proper support as soon as it is
+	  available.
 
 	  It can also be used to block the probe of recognized and fully
 	  supported devices.
@@ -75,7 +76,8 @@ config DRM_I915_FORCE_PROBE
 	  Use "<pci-id>[,<pci-id>,...]" to force probe the i915 for listed
 	  devices. For example, "4500" or "4500,4571".
 
-	  Use "*" to force probe the driver for all known devices.
+	  Use "*" to force probe the driver for all known devices. Not
+	  recommended.
 
 	  Use "!" right before the ID to block the probe of the device. For
 	  example, "4500,!4571" forces the probe of 4500 and blocks the probe of
diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
index 125f7ef1252c3..2b5aaea422208 100644
--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -1346,6 +1346,12 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
+	if (intel_info->require_force_probe) {
+		dev_info(&pdev->dev, "Force probing unsupported Device ID %04x, tainting kernel\n",
+			 pdev->device);
+		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+	}
+
 	/* Only bind to function 0 of the device. Early generations
 	 * used function 1 as a placeholder for multi-head. This causes
 	 * us confusion instead, especially on the systems where both
-- 
2.39.2



