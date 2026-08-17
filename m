Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB326426693;
	Mon, 17 Aug 2026 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978258; cv=none; b=m/whwkD7QBji3t9SBotaJzR/x+2EopkVC7zxkVwvh7gf4pWzZ30qVpil1GeP9Tx3icBpL/j8JteBghY9y8efLnYFdX+aTdzCDO+6Ldt7nukV9KALSTBa4Qo/qiHrW5J3uKgRSC9uubz9UVXsYtDUC1/jbou/RQ+xgPqqRwbHsLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978258; c=relaxed/simple;
	bh=4dwIXFI/2XTFc43VVeq7fkj6I4TJ1RwhsCeoIu950dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNkAkHXUkpeVrdGWxetXTmzAPQ7tvdh6lnYcjI3eOERIvxzLb50bshf3TlaWxrp2juz+XclKmCwZ9wMyzSYES0G6zYEib5fArw32i7qkYzMfUCHoBwqYnBy7RMudCC/Zkc4N0XLs47tyHVnI/JeVg/abSjoFBgvVjMXT9RxFgl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtynBx67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtynBx67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FF71F000E9;
	Mon, 17 Aug 2026 14:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978256;
	bh=LiuKMqpJCIo06X+iRx/WMb9wRcgnx0mTCMnJClIxS+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtynBx67dZkoTG0ZS9hVTU+tj5RCpbkJdAKTeFVw7nHL6O3E03dhF9nD23WBD50M3
	 U3fgOXJtCBpH7pfEYwURcGjQnONp7azaqe33NjDTio6fuq62VU2ji/Bf7GAB0sIPSH
	 T5n0h1gHUd1aUX6TJU96B5DoA/i8Y6r6pRxglzkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 155/181] vsock/virtio: avoid refilling the RX queue after teardown
Date: Mon, 17 Aug 2026 15:34:09 +0200
Message-ID: <20260817132541.787337097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit a31e0ad444698d8aa7534a0f89fda543730f97a5 upstream.

Commit b917507e5ad9 ("vsock/virtio: stop workers during the .remove()")
made the RX worker jump to its common exit when rx_run is clear.  That
exit still refills the RX queue when the buffer count is low, so work
queued across virtio_vsock_vqs_del() can add buffers after the virtqueues
have been deleted.

BUG: KASAN: slab-use-after-free in virtqueue_add_sgs
Read of size 4 by task kworker/0:1
Workqueue: virtio_vsock virtio_transport_rx_work
Call Trace:
 virtqueue_add_sgs (drivers/virtio/virtio_ring.c:2796)
 virtio_vsock_rx_fill (net/vmw_vsock/virtio_transport.c:332)
 virtio_transport_rx_work (net/vmw_vsock/virtio_transport.c:701)
 process_one_work (kernel/workqueue.c:3314)
 worker_thread (kernel/workqueue.c:3478)
 kthread (kernel/kthread.c:436)
 ret_from_fork (arch/x86/kernel/process.c:158)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
...
Freed by task 141:
 kfree (mm/slub.c:6566)
 vp_del_vq (drivers/virtio/virtio_pci_common.c:259)
 vp_del_vqs (drivers/virtio/virtio_pci_common.c:285)
 virtio_vsock_freeze (net/vmw_vsock/virtio_transport.c:912)
 virtio_device_freeze (drivers/virtio/virtio.c:658)
 virtio_pci_freeze (drivers/virtio/virtio_pci_common.c:601)
 pci_pm_freeze (drivers/pci/pci-driver.c:1098)
 device_suspend (drivers/base/power/main.c:1968)
Kernel panic - not syncing: KASAN: panic_on_warn set ...

Jump to a no-refill exit when rx_run is clear, leaving the normal exit
to replenish a running queue.

Fixes: b917507e5ad9 ("vsock/virtio: stop workers during the .remove()")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei <xmei5@asu.edu>
Link: https://lore.kernel.org/r/20260727035804.1860862-1-bestswngs@gmail.com
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Link: https://patch.msgid.link/f9c8c1d64cad9d262f305d02ffe164c2f900fadf.1785352330.git.bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -618,7 +618,7 @@ static void virtio_transport_rx_work(str
 	mutex_lock(&vsock->rx_lock);
 
 	if (!vsock->rx_run)
-		goto out;
+		goto out_nofill;
 
 	vq = vsock->vqs[VSOCK_VQ_RX];
 
@@ -668,6 +668,7 @@ static void virtio_transport_rx_work(str
 out:
 	if (vsock->rx_buf_nr < vsock->rx_buf_max_nr / 2)
 		virtio_vsock_rx_fill(vsock);
+out_nofill:
 	mutex_unlock(&vsock->rx_lock);
 }
 


