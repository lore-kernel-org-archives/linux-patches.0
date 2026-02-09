Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EC72750E6;
	Mon,  9 Feb 2026 14:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770649015; cv=none; b=PjZn0jFfhFvpMD9bUT+JZ8zxI1/3hKIh93PGhQRTCKwKARzokk8+g28pAG3874nVFhLNlBbmbZ2CB3aS5M/i+Z95KnheJC4WfiJQ8lrGG7FWkoFjO9jvmb7eNhawFTD2s36O8ePg+vOIMb3VFMKDVwBL6z9XK6ppucRLmpidm/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770649015; c=relaxed/simple;
	bh=Out0DXXSD62aNXwq6RDIAcfDVb9Us0B5xpFUz/gSG8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mE2fVrvSiBleFDXdpCk0phugcGfbo9HJ8wQD85mC26FWwqmxwGHqMVaD6iaMAn4jHi0Dl763Cn5oQXBs1VFYg5C9bbUGapXKvd2kDgCr/Qh3jmfbTQZISKhG9ESj5idrEPxGeQJLo2xyZ7cDc7KF5rU6kPc9CqJOh3pKt/9/JP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvFxO8aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvFxO8aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204C6C116C6;
	Mon,  9 Feb 2026 14:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770649015;
	bh=Out0DXXSD62aNXwq6RDIAcfDVb9Us0B5xpFUz/gSG8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvFxO8aUu8x1THHm5obTBMYGXqe9nv0PenmTmE1bHywvh9GDhNz1pC6f/OGpAPiwz
	 fekSwvQ3mar5j6a1K5b3bMzVGS2TiuWX37XcIxFCqUzg+Zz6p0o7j28g6OmGm5TvbE
	 WczcYTXiXKpduXoZXgMziuuEy8vCQG3ySO+onI5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 5.15 67/75] Bluetooth: hci_event: call disconnect callback before deleting conn
Date: Mon,  9 Feb 2026 15:25:04 +0100
Message-ID: <20260209142304.263885246@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

commit 7f7cfcb6f0825652973b780f248603e23f16ee90 upstream.

In hci_cs_disconnect, we do hci_conn_del even if disconnection failed.

ISO, L2CAP and SCO connections refer to the hci_conn without
hci_conn_get, so disconn_cfm must be called so they can clean up their
conn, otherwise use-after-free occurs.

ISO:
==========================================================
iso_sock_connect:880: sk 00000000eabd6557
iso_connect_cis:356: 70:1a:b8:98:ff:a2 -> 28:3d:c2:4a:7e:da
...
iso_conn_add:140: hcon 000000001696f1fd conn 00000000b6251073
hci_dev_put:1487: hci0 orig refcnt 17
__iso_chan_add:214: conn 00000000b6251073
iso_sock_clear_timer:117: sock 00000000eabd6557 state 3
...
hci_rx_work:4085: hci0 Event packet
hci_event_packet:7601: hci0: event 0x0f
hci_cmd_status_evt:4346: hci0: opcode 0x0406
hci_cs_disconnect:2760: hci0: status 0x0c
hci_sent_cmd_data:3107: hci0 opcode 0x0406
hci_conn_del:1151: hci0 hcon 000000001696f1fd handle 2560
hci_conn_unlink:1102: hci0: hcon 000000001696f1fd
hci_conn_drop:1451: hcon 00000000d8521aaf orig refcnt 2
hci_chan_list_flush:2780: hcon 000000001696f1fd
hci_dev_put:1487: hci0 orig refcnt 21
hci_dev_put:1487: hci0 orig refcnt 20
hci_req_cmd_complete:3978: opcode 0x0406 status 0x0c
... <no iso_* activity on sk/conn> ...
iso_sock_sendmsg:1098: sock 00000000dea5e2e0, sk 00000000eabd6557
BUG: kernel NULL pointer dereference, address: 0000000000000668
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP PTI
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc38 04/01/2014
RIP: 0010:iso_sock_sendmsg (net/bluetooth/iso.c:1112) bluetooth
==========================================================

L2CAP:
==================================================================
hci_cmd_status_evt:4359: hci0: opcode 0x0406
hci_cs_disconnect:2760: hci0: status 0x0c
hci_sent_cmd_data:3085: hci0 opcode 0x0406
hci_conn_del:1151: hci0 hcon ffff88800c999000 handle 3585
hci_conn_unlink:1102: hci0: hcon ffff88800c999000
hci_chan_list_flush:2780: hcon ffff88800c999000
hci_chan_del:2761: hci0 hcon ffff88800c999000 chan ffff888018ddd280
...
BUG: KASAN: slab-use-after-free in hci_send_acl+0x2d/0x540 [bluetooth]
Read of size 8 at addr ffff888018ddd298 by task bluetoothd/1175

