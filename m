Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1581D18DF60;
	Wed,  2 Oct 2024 13:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876680; cv=none; b=VYeaFR18WyfbrlrHHuqkPLSUTpbYPL58CO6rz/eBFOquAKMf7WvHpkAGAhcjfiJPoJ0rlz9c/aWYVKa9MV9h8yOs01GY060ZwYAJycBUN9Lq2wLaDxXCTI0jM9gDXdGLtglJKDQuh988jzL5sPj9VzvEbSVC2CouZrlhdQcmZzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876680; c=relaxed/simple;
	bh=CILjwlyM7lfqlO+G4WRpDh2N/zcGU4/4WECee8+fX0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MabFoxWi1SoBxGJQJMymv87N9p+nO+ryaAvLbXRLJ3IdF3LFIuPd+uX/LaWhJXUAW5MvzipQD5v7wsnLx5OKPL8MS+nUROFKA9vToOpZjRY761fS6bADOvSUXfB4dKtUIdtrTXqOR/7i0laqed+xT6dyoHdvzS3hKT+ksSEMm+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUEqaxyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUEqaxyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EF0C4CEC5;
	Wed,  2 Oct 2024 13:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876679;
	bh=CILjwlyM7lfqlO+G4WRpDh2N/zcGU4/4WECee8+fX0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUEqaxyhyM4G0kA8bVlh0JvtdHhdIrfTdVUybo1S93GP9VdPDDVH7KG9yBguI7VZd
	 IQFsZEGBDgcEQf/sTHlYo5EPEcYHNbch8SUEx4jx7d9amhGAElq+ZT62CTv0J4cSsv
	 hqMEnLcfhP6YInT2n9k34lyVc2vx1ouQthZZkeCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 495/695] io_uring/sqpoll: do not allow pinning outside of cpuset
Date: Wed,  2 Oct 2024 14:58:13 +0200
Message-ID: <20241002125842.232952619@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Link: https://lore.kernel.org/r/20240909150036.55921-1-felix.moessbauer@siemens.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <linux/cpuset.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -460,10 +461,12 @@ __cold int io_sq_offload_create(struct i
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


