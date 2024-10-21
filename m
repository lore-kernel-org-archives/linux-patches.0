Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0C01EBA16;
	Mon, 21 Oct 2024 10:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507766; cv=none; b=MJqjQLwXLszhLegPQ9jlPDKMYnRngNLMoULjfYdVBk64CmFIJ5llCoYgFL5cA3fFtRTZo/1b7rmEIVbyJEXgQWxW1IKJYq4BvUdwYbx7RUDJR5tTtjoopIobQPsqR+gm20j58yYxP9/HV+X8eApxwiPXuhiLzeLgv97Gu+JL1PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507766; c=relaxed/simple;
	bh=wTr/TzjfxQprzJHoFZQ3VyaPCkcIJzQAO0J6nXGM1IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tI9RTiyLcglbAeLsdVZI5nzmmk+OtbqWcXL6xvxRwOrtkYWkE+JQy0PGcmfAvkL6djTUJMBtZtuNFbmoUqBTHHjB2fe/5qSFn74/4++Ab/3N+BjrUi24RKK6vpsIWQwu1n4yplEI0ioLEqLAeOXfzlT4sGq3OzD6X/TLNP03gIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l097QZMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l097QZMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808F9C4CEC3;
	Mon, 21 Oct 2024 10:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507765;
	bh=wTr/TzjfxQprzJHoFZQ3VyaPCkcIJzQAO0J6nXGM1IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l097QZMtRidTpxQcQ7M+Ld1qZHHcfXTXGVt35x7sq4sgR4ReBq+J1LR15XLBAv9wi
	 K6DVzWuB5TYknERLq9lIo43+HRrJH5XV35gS/L1YaUsn/qSjN3J8qD7drJOTwTmYv2
	 iT3hmBRK7XVAxEeCShyzGQuxBXKYQ6WNSH+/Yy1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 12/52] io_uring/sqpoll: do not allow pinning outside of cpuset
Date: Mon, 21 Oct 2024 12:25:33 +0200
Message-ID: <20241021102242.108501826@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Moessbauer <felix.moessbauer@siemens.com>

commit f011c9cf04c06f16b24f583d313d3c012e589e50 upstream.

The submit queue polling threads are userland threads that just never
exit to the userland. When creating the thread with IORING_SETUP_SQ_AFF,
the affinity of the poller thread is set to the cpu specified in
sq_thread_cpu. However, this CPU can be outside of the cpuset defined
by the cgroup cpuset controller. This violates the rules defined by the
cpuset controller and is a potential issue for realtime applications.

In b7ed6d8ffd6 we fixed the default affinity of the poller thread, in
case no explicit pinning is required by inheriting the one of the
creating task. In case of explicit pinning, the check is more
complicated, as also a cpu outside of the parent cpumask is allowed.
We implemented this by using cpuset_cpus_allowed (that has support for
cgroup cpusets) and testing if the requested cpu is in the set.

Fixes: 37d1e2e3642e ("io_uring: move SQPOLL thread io-wq forked worker")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Link: https://lore.kernel.org/r/20240909150036.55921-1-felix.moessbauer@siemens.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -56,6 +56,7 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/percpu.h>
+#include <linux/cpuset.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/bvec.h>
@@ -8571,10 +8572,12 @@ static int io_sq_offload_create(struct i
 			return 0;
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
+			struct cpumask allowed_mask;
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
-			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+			cpuset_cpus_allowed(current, &allowed_mask);
+			if (!cpumask_test_cpu(cpu, &allowed_mask))
 				goto err_sqpoll;
 			sqd->sq_cpu = cpu;
 		} else {


