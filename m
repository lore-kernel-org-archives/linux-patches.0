Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D8743AA6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDloFdc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455E7C433C8;
	Wed, 15 Nov 2023 20:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081097;
	bh=sbJVwXnix2nKPDkPosppvwcdwVszQ/eH4KaLWY8amPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDloFdc5Q/MItM5cYeibU/V1B3VFh1Zt9ukmIwyrCi8KRdsb2k0r+oevipVKEdhEz
	 7nSi48NlJCwYBkI1I8+exO0XtKAaiIOXz6srbQ0uOdJ0odE7JRUuBykCF7pPPry831
	 nd8BEo0aoNPXTgWa+FYtimTygxZVpbdUs3oc8D7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Glozar <tglozar@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/88] nd_btt: Make BTT lanes preemptible
Date: Wed, 15 Nov 2023 15:35:49 -0500
Message-ID: <20231115191428.408798121@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit 36c75ce3bd299878fd9b238e9803d3817ddafbf3 ]

nd_region_acquire_lane uses get_cpu, which disables preemption. This is
an issue on PREEMPT_RT kernels, since btt_write_pg and also
nd_region_acquire_lane itself take a spin lock, resulting in BUG:
sleeping function called from invalid context.

Fix the issue by replacing get_cpu with smp_process_id and
migrate_disable when needed. This makes BTT operations preemptible, thus
permitting the use of spin_lock.

BUG example occurring when running ndctl tests on PREEMPT_RT kernel:

BUG: sleeping function called from invalid context at
kernel/locking/spinlock_rt.c:48
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 4903, name:
libndctl
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
Preemption disabled at:
[<ffffffffc1313db5>] nd_region_acquire_lane+0x15/0x90 [libnvdimm]
Call Trace:
 <TASK>
 dump_stack_lvl+0x8e/0xb0
 __might_resched+0x19b/0x250
 rt_spin_lock+0x4c/0x100
 ? btt_write_pg+0x2d7/0x500 [nd_btt]
 btt_write_pg+0x2d7/0x500 [nd_btt]
 ? local_clock_noinstr+0x9/0xc0
 btt_submit_bio+0x16d/0x270 [nd_btt]
 __submit_bio+0x48/0x80
 __submit_bio_noacct+0x7e/0x1e0
 submit_bio_wait+0x58/0xb0
 __blkdev_direct_IO_simple+0x107/0x240
 ? inode_set_ctime_current+0x51/0x110
 ? __pfx_submit_bio_wait_endio+0x10/0x10
 blkdev_write_iter+0x1d8/0x290
 vfs_write+0x237/0x330
 ...
 </TASK>

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/region_devs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 609fc450522a1..89539a078623c 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -947,7 +947,8 @@ unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
 {
 	unsigned int cpu, lane;
 
-	cpu = get_cpu();
+	migrate_disable();
+	cpu = smp_processor_id();
 	if (nd_region->num_lanes < nr_cpu_ids) {
 		struct nd_percpu_lane *ndl_lock, *ndl_count;
 
@@ -966,16 +967,15 @@ EXPORT_SYMBOL(nd_region_acquire_lane);
 void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
 {
 	if (nd_region->num_lanes < nr_cpu_ids) {
-		unsigned int cpu = get_cpu();
+		unsigned int cpu = smp_processor_id();
 		struct nd_percpu_lane *ndl_lock, *ndl_count;
 
 		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
 		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
 		if (--ndl_count->count == 0)
 			spin_unlock(&ndl_lock->lock);
-		put_cpu();
 	}
-	put_cpu();
+	migrate_enable();
 }
 EXPORT_SYMBOL(nd_region_release_lane);
 
-- 
2.42.0



