Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA4D415F22;
	Fri,  4 Sep 2026 05:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500235; cv=none; b=lg5o01EwBw7O93KY99aGtobS1GTZAwHTUs2uRDrx2toCGJvrvrR30SQrhqckVoCo4fpm8pGI4esehotR21Y47/Rz6cKupvNrqJ5DbY3WPusBoGobOPL9UPYww+lHcexsRpwu5CAyTnb/wl0EH9ggrHfNMUjEbfRzXm5cHZR6ADg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500235; c=relaxed/simple;
	bh=gu+8JFimFDDoPmT9Suks8XSjgDuCOMuIVNfS8ZQbxhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjOkrarGcpOhCz5oXpmDD9JUrE0dTzcTh9a01x8zHUOYWt9+Jkv39FaP2AP+6Nn4o35QL09VkYmIxTh4oVP5m3Si7pAIjobG97EpAX+hREk+bOSdL9lMgL6L8FaZfG3C2aV3GgMm2YomIZnECxnL2z75DRlxGdQjLOcx+461Ma4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFYf9gvS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFYf9gvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E821F00A3D;
	Fri,  4 Sep 2026 05:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500233;
	bh=xiCfXvT5CCGNZsMsjVtGF4o83PVgTYWwY20d8ayqLw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFYf9gvSoOpyoerKhXY+flxH7uY+o1BOqZB0h9rP5ugp5CDe4HjuO+C9KRWlXzdC/
	 clBjAdPbhnzLwECJuxFt158Zuzq+u7k6BrczlSRw00LZo871GE3XHeC9gsfIC99vOT
	 cWfKAFtAu2FkZkZVcr5YyW8EpkFcT+a2lHrnFY2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 698/713] vsock/virtio: flush works in dependency order
Date: Fri,  4 Sep 2026 07:01:06 +0200
Message-ID: <20260904045819.493563520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 728836ebca239810f164262b10211ef59182f811 upstream.

virtio_vsock_remove() stops the virtqueues and then flushes each work
item before freeing the enclosing virtio_vsock.  The current order does
not account for dependencies between those items: tx_work may queue
send_pkt_work, and send_pkt_work may queue rx_work.

In particular, send_pkt_work can set restart_rx and release tx_lock.
The remove path can then stop the queues and flush rx_work before
send_pkt_work queues it.  Although the later send_pkt_work flush waits
for that producer to finish, nothing waits for the newly queued rx_work,
so kfree(vsock) can race with it.

KASAN reported:

  BUG: KASAN: slab-use-after-free in
  virtio_transport_rx_work+0x487/0x4b0
  Read of size 8 at addr ffff888114c2b008 by task kworker/1:1/47
  Workqueue: virtio_vsock virtio_transport_rx_work
  Call Trace:
   virtio_transport_rx_work+0x487/0x4b0
   process_one_work+0x688/0x1120
   worker_thread+0x45b/0xd10
  Allocated by task 1:
   virtio_vsock_probe+0xef/0x6b0
  Freed by task 84:
   kfree+0x131/0x3c0
   virtio_vsock_remove+0xd1/0x100

Flush the works in producer-to-consumer order.  virtio_vsock_vqs_del()
has already disabled the queue callbacks and cleared the run flags, so
after tx_work and send_pkt_work are drained, no source remains that can
queue rx_work after its flush.

Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Link: https://patch.msgid.link/20260822164556.3750959-1-nicoyip.dev@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -872,10 +872,10 @@ static void virtio_vsock_remove(struct v
 	/* Other works can be queued before 'config->del_vqs()', so we flush
 	 * all works before to free the vsock object to avoid use after free.
 	 */
-	flush_work(&vsock->rx_work);
 	flush_work(&vsock->tx_work);
 	flush_work(&vsock->event_work);
 	flush_work(&vsock->send_pkt_work);
+	flush_work(&vsock->rx_work);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 


