Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056855;
	b=ux5qhDpKQz7j730MWAC8NS750X+/bJHQb85O6vCQbVlPSQ25udcwSIK3E5/EMhj9/dGB
	 /bk+uVMML4mM41ongTi/jhLm6OKmBiXEzjUQBDJo5BlqXTD4kyxZGJCXImlABQ/BUdctB
	 F7P4OAUI1Ez1gbv0+q85JYNDfb/sU6ODtl9y7s6r0A7APyTO0a9Fe8vIoVrAH5YLy4Kz3
	 nDzB2h3JGuOyOyvPC7a3RtmChxZglpY0yQV+1Gv+dzrAUbAq+tn8OPH8VfMA3M6+kmkpr
	 kEnrtTjqIa8aXg5Tm+JFXsKhg9JE6o66HYcDQnk+00ljoWxY5EL+MhNoJkWnJU7th5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=glyeuIjDyg5DXFaJ+SnE9SGorDlvNVkDP1zHK+KEBsw=;
	b=So+mHuB9beolGrqQiDRVrfSBb76l8JvBstqftPDqhu5M5/MAYlMVW/6F+DVvQpkgr74Y
	 xNKmaEVwA6X/roMp8pcB39nO208gkeyyhCRklHJBTh1lXsQjONJZLGboQ9ZczzY8GgMCe
	 EfiZtWQz69xSAIfVsnZs0D8j/f2YaYp+RY79XC7vTUq6KUGUvYMJrqAUSwm1E4KTKk6q0
	 cOEzXI7CXqdqZzVRIn/i+dx/Hq2sp1/ZqYZJ5xZxDvmX1KRB9RTG19pzjXIY6le1dNRWE
	 17QmscS9pI+anahWoNDfGxQozXvLexUKT61dbyEfJW4Ly4ER3hhq7xgkdwwClndltjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEc+MAjX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F63606A31C;
	Thu, 19 Nov 2026 02:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEc+MAjX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEDE1F000C4;
	Thu, 19 Nov 2026 02:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056854;
	bh=glyeuIjDyg5DXFaJ+SnE9SGorDlvNVkDP1zHK+KEBsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEc+MAjXc9LKpkDj/E17k46u94ZIFrf6uj2zduuQfVly86fsXy93VYVSH8OJTaSn6
	 xvBgWnDYe2+DvyYAS+ZuhkIpSIbzi+ow6Ts9YaglLjfrlusCWEkh1Ir1huBu7hG0hT
	 PqwhjNjqrggUdJ6qWLjd/+PrvVY4JyhOLAnQadbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2137/2214] net: tun: hold napi_mutex when deleting NAPI in tun_detach_all()
Date: Wed, 18 Nov 2026 16:03:33 +0100
Message-ID: <20261118150136.008575609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9363295aaa2a9..652cb1c638081 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -737,14 +737,18 @@ static void tun_detach_all(struct net_device *dev)
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



