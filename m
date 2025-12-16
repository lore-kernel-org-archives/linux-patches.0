Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DC3385CD9;
	Tue, 16 Dec 2025 12:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888625; cv=none; b=e6dzoR2fcfQ1btwdcbyZJYMxkCnH0HNiJvVPgXKUevuHFDt8I2yKkVRpElyJ2ufRZkxTPqGBpTVwT13HXiP4WdVhPxxlI8InGcqZ1BZsjjIa406OKZVTZ+OPQwD+taAxDCk3EkFAfQaluYPgYGjRH+EKycXrp5ps1+MIpjhGMHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888625; c=relaxed/simple;
	bh=RCAia9YWaTNyQHf2hWY5MegnRMZBMFS5wGtUhDGpqpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M0CIEs0XV/rYs2ekAYVnyjnw6OxtSRq2W466Nplmgulun0mUsFSIGa7Ll8AY++EE7ZyatXrkvQBX92QTeDdcFqIUycYfpzg77lV3ukg/blcgjiSfrQbPJXm/LRZb28ywyTikW7DymMdEJeOJ1/u2fyYKdshS7z1DaqZjvTEy2A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvzFdEuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvzFdEuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570FDC4CEF1;
	Tue, 16 Dec 2025 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888624;
	bh=RCAia9YWaTNyQHf2hWY5MegnRMZBMFS5wGtUhDGpqpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvzFdEuWmjjygZmsGTCUnVe9gBEBXAdm39VSXFh+boKoeQmWFGyqWoVVCL+OtMeLE
	 K+bWzW3LHu8kj2qrU9N0EXBJSA6w3g8aEDjdOC+rHKkXe2o5vae2JHFYaNhp0dNDRX
	 DWPxDz2t7vagVdKk0LjwaI3rVVbMbrgGe+QuHQZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 589/614] drm/i915/fbdev: Hold runtime PM ref during fbdev BO creation
Date: Tue, 16 Dec 2025 12:15:56 +0100
Message-ID: <20251216111422.731661407@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>

[ Upstream commit 460b31720369fc77c23301708641cfa1bf2fcb8f ]

During fbdev probe, the xe driver allocates and pins a framebuffer
BO (via xe_bo_create_pin_map_novm() → xe_ggtt_insert_bo()).

Without a runtime PM reference, xe_pm_runtime_get_noresume() warns about
missing outer PM protection as below:

	xe 0000:03:00.0: [drm] Missing outer runtime PM protection

Acquire a runtime PM reference before framebuffer allocation to ensure
xe_ggtt_insert_bo()  executes  under active runtime PM context.

Changes in v2:
 - Update commit message to add Fixes tag (Jani Nikula)

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6350
Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Signed-off-by: Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20251111135403.3415947-1-dibin.moolakadan.subrahmanian@intel.com
(cherry picked from commit 37fc7b7b3ab0e3bb900657199cd3770a4fda03fb)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fbdev.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbdev.c b/drivers/gpu/drm/i915/display/intel_fbdev.c
index e46c08762b847..7daf72b69bae4 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev.c
@@ -263,13 +263,18 @@ int intel_fbdev_driver_fbdev_probe(struct drm_fb_helper *helper,
 		drm_framebuffer_put(&fb->base);
 		fb = NULL;
 	}
+
+	wakeref = intel_display_rpm_get(display);
+
 	if (!fb || drm_WARN_ON(display->drm, !intel_fb_bo(&fb->base))) {
 		drm_dbg_kms(display->drm,
 			    "no BIOS fb, allocating a new one\n");
 
 		fb = __intel_fbdev_fb_alloc(display, sizes);
-		if (IS_ERR(fb))
-			return PTR_ERR(fb);
+		if (IS_ERR(fb)) {
+			ret = PTR_ERR(fb);
+			goto out_unlock;
+		}
 	} else {
 		drm_dbg_kms(display->drm, "re-using BIOS fb\n");
 		prealloc = true;
@@ -277,8 +282,6 @@ int intel_fbdev_driver_fbdev_probe(struct drm_fb_helper *helper,
 		sizes->fb_height = fb->base.height;
 	}
 
-	wakeref = intel_display_rpm_get(display);
-
 	/* Pin the GGTT vma for our access via info->screen_base.
 	 * This also validates that any existing fb inherited from the
 	 * BIOS is suitable for own access.
-- 
2.51.0



