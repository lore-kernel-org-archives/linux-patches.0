Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B331BCBC;
	Mon, 27 Oct 2025 19:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592974; cv=none; b=EHghpmAW9fDsC7Oq8SoKDluRf2e9bHQPaH7IjYTck37r5yv+LjAFWxyamLHK0nEHlw8rJly5N0ru+r7lF/gGiieL92m5MeO1e22EG0QfwQrSGDqHmms57hLMP7VBVzdS+XTfMPBCv7vUUWIuAdAFdCx0xjPj4iU4BMpsY8QquXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592974; c=relaxed/simple;
	bh=bvzstBSYbH8qAO/DfnHyLAD8TPFX4XcH+Lr5szEYKb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJXLVlnTZ42VsTfCzYOPElAhhISgQJlUft+EefZHlpJR4plEsNIHqaxS3aD5sGtSJHDGjBeRTnwx+zDB38ekoRBMTZF4H5pljIK7lL2y2U0/DpXBuBG2xRIhE8Nqpp4M/hgeVabgyYPf4AbtsK9Dy19dwi6RXihvYMbCEnRrcb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tL5Myskv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tL5Myskv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AE9C4CEF1;
	Mon, 27 Oct 2025 19:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592973;
	bh=bvzstBSYbH8qAO/DfnHyLAD8TPFX4XcH+Lr5szEYKb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tL5MyskvSelqSAcnUsRrmvA6qmucyII+xFtvA74aqRrzRxsYIMpjpSSJOG1dQ9fCq
	 WukIxux+8RBPuAawKowgI2qAwl3VegNff28Pq67/Na5eAlmNS9ww+j/KLIpzXL0X3l
	 WzjoNTQioqYR9d5EH4qjuEQph55SNc6vOSSJI4h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/117] nbd: override creds to kernel when calling sock_{send,recv}msg()
Date: Mon, 27 Oct 2025 19:36:50 +0100
Message-ID: <20251027183456.298555449@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 81ccca31214e11ea2b537fd35d4f66d7cf46268e ]

sock_{send,recv}msg() internally calls security_socket_{send,recv}msg(),
which does security checks (e.g. SELinux) for socket access against the
current task. However, _sock_xmit() in drivers/block/nbd.c may be called
indirectly from a userspace syscall, where the NBD socket access would
be incorrectly checked against the calling userspace task (which simply
tries to read/write a file that happens to reside on an NBD device).

To fix this, temporarily override creds to kernel ones before calling
the sock_*() functions. This allows the security modules to recognize
this as internal access by the kernel, which will normally be allowed.

A way to trigger the issue is to do the following (on a system with
SELinux set to enforcing):

    ### Create nbd device:
    truncate -s 256M /tmp/testfile
    nbd-server localhost:10809 /tmp/testfile

    ### Connect to the nbd server:
    nbd-client localhost

    ### Create mdraid array
    mdadm --create -l 1 -n 2 /dev/md/testarray /dev/nbd0 missing

After these steps, assuming the SELinux policy doesn't allow the
unexpected access pattern, errors will be visible on the kernel console:

[  142.204243] nbd0: detected capacity change from 0 to 524288
[  165.189967] md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
[  165.252299] md/raid1:md127: active with 1 out of 2 mirrors
[  165.252725] md127: detected capacity change from 0 to 522240
[  165.255434] block nbd0: Send control failed (result -13)
[  165.255718] block nbd0: Request send failed, requeueing
[  165.256006] block nbd0: Dead connection, failed to find a fallback
[  165.256041] block nbd0: Receive control failed (result -32)
[  165.256423] block nbd0: shutting down sockets
[  165.257196] I/O error, dev nbd0, sector 2048 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  165.257736] Buffer I/O error on dev md127, logical block 0, async page read
[  165.258263] I/O error, dev nbd0, sector 2048 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  165.259376] Buffer I/O error on dev md127, logical block 0, async page read
[  165.259920] I/O error, dev nbd0, sector 2048 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  165.260628] Buffer I/O error on dev md127, logical block 0, async page read
[  165.261661] ldm_validate_partition_table(): Disk read failed.
[  165.262108] I/O error, dev nbd0, sector 2048 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  165.262769] Buffer I/O error on dev md127, logical block 0, async page read
[  165.263697] I/O error, dev nbd0, sector 2048 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  165.264412] Buffer I/O error on dev md127, logical block 0, async page read
[  165.265412] I/O error, dev nbd0, sector 2048 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  165.265872] Buffer I/O error on dev md127, logical block 0, async page read
[  165.266378] I/O error, dev nbd0, sector 2048 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  165.267168] Buffer I/O error on dev md127, logical block 0, async page read
[  165.267564]  md127: unable to read partition table
[  165.269581] I/O error, dev nbd0, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  165.269960] Buffer I/O error on dev nbd0, logical block 0, async page read
[  165.270316] I/O error, dev nbd0, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  165.270913] Buffer I/O error on dev nbd0, logical block 0, async page read
[  165.271253] I/O error, dev nbd0, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  165.271809] Buffer I/O error on dev nbd0, logical block 0, async page read
[  165.272074] ldm_validate_partition_table(): Disk read failed.
[  165.272360]  nbd0: unable to read partition table
[  165.289004] ldm_validate_partition_table(): Disk read failed.
[  165.289614]  nbd0: unable to read partition table

