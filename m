Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079852F235E;
	Thu,  3 Jul 2025 15:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555639; cv=none; b=hcegztRgdoDh1m92Q1okZO1UTLmIWAi2Jd93b8BNxyq20NfSOE1+NrJ254lGrEh2ifdVGCinGVWelTm9VrsGjQDhlslFoY7/kutCgwDuqkkzdUUbE9VRdp0qHCbzU7J+xb+9E2a0KnQOY6hpSzSXuXNX/canEeRu07AfJ9M6COw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555639; c=relaxed/simple;
	bh=raF2Q6BfDGIlraJEgMgRPRV25WDmD0u7VVkdblm92xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPppWdC+2dg9yS/KpbN9EU12qjfevydv3o3ThDLS19QPKucqdDt61tm9hwGajxGc0I/CC6KI6DMSrjmVcMGhyQgRyPNPBRlWRfAWod6Em6dDqZElmll21xHvXG62A+8G1TY9+gHbYpbw3d10FDeoWWN4lGHfBJlfHhDzESZPrgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w32T5q4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w32T5q4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF24C4CEEE;
	Thu,  3 Jul 2025 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555638;
	bh=raF2Q6BfDGIlraJEgMgRPRV25WDmD0u7VVkdblm92xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w32T5q4HLQmdOnhVslP9Gm7utGgWcWK/bJUYPhMDjP7LWmdMjo6YSn0OGKBo5NGfC
	 L+kXwFeh04oBBJBdiX/bR4mVEbuEsat85B2lIw0QLZTEtfHqUyVfPlC0obvsnInXdw
	 IDJEj/QqSDe/ReqfuQBzsCzldndGCyI3issNJnN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	ErKun Yang <yangerkun@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	"zhangyi (F)" <yi.zhang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 076/139] lib/group_cpus: fix NULL pointer dereference from group_cpus_evenly()
Date: Thu,  3 Jul 2025 16:42:19 +0200
Message-ID: <20250703143944.139816089@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yu Kuai <yukuai3@huawei.com>

commit df831e97739405ecbaddb85516bc7d4d1c933d6b upstream.

While testing null_blk with configfs, echo 0 > poll_queues will trigger
following panic:

BUG: kernel NULL pointer dereference, address: 0000000000000010
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 27 UID: 0 PID: 920 Comm: bash Not tainted 6.15.0-02023-gadbdb95c8696-dirty #1238 PREEMPT(undef)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
RIP: 0010:__bitmap_or+0x48/0x70
Call Trace:
 <TASK>
 __group_cpus_evenly+0x822/0x8c0
 group_cpus_evenly+0x2d9/0x490
 blk_mq_map_queues+0x1e/0x110
 null_map_queues+0xc9/0x170 [null_blk]
 blk_mq_update_queue_map+0xdb/0x160
 blk_mq_update_nr_hw_queues+0x22b/0x560
 nullb_update_nr_hw_queues+0x71/0xf0 [null_blk]
 nullb_device_poll_queues_store+0xa4/0x130 [null_blk]
 configfs_write_iter+0x109/0x1d0
 vfs_write+0x26e/0x6f0
 ksys_write+0x79/0x180
 __x64_sys_write+0x1d/0x30
 x64_sys_call+0x45c4/0x45f0
 do_syscall_64+0xa5/0x240
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Root cause is that numgrps is set to 0, and ZERO_SIZE_PTR is returned from
kcalloc(), and later ZERO_SIZE_PTR will be deferenced.

Fix the problem by checking numgrps first in group_cpus_evenly(), and
return NULL directly if numgrps is zero.

[yukuai3@huawei.com: also fix the non-SMP version]
  Link: https://lkml.kernel.org/r/20250620010958.1265984-1-yukuai1@huaweicloud.com
Link: https://lkml.kernel.org/r/20250619132655.3318883-1-yukuai1@huaweicloud.com
Fixes: 6a6dcae8f486 ("blk-mq: Build default queue map via group_cpus_evenly()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: ErKun Yang <yangerkun@huawei.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/group_cpus.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index ee272c4cefcc..18d43a406114 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -352,6 +352,9 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
 	int ret = -ENOMEM;
 	struct cpumask *masks = NULL;
 
+	if (numgrps == 0)
+		return NULL;
+
 	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
 		return NULL;
 
@@ -426,8 +429,12 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
 #else /* CONFIG_SMP */
 struct cpumask *group_cpus_evenly(unsigned int numgrps)
 {
-	struct cpumask *masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
+	struct cpumask *masks;
 
+	if (numgrps == 0)
+		return NULL;
+
+	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
 	if (!masks)
 		return NULL;
 
-- 
2.50.0



