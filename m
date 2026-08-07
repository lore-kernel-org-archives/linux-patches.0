Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF47518E02A;
	Fri,  7 Aug 2026 15:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115651; cv=none; b=NadNj2o1yXVRsNqM3bjxV5qoI9C99rRa9yADx4G2VBAGRmVml3Fpnf6fFKOQmhSTvnRgHV9Jnx5XgMMeI/6TelFUXeYeDAxm/9pfCQtXSlIcE0JK+bavg9F5Ep4fsaJvdTuXk82mS+zPpe4E9aMHENVcgiPuLlmzk463QN0brX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115651; c=relaxed/simple;
	bh=PpClwhs+sRRGp0FZdqVNT789r6v3nMdzKPlvl2b6tJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQduUjSNFDJpSUGh8NkbU+XgbfEpS80+Uo1hP7Ad9QnNgRwWK0nKJkaoEpBC7M50cI9CgDGV0Ut/g+GrVZJCkWjG+2ygGR5iUA3mv7ipgELtd1rlv1ts/klSCn44+26nXVkR4VKig118LZh4mDpZ2jK95meqQfUuEp670JduXnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDKASP8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDKASP8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176E81F000E9;
	Fri,  7 Aug 2026 15:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115650;
	bh=A3PCRfAhBDSSOrvs5oICEtUR5O+MXAfCnMMYRgj0sWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDKASP8sKXNQ/UP3TiiZHPFf96PbthZiNjs+UiAND42WiM6Q0C28AeLwoQnGXvv/a
	 vlH7UAAdagXJRz90vqlhQgjPuens6YvQ/qfhht/jL9cj8Tu2tBvAITwc9qMdIiIG78
	 eqyC+Z8Y1T0GQw9qh/yDIhXNlm0KA8VfF3d0bM5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 351/396] drm/xe/oa: (De-)whitelist OA registers on OA stream open/release
Date: Fri,  7 Aug 2026 16:38:31 +0200
Message-ID: <20260807143431.856833625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7d04591e297a8..98df9ee1cac39 100644
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
@@ -863,6 +864,9 @@ static void xe_oa_stream_destroy(struct xe_oa_stream *stream)
 
 	mutex_destroy(&stream->stream_lock);
 
+	if (stream->sample)
+		xe_reg_dewhitelist_oa_regs(stream->gt);
+
 	xe_oa_disable_metric_set(stream);
 	xe_exec_queue_put(stream->k_exec_q);
 
@@ -1887,6 +1891,9 @@ static int xe_oa_stream_open_ioctl_locked(struct xe_oa *oa,
 		goto err_disable;
 	}
 
+	if (stream->sample)
+		xe_reg_whitelist_oa_regs(stream->gt);
+
 	/* Hold a reference on the drm device till stream_fd is released */
 	drm_dev_get(&stream->oa->xe->drm);
 
-- 
2.53.0