The corresponding SELinux denial on Fedora/RHEL will look like this
(assuming it's not silenced):
type=AVC msg=audit(1758104872.510:116): avc:  denied  { write } for  pid=1908 comm="mdadm" laddr=::1 lport=32772 faddr=::1 fport=10809 scontext=system_u:system_r:mdadm_t:s0-s0:c0.c1023 tcontext=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 tclass=tcp_socket permissive=0

The respective backtrace looks like this:
@security[mdadm, -13,
        handshake_exit+221615650
        handshake_exit+221615650
        handshake_exit+221616465
        security_socket_sendmsg+5
        sock_sendmsg+106
        handshake_exit+221616150
        sock_sendmsg+5
        __sock_xmit+162
        nbd_send_cmd+597
        nbd_handle_cmd+377
        nbd_queue_rq+63
        blk_mq_dispatch_rq_list+653
        __blk_mq_do_dispatch_sched+184
        __blk_mq_sched_dispatch_requests+333
        blk_mq_sched_dispatch_requests+38
        blk_mq_run_hw_queue+239
        blk_mq_dispatch_plug_list+382
        blk_mq_flush_plug_list.part.0+55
        __blk_flush_plug+241
        __submit_bio+353
        submit_bio_noacct_nocheck+364
        submit_bio_wait+84
        __blkdev_direct_IO_simple+232
        blkdev_read_iter+162
        vfs_read+591
        ksys_read+95
        do_syscall_64+92
        entry_SYSCALL_64_after_hwframe+120
]: 1

The issue has started to appear since commit 060406c61c7c ("block: add
plug while submitting IO").

Cc: Ming Lei <ming.lei@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2348878
Fixes: 060406c61c7c ("block: add plug while submitting IO")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index de692eed98740..deb298371a6a3 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -52,6 +52,7 @@
 static DEFINE_IDR(nbd_index_idr);
 static DEFINE_MUTEX(nbd_index_mutex);
 static struct workqueue_struct *nbd_del_wq;
+static struct cred *nbd_cred;
 static int nbd_total_devices = 0;
 
 struct nbd_sock {
@@ -557,6 +558,7 @@ static int __sock_xmit(struct nbd_device *nbd, struct socket *sock, int send,
 	int result;
 	struct msghdr msg = {} ;
 	unsigned int noreclaim_flag;
+	const struct cred *old_cred;
 
 	if (unlikely(!sock)) {
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
@@ -565,6 +567,8 @@ static int __sock_xmit(struct nbd_device *nbd, struct socket *sock, int send,
 		return -EINVAL;
 	}
 
+	old_cred = override_creds(nbd_cred);
+
 	msg.msg_iter = *iter;
 
 	noreclaim_flag = memalloc_noreclaim_save();
@@ -589,6 +593,8 @@ static int __sock_xmit(struct nbd_device *nbd, struct socket *sock, int send,
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 
+	revert_creds(old_cred);
+
 	return result;
 }
 
@@ -2605,7 +2611,15 @@ static int __init nbd_init(void)
 		return -ENOMEM;
 	}
 
+	nbd_cred = prepare_kernel_cred(&init_task);
+	if (!nbd_cred) {
+		destroy_workqueue(nbd_del_wq);
+		unregister_blkdev(NBD_MAJOR, "nbd");
+		return -ENOMEM;
+	}
+
 	if (genl_register_family(&nbd_genl_family)) {
+		put_cred(nbd_cred);
 		destroy_workqueue(nbd_del_wq);
 		unregister_blkdev(NBD_MAJOR, "nbd");
 		return -EINVAL;
@@ -2660,6 +2674,7 @@ static void __exit nbd_cleanup(void)
 	/* Also wait for nbd_dev_remove_work() completes */
 	destroy_workqueue(nbd_del_wq);
 
+	put_cred(nbd_cred);
 	idr_destroy(&nbd_index_idr);
 	unregister_blkdev(NBD_MAJOR, "nbd");
 }
-- 
2.51.0



