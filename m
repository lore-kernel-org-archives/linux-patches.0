Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1367C1DE2B2;
	Wed, 19 Mar 2025 14:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395140; cv=none; b=Tj41q1pGNvv3Cg+wuTLxu1qlLW4I0EpbIoalASm79fe+Za9P2s2lKgMLaCzC8q7Fr+xduRG9rTMvv1v6gltmgM5xG37StAr5PfDT02Ndv258dL+iek9FmfGlSpIQ7e+GD3XqLJaF5TAo78BWENej7nC9kNVkF3OJUVcbYH6ergk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395140; c=relaxed/simple;
	bh=TMyeGfRYLItjg8OwZRbqunXXiNXWR3WVBmGlexQo7zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJjn/viowLYaJH8Thsu4LBpZ2DYBEZJqMj7sFNqPqFhBKCa5E12LQpsOggF9wP0/xDDOdD0Ckdfr3SX4L7qz4+s+tlYMqpv9kjwKS5z2aMVKS9BvKeBqJ/nXtlpoMO0jWWa8zkrJJMUIgcxemgIZRrqjMy9ZnhHtltjgGOB4RKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMM9KZJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMM9KZJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C52C4CEE4;
	Wed, 19 Mar 2025 14:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395139;
	bh=TMyeGfRYLItjg8OwZRbqunXXiNXWR3WVBmGlexQo7zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMM9KZJR0qYbyPmPXFOL7fgFEXQBJ08Pg/UfMIYSfuiwLk0XWJAZJZQeY2da7d5wJ
	 VtRmeckjlNQCpSifoUTeGaYwCeIoPe8N78F+V1IohuwrBmd3hSKWRGn/yd2d5Mbsq+
	 +cy4jySr1ibX/OxNMo/QIZ5emQqIOUln0W0tQa/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/231] drm/xe/pm: Temporarily disable D3Cold on BMG
Date: Wed, 19 Mar 2025 07:31:40 -0700
Message-ID: <20250319143031.960053184@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit 3e331a6715ee26f2fabc59dad6bb36d810707028 ]

Currently, many instability cases related to D3Cold -> D0 transition
on BMG are under investigation. Among them some bad cases where
the device is lost after 1 to 3 transitions from D3Cold to D0
on the runtime pm, with pcieport upstream bridge port link retrain
failure.

In other cases, it works fine, but with some sudden random memory
corruptions after D3cold, that could be 0xffff missed ack on GT
forcewake or GuC reload related failures.

In some other cases though, D3Cold -> D0 works pretty reliably.
It looks like it is a combination of GPU cards and Host boards at
this point. So, there is no possible/available quirk at this time.

This patch disables the D3Cold by default on BMG by reducing the
vram_d3cold_threshold to 0. Users and developers who wants to enable
it are still able to via
$ echo 300 > /sys/bus/pci/devices/<addr>/vram_d3cold_threshold

Fixes: 3adcf970dc7e ("drm/xe/bmg: Drop force_probe requirement")
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4037
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4395
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4396
Cc: Karthik Poosa <karthik.poosa@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250308005636.1475420-1-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit d945cc876277851053c0cf37927c8d7bd9d0e880)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 33eb039053e4f..06f50aa313267 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -264,6 +264,15 @@ int xe_pm_init_early(struct xe_device *xe)
 	return 0;
 }
 
+static u32 vram_threshold_value(struct xe_device *xe)
+{
+	/* FIXME: D3Cold temporarily disabled by default on BMG */
+	if (xe->info.platform == XE_BATTLEMAGE)
+		return 0;
+
+	return DEFAULT_VRAM_THRESHOLD;
+}
+
 /**
  * xe_pm_init - Initialize Xe Power Management
  * @xe: xe device instance
@@ -274,6 +283,7 @@ int xe_pm_init_early(struct xe_device *xe)
  */
 int xe_pm_init(struct xe_device *xe)
 {
+	u32 vram_threshold;
 	int err;
 
 	/* For now suspend/resume is only allowed with GuC */
@@ -287,7 +297,8 @@ int xe_pm_init(struct xe_device *xe)
 		if (err)
 			return err;
 
-		err = xe_pm_set_vram_threshold(xe, DEFAULT_VRAM_THRESHOLD);
+		vram_threshold = vram_threshold_value(xe);
+		err = xe_pm_set_vram_threshold(xe, vram_threshold);
 		if (err)
 			return err;
 	}
-- 
2.39.5



