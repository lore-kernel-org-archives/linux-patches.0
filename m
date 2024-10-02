Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1391D175B;
	Wed,  2 Oct 2024 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880237; cv=none; b=fu4GjU+EabannLb4CWEwvvI32jUdAEs8Liyg+m3TFaaG/1i+tNT2aD/PhQH5mkM52qye7C/J1uCxxQ8PjzN8CD6UjrVL9C02R3C1b2PXsAMVJBDmBsKSO5qrsDFFJqSajf/9RNL+VmECbIeXvfegTkIvxHBe44Ue4t0X80/l8Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880237; c=relaxed/simple;
	bh=es8bYu1FW2ShxD2ducuaeXA4UUSlU1ReJGHUzElvIJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKg+DL3KOnKJOMTHU8JLKAtpohyMu/8h+QLwG6zFYdFTFbCupZjlBm0OtcpFwHyMwg7ugq/Hc3xB/+4StJwAfnB9/ljWZjnMTbGFBDCSsjJyKOX2VB4wundzcGvEC9FnLANzHEy+wQnm5+f3n3V27jtSbjQVJPNyLkIqRXctsaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ow+C26T8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ow+C26T8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A09C4CEC2;
	Wed,  2 Oct 2024 14:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880237;
	bh=es8bYu1FW2ShxD2ducuaeXA4UUSlU1ReJGHUzElvIJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ow+C26T8k38mYDr47bWVvQddnO+f+P3zIYRdsts6Vtca0InG1VRfA9/Bs7xmmO8zg
	 zLF/Ws3k7DNkCdTWQJIPVQepsxYUKJvpERKDsqwSu3ZpmAk6CXqXyBDJlWmIQ0td+B
	 XUUSzh5DgAREaTuOdwxmn/Wadtw3t4IOdf5TWRj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 390/538] io_uring/sqpoll: retain test for whether the CPU is valid
Date: Wed,  2 Oct 2024 15:00:29 +0200
Message-ID: <20241002125807.826441149@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
@@ -406,6 +406,8 @@ __cold int io_sq_offload_create(struct i
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
+			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+				goto err_sqpoll;
 			cpuset_cpus_allowed(current, &allowed_mask);
 			if (!cpumask_test_cpu(cpu, &allowed_mask))
 				goto err_sqpoll;


