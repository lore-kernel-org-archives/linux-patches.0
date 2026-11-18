Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033110;
	b=fYv7HJQx4WoOVFUXaq8CyyQpyFTK6gRC3XZiD6b7aAWd2c2AyCMfvTS+ZSaDJ2cISanW
	 zAGXb5qNT19qq6PDdGqi1zmO+i0ua5jMe+jZiS18XUs4mY75faljnKv2He+1AUY3Mv797
	 EgFCeXNhgeGjqdxUfhoDSHFn+iMg+xkuvTQLrAEZUX1i9R1HnFT3RqZlyaLIQE+HlnMlc
	 AJzNdDp9dn/AxL3QMbOLy5szLO/MOiWwO/nm0yDWck8Wh7QfM1UndQZ+c48P2OuEKh6ys
	 aemMw71rq6PwpSZx9CrMW5SFy1hIAG6BEoXnbBQBr3lfc8Yr96OQM3Djc+TuWIlp0Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HlbEwNoElV0S4HrMrH+wrkz4sVv3WBcFk41fZCK2glo=;
	b=vzHHMvH71/M0FzGLHJrBC8FmZujeEsbQHK+leSqz6bJwvzkGsZXN/XEY+cHSc86um9yw
	 MzjeKsSnSIp5NyCWGOB+7Z1hPLLTuxhCfFZj8IAe+1o5Sor87AiZIa3G8nW3Fa9ejCBph
	 Gx3gSlWIvh4o06Fy+/70x6FG0Qkb5BId2y4y7fLitL9nSpJeTH2UGnr2p6oZH7dWkTFk+
	 S+1ebKrXI5xXZuOm4pG6/+gXjt4RpRrPlbnD3NquK7uXfaYC7sd2iyESzGFlLiPDHHxRX
	 r7ful9+HbDf+ikXQcvXS5+l9dgjDpyPWfpPYofEhAAjPNxMy91Oq0+jldIwSDazPWUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqeObwJh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3E8606A325;
	Wed, 18 Nov 2026 20:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqeObwJh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BC11F000C4;
	Wed, 18 Nov 2026 20:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033110;
	bh=HlbEwNoElV0S4HrMrH+wrkz4sVv3WBcFk41fZCK2glo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqeObwJhfR1nycUM6bdQvQVyGLCUalw7LN1tCeBFnVkqB3XXND6UPYnmV3CWj1pbc
	 QdBpvLqpSaDKPqkYz6+f0aZxpy6tn9DTx0XnuSsHWunYBCp6S9axT6Y2TUhfHaG6+r
	 6AkQ0jbVSndrrCCzs9wzsxKMrc6Q8tkTpwKJCTFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1599/1756] net: tun: hold napi_mutex when deleting NAPI in tun_detach_all()
Date: Wed, 18 Nov 2026 16:02:06 +0100
Message-ID: <20261118150113.560619126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 78a8f1e8eb855..479108e87e3d8 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -736,14 +736,18 @@ static void tun_detach_all(struct net_device *dev)
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



