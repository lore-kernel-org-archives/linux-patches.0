Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0798E3B19BF;
	Sat, 17 Oct 2026 16:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255724; cv=none; b=jbsPxUpz4k2jvI80+wzpURBn+A9TYn2l1GQS1FO29Hyjzb5+FeVX9/UBF9VkTL+dy8FcRq29weDoJoaXR1w3KevPIveieJcD26jGMeIlKCyq0F7ur5bFy5lGvr4OPxXoUKTZXSjumE4+0Ef3MJClAawM9YafL9hcyTTZ8sCQQqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255724; c=relaxed/simple;
	bh=RjQGTcUPC5L1CkbCf98VVGsYJcMvHnLaI79+c/I2vXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibPA1XCB7tMRLcMMI5eR/NQC76vIioHOdd/WObRSkFk1Car3kFG+cctAGDT9xFlBRJ6nG8DTHw4YtXyKlpsxXzJZHqXT+zPAf/fhVdX2ll8vmsYsBZr8UdBOr5X3d8SUdmXTlF0HbuagfSBt9x9+nZC+7qSkm/KJeYRzs/a+0JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWNCGYXn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWNCGYXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B09F1F000C4;
	Sat, 17 Oct 2026 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255722;
	bh=sqZP1JfBCx5OllxKKCU7C/8oe1wFiX8t8kjcWrT0hh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWNCGYXnby7Ox1u0AZO5drgUFPbc8N8IzZ9eKy5O17O8jjevvv/7bWjYIrPMyclxn
	 WWart/ktDu4BsivLVSnEVuWtsrS8p3bJQMvVLELdEjPLWqpZ/Sn0yg+Xfd2c5TVUOu
	 eyUC6m6JBj1gBVDcAcePZWEAsAwwD6VcajObGXyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.12 869/869] drm/panfrost: Fix scheduler workqueue bug
Date: Sat, 17 Oct 2026 18:01:50 +0200
Message-ID: <20261017160059.136766599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 drivers/gpu/drm/panfrost/panfrost_job.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -835,7 +835,6 @@ int panfrost_job_init(struct panfrost_de
 		.num_rqs = DRM_SCHED_PRIORITY_COUNT,
 		.credit_limit = 2,
 		.timeout = msecs_to_jiffies(JOB_TIMEOUT_MS),
-		.timeout_wq = pfdev->reset.wq,
 		.name = "pan_js",
 		.dev = pfdev->dev,
 	};
@@ -873,6 +872,7 @@ int panfrost_job_init(struct panfrost_de
 	pfdev->reset.wq = alloc_ordered_workqueue("panfrost-reset", 0);
 	if (!pfdev->reset.wq)
 		return -ENOMEM;
+	args.timeout_wq = pfdev->reset.wq;
 
 	for (j = 0; j < NUM_JOB_SLOTS; j++) {
 		js->queue[j].fence_context = dma_fence_context_alloc(1);


