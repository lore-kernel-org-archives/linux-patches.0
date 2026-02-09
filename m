Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DCB37BE93;
	Mon,  9 Feb 2026 14:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648076; cv=none; b=KC4ofO0IQ5IOD8XMrHS49wkeqht1cfGfvMX8Y2eHL3LpyhUZ8hH3VmIMedLGpImsC15xA/d68MkmkJKqun5fcM0Eu1yS2/WBPl/b2KyCLWfQIBFfecIoWzTHsoynfTnECFzegqOxgYv8OLHte/a2XcG4wOB2ujsuic54caL/BiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648076; c=relaxed/simple;
	bh=uUhrn2mDrsAUCUToxNJ2NMlP2ntT4Zl9XN8hifueheY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8FR0psRdJuWTeCH6sGMNru6cqazcCz6gMta4GRg/FgpsGdqgckLxMRG8YJ7gjpOj7DowOTVUQUa1msTvnVhgQVLCioTlSYdZxOVzVr55er+zWFm8xjnYyWSSWM49lshSXK2GJznSna4xkikWfUrPc/IH3QwuDTYbbSzaWNtJ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04lNDkx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04lNDkx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33417C19422;
	Mon,  9 Feb 2026 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648075;
	bh=uUhrn2mDrsAUCUToxNJ2NMlP2ntT4Zl9XN8hifueheY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04lNDkx243lS8liT2lkYMYuqKcmsj+AiXRkor7rDWekQKRlwy2ZSryUYsiAAHGxk0
	 Wg8tz9nwBtrkrcO8NHzXYUO6I5qLP+UPaGnsvFC42ownEFDzwA9Xj8OijxIoXLwGZw
	 ttFHK0DvEbY67QMm79BN2myNdEZwbsyLz32T91+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/113] drm/xe/pm: Also avoid missing outer rpm warning on system suspend
Date: Mon,  9 Feb 2026 15:24:08 +0100
Message-ID: <20260209142313.734377105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit f2eedadf19979109415928f5ea9ba9a73262aa8f ]

Fix the false-positive "Missing outer runtime PM protection" warning
triggered by
release_async_domains() -> intel_runtime_pm_get_noresume() ->
xe_pm_runtime_get_noresume()
during system suspend.

xe_pm_runtime_get_noresume() is supposed to warn if the device is not in
the runtime resumed state, using xe_pm_runtime_get_if_in_use() for this.
However the latter function will fail if called during runtime or system
suspend/resume, regardless of whether the device is runtime resumed or
not.

Based on the above suppress the warning during system suspend/resume,
similarly to how this is done during runtime suspend/resume.

Suggested-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241217230547.1667561-1-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: bb36170d959f ("drm/xe/pm: Disable D3Cold for BMG only on specific platforms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index f8fad9e56805b..1012925aa4816 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -6,6 +6,7 @@
 #include "xe_pm.h"
 
 #include <linux/pm_runtime.h>
+#include <linux/suspend.h>
 
 #include <drm/drm_managed.h>
 #include <drm/ttm/ttm_placement.h>
@@ -622,7 +623,8 @@ static bool xe_pm_suspending_or_resuming(struct xe_device *xe)
 	struct device *dev = xe->drm.dev;
 
 	return dev->power.runtime_status == RPM_SUSPENDING ||
-		dev->power.runtime_status == RPM_RESUMING;
+		dev->power.runtime_status == RPM_RESUMING ||
+		pm_suspend_target_state != PM_SUSPEND_ON;
 #else
 	return false;
 #endif
-- 
2.51.0



