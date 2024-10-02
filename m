Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B3E1D0F57;
	Wed,  2 Oct 2024 14:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878572; cv=none; b=UyVfiWAQm46/dQ5kuoXcnUnXvWhyS/TsUjHSIwqWraDFgH1n0wkGtWnXel3Q6jLemcRFRDBlfzHkDaSECXZSjgsYgn1SavhCL9/rSxk/dWdHgn1q0WjI8EVrGuPyDBfo+JvUefOtS0htZhWwZH3oYZWBSntbHNnR6fnrAsk8gDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878572; c=relaxed/simple;
	bh=pFgbD1A5O2VQrediRV6kv0GJhMNpos5toT6kz8u+B/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQ8Sbc3erFqthsfHXrZjOG68O2yW3KpcxG4cbaTSseR0sdRYjJGmIwsMahF2aOkhhCD0S/7HLalvobv/AsR8OnUTUKPa2Mqht9D07b978mXAu1CApm/alLT8wnShdLUggFLKxTnaMFcttv8u0QScL33CnU/edUxFeZmUwZ8gNIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBN+/rQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBN+/rQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B488C4CEC2;
	Wed,  2 Oct 2024 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878571;
	bh=pFgbD1A5O2VQrediRV6kv0GJhMNpos5toT6kz8u+B/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBN+/rQBrzViTW3+RZXp4KmXIcFsgQjubiJtjOlthCXlXn6nvhBpeKW9UMCycq5vp
	 GgH10O2UEPs7/JtPzaZocAe1UZyQ73TtKLEuZ1UoXLi0jNfyz67RFfyyfWBb/UlMh1
	 095oUWb7w8TKYldmVgl9OTBjx9E3F+Iu2qoXxFF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 459/634] io_uring/sqpoll: retain test for whether the CPU is valid
Date: Wed,  2 Oct 2024 14:59:19 +0200
Message-ID: <20241002125829.220210746@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit a09c17240bdf2e9fa6d0591afa9448b59785f7d4 upstream.

A recent commit ensured that SQPOLL cannot be setup with a CPU that
isn't in the current tasks cpuset, but it also dropped testing whether
the CPU is valid in the first place. Without that, if a task passes in
a CPU value that is too high, the following KASAN splat can get
triggered:

BUG: KASAN: stack-out-of-bounds in io_sq_offload_create+0x858/0xaa4
Read of size 8 at addr ffff800089bc7b90 by task wq-aff.t/1391

CPU: 4 UID: 1000 PID: 1391 Comm: wq-aff.t Not tainted 6.11.0-rc7-00227-g371c468f4db6 #7080
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace.part.0+0xcc/0xe0
 show_stack+0x14/0x1c
 dump_stack_lvl+0x58/0x74
 print_report+0x16c/0x4c8
 kasan_report+0x9c/0xe4
 __asan_report_load8_noabort+0x1c/0x24
 io_sq_offload_create+0x858/0xaa4
 io_uring_setup+0x1394/0x17c4
 __arm64_sys_io_uring_setup+0x6c/0x180
 invoke_syscall+0x6c/0x260
 el0_svc_common.constprop.0+0x158/0x224
 do_el0_svc+0x3c/0x5c
 el0_svc+0x34/0x70
 el0t_64_sync_handler+0x118/0x124
 el0t_64_sync+0x168/0x16c

The buggy address belongs to stack of task wq-aff.t/1391
 and is located at offset 48 in frame:
 io_sq_offload_create+0x0/0xaa4

This frame has 1 object:
 [32, 40) 'allowed_mask'

The buggy address belongs to the virtual mapping at
 [ffff800089bc0000, ffff800089bc9000) created by:
 kernel_clone+0x124/0x7e0

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff0000d740af80 pfn:0x11740a
memcg:ffff0000c2706f02
flags: 0xbffe00000000000(node=0|zone=2|lastcpupid=0x1fff)
raw: 0bffe00000000000 0000000000000000 dead000000000122 0000000000000000
raw: ffff0000d740af80 0000000000000000 00000001ffffffff ffff0000c2706f02
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff800089bc7a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff800089bc7b00: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
>ffff800089bc7b80: 00 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
                         ^
 ffff800089bc7c00: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
 ffff800089bc7c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f3

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202409161632.cbeeca0d-lkp@intel.com
Fixes: f011c9cf04c0 ("io_uring/sqpoll: do not allow pinning outside of cpuset")
Tested-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -465,6 +465,8 @@ __cold int io_sq_offload_create(struct i
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
+			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+				goto err_sqpoll;
 			cpuset_cpus_allowed(current, &allowed_mask);
 			if (!cpumask_test_cpu(cpu, &allowed_mask))
 				goto err_sqpoll;


