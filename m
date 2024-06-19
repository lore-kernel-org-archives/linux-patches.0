Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCCF4D9EA;
	Wed, 19 Jun 2024 13:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803560; cv=none; b=aR6XTeCDgPU1xbDDRImPi5DOJ9zU9Tdee2zEx2VtopagLZcYk+1IHykzPks4AchhvbXPOnpjtoeEq2rzhn5gI3di1Qww1ViysSonnLiSd1pM8P+7FM5MB0F5WE+5zfRRiXbsVSMd5htL3rzZX5CpAy5euXFfkQkqw0yLIN3qLRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803560; c=relaxed/simple;
	bh=BwHCTRgWlNtA/Y0DB6DLoi4qkCkTc1VoHHP0iqn3rgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/JSN8xsNjgtnXG9P+BvLr05jhJZs5551lCNcR+oXB1Cq5pwYbcZS1APRsOhrbygKsxGpd+e3ayy4veRvwYaZ5Bj81pbs316C5za9707wHI4Q4H8QD23mBhgjrVftkZsgD60osFjZ4UaS2JKnlvhHRNtyPbD+8mtpLIS/Fahg7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ia3lEbi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ia3lEbi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716F8C2BBFC;
	Wed, 19 Jun 2024 13:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803559;
	bh=BwHCTRgWlNtA/Y0DB6DLoi4qkCkTc1VoHHP0iqn3rgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ia3lEbi7cpxn8DBcE5XYZTiHFdSCNGTtsBKieOmkTrECS41WPSR69WDokpTWFrovm
	 dkC7qBpE1zIZLwX43GqSdhUP+GqLF7vIkv+F6lNwJ3ZBkhMT8RMqi2iSOeQhTJ5cRG
	 PULlPzj2B32mR/K+4gKJ6jKFAxY1I/0/jRvuS0mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/217] net/mlx5: Always stop health timer during driver removal
Date: Wed, 19 Jun 2024 14:54:29 +0200
Message-ID: <20240619125557.658567651@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit c8b3f38d2dae0397944814d691a419c451f9906f ]

Currently, if teardown_hca fails to execute during driver removal, mlx5
does not stop the health timer. Afterwards, mlx5 continue with driver
teardown. This may lead to a UAF bug, which results in page fault
Oops[1], since the health timer invokes after resources were freed.

Hence, stop the health monitor even if teardown_hca fails.

[1]
mlx5_core 0000:18:00.0: E-Switch: Unload vfs: mode(LEGACY), nvfs(0), necvfs(0), active vports(0)
mlx5_core 0000:18:00.0: E-Switch: Disable: mode(LEGACY), nvfs(0), necvfs(0), active vports(0)
mlx5_core 0000:18:00.0: E-Switch: Disable: mode(LEGACY), nvfs(0), necvfs(0), active vports(0)
mlx5_core 0000:18:00.0: E-Switch: cleanup
mlx5_core 0000:18:00.0: wait_func:1155:(pid 1967079): TEARDOWN_HCA(0x103) timeout. Will cause a leak of a command resource
mlx5_core 0000:18:00.0: mlx5_function_close:1288:(pid 1967079): tear_down_hca failed, skip cleanup
BUG: unable to handle page fault for address: ffffa26487064230
PGD 100c00067 P4D 100c00067 PUD 100e5a067 PMD 105ed7067 PTE 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           OE     -------  ---  6.7.0-68.fc38.x86_64 #1
Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0013.121520200651 12/15/2020
RIP: 0010:ioread32be+0x34/0x60
RSP: 0018:ffffa26480003e58 EFLAGS: 00010292
RAX: ffffa26487064200 RBX: ffff9042d08161a0 RCX: ffff904c108222c0
RDX: 000000010bbf1b80 RSI: ffffffffc055ddb0 RDI: ffffa26487064230
RBP: ffff9042d08161a0 R08: 0000000000000022 R09: ffff904c108222e8
R10: 0000000000000004 R11: 0000000000000441 R12: ffffffffc055ddb0
R13: ffffa26487064200 R14: ffffa26480003f00 R15: ffff904c108222c0
FS:  0000000000000000(0000) GS:ffff904c10800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffa26487064230 CR3: 00000002c4420006 CR4: 00000000007706f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <IRQ>
 ? __die+0x23/0x70
 ? page_fault_oops+0x171/0x4e0
 ? exc_page_fault+0x175/0x180
 ? asm_exc_page_fault+0x26/0x30
 ? __pfx_poll_health+0x10/0x10 [mlx5_core]
 ? __pfx_poll_health+0x10/0x10 [mlx5_core]
 ? ioread32be+0x34/0x60
 mlx5_health_check_fatal_sensors+0x20/0x100 [mlx5_core]
 ? __pfx_poll_health+0x10/0x10 [mlx5_core]
 poll_health+0x42/0x230 [mlx5_core]
 ? __next_timer_interrupt+0xbc/0x110
 ? __pfx_poll_health+0x10/0x10 [mlx5_core]
 call_timer_fn+0x21/0x130
 ? __pfx_poll_health+0x10/0x10 [mlx5_core]
 __run_timers+0x222/0x2c0
 run_timer_softirq+0x1d/0x40
 __do_softirq+0xc9/0x2c8
 __irq_exit_rcu+0xa6/0xc0
 sysvec_apic_timer_interrupt+0x72/0x90
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20
RIP: 0010:cpuidle_enter_state+0xcc/0x440
 ? cpuidle_enter_state+0xbd/0x440
 cpuidle_enter+0x2d/0x40
 do_idle+0x20d/0x270
 cpu_startup_entry+0x2a/0x30
 rest_init+0xd0/0xd0
 arch_call_rest_init+0xe/0x30
 start_kernel+0x709/0xa90
 x86_64_start_reservations+0x18/0x30
 x86_64_start_kernel+0x96/0xa0
 secondary_startup_64_no_verify+0x18f/0x19b
---[ end trace 0000000000000000 ]---

Fixes: 9b98d395b85d ("net/mlx5: Start health poll at earlier stage of driver load")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index fe0a78c29438b..67849b1c0bb71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1254,6 +1254,9 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 
 	if (!err)
 		mlx5_function_disable(dev, boot);
+	else
+		mlx5_stop_health_poll(dev, boot);
+
 	return err;
 }
 
-- 
2.43.0



