Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D691147C96;
	Tue, 25 Jun 2024 09:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308921; cv=none; b=UfiN1zChzYiyy8rkT1EkkW/02c1Nz4IkInZMuphoSo0dJkPfxbyHU2wROIhlnXWF6McqrOLMZ1n+pOEv8OHuSrE2cZq8rD9VIAk7BpT/6cP3MUjDHvTMj1bBYEGt+T7uSYfz2VSLr57STkxasek3Uhp6fyxHvJV4KpJcD07XiQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308921; c=relaxed/simple;
	bh=KGoKJU7EuENiNFe/3YZ3H6TNkc8IH4npPAmVGua4ohM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZ0PdIphDfzTB68iRz4AqWnlrFqhBTFB4crXxlZDvBtI+AJKeKQjC0BCzUqN23+qRC9mhGlUk9oD0uqqhNiRew7HK6AWMMrT2lPieXdmWEkSQXXojxAQTK/GpMyVXU4NxwguRvLi4R4QepJKVePRM+M0LIkw1G0pXVcy24il+UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoMBMCf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoMBMCf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2399DC32786;
	Tue, 25 Jun 2024 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308921;
	bh=KGoKJU7EuENiNFe/3YZ3H6TNkc8IH4npPAmVGua4ohM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoMBMCf8r33F6PxccEBf/ZniDFgWYO7322iT3UctcYDj2FBxG0LaLJRMDmW/CJkCd
	 HYz1VcUR2NEz6wTkc+sD8YaOHe7E4lhoeKGprifJDav8CSPrDQMRZ9yANdOqXkHEHw
	 AzrB+bhLgrN9L5SCWSbIGddrGl2hM663jvxeyhQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erico Nunes <nunes.erico@gmail.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/192] drm/lima: mask irqs in timeout path before hard reset
Date: Tue, 25 Jun 2024 11:31:46 +0200
Message-ID: <20240625085538.471092385@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erico Nunes <nunes.erico@gmail.com>

[ Upstream commit a421cc7a6a001b70415aa4f66024fa6178885a14 ]

There is a race condition in which a rendering job might take just long
enough to trigger the drm sched job timeout handler but also still
complete before the hard reset is done by the timeout handler.
This runs into race conditions not expected by the timeout handler.
In some very specific cases it currently may result in a refcount
imbalance on lima_pm_idle, with a stack dump such as:

[10136.669170] WARNING: CPU: 0 PID: 0 at drivers/gpu/drm/lima/lima_devfreq.c:205 lima_devfreq_record_idle+0xa0/0xb0
...
[10136.669459] pc : lima_devfreq_record_idle+0xa0/0xb0
...
[10136.669628] Call trace:
[10136.669634]  lima_devfreq_record_idle+0xa0/0xb0
[10136.669646]  lima_sched_pipe_task_done+0x5c/0xb0
[10136.669656]  lima_gp_irq_handler+0xa8/0x120
[10136.669666]  __handle_irq_event_percpu+0x48/0x160
[10136.669679]  handle_irq_event+0x4c/0xc0

We can prevent that race condition entirely by masking the irqs at the
beginning of the timeout handler, at which point we give up on waiting
for that job entirely.
The irqs will be enabled again at the next hard reset which is already
done as a recovery by the timeout handler.

Signed-off-by: Erico Nunes <nunes.erico@gmail.com>
Reviewed-by: Qiang Yu <yuq825@gmail.com>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240405152951.1531555-4-nunes.erico@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/lima/lima_sched.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/lima/lima_sched.c b/drivers/gpu/drm/lima/lima_sched.c
index ffd91a5ee2990..1114bffe38c83 100644
--- a/drivers/gpu/drm/lima/lima_sched.c
+++ b/drivers/gpu/drm/lima/lima_sched.c
@@ -402,6 +402,13 @@ static enum drm_gpu_sched_stat lima_sched_timedout_job(struct drm_sched_job *job
 	struct lima_sched_task *task = to_lima_task(job);
 	struct lima_device *ldev = pipe->ldev;
 
+	/*
+	 * The task might still finish while this timeout handler runs.
+	 * To prevent a race condition on its completion, mask all irqs
+	 * on the running core until the next hard reset completes.
+	 */
+	pipe->task_mask_irq(pipe);
+
 	if (!pipe->error)
 		DRM_ERROR("lima job timeout\n");
 
-- 
2.43.0



