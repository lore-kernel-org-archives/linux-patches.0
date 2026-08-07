Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DC746D090;
	Fri,  7 Aug 2026 15:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117738; cv=none; b=gLhVbNnDI/PrXZQmOfdjbucbH3DTeU0Z2fOaZPpokkWF+NJjgOMWs+DFDMD9wuXXaUxVGbydrvHsf3WRv5W4Bfa/lyCMBEYYaHIWy3dDGPifUCAgKLQ9fOyXvfy7qPDURQipXYtcIdZHVXE2fRd6jA9c1ZLLmG9skENstVFUx1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117738; c=relaxed/simple;
	bh=icV0evLESPiF6i12o+63QmfitUaJbfa/HfMBsv4xEZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s77zNMHoClIsBas/ulZt6lAOkji90LBTg0P4InSmEfGxqftgZppPv12EMK56KrMC+GCHBwBwHhYewZbDeATQN/sEU3VbjsXoG/Lgr/oB/SliXVEETnNdgdZNiBgwYocEqXa7Gz3z7/Df9D65EswKPQyN+27O/sUOTHHpxF5Pwp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sg3hXNrC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sg3hXNrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13811F000E9;
	Fri,  7 Aug 2026 15:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117737;
	bh=VILvMsWz+m/+wYjJy4EmFdt/PFJJajZm/IkzMtvw/lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sg3hXNrCk/jQTZ70xHiksUicYzkeqaUbePSmc1/ANM7HB0O74yb918lWqr7CoTPbJ
	 66j5yAiQn+b4rID+xWtn+NB8UeWqB9eGtRB4g0IbrQfA/F15BywJaOQfuMLPKqjd3/
	 2LtvUbUJzgGDBRLZpNf8K0a8rTVSpbIlzwvQ3lDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 424/438] drm/xe/oa: (De-)whitelist OA registers on OA stream open/release
Date: Fri,  7 Aug 2026 16:40:20 +0200
Message-ID: <20260807143437.005599162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 63ddb3ad08ff4e89c108499dfec5e9be5ddc25c9 ]

Whitelist OA registers on stream open and de-whitelist on stream
close/release. Whitelisting is only done when 'stream->sample' is
true. 'stream->sample' is only true when (a) xe_observation_paranoid is set
to false by system admin, or (b) the process is perfmon_capable(). This
therefore enforces the OA register whitelisting security requirements.

Fixes: 828a8eaf37c3 ("drm/xe/oa: Add MMIO trigger support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260615224227.34880-9-ashutosh.dixit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index d908f4e039063..5111c6519c6db 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -35,6 +35,7 @@
 #include "xe_oa.h"
 #include "xe_observation.h"
 #include "xe_pm.h"
+#include "xe_reg_whitelist.h"
 #include "xe_sched_job.h"
 #include "xe_sriov.h"
 #include "xe_sync.h"
@@ -866,6 +867,9 @@ static void xe_oa_stream_destroy(struct xe_oa_stream *stream)
 
 	mutex_destroy(&stream->stream_lock);
 
+	if (stream->sample)
+		xe_reg_dewhitelist_oa_regs(stream->gt);
+
 	xe_oa_disable_metric_set(stream);
 	xe_exec_queue_put(stream->k_exec_q);
 
@@ -1871,6 +1875,9 @@ static int xe_oa_stream_open_ioctl_locked(struct xe_oa *oa,
 		goto err_disable;
 	}
 
+	if (stream->sample)
+		xe_reg_whitelist_oa_regs(stream->gt);
+
 	/* Hold a reference on the drm device till stream_fd is released */
 	drm_dev_get(&stream->oa->xe->drm);
 
-- 
2.53.0



