Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05CB1E3764;
	Mon, 21 Oct 2024 10:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507598; cv=none; b=gOGAY2G2RfGcWjtT4SHhPLCMUFxm6/4nmG9+INSGFIKb2pKSG48fxwWXF1kAlyDyrv2dqI1DjEAOX/C4iFhz8u3I0Ge/QByl2X05OrHBrMuVMAVvEUxfBzGEM+DfhXgUWl4cMZZiuhBefME7idagJxL3CU2wny+HMPFBsX69sXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507598; c=relaxed/simple;
	bh=KWgyUB7bd9FULWENG1+ADu5KIMhFVvAtS873MUJGICA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M55/e4/WXcjv7rr37C+j+NbBQdDKHJXG3Ul68OWOYXlxxwOsggmNk5vM4fDyIRJ+YOW7/TDLeseCVdT7TLfIctWY/1jcFq+oMS+0h05HsfXNd9ZkACROIiqvuQZOI0RrFfLdrVCoK91DCz1eiLdAjh6ga6dQIhN59o4Dv0TTo7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwegCovl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwegCovl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63891C4CEC3;
	Mon, 21 Oct 2024 10:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507597;
	bh=KWgyUB7bd9FULWENG1+ADu5KIMhFVvAtS873MUJGICA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwegCovlRCx0o+vFpo6KXj6oLkbf8LuS6GqQCGQbLeO5LyigscLE6fG43HD1pTnqe
	 YvhyyGfNbvY0YoeCYCX6C3MRfY17GDQJYN8zIXEHh8Yb2KlgW/xlEGyaSRHpBFUv1K
	 twq0Gw+UgIeLtPyoHEx/MtSRxea8iY1CTlCKsXUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 38/82] io_uring/sqpoll: do not put cpumask on stack
Date: Mon, 21 Oct 2024 12:25:19 +0200
Message-ID: <20241021102248.748744278@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

commit 7f44beadcc11adb98220556d2ddbe9c97aa6d42d upstream.

Putting the cpumask on the stack is deprecated for a long time (since
2d3854a37e8), as these can be big. Given that, change the on-stack
allocation of allowed_mask to be dynamically allocated.

Fixes: f011c9cf04c0 ("io_uring/sqpoll: do not allow pinning outside of cpuset")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Link: https://lore.kernel.org/r/20240916111150.1266191-1-felix.moessbauer@siemens.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -8747,15 +8747,22 @@ static int io_sq_offload_create(struct i
 			return 0;
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
-			struct cpumask allowed_mask;
+			cpumask_var_t allowed_mask;
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
 			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 				goto err_sqpoll;
-			cpuset_cpus_allowed(current, &allowed_mask);
-			if (!cpumask_test_cpu(cpu, &allowed_mask))
+			ret = -ENOMEM;
+			if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
 				goto err_sqpoll;
+			ret = -EINVAL;
+			cpuset_cpus_allowed(current, allowed_mask);
+			if (!cpumask_test_cpu(cpu, allowed_mask)) {
+				free_cpumask_var(allowed_mask);
+				goto err_sqpoll;
+			}
+			free_cpumask_var(allowed_mask);
 			sqd->sq_cpu = cpu;
 		} else {
 			sqd->sq_cpu = -1;


