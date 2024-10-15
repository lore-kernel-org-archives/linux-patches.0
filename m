Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439B81D4154;
	Tue, 15 Oct 2024 11:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993277; cv=none; b=dpRucHnV8xVn6m2mioH4KihbYRf1U59VUMdCGhhgz8MvWRrLwYXmmbk6rsWWXQOvkYFt8vWjLaay36s/smhcuf2TIoww8GEtpgm8SOlgcy04JVpp9wDqORRc4Pg/nVutLA7UlEWCvyUaYQad6D+t5i270ivfHJMHtuTFph4ocvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993277; c=relaxed/simple;
	bh=+DF5C7iaPsci/sKWebrKyup72yddDERhnaMqEvw1lak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNXlHRp+C9XTV1dKdHzvkxMqwjW0LxvO8Qw7x02oiNvoHsg0F13LV5ov/4OYM/HCOTCl1VqS0IU7wyChNmXIQgZdaoKrZyGHVRivTjmRxOOL77TQTe29ZnXIiGGLgZSioNPWHfCjVx8IICza9y+Wmt1lBLmFdflQ6l11amkxzOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDgm8jKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDgm8jKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7442C4CEC6;
	Tue, 15 Oct 2024 11:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993277;
	bh=+DF5C7iaPsci/sKWebrKyup72yddDERhnaMqEvw1lak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDgm8jKsmSbSMcCx6m8hWeNGeKk8dwfpypFB8CIPVSQpnsIvr0l1sls093UeNpNG3
	 TOPG8RYZU8bsWhZodsM5Hz5BE1/BNp42D0p4sr0qBGsvCvSrsoWbfR9gMQGE8KuOPK
	 Rrp1EVHqbrhJcik3zEmXonan20JqtqKAIVFm7fWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 364/691] io_uring/sqpoll: do not allow pinning outside of cpuset
Date: Tue, 15 Oct 2024 13:25:12 +0200
Message-ID: <20241015112454.792741046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Moessbauer <felix.moessbauer@siemens.com>

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
Cc: stable@vger.kernel.org # 6.1+
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
@@ -8746,10 +8747,12 @@ static int io_sq_offload_create(struct i
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


