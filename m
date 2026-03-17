Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F413EDADB;
	Tue, 17 Mar 2026 16:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766397; cv=none; b=NwNjyXQAo7RqzYjHapX9JpP5AV51zLpxo/rlkqUxQdvBTJvd3CPW8+HRUdBbqtisezdNVWXIxU97HGkuu/wKnxAAsxh1jq/rqWrIC69QUdz0KqWv0TH+Ym+gOZg9p9heHIsdx/UnhUelhzNWJg1eAWwSzm6X9HhsyZW9TAQ0wIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766397; c=relaxed/simple;
	bh=ErhYhJMB72c9hEH6ySPPUi2rTO2uJ7N6Cnb/mV/LUhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0n2k+H477xgcveBoF9qQe7VX1LIX0ZDgZJgrnKbJVUsu6i6OX1du3If4Wpn8b6cpf0gdo6qNvdipeUO9UWcJXUCyxzhMJsyhSjwjdopFJcuwMhDwNfwSdjqy+baY3nnofYOtNgAlpk8FjrcvfUvk6scqPGClklVjjXfjqqLy0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLZlKaS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLZlKaS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F05C4CEF7;
	Tue, 17 Mar 2026 16:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766397;
	bh=ErhYhJMB72c9hEH6ySPPUi2rTO2uJ7N6Cnb/mV/LUhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLZlKaS8FZ9Qdz7a8pPIM5S4sCWAMyzNzlueo/x3dtcL/5ejrEG6fW0GPaa0nZumQ
	 f/dqmc4BMMIpVuQbU6lpc+IDxtrqyZFv1uR3HJ1irPQG5u7WfoH/J7VjO1t2SBUA52
	 t/mcJT8k56hHPji3Xph8nNdBdjLXO0ife7roYu4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.19 205/378] libceph: Fix potential out-of-bounds access in ceph_handle_auth_reply()
Date: Tue, 17 Mar 2026 17:32:42 +0100
Message-ID: <20260317163014.553076582@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit b282c43ed156ae15ea76748fc15cd5c39dc9ab72 upstream.

This patch fixes an out-of-bounds access in ceph_handle_auth_reply()
that can be triggered by a message of type CEPH_MSG_AUTH_REPLY. In
ceph_handle_auth_reply(), the value of the payload_len field of such a
message is stored in a variable of type int. A value greater than
INT_MAX leads to an integer overflow and is interpreted as a negative
value. This leads to decrementing the pointer address by this value and
subsequently accessing it because ceph_decode_need() only checks that
the memory access does not exceed the end address of the allocation.

This patch fixes the issue by changing the data type of payload_len to
u32. Additionally, the data type of result_msg_len is changed to u32,
as it is also a variable holding a non-negative length.

Also, an additional layer of sanity checks is introduced, ensuring that
directly after reading it from the message, payload_len and
result_msg_len are not greater than the overall segment length.

BUG: KASAN: slab-out-of-bounds in ceph_handle_auth_reply+0x642/0x7a0 [libceph]
Read of size 4 at addr ffff88811404df14 by task kworker/20:1/262

CPU: 20 UID: 0 PID: 262 Comm: kworker/20:1 Not tainted 6.19.2 #5 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: ceph-msgr ceph_con_workfn [libceph]
Call Trace:
 <TASK>
 dump_stack_lvl+0x76/0xa0
 print_report+0xd1/0x620
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? kasan_complete_mode_report_info+0x72/0x210
 kasan_report+0xe7/0x130
 ? ceph_handle_auth_reply+0x642/0x7a0 [libceph]
 ? ceph_handle_auth_reply+0x642/0x7a0 [libceph]
 __asan_report_load_n_noabort+0xf/0x20
 ceph_handle_auth_reply+0x642/0x7a0 [libceph]
 mon_dispatch+0x973/0x23d0 [libceph]
 ? apparmor_socket_recvmsg+0x6b/0xa0
 ? __pfx_mon_dispatch+0x10/0x10 [libceph]
 ? __kasan_check_write+0x14/0x30i
 ? mutex_unlock+0x7f/0xd0
 ? __pfx_mutex_unlock+0x10/0x10
 ? __pfx_do_recvmsg+0x10/0x10 [libceph]
 ceph_con_process_message+0x1f1/0x650 [libceph]
 process_message+0x1e/0x450 [libceph]
 ceph_con_v2_try_read+0x2e48/0x6c80 [libceph]
 ? __pfx_ceph_con_v2_try_read+0x10/0x10 [libceph]
 ? save_fpregs_to_fpstate+0xb0/0x230
 ? raw_spin_rq_unlock+0x17/0xa0
 ? finish_task_switch.isra.0+0x13b/0x760
 ? __switch_to+0x385/0xda0
 ? __kasan_check_write+0x14/0x30
 ? mutex_lock+0x8d/0xe0
 ? __pfx_mutex_lock+0x10/0x10
 ceph_con_workfn+0x248/0x10c0 [libceph]
 process_one_work+0x629/0xf80
 ? __kasan_check_write+0x14/0x30
 worker_thread+0x87f/0x1570
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? __pfx_try_to_wake_up+0x10/0x10
 ? kasan_print_address_stack_frame+0x1f7/0x280
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x396/0x830
 ? __pfx__raw_spin_lock_irq+0x10/0x10
 ? __pfx_kthread+0x10/0x10
 ? __kasan_check_write+0x14/0x30
 ? recalc_sigpending+0x180/0x210
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x3f7/0x610
 ? __pfx_ret_from_fork+0x10/0x10
 ? __switch_to+0x385/0xda0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

[ idryomov: replace if statements with ceph_decode_need() for
  payload_len and result_msg_len ]

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/auth.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -205,9 +205,9 @@ int ceph_handle_auth_reply(struct ceph_a
 	s32 result;
 	u64 global_id;
 	void *payload, *payload_end;
-	int payload_len;
+	u32 payload_len;
 	char *result_msg;
-	int result_msg_len;
+	u32 result_msg_len;
 	int ret = -EINVAL;
 
 	mutex_lock(&ac->mutex);
@@ -217,10 +217,12 @@ int ceph_handle_auth_reply(struct ceph_a
 	result = ceph_decode_32(&p);
 	global_id = ceph_decode_64(&p);
 	payload_len = ceph_decode_32(&p);
+	ceph_decode_need(&p, end, payload_len, bad);
 	payload = p;
 	p += payload_len;
 	ceph_decode_need(&p, end, sizeof(u32), bad);
 	result_msg_len = ceph_decode_32(&p);
+	ceph_decode_need(&p, end, result_msg_len, bad);
 	result_msg = p;
 	p += result_msg_len;
 	if (p != end)


