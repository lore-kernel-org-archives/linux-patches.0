Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871CD126C02;
	Tue, 16 Dec 2025 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883823; cv=none; b=aMfsgZcUzDQB4UrtZXo2FNdf368rWxp3EI1sgr8Q3IjlNqmGLyQ5ZZCuvax8N2JGLl6eh/vbWBb23hUkW3lBQqAUosiRhaVmPXBcH2OMSz0RsP0bTHBHs7C/L04xNMEY0UuFNrboclkdZkXaV7tqw9FOZHIjuAF2fouj8KuCqD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883823; c=relaxed/simple;
	bh=banmhn5daweTRiDPFBZ4HsYJvHhgfTwgvzmaQjkVdzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlxDIiQ6ZPJbiIycYlf0TmTtuAxXMRTBb0DH3e8rPX/SQSI54TOFub49r1ygYsRaa46VjGjAXerxQfNRJjEMsks0aU02YAd4tQdQlNpXVqZwJ57mLuKMYUXn7enhNuUmgtFrwlaNz6TNjXKEUjmoYS1VJDqkDBB8pwfdhQKSkQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vpi8ucZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vpi8ucZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE585C4CEF1;
	Tue, 16 Dec 2025 11:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883822;
	bh=banmhn5daweTRiDPFBZ4HsYJvHhgfTwgvzmaQjkVdzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vpi8ucZgVnxuKeYr1EDkcxhoh7/uMwTlPcjIE9/jQqegW1FHX2fvRQS0mx0SSnEWC
	 v8OqPywqAIKVXktZuptcQIZQqlb8sqQheKFAxblMukyKB4famGhbgs+X+I2z0Y5WZn
	 xE9wHu4HA3N6Wty+J/HfIbQ5jcE+lN6bpJ6xz2j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/354] accel/ivpu: Ensure rpm_runtime_put in case of engine reset/resume fail
Date: Tue, 16 Dec 2025 12:09:37 +0100
Message-ID: <20251216111321.280551053@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index a0dca1c253b74..172502b71b9cf 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -854,7 +854,7 @@ void ivpu_context_abort_thread_handler(struct work_struct *work)
 
 	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW)
 		if (ivpu_jsm_reset_engine(vdev, 0))
-			return;
+			goto runtime_put;
 
 	mutex_lock(&vdev->context_list_lock);
 	xa_for_each(&vdev->context_xa, ctx_id, file_priv) {
@@ -871,7 +871,7 @@ void ivpu_context_abort_thread_handler(struct work_struct *work)
 		goto runtime_put;
 
 	if (ivpu_jsm_hws_resume_engine(vdev, 0))
-		return;
+		goto runtime_put;
 	/*
 	 * In hardware scheduling mode NPU already has stopped processing jobs
 	 * and won't send us any further notifications, thus we have to free job related resources
-- 
2.51.0



