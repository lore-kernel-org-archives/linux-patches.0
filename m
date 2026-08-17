Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B513C9C4;
	Mon, 17 Aug 2026 14:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976443; cv=none; b=stDj+++3oTQhOvDc91kSjRQw25ql39IeIdkXl80GEwzAU44jf1WmZFvPNmMdtdl56t/kM+KOGf7XKD2S+9MJIUFZQki9zkaTWMe9xKxynyoKr/89TlGWUTBYq7s51a0/FRG21ttFX3JgiU6Dp2vq0cEbKE2hAODWQ49XCAqGI4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976443; c=relaxed/simple;
	bh=TQH7x6e/i24WcleP7cjSjhCcnEOaARtj9nO170yXR9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t59Gvhen6z5OkrzpfvAnQ8329mXsJGim1n7zSM/fFJK6oPnZo55ZaPTu0+COfBDHZODP4izrExxhDAVA4aqGTUK0IX/GrKdWiB2ojhyqEsLnPNqNJeNDbM7K8FMKutUKZJ6HcjLUyYRso+Ta+uaXVgVJ4+6LJL4nSOg1ftn8n6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wonqRVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wonqRVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DD21F000E9;
	Mon, 17 Aug 2026 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976442;
	bh=PM1C84PdSO7wtE3Rhv+WgmMbft+z/aTqxq6HypSgK+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wonqRVC01SDpyKBBHom6WoA5EVe6iIFwXhc0c6An6gGxVsWN09dAbLCF2B6s51P5
	 PgtVOC0AvqtInX6mrNZDawfXc6ixxNAEgrdDNUnwAU1Ra1twR7FsPCILLhzzlfB6k4
	 Pj5D4p/JWO/YeU76rKoPCoubWclY4YlVW9nEPKH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 375/389] vsock/virtio: avoid refilling the RX queue after teardown
Date: Mon, 17 Aug 2026 15:33:34 +0200
Message-ID: <20260817132553.323196790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -501,7 +501,7 @@ static void virtio_transport_rx_work(str
 	mutex_lock(&vsock->rx_lock);
 
 	if (!vsock->rx_run)
-		goto out;
+		goto out_nofill;
 
 	do {
 		virtqueue_disable_cb(vq);
@@ -540,6 +540,7 @@ static void virtio_transport_rx_work(str
 out:
 	if (vsock->rx_buf_nr < vsock->rx_buf_max_nr / 2)
 		virtio_vsock_rx_fill(vsock);
+out_nofill:
 	mutex_unlock(&vsock->rx_lock);
 }
 


