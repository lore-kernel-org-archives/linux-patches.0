Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E3F223DCE;
	Mon, 13 Apr 2026 16:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098921; cv=none; b=a2qaLv4Juf+Nsg18HfICXbT15Psfm1n2zYtHgd2xxjLsEx5+YAHovV8kbxCqDYWsitwoeEV13OgAyeysKRD9T3VJ3abOgQyOkNVm9GX/DD4qNk2ZxiXFVeMbKkiSawjwJBOZW2PmnYsvBBZCByGiRyFRQiACZP4Uv/4oabUVTAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098921; c=relaxed/simple;
	bh=kto1kre+xEdRRJgQ7IympDVQ9bN/U8KBoDATx6Sl8rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dk9//6uWFzDvYy08/xJtP8akP1wXCkdh4OLWllgoPsyesRBv+drnpdpUF9hGZkGEZq3wJ3PxyynB+SZz5LuxhNEBZ69NKztPxEW3GtMsC8zgSAUgo29neB/+Pl2Ui+di1A+Ljp7jowb2wyjWrkBAg9XISCkZWWjzV+3XjhDN2yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpSd5qJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpSd5qJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5EFC2BCAF;
	Mon, 13 Apr 2026 16:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098920;
	bh=kto1kre+xEdRRJgQ7IympDVQ9bN/U8KBoDATx6Sl8rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpSd5qJaxp+yxkhRvlJW8CkgDOWzRHN86Kg4Cp2xW8IOu2gcc6+N5+8SuSoJy/yZI
	 5+QOXgoraHMJryxuWXkfyOcAWEuFd2SDJ2SQvxtpWfFAGdSxGY8nos5DDrSIpXXaCS
	 rdyzCUZdNpfq6aSNxHht/NXs1qFzRHSxYQVtsZdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 108/491] libceph: Fix potential out-of-bounds access in ceph_handle_auth_reply()
Date: Mon, 13 Apr 2026 17:55:53 +0200
Message-ID: <20260413155823.085980263@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -185,9 +185,9 @@ int ceph_handle_auth_reply(struct ceph_a
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
@@ -197,10 +197,12 @@ int ceph_handle_auth_reply(struct ceph_a
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


