Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028003;
	b=vbIRXNwhnpNUHc8CklnGAqJ9k6llQc7+GZBFK8+BXVJuziU9z3l73Jq0de/7xcXfTENG
	 DmhGSwLrfvhWVbXnJMywhqOcrUkHoVukEpjEM2Hq6r9dyzU34ksxpOal/krp8IZgDar8S
	 pK8d3DMYVbxNmn0ndjrln7r8UMwdZov6IJEHpewpm6OcWXulrWm+JHkaYmBY6xGxIdYR1
	 40Cn8HYB7VlvIk/I64nOxGFv42RREPoPxJPeRD6oXSo5Hv2yozigdz+RxxB9jpjzPITtj
	 eTxkkKZ7Yi1QEoTw1OcF2YfJNvmp5lxCrVORwGfMDXFrR3vVloQRfJwfbS/5r7XjOJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t7PM3YOgmBHweVNXxXlreEwIg3GdED5VBoX80S27Xlg=;
	b=nKqfyqxO0/QlZ7uDNJHTnPHTTqBnVn5Tdm/2lWiipaX/Yk21T1xnhrtxf/QUs2j0Kx63
	 LC+5YgyMWJ23xBvE4KX0So1w4QzXO43Db3oxtBioVhPmKxy8rkfPUwPEhzgvTr8yUQA0f
	 AGiWT/L7cfYPTLBfhOz7/IfX9kOUWAYGxcMgJ6URbPvO3EG5vO2Z+DHYCmS7cC8cBgh3A
	 f9q7ZXNClE75KXIoex2bklDdQU43fXcxJ+NSf457O3pWxyrk8Ut+YWO50gT5nSbDTGN5H
	 7OGEARCARUhSnjNuoatmbnO7KFkfncwGyjNpqjHSAF81enEAHPGULuIIAskedK86HJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrN2EhU6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEEE606A32F;
	Wed, 18 Nov 2026 18:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrN2EhU6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17FC1F000C4;
	Wed, 18 Nov 2026 18:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028003;
	bh=t7PM3YOgmBHweVNXxXlreEwIg3GdED5VBoX80S27Xlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrN2EhU6Ipb13/C8BxuqX+zs3aG1mMaz88d2QB9YJS5CPtbkVHPnIFdlOqeSYWQK8
	 8Rc2d3AwEfHzTB4gikJYC4MNTn+SJ9JajtVQv1it8PxYZ7981dDgxa18SaOgtuqtRY
	 ZBJ/WkgDakn8TAMBX5tIL+bZDBO9XeJODaZSln7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1989/2151] net: tun: hold napi_mutex when deleting NAPI in tun_detach_all()
Date: Wed, 18 Nov 2026 16:02:04 +0100
Message-ID: <20261118150234.180704037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

[ Upstream commit 6c799b4998c87bb44574bb090b8728bb3b3dbc47 ]

With IFF_NAPI_FRAGS, tun_get_user() takes tfile->napi_mutex, gets the
skb from napi_get_frags() and copies the user data into it before it
enters the RCU read-side section around napi_gro_frags().

tun_detach_all() waits with synchronize_net() and then calls
tun_napi_del() without napi_mutex.  netif_napi_del() frees napi->skb
through napi_free_frags().  A writer that is still copying has not yet
entered its RCU section, so synchronize_net() does not wait for it, and
deleting the device frees the skb while the writer is using it:

  BUG: KASAN: slab-use-after-free in skb_copy_datagram_from_iter+0x175/0x720
  Read of size 8 at addr ffff888077def990 by task br029-poc/9406
  Call Trace:
   skb_copy_datagram_from_iter+0x175/0x720
   tun_get_user+0xb42/0x3d00
   tun_chr_write_iter+0x113/0x200
  ...
  Freed by task 9405:
   kmem_cache_free+0x184/0x670
   __netif_napi_del_locked+0x2bb/0x3c0
   tun_net_uninit+0x566/0xa70
   unregister_netdevice_many_notify+0x1a26/0x2090
   rtnl_dellink+0x514/0x710

__tun_detach() also calls tun_napi_del() without the mutex, but only
from tun_chr_close(), when no write on that file can be in flight.

Take napi_mutex around tun_napi_del() in tun_detach_all() for both
attached and disabled queues.

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/179268538303.70821.16548460883330758972@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 636a7094577c3..ff1f69589a66a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -672,14 +672,18 @@ static void tun_detach_all(struct net_device *dev)
 	synchronize_net();
 	for (i = 0; i < n; i++) {
 		tfile = rtnl_dereference(tun->tfiles[i]);
+		mutex_lock(&tfile->napi_mutex);
 		tun_napi_del(tfile);
+		mutex_unlock(&tfile->napi_mutex);
 		/* Drop read queue */
 		tun_queue_purge(tfile);
 		xdp_rxq_info_unreg(&tfile->xdp_rxq);
 		sock_put(&tfile->sk);
 	}
 	list_for_each_entry_safe(tfile, tmp, &tun->disabled, next) {
+		mutex_lock(&tfile->napi_mutex);
 		tun_napi_del(tfile);
+		mutex_unlock(&tfile->napi_mutex);
 		tun_enable_queue(tfile);
 		tun_queue_purge(tfile);
 		xdp_rxq_info_unreg(&tfile->xdp_rxq);
-- 
2.53.0