CPU: 0 PID: 1175 Comm: bluetoothd Tainted: G            E      6.4.0-rc4+ #2
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc38 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x5b/0x90
 print_report+0xcf/0x670
 ? __virt_addr_valid+0xf8/0x180
 ? hci_send_acl+0x2d/0x540 [bluetooth]
 kasan_report+0xa8/0xe0
 ? hci_send_acl+0x2d/0x540 [bluetooth]
 hci_send_acl+0x2d/0x540 [bluetooth]
 ? __pfx___lock_acquire+0x10/0x10
 l2cap_chan_send+0x1fd/0x1300 [bluetooth]
 ? l2cap_sock_sendmsg+0xf2/0x170 [bluetooth]
 ? __pfx_l2cap_chan_send+0x10/0x10 [bluetooth]
 ? lock_release+0x1d5/0x3c0
 ? mark_held_locks+0x1a/0x90
 l2cap_sock_sendmsg+0x100/0x170 [bluetooth]
 sock_write_iter+0x275/0x280
 ? __pfx_sock_write_iter+0x10/0x10
 ? __pfx___lock_acquire+0x10/0x10
 do_iter_readv_writev+0x176/0x220
 ? __pfx_do_iter_readv_writev+0x10/0x10
 ? find_held_lock+0x83/0xa0
 ? selinux_file_permission+0x13e/0x210
 do_iter_write+0xda/0x340
 vfs_writev+0x1b4/0x400
 ? __pfx_vfs_writev+0x10/0x10
 ? __seccomp_filter+0x112/0x750
 ? populate_seccomp_data+0x182/0x220
 ? __fget_light+0xdf/0x100
 ? do_writev+0x19d/0x210
 do_writev+0x19d/0x210
 ? __pfx_do_writev+0x10/0x10
 ? mark_held_locks+0x1a/0x90
 do_syscall_64+0x60/0x90
 ? lockdep_hardirqs_on_prepare+0x149/0x210
 ? do_syscall_64+0x6c/0x90
 ? lockdep_hardirqs_on_prepare+0x149/0x210
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7ff45cb23e64
Code: 15 d1 1f 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 80 3d 9d a7 0d 00 00 74 13 b8 14 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 89 54 24 1c 48 89
RSP: 002b:00007fff21ae09b8 EFLAGS: 00000202 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007ff45cb23e64
RDX: 0000000000000001 RSI: 00007fff21ae0aa0 RDI: 0000000000000017
RBP: 00007fff21ae0aa0 R08: 000000000095a8a0 R09: 0000607000053f40
R10: 0000000000000001 R11: 0000000000000202 R12: 00007fff21ae0ac0
R13: 00000fffe435c150 R14: 00007fff21ae0a80 R15: 000060f000000040
 </TASK>

Allocated by task 771:
 kasan_save_stack+0x33/0x60
 kasan_set_track+0x25/0x30
 __kasan_kmalloc+0xaa/0xb0
 hci_chan_create+0x67/0x1b0 [bluetooth]
 l2cap_conn_add.part.0+0x17/0x590 [bluetooth]
 l2cap_connect_cfm+0x266/0x6b0 [bluetooth]
 hci_le_remote_feat_complete_evt+0x167/0x310 [bluetooth]
 hci_event_packet+0x38d/0x800 [bluetooth]
 hci_rx_work+0x287/0xb20 [bluetooth]
 process_one_work+0x4f7/0x970
 worker_thread+0x8f/0x620
 kthread+0x17f/0x1c0
 ret_from_fork+0x2c/0x50

Freed by task 771:
 kasan_save_stack+0x33/0x60
 kasan_set_track+0x25/0x30
 kasan_save_free_info+0x2e/0x50
 ____kasan_slab_free+0x169/0x1c0
 slab_free_freelist_hook+0x9e/0x1c0
 __kmem_cache_free+0xc0/0x310
 hci_chan_list_flush+0x46/0x90 [bluetooth]
 hci_conn_cleanup+0x7d/0x330 [bluetooth]
 hci_cs_disconnect+0x35d/0x530 [bluetooth]
 hci_cmd_status_evt+0xef/0x2b0 [bluetooth]
 hci_event_packet+0x38d/0x800 [bluetooth]
 hci_rx_work+0x287/0xb20 [bluetooth]
 process_one_work+0x4f7/0x970
 worker_thread+0x8f/0x620
 kthread+0x17f/0x1c0
 ret_from_fork+0x2c/0x50
==================================================================

Fixes: b8d290525e39 ("Bluetooth: clean up connection in hci_cs_disconnect")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2373,6 +2373,9 @@ static void hci_cs_disconnect(struct hci
 			hci_req_reenable_advertising(hdev);
 		}
 
+		/* Inform sockets conn is gone before we delete it */
+		hci_disconn_cfm(conn, HCI_ERROR_UNSPECIFIED);
+
 		/* If the disconnection failed for any reason, the upper layer
 		 * does not retry to disconnect in current implementation.
 		 * Hence, we need to do some basic cleanup here and re-enable


