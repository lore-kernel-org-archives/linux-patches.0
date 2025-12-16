Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EB035A941;
	Tue, 16 Dec 2025 12:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886714; cv=none; b=JW/XbBk4apJ19YwpHvj/K1R3LodwrjsRP+XybDDW5w2InY94tZeWtI/v+AB4Mg70H7u9/++uxEuJMxvSXhZtk6yp7CJ0q3nuClGpVjE+JzFJKZ4T9NFVgcnzUyEQhGdIZIKnLfUTcbNcgU1QZesTsD3Kf8Z+bLndHgfgtxPhwio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886714; c=relaxed/simple;
	bh=ZJ5vIlMmnaw/NWcZoz6S4HbkBSkbx2zRL2tsj4q0g8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4qk5SonalLRzRty0IS5Y6YAZl/Hioyazrqjj2ORSlKyxYyFPP6QzX7Q+uLxMCJ462IOvfCuOD5w9UjkcLvuIBxygTpmjRjAKYWVDTpRn8IbNrrM4QTw7LtA5i24unDJEHZIapcQm/8A0i3AZipXGq02L3lGsKboUr3BmaBOAUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6dvFyeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6dvFyeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2DFC4CEF1;
	Tue, 16 Dec 2025 12:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886714;
	bh=ZJ5vIlMmnaw/NWcZoz6S4HbkBSkbx2zRL2tsj4q0g8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6dvFyeNstq5gBw8wN6hceVuH2AE064QegUwvpu/77QjzDzejdyhh3NlwLgr7lIvI
	 3DhEcY8rmmA0hwWbeFnYqR6UrC8fUB672/wlFFSmg29fNnGWYDDHcKwJWw5qJWL1oT
	 Ul1DQ8izh87LXgqc+1XxR0z27BeDe69rg8zMF9so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/614] accel/ivpu: Ensure rpm_runtime_put in case of engine reset/resume fail
Date: Tue, 16 Dec 2025 12:06:18 +0100
Message-ID: <20251216111401.706736503@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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



