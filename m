Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA98E2DEA8E;
	Tue, 22 Jul 2025 14:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193337; cv=none; b=EUd1CATT3hv6FLTGTqooGxE1fES8beDoU/ee9cG7BDarfsgmKJ4fP1w1VJO3QLRNPNnPl75F3lxWD/wQVt6FKuOc3jYIVQBZjBr+Xir2EWTL1cGA5R3dP52jSUc454gLJanWuigmZbUKV1J0x2AVmpaF6SMKRpkTl3v6nFN/48A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193337; c=relaxed/simple;
	bh=qxJsiimbuUrreW7S6i6QZamuhJN2zOX6vL0kgYcdLoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkcsP5ebz/wq3ugSYpDOaV+B3jNGILL/w0/xSJf5VI9cgvxdQZfsys8WVifsEfWbq2cncfBjI66aQ62kjUEyWEjDeclrCI89RlTu/eEjXIih+geVFD8yR6TB1UuK++uGyIoLnBWPyZT5vPJzePK6IcubvbgEk6VL8SwVPMwulCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GQ2u1IR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GQ2u1IR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C3AC4CEF1;
	Tue, 22 Jul 2025 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193337;
	bh=qxJsiimbuUrreW7S6i6QZamuhJN2zOX6vL0kgYcdLoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GQ2u1IRbJrFzHuXfDMBXB5PDq30g+r6wzF2Modr+hpAG4FrzRNeWh0uPIJnk9pOq
	 XMbPd8Uxs4LowzHPYPC7x1RJBM51jOpBKT4ZYXpoHyQV+D4x8k2oGSzC9Wq7n5rXub
	 qA6XRqaJUxyETxe+uwAta9SwYgrMnjd01n1o6xpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.15 034/187] drm/panfrost: Fix scheduler workqueue bug
Date: Tue, 22 Jul 2025 15:43:24 +0200
Message-ID: <20250722134347.028250308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

commit cb345f954eacd162601e7d07ca2f0f0a17b54ee3 upstream.

When the GPU scheduler was ported to using a struct for its
initialization parameters, it was overlooked that panfrost creates a
distinct workqueue for timeout handling.

The pointer to this new workqueue is not initialized to the struct,
resulting in NULL being passed to the scheduler, which then uses the
system_wq for timeout handling.

Set the correct workqueue to the init args struct.

Cc: stable@vger.kernel.org # 6.15+
Fixes: 796a9f55a8d1 ("drm/sched: Use struct for drm_sched_init() params")
Reported-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Closes: https://lore.kernel.org/dri-devel/b5d0921c-7cbf-4d55-aa47-c35cd7861c02@igalia.com/
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250709102957.100849-2-phasta@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_job.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index 5657106c2f7d..15e2d505550f 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -841,7 +841,6 @@ int panfrost_job_init(struct panfrost_device *pfdev)
 		.num_rqs = DRM_SCHED_PRIORITY_COUNT,
 		.credit_limit = 2,
 		.timeout = msecs_to_jiffies(JOB_TIMEOUT_MS),
-		.timeout_wq = pfdev->reset.wq,
 		.name = "pan_js",
 		.dev = pfdev->dev,
 	};
@@ -879,6 +878,7 @@ int panfrost_job_init(struct panfrost_device *pfdev)
 	pfdev->reset.wq = alloc_ordered_workqueue("panfrost-reset", 0);
 	if (!pfdev->reset.wq)
 		return -ENOMEM;
+	args.timeout_wq = pfdev->reset.wq;
 
 	for (j = 0; j < NUM_JOB_SLOTS; j++) {
 		js->queue[j].fence_context = dma_fence_context_alloc(1);
-- 
2.50.1



