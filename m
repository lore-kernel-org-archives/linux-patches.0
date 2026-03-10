Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15CE38945A;
	Tue, 10 Mar 2026 11:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141247; cv=none; b=WPvZc1j8347/UlP2edKRMebCT0SFJ/opmFPnaoaDpldcjouZskDG/HgMSQvPavPCd15PtYxfMrrdpzwM1E0B9EH1y7NZ3X4dvKIjpHHMfm7IcyNxV8A3Cp2xh8N37NTQ8vO4z8wc0cvxmcnpkkoRYBk1HsrCP2gjgXNUE3Pf6qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141247; c=relaxed/simple;
	bh=amrbikU7IN6hJui9TMZQlIjt1R5+iXG3LRSOilXiYBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAIW7JMSN4sacbzq5bxGyeBJ3sufxroutlNvXI9Kl+jlH6IDM9Hichway3kPo5RZmfmrmLYS+hf+ri3lupT/or8C6FjNh0pqv0b9FjaEKKuk8DlxHSqb55KqX7YtmJE2ZoFpDBefO5rJkO5SHObe4fGZxohVCvjfp8RGHkjc/TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cv5pLh3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cv5pLh3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B2DC19423;
	Tue, 10 Mar 2026 11:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141246;
	bh=amrbikU7IN6hJui9TMZQlIjt1R5+iXG3LRSOilXiYBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cv5pLh3/ySJQIUS2LR4KJ2SpWxwzBKkEhID23PElFVQeHeWd4uYQoHZ5Tp3QkZofc
	 gpc/gtLdP2JlNdcuvJhUj38PtBGZ3j6WMKdUY7RR3cqdkN8a1my6JeZqqmZAWd3IbI
	 3Rze6+7FMPLJgSQpyHrM2Fy1+J9dk80CATEHg7sAq8jk+jc0EpJkfdjQ9TQ2ju9ZAb
	 OYZNxzVqrx8zvawnIwTs9F6NVhCZ73P5AZcIa8ZcIWwzAMVKDrptgrNkxWsPH41bGQ
	 W02MPSkVzbduClw9xohA/AUJwMV1wVKt5+9JctRmbaqLi5m865peWC970ALxc31Oma
	 C5m3d72JGs+rw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 249/311] libie: don't unroll if fwlog isn't supported
Date: Tue, 10 Mar 2026 07:04:56 -0400
Message-ID: <c3adc4cc5f14d8193bca6259bbf301e97c20f82d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 636cc3bd12f499c74eaf5dc9a7d5b832f1bb24ed ]

The libie_fwlog_deinit() function can be called during driver unload
even when firmware logging was never properly initialized. This led to call
trace:

[  148.576156] Oops: Oops: 0000 [#1] SMP NOPTI
[  148.576167] CPU: 80 UID: 0 PID: 12843 Comm: rmmod Kdump: loaded Not tainted 6.17.0-rc7next-queue-3oct-01915-g06d79d51cf51 #1 PREEMPT(full)
[  148.576177] Hardware name: HPE ProLiant DL385 Gen10 Plus/ProLiant DL385 Gen10 Plus, BIOS A42 07/18/2020
[  148.576182] RIP: 0010:__dev_printk+0x16/0x70
[  148.576196] Code: 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 41 55 41 54 49 89 d4 55 48 89 fd 53 48 85 f6 74 3c <4c> 8b 6e 50 48 89 f3 4d 85 ed 75 03 4c 8b 2e 48 89 df e8 f3 27 98
[  148.576204] RSP: 0018:ffffd2fd7ea17a48 EFLAGS: 00010202
[  148.576211] RAX: ffffd2fd7ea17aa0 RBX: ffff8eb288ae2000 RCX: 0000000000000000
[  148.576217] RDX: ffffd2fd7ea17a70 RSI: 00000000000000c8 RDI: ffffffffb68d3d88
[  148.576222] RBP: ffffffffb68d3d88 R08: 0000000000000000 R09: 0000000000000000
[  148.576227] R10: 00000000000000c8 R11: ffff8eb2b1a49400 R12: ffffd2fd7ea17a70
[  148.576231] R13: ffff8eb3141fb000 R14: ffffffffc1215b48 R15: ffffffffc1215bd8
[  148.576236] FS:  00007f5666ba6740(0000) GS:ffff8eb2472b9000(0000) knlGS:0000000000000000
[  148.576242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  148.576247] CR2: 0000000000000118 CR3: 000000011ad17000 CR4: 0000000000350ef0
[  148.576252] Call Trace:
[  148.576258]  <TASK>
[  148.576269]  _dev_warn+0x7c/0x96
[  148.576290]  libie_fwlog_deinit+0x112/0x117 [libie_fwlog]
[  148.576303]  ixgbe_remove+0x63/0x290 [ixgbe]
[  148.576342]  pci_device_remove+0x42/0xb0
[  148.576354]  device_release_driver_internal+0x19c/0x200
[  148.576365]  driver_detach+0x48/0x90
[  148.576372]  bus_remove_driver+0x6d/0xf0
[  148.576383]  pci_unregister_driver+0x2e/0xb0
[  148.576393]  ixgbe_exit_module+0x1c/0xd50 [ixgbe]
[  148.576430]  __do_sys_delete_module.isra.0+0x1bc/0x2e0
[  148.576446]  do_syscall_64+0x7f/0x980

It can be reproduced by trying to unload ixgbe driver in recovery mode.

Fix that by checking if fwlog is supported before doing unroll.

Fixes: 641585bc978e ("ixgbe: fwlog support for e610")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/libie/fwlog.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/libie/fwlog.c b/drivers/net/ethernet/intel/libie/fwlog.c
index f39cc11cb7c56..5d890d9d3c4d5 100644
--- a/drivers/net/ethernet/intel/libie/fwlog.c
+++ b/drivers/net/ethernet/intel/libie/fwlog.c
@@ -1051,6 +1051,10 @@ void libie_fwlog_deinit(struct libie_fwlog *fwlog)
 {
 	int status;
 
+	/* if FW logging isn't supported it means no configuration was done */
+	if (!libie_fwlog_supported(fwlog))
+		return;
+
 	/* make sure FW logging is disabled to not put the FW in a weird state
 	 * for the next driver load
 	 */
-- 
2.51.0

