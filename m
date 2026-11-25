Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619750;
	b=K+YlbEaRH/SI7VcLKo9xPrFZwZkNeUew7781JGZyoqAVeThgZOIGDVsubeis22lwnqjF
	 9H9nK5wmZFBtpgUD2kD7U6CsY8Q8YRi3kOkt6S8X1nO283WL7KXvbh2k2VrLL/YM4Pe4S
	 B2bSvOt5Rpfo3GxKB2gEB9Gdat/hU5LmbcGaGOysXp2KkoPA7VqgyBAoyZ1vzQB13aZnB
	 s3zwtUQ2y4n6g55E/fvyZWwbMrrXaHIHuVt+ntfcYvxZNZxr+4wyLYJKuKPYN+xrNgiOq
	 ZKU956KGnW7yTdGFzdG7irpaNNn7dRQH1OeTqAW1+FYQqQ8PrEEir0vAz/GtIdZVzFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D4bt0/KKm67miUavCMcljb8+rfPwBltL2JRGVoBJPZc=;
	b=arKNzDkUxEJJdyI11A7DZNERip59x12oJPlQQaN3r3oqp37shM7DIlo9N3XgnPbAWbQZ
	 ankLJiLkknfmXuEVJ0fk/lK9JAL3GjBH5byEjcFjku7IWBibitTDGfUqPQ75G9Z8aoA5J
	 PYEENLq7KeirzRHQcPYW6RFEKjda8IvXpNz0O6a21fBHW3SIqoL9UEqmVYiZAn9U3zrsg
	 a03KNL3BwDwzYeIyuTbiLuHXsxTKfevhNx86YC+n8ug/xsAONBvc1vAKlVdBuaDhf3d49
	 cGHJ31uGTtZTfoonBXsa/WgiznmIFRaQE86lxZj/fopZRvl0teEQNh6q5S1nO/xr9xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A97Ixa5J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D986606A321;
	Wed, 25 Nov 2026 15:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A97Ixa5J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187D21F000D1;
	Wed, 25 Nov 2026 15:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619749;
	bh=D4bt0/KKm67miUavCMcljb8+rfPwBltL2JRGVoBJPZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A97Ixa5Jz4KW6z2Zo0scc07Vr/twHEe9e3oWdo8pKdeiRWDo80eP+U/sRbzVBSOWR
	 SSvqI+ESx8Ik1AGf6tcFz7PFIsr1UkJe8yUga/vJg3NsgHzsb6hJhoKEeUowRQzsDP
	 SfgxVc6HXwD4K8u9XxfV2vteXPJfg91BCmF68j4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.3 0651/1005] ipvs: Defer application parent freeing until after RCU readers
Date: Wed, 25 Nov 2026 15:33:09 +0100
Message-ID: <20261125143836.999014579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 1e0808008e44d736e57a897a51d14fa995099010 upstream.

unregister_ip_vs_app() removes each incarnation from its protocol list and
uses call_rcu() to defer freeing it, but frees the parent application
immediately. An RCU reader that already found an incarnation can still
access the parent through inc->app in ip_vs_app_inc_get().

During FTP helper module unload, the following interleaving is possible:

  CPU 0 (RCU reader)                 CPU 1 (module unload)
  tcp_app_conn_bind()
    find inc in protocol list
                                     unregister_ip_vs_app()
                                       ip_vs_app_inc_release(inc)
                                         list_del_rcu(&inc->p_list)
                                         call_rcu(&inc->rcu_head, ...)
                                       kfree(a)
    ip_vs_app_inc_get(inc)
      try_module_get(inc->app->module)

The helper module is already going away, so try_module_get() would fail,
but evaluating its argument first reads the freed parent. The subsequent
rcu_barrier() in pernet unregistration cannot protect this earlier free.
KASAN reported:

  BUG: KASAN: slab-use-after-free in ip_vs_app_inc_get+0x7c/0x90
  Call Trace:
   ip_vs_app_inc_get+0x7c/0x90
   tcp_app_conn_bind+0x1bc/0x290
   ip_vs_conn_new+0x1915/0x20d0
   ip_vs_schedule+0x697/0xea0
   tcp_conn_schedule+0x489/0x820
   ip_vs_in_hook+0x7bf/0x1f40
  Allocated by task 88:
   kmemdup_noprof+0x20/0x50
   register_ip_vs_app+0x12d/0x2c0
   __ip_vs_ftp_init+0x56/0x160 [ip_vs_ftp]
  Freed by task 104:
   kfree+0x131/0x3c0
   unregister_ip_vs_app+0x2f4/0x5b0
   unregister_pernet_operations+0x232/0x490
   unregister_pernet_subsys+0x1c/0x30
   __do_sys_delete_module+0x346/0x510

Use kfree_rcu() with the existing rcu_head to keep the parent alive until
these readers finish. Successful helper references already prevent normal
module unload, and incarnation RCU callbacks do not access the parent.

Fixes: 363c97d7435e ("ipvs: convert app locks")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_app.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -242,7 +242,7 @@ void unregister_ip_vs_app(struct netns_i
 		}
 
 		list_del(&a->a_list);
-		kfree(a);
+		kfree_rcu(a, rcu_head);
 
 		/* decrease the module use count */
 		ip_vs_use_count_dec();


