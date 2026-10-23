Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774615;
	b=TNjy9jQu3rANLmI0qqWbvh7RKOm4nle1F9bhd231fqbtTaqiiMLq2p0UaPD53klnqFhK
	 pc2zES7hYBX8S4F46tsSUIhbrzULwvp4D3/4I+USgY0iNi0D/t8xemCrb+yUqpFCDUcxa
	 kYDEj7Iz9Y/eaI7KPHrs8Mv/VpJYiZq2z0HAz9s+bL7HK+WOD1gVYWIyq72FA4O5mLwUr
	 aGT7K9UH/HgAoN7rUAhdeEAWR4V9rH0dcHDIR7b8jP4qtOCLQpST32qBgf6UT9qBrl5Bm
	 IhWB8WrF5/tA4ypYB/44FCRsWcD+tYqK5C0Q3ZIgtktKp9K0ULeUsGfLsjszxHvMM4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BVTWSdHkBjAQuWVaBcE0DROR5poacp6QHRnznnF//cs=;
	b=Ho2X5WN+hmWGy/pPneCmqxf0U0fjUV3+fqOnNVY67VV1lzSSZJZzdHis4/Gwx2XNRux+
	 nwvQLNpqZbHdjIORzN3Nc9IK+dBNOmhWfSPp0Zsv0pbouif6zoLvupaghQnP4VbB0F7i6
	 aq8Mz6liLC5Xr4q2sBWSA5MiITz9ATp6J1EMHkdGe0+5h10/OlmWc5jN3kXNM+E2/E38i
	 11di/VxdY5RwBkf66ABZpHVc+uPOtvq5JhsGFODoWfc7BEnaHs8b7zmR5istuFwKnzv2c
	 qPLMYy4S8izybfxoLjoi5JfZQyMiu3XYD0LImSYOJb94eYUNSJR6HG4+I12IqGTaZ5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t0knm35d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A33606A31A;
	Fri, 23 Oct 2026 16:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t0knm35d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01661F01825;
	Fri, 23 Oct 2026 16:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774614;
	bh=BVTWSdHkBjAQuWVaBcE0DROR5poacp6QHRnznnF//cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0knm35d/EpcTjGKp3OlMtJljV0ZARGqSDhJ7wcms+B540Fhf8T2WgudYcr5LpbPB
	 arJBIUsMBKZIWJNzgt2cVVT2hO4KDebrHibbVhBbj+phbLhE4KcI8ah98gaVqNnZ6u
	 BBRIB+0vgp+L+A6xTzY+au16RSQYhnvKRUJefWyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidong Yang <sidong.yang@furiosa.ai>,
	Igor Paunovic <royalnet026@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 7.2 101/242] accel/rocket: search every core slot when looking up a scheduler
Date: Fri, 23 Oct 2026 18:39:03 +0200
Message-ID: <20261023163716.169873066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Paunovic <royalnet026@gmail.com>

commit 89c2c777df17eb0201c8e22afabbf3691f2a28fe upstream.

sched_to_core() walks rdev->cores[] up to rdev->num_cores, and
rocket_remove() decrements num_cores for every core it removes. Unbind a
core that is not the last one and the cores behind it fall outside the
search, so sched_to_core() returns NULL for a core that is still bound and
still running jobs. Neither caller checks the result:

  rocket_job_run():      rocket_fence_create(core), core->dev
  rocket_job_timedout(): dev_err(core->dev, "NPU job timed out")

Unbinding the middle core of the three on an RK3588 while three clients are
submitting to all of them faults twice, once from the surviving core's
job queue and once from its reset work:

  KASAN: null-ptr-deref in range [0x0000000000000220-0x0000000000000227]
  Workqueue: fdad0000.npu drm_sched_run_job_work [gpu_sched]
  pc : rocket_job_run+0x234/0x838 [rocket]
  Call trace:
   rocket_job_run+0x234/0x838 [rocket]
   drm_sched_run_job_work+0x2cc/0xad8 [gpu_sched]
   process_one_work+0x640/0x14f0

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  Workqueue: rocket-reset-2 drm_sched_job_timedout [gpu_sched]
  pc : rocket_job_timedout+0xf0/0x1e0 [rocket]
  Call trace:
   rocket_job_timedout+0xf0/0x1e0 [rocket]
   drm_sched_job_timedout+0x188/0x6a0 [gpu_sched]

Both are the third core: the workqueue names are its device and its
core->index, and it was left at slot 2 while num_cores had dropped to 2.

Search all the slots that were allocated, the way find_core_for_dev() now
does. A core that is still bound is then found, and the two callers get
the pointer they already assume they have.

This does not make unbinding one core out of several safe. An open client
keeps an entity pointing at the scheduler of the core that went away:
drm_sched reports it as not ready for every job that lands on it, and the
client waits in dma_fence_default_wait for a fence that will never signal.
Stopping the NULL dereference is what belongs in a fix; the rest wants
more thought.

Reported-by: Sidong Yang <sidong.yang@furiosa.ai>
Closes: https://lore.kernel.org/dri-devel/apwUewaRnoTNXHCt@rock-5b-plus/
Fixes: 0810d5ad88a1 ("accel/rocket: Add job submission IOCTL")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Paunovic <royalnet026@gmail.com>
Assisted-by: LLM sparse checkpatch
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260905150432.7477-1-royalnet026@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/rocket/rocket_job.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/rocket/rocket_job.c b/drivers/accel/rocket/rocket_job.c
index f40435505818..4bc4f9c8ee40 100644
--- a/drivers/accel/rocket/rocket_job.c
+++ b/drivers/accel/rocket/rocket_job.c
@@ -283,7 +283,7 @@ static struct rocket_core *sched_to_core(struct rocket_device *rdev,
 {
 	unsigned int core;
 
-	for (core = 0; core < rdev->num_cores; core++) {
+	for (core = 0; core < rdev->max_cores; core++) {
 		if (&rdev->cores[core].sched == sched)
 			return &rdev->cores[core];
 	}
-- 
2.56.0



