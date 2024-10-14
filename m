Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF63F1A76A5;
	Mon, 14 Oct 2024 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918294; cv=none; b=uaAhnipR6SYTcZxYhJoMj8wmhAWIb/OG9CnOFufqJaN6r49DmkYPUkDD9/K98BNMS2y3d6+5GpPpR+dS2kmyS9cm0BGsPbyu9SjIiW1zeN7J1tbwpQF37ERzeEfFSBNlwDv5FMaCmb32JB2TpAIY8nMQJ+o6IbF8PfAqIVOCrZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918294; c=relaxed/simple;
	bh=68vfQIYmpUNt0cem0yQAJWahKl+eZ0dX1fcZ+CGaMsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0/aLh+0VxRG8sjDH6jX0hyRVWS6GhbSEoEAMvPkUADUG0uNt53cuCWCGDBc/6B9bCbHQl3rKzzKH8K2bkzDbzfz7z2mFV3Syrkj1HNK4lqwH3Y/zeyDldSPR72V2PAqf1hKqUYeCo8zUaCoj2fPccKuqg0sPqB129ssvsrcork=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovGrZFyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovGrZFyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20740C4CEC7;
	Mon, 14 Oct 2024 15:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918294;
	bh=68vfQIYmpUNt0cem0yQAJWahKl+eZ0dX1fcZ+CGaMsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovGrZFyYwauksMjC22vxRV9MnRkrgWb4qbYjKyngWG9OEIfa+knO/u5UulaqsHg/Y
	 abe5P1LH3RXdRuLEPNstxazQRNBpvj3Ncg/cOBCrq1yipkt/rG41cWI0h9v9ylpOQY
	 lv1NqEGxSduqLqtf2NpbLmmRTxrrzwwHamdc+FAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 280/798] io_uring/sqpoll: do not put cpumask on stack
Date: Mon, 14 Oct 2024 16:13:54 +0200
Message-ID: <20241014141228.946023293@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 io_uring/sqpoll.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -395,15 +395,22 @@ __cold int io_sq_offload_create(struct i
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


