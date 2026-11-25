Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624396;
	b=3zFVaFTUewK7iPTa2N0x+wXxTjnaM9MmSMV/sIYh7x9JpjppG7yyGiEtdfaIfP7OY0RQ
	 L+v14wlxTFjV0m/D6ydMVNyrMb8Hhjq3OVgS7ZJesuRuBLUVwnb5pLT+sOkZIvC/tykmD
	 OPOZcB3d003TXLUebQ/qVwYKIEkftsXjN28H8DTWN8/o0VUuMxOkZqPc1BuJuHzgdeMQY
	 IOCY3AnQvQSvngeQCRK80yIttCKPJHnMlQo8NPTqasaVz5qF24gLaP1vwEtbSaCo3pfOJ
	 q69N/2iluiGwI5NAbnTtGnI0leL4rzDeK31Au6EwmNMEHlr9sq3cTw12CBvDjJgiB0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I4ImDKagfPHI3f3fshAOgUCsSY5p+UlnxBMB3IvmCTQ=;
	b=pxFJuQuwoGeboSmv2NbfadWHrjoPoNgsGIOLLS8Uz7WqAi7wJ9DNC4oTz4bvrBxWLBwW
	 Jhjqom1vdqo2OIxOeMJ7TiRIwrGFJ6UOU4zwCTNeWxKIG2Cwi8HZQtyM65dunJhzxW+wb
	 R7sHuOXgKG3M/kNSWM72H3xzcVGW10WPUDeObI9ddjnAJd9/FqFZg5Qh5VkpwpMUS5pRf
	 berCXTmbLypCAQO0ZlXCWthmCCkeQ8MnTpa5z6d9dUOcViJpvIBRa51aHsb1mseXQgcDU
	 2ThFh+4FIFTebZ3rXXKCLffZYdzgr2UQwwE1oWic57J+UxFYCXsnxGz1GkClypAMUqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tVnKjHq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E2B606A697;
	Wed, 25 Nov 2026 16:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tVnKjHq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BCA1F000C6;
	Wed, 25 Nov 2026 16:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624396;
	bh=I4ImDKagfPHI3f3fshAOgUCsSY5p+UlnxBMB3IvmCTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tVnKjHq9feWLynfOaamj0WHcqjzBNWbkhzl+PqkFf3Aix4ppHucezpTJUf3V8Nbs
	 KKcd+51d4My2qiM3QDsTLrgPi7S5J8i2IRCKXYBBoNijHYhdHnQTbfPHmXomUe8Sca
	 /iYMKZwC8zVlGp+IoleFtmcSj38Kcd32Kut4mNvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/816] vhost-scsi: do not relock event vq mutex on send_evt fallback
Date: Wed, 25 Nov 2026 15:28:02 +0100
Message-ID: <20261125143852.304873717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit a016d03a9cfe29aeeba438f32f8e8f63291e3275 ]

vhost_scsi_send_evt() is called with the event virtqueue mutex held.
If the worker is gone, the fallback currently calls
vhost_scsi_complete_events(), which tries to acquire the same mutex again
and deadlocks the caller.

Split event completion into a helper for callers that already hold the
mutex and a locking wrapper for the event worker. Use the helper on the
fallback path.

Link: https://lore.kernel.org/all/20260905005352.1E5B01F00A3D@smtp.kernel.org/
Fixes: b1b2ce58ed23 ("vhost-scsi: Handle vhost_vq_work_queue failures for events")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260915094244.7900-3-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5f7480db273a6..b8a726e1a2c78 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -508,19 +508,26 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 		vq_err(vq, "Faulted on vhost_scsi_send_event\n");
 }
 
-static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
+/* Caller must hold the event virtqueue mutex. */
+static void __vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
 {
-	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	struct vhost_scsi_evt *evt, *t;
 	struct llist_node *llnode;
 
-	mutex_lock(&vq->mutex);
 	llnode = llist_reverse_order(llist_del_all(&vs->vs_event_list));
 	llist_for_each_entry_safe(evt, t, llnode, list) {
 		if (!drop)
 			vhost_scsi_do_evt_work(vs, evt);
 		vhost_scsi_free_evt(vs, evt);
 	}
+}
+
+static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
+{
+	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
+
+	mutex_lock(&vq->mutex);
+	__vhost_scsi_complete_events(vs, drop);
 	mutex_unlock(&vq->mutex);
 }
 
@@ -1595,7 +1602,7 @@ vhost_scsi_send_evt(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 
 	llist_add(&evt->list, &vs->vs_event_list);
 	if (!vhost_vq_work_queue(vq, &vs->vs_event_work))
-		vhost_scsi_complete_events(vs, true);
+		__vhost_scsi_complete_events(vs, true);
 }
 
 static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
-- 
2.53.0



