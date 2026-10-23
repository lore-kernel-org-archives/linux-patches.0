Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774757;
	b=gJHRfhb1SqZJxLmhbFTtZPwqxXHPyDnBDKA3t5iWf4SXDplur5UwWpmp3U+GQi6RfVEZ
	 mR0HiiLd5o6YSbLR9lRvLJyWZLez0HAVLWCKKpRS5beoG2SytPMPaEdlGdp2faRVhiBQ0
	 FbnfBcsrQIhxwJBhVtiTOdvvB2VJAbfrEIOSaEXUqhvelV0vGH2AI4qV1WpLoHs5Ux4XJ
	 2K/GjREtnWAh15AjicyfAWS9J00P8+prUQ1YUZuZugvTcEO3BYV22SB2I8W0r+buQjt7/
	 rWx16OVStKY9eqmWXKiUs36jsn9ZwFeKWL8iNUPTf/sAiyE0icRV8lsRxuxgr4D/sfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zUQ56g2HvHmeZ7RkD6HeiAxwsk2D86YSmYXqz00S5VI=;
	b=n9d7WoWSvmYC0Ba2ic/LO3I57FLhXbjr8tlJUUwlmIOzbRgKztFr1Ii7gRaF07snerBh
	 wsloedZ4zVa/U6ht5C7jeXpyXR38CfAV1qW+5EasMCxH26b/Ft8PnYXJEX+vd4OcES+Wi
	 aGxErlSC4UpDWq8wwDJW3obIFc4CHrh4B3NkeaKav6lDyZvE0WLBEbqBnUEw7LYzCDCmD
	 4nie7BHAu1GcOuyV0Ncbp0+WNrH+FgoBpHFUjgz1kLqJAG89M3Vn9nLXvWxELAsS4wy/v
	 OSCW/pFAvnMsxlxbSNobCUH43BBlAXblcDVY974SylqxiyLUHKtRowNWmyo93UQQlvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gK472l0l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFE8606A31A;
	Fri, 23 Oct 2026 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gK472l0l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAE91F01825;
	Fri, 23 Oct 2026 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774757;
	bh=zUQ56g2HvHmeZ7RkD6HeiAxwsk2D86YSmYXqz00S5VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gK472l0l39gpBqVVQEbi4lDHpWl7LJwuNvoPOlecKmSuyumK7t3fqTCRp0+ccskob
	 BiIFZqpzj1h+ugoCwnoNMVvaeUsW5NjQnsP2ywmAz3tYWs0xsNVTJ+qtcC8WkDXFkT
	 ba3fRRjjJQfr+sbplfaxBNrRVKNLN8t8EeI7VIoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 148/242] scsi: libiscsi: Validate the ITT reflected in a Reject PDU
Date: Fri, 23 Oct 2026 18:39:50 +0200
Message-ID: <20261023163717.283768332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit c5958c770b2a0ee492414e26b07da9164a0d1f5d upstream.

A Reject PDU carries a copy of the header it rejects, and
iscsi_handle_reject() takes the ITT out of that copy to find the task to
clean up:

      memcpy(&rejected_pdu, data, sizeof(struct iscsi_hdr));
      ...
      task = iscsi_itt_to_task(conn, rejected_pdu.itt);

That value is whatever the target put there. iscsi_itt_to_task() bounds
the index against cmds_max and checks nothing else, so any task in the
pool can be named, and iscsi_nop_out_rsp() then completes it.

An index that has never been used gives a NULL task->conn: the pool is
zeroed at session setup and conn is assigned only when a task is
allocated. If the task was used and returned, iscsi_complete_task() hits
its WARN_ON_ONCE(task->state == ISCSI_TASK_FREE) and the refcount
underflows. An in-flight SCSI command is completed as successful - a 1
MiB read returned 1048576 with none of its buffer written and no
warning.

Validate the reflected ITT the way iscsi_itt_to_ctask() validates a
command ITT, and require the task to be in flight and not a SCSI
command.

[    6.248477] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN NOPTI
[    6.249357] KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
[    6.249951] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted 7.2.0-rc5-ISCSI1-gf5098b6bae76 #1 PREEMPT(lazy)
[    6.250718] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    6.251616] RIP: 0010:iscsi_nop_out_rsp.constprop.0+0x46/0x160
[    6.252043] Code: c1 ea 03 48 83 ec 08 80 3c 02 00 0f 85 f5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 58 48 8d 7d 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 00 00 00 48 8b 45 60 48 39 c3 74 50 48 b8 00
[    6.252813] RSP: 0018:ffff88806c907b80 EFLAGS: 00010206
[    6.253042] RAX: dffffc0000000000 RBX: ffff88800607e000 RCX: ffffffff8d571a25
[    6.253345] RDX: 000000000000000c RSI: ffff88806c907c38 RDI: 0000000000000060
[    6.253642] RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbfff235a504
[    6.253947] R10: 0000000000000003 R11: 7463656e6e6f6320 R12: 0000000000000000
[    6.254251] R13: 0000000000000000 R14: ffff88806c907c38 R15: 0000000000000000
[    6.254549] FS:  0000000000000000(0000) GS:ffff8880d95bc000(0000) knlGS:0000000000000000
[    6.254887] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.255140] CR2: 00007fc393e8ffc0 CR3: 0000000005252006 CR4: 0000000000770ef0
[    6.255439] PKRU: 55555554
[    6.255564] Call Trace:
[    6.255674]  <IRQ>
[    6.255768]  __iscsi_complete_pdu+0x18bf/0x22a0
[    6.256733]  iscsi_complete_pdu+0x54/0xa0
[    6.256905]  iscsi_tcp_data_recv_done+0xf4/0x250
[    6.257103]  iscsi_tcp_recv_skb+0x31e/0xec0
[    6.257680]  iscsi_sw_tcp_recv+0x12f/0x390
[    6.258061]  __tcp_read_sock+0x1ab/0x810
[    6.258853]  iscsi_sw_tcp_data_ready+0x18b/0x510
[    6.259808]  tcp_data_queue+0x1f13/0x4cd0
[    6.260567]  tcp_rcv_established+0x8a5/0x3a00
[    6.261931]  tcp_v4_do_rcv+0x449/0x960
[    6.262269]  tcp_v4_rcv+0x2245/0x3bc0

Fixes: 8afa1439fcff ("[SCSI] libiscsi: handle immediate command rejections")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20261007015842.634893-3-yhlee@isslab.korea.ac.kr
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libiscsi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1142,13 +1142,15 @@ static int iscsi_handle_reject(struct is
 			spin_unlock(&conn->session->frwd_lock);
 			spin_lock(&conn->session->back_lock);
 		} else {
-			struct iscsi_task *task;
+			struct iscsi_task *task = NULL;
 			/*
 			 * Our nop as ping got dropped. We know the target
 			 * and transport are ok so just clean up
 			 */
-			task = iscsi_itt_to_task(conn, rejected_pdu.itt);
-			if (!task) {
+			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
+				task = iscsi_itt_to_task(conn, rejected_pdu.itt);
+			if (!task || task->state == ISCSI_TASK_FREE ||
+			    task->sc) {
 				iscsi_conn_printk(KERN_ERR, conn,
 						 "Invalid pdu reject. Could "
 						 "not lookup rejected task.\n");


