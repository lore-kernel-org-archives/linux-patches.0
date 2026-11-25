Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621211;
	b=PwMaSY9PUHyj0bRnXxdyerajOu3kvJErQOanUvimTd1BKVc6/2XOGuQFhPmFjBDXP493
	 qIBHCz+aBAeInepjHqHFoPJs/CgzBucRKpygBOsN33HI7W2KYb6RpxAoIsbNpVoK97LnI
	 B/tb3FOUSjfJjCKPPBeFMZX1FNKA8VYtVNXz5njbrfw76tNPJ8NZKU5HudnpbisV2N1Qy
	 BX9JhlR+ajpNv3AsdRiJDkp7GQlIdvcil9Env7pac9ondCND7Ojtyt64xs+S2xwgo3HJA
	 7zJz+oQpXhwfuhbyo1M8DKAh7XdCYnamfsfmk64Bkoo7DnunzuYGrPEG6Y+owByguZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pjZbc6d5oDlBxpYewYjboKffTbRvntPDdQJthrTGU00=;
	b=MwkEVLxfLkYHKFwaaSgIDv7m3Vcy17FvtGujqsw4ksxIo4UP1Mal92/loa3FOEXH2fzl
	 dwbKvASF6hvNuU0EB4CoW7Quf9Otq6bo/qUZBIlAknHbbrbxBAODmqSx9bIQIo5NU4YK5
	 Njy5p0GhJ5fJh4JHYxpzDv7WDfvPiUCpStpIH+DfAukyItq8cuzVPoPLuBkxNrUsBkOi7
	 D4yyfZIKNba488XIdfZZfsmd0t+oiDJnD1YpygtaAXYeLKh9uejAfrwsxNimZulgk8QLj
	 5UD1UJZ1FCTC51JK4nvaYb0yNHzdVZyYQhZHMuJtt2kjVhn/XVYcBWSPVM2BUSbpGxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJgJueq4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E23606A6A0;
	Wed, 25 Nov 2026 15:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJgJueq4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693541F000D3;
	Wed, 25 Nov 2026 15:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621210;
	bh=pjZbc6d5oDlBxpYewYjboKffTbRvntPDdQJthrTGU00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJgJueq4LnHldIAoGNfYJGyw/1407N+Kh7KhVy0p1boAa/OWQu7bm4dJbDUWHmj7O
	 SCSHk2WjNBLgY7u2FoDpsKXUbVsaj9Smq2iei9Jy5Bl5RRrN9jgw2axyZu0pUTJ0p4
	 KtQ71dG5ebosW51lHTap+ica86d/6n5Gli/sc00A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/990] vhost-scsi: do not relock event vq mutex on send_evt fallback
Date: Wed, 25 Nov 2026 15:25:21 +0100
Message-ID: <20261125143825.700026085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4e078d439836a..d39dc7d215c09 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -629,19 +629,26 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 	vhost_scsi_log_write(vq, vq_log, log_num);
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
 
@@ -1835,7 +1842,7 @@ vhost_scsi_send_evt(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 
 	llist_add(&evt->list, &vs->vs_event_list);
 	if (!vhost_vq_work_queue(vq, &vs->vs_event_work))
-		vhost_scsi_complete_events(vs, true);
+		__vhost_scsi_complete_events(vs, true);
 }
 
 static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
-- 
2.53.0



