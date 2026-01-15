Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6A22C3268;
	Thu, 15 Jan 2026 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498357; cv=none; b=QP0cgnJ7ywwe67/7cvhnSBaYYsIbpxuqhMQFbdb2VQx5+aCgJfKXo7Y1JSOxaNE2Y007Xh/BcGiQqiEHg7lzAS9Lg6vkJfIZeYnuUyyHOXPAEiSvJ/7jtGxTKMcK//9vpeZ1Vkh9mQX6Mh8Vhi4X7nl+R7rs4yfSf43BKP5McZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498357; c=relaxed/simple;
	bh=CkDdKgHyCCCjE41vfLzRIcOJHe2ObP+tfBp/3f1dN/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0/QFFan6ezWS1jk/Z5NVuJniA8qhVczZEyNoGyO+JGdRZuVLcENnBIR6X73yGrAlbOYPZ6uRNLFE+WreItaoX944vXSCMFo7GuACjLnbgmhErIC7D2WEXDjGzB4KeEDkrrvESC9j3+9jRjR69DWn3Wx4DKmU9F9180Zr3gVTNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHTrmagE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHTrmagE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E60C116D0;
	Thu, 15 Jan 2026 17:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498357;
	bh=CkDdKgHyCCCjE41vfLzRIcOJHe2ObP+tfBp/3f1dN/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHTrmagETwB/mo3+mqCHQ3/c0kY8ysPtVwxmiXaEDxr4fqlt7HHNNn12Ceomsvz7G
	 fJhLW6gguAIeN14I4NvjpP70ssslD1gF3P9GBVlYzS6MgrtDf0CrGGFA7VEQ9zPwmx
	 zlvAw24n0ozH9Mhnf194U6zzknyicsBNTFhEeJi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 403/554] e1000: fix OOB in e1000_tbi_should_accept()
Date: Thu, 15 Jan 2026 17:47:49 +0100
Message-ID: <20260115164300.822652478@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 9c72a5182ed92904d01057f208c390a303f00a0f upstream.

In e1000_tbi_should_accept() we read the last byte of the frame via
'data[length - 1]' to evaluate the TBI workaround. If the descriptor-
reported length is zero or larger than the actual RX buffer size, this
read goes out of bounds and can hit unrelated slab objects. The issue
is observed from the NAPI receive path (e1000_clean_rx_irq):

==================================================================
BUG: KASAN: slab-out-of-bounds in e1000_tbi_should_accept+0x610/0x790
Read of size 1 at addr ffff888014114e54 by task sshd/363

CPU: 0 PID: 363 Comm: sshd Not tainted 5.18.0-rc1 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0x5a/0x74
 print_address_description+0x7b/0x440
 print_report+0x101/0x200
 kasan_report+0xc1/0xf0
 e1000_tbi_should_accept+0x610/0x790
 e1000_clean_rx_irq+0xa8c/0x1110
 e1000_clean+0xde2/0x3c10
 __napi_poll+0x98/0x380
 net_rx_action+0x491/0xa20
 __do_softirq+0x2c9/0x61d
 do_softirq+0xd1/0x120
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0xfe/0x130
 ip_finish_output2+0x7d5/0xb00
 __ip_queue_xmit+0xe24/0x1ab0
 __tcp_transmit_skb+0x1bcb/0x3340
 tcp_write_xmit+0x175d/0x6bd0
 __tcp_push_pending_frames+0x7b/0x280
 tcp_sendmsg_locked+0x2e4f/0x32d0
 tcp_sendmsg+0x24/0x40
 sock_write_iter+0x322/0x430
 vfs_write+0x56c/0xa60
 ksys_write+0xd1/0x190
 do_syscall_64+0x43/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f511b476b10
Code: 73 01 c3 48 8b 0d 88 d3 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d f9 2b 2c 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 8e 9b 01 00 48 89 04 24
RSP: 002b:00007ffc9211d4e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000004024 RCX: 00007f511b476b10
RDX: 0000000000004024 RSI: 0000559a9385962c RDI: 0000000000000003
RBP: 0000559a9383a400 R08: fffffffffffffff0 R09: 0000000000004f00
R10: 0000000000000070 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc9211d57f R14: 0000559a9347bde7 R15: 0000000000000003
 </TASK>
Allocated by task 1:
 __kasan_krealloc+0x131/0x1c0
 krealloc+0x90/0xc0
 add_sysfs_param+0xcb/0x8a0
 kernel_add_sysfs_param+0x81/0xd4
 param_sysfs_builtin+0x138/0x1a6
 param_sysfs_init+0x57/0x5b
 do_one_initcall+0x104/0x250
 do_initcall_level+0x102/0x132
 do_initcalls+0x46/0x74
 kernel_init_freeable+0x28f/0x393
 kernel_init+0x14/0x1a0
 ret_from_fork+0x22/0x30
The buggy address belongs to the object at ffff888014114000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1620 bytes to the right of
 2048-byte region [ffff888014114000, ffff888014114800]
The buggy address belongs to the physical page:
page:ffffea0000504400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14110
head:ffffea0000504400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x100000000010200(slab|head|node=0|zone=1)
raw: 0100000000010200 0000000000000000 dead000000000001 ffff888013442000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
==================================================================

This happens because the TBI check unconditionally dereferences the last
byte without validating the reported length first:

	u8 last_byte = *(data + length - 1);

Fix by rejecting the frame early if the length is zero, or if it exceeds
adapter->rx_buffer_len. This preserves the TBI workaround semantics for
valid frames and prevents touching memory beyond the RX buffer.

Fixes: 2037110c96d5 ("e1000: move tbi workaround code into helper function")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -4089,7 +4089,15 @@ static bool e1000_tbi_should_accept(stru
 				    u32 length, const u8 *data)
 {
 	struct e1000_hw *hw = &adapter->hw;
-	u8 last_byte = *(data + length - 1);
+	u8 last_byte;
+
+	/* Guard against OOB on data[length - 1] */
+	if (unlikely(!length))
+		return false;
+	/* Upper bound: length must not exceed rx_buffer_len */
+	if (unlikely(length > adapter->rx_buffer_len))
+		return false;
+	last_byte = *(data + length - 1);
 
 	if (TBI_ACCEPT(hw, status, errors, length, last_byte)) {
 		unsigned long irq_flags;


