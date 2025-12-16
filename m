Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EBC34676E;
	Tue, 16 Dec 2025 11:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885077; cv=none; b=Ij9mW5rwXcXGt3thOCK8tLHlj1SMCFceEqEv9TKVzNyFk8ahCupw6sJ05rxhfR+Ndox59sQNhEnAgdUmoAJwqTb9HXLg2sMBD+os/TUS5P6fPpV5WIyKNP77It+YR0qYukX1+rgRiyqGyDuaZiLu2KCIdqWzhnXJcYlCyvDHEh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885077; c=relaxed/simple;
	bh=aMWcoBtYt1X0vWnzFnQDkDM/woc956gck/KA3grhO5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJdZFGDmpAaCbKrE/r2XIq8gbW/Pl7vP9EwSP6ZgMY5S7Hot2xEqgDhpdQnV/hzdMLRgMiPVvRsfl5T4LCLzQACm8fZNAlBzn6rX/poDI2TQmG/RD8cGVZpRJfX5Q2nEZGoDe6+BtUaNUYISSI4teALx4UeNs0djU4vMmDoLrN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfnX52or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfnX52or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEBAC4CEF1;
	Tue, 16 Dec 2025 11:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885077;
	bh=aMWcoBtYt1X0vWnzFnQDkDM/woc956gck/KA3grhO5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfnX52ormNwaZgmz4t2OuKhIovGiixLgM1Wgkwx+z2YMOYgARd+Wtazmw5pxmL76R
	 7FvJ1/KMy8MmnXmiKjYG3p46hhVqysKxnCQaN33eMkprSvA1K/mv4y9lMJD7qR4sr6
	 sl/4yWSmn52HWuybMHcmiRc4ju7sMd962i7BbY+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 009/507] accel/ivpu: Ensure rpm_runtime_put in case of engine reset/resume fail
Date: Tue, 16 Dec 2025 12:07:30 +0100
Message-ID: <20251216111345.871461770@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@linux.intel.com>

[ Upstream commit 9f6c63285737b141ca25a619add80a96111b8b96 ]

Previously, aborting work could return early after engine reset or resume
failure, skipping the necessary runtime_put cleanup leaving the device
with incorrect reference count breaking runtime power management state.

Replace early returns with goto statements to ensure runtime_put is always
executed.

Fixes: a47e36dc5d90 ("accel/ivpu: Trigger device recovery on engine reset/resume failure")
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://lore.kernel.org/r/20250916084809.850073-1-karol.wachowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_job.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index 060f1fc031d34..dbefa43c74e28 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -1012,7 +1012,7 @@ void ivpu_context_abort_work_fn(struct work_struct *work)
 
 	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW)
 		if (ivpu_jsm_reset_engine(vdev, 0))
-			return;
+			goto runtime_put;
 
 	mutex_lock(&vdev->context_list_lock);
 	xa_for_each(&vdev->context_xa, ctx_id, file_priv) {
@@ -1036,7 +1036,7 @@ void ivpu_context_abort_work_fn(struct work_struct *work)
 		goto runtime_put;
 
 	if (ivpu_jsm_hws_resume_engine(vdev, 0))
-		return;
+		goto runtime_put;
 	/*
 	 * In hardware scheduling mode NPU already has stopped processing jobs
 	 * and won't send us any further notifications, thus we have to free job related resources
-- 
2.51.0



