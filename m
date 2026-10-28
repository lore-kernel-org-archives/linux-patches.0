Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216965;
	b=Rhs5bUVP+4CNE9c1j6uipw78MR1vzBBJsKwQHkPQrj42Y+dckVisCKTYAeXnOxGsnvoy
	 AEpQ5qrpR4Y838uRAYr9HbjJFna1yIHOviTvGAL5m1txfxJzi3eJg1J9gCiUFqKRyzcot
	 uGPkMYm8qKZxDFQDTM26zBoZUiB1onVrc/Ji1NFkiUgouvqT/Rn7BR5p5jDCE7Tp+9d4Y
	 Tf3EOoiRocYTQ8KKWLrjMLGgfHUf+0viieJkSAWzso3Ec3Ga70QDsCRNpr27peAlIFUkH
	 TEz/nbwIt2dItBg/EKx9hOIzn9+TINYqSb7+8tijIvW2GRDptgO3+IoErEW5W9w6JVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=abtpvhDr/O0USHZ++o82ESujGMbNXDOtfEbRqlZ9UCE=;
	b=QLtjsP6ZoIgJEG9GlY97HUPp74JCGliohEDpHgfGoCOytLNYL0pkrSMFaEkh2zxyuiby
	 opp5aMBtuz9qSUNBY4Wma6KQRL9T9icZL3zu+YoBTWvDKY2GWUpYHQX/v9E7sy9dI4fYn
	 pFjPeZOc3GDfBjHtK2xryPbkG6ol3MiMsLGa2lmqnxOe02GbUZVdNaqksLWWtle38hVMq
	 cvWm4mTfI9Ym2VQcahGV25D9usbTupvZE2nwZBIx4+KaN20yoTH8lXP3TzRvBtOuRgmOb
	 4xnYwmNGhIMo13hE5hWaNR1ixK02auSwmBz1RLFcDtabpELuYZpmBCHe6J1/K25n/Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pFJYKv0v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDA3606A31A;
	Wed, 28 Oct 2026 19:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pFJYKv0v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBC01F01828;
	Wed, 28 Oct 2026 19:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216965;
	bh=abtpvhDr/O0USHZ++o82ESujGMbNXDOtfEbRqlZ9UCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFJYKv0vRzIvpWCtwj92n23gxSIeJ4jEanOnLmI9FVSh6VkQpQpm/uU7Du3YZtOqj
	 JzuXn02DoTjzYPCQ9mq2p7+fLXseK2ScIojsWkhiPFzggyZn0IGopTPKqXnorjVG/k
	 2u7W0VY7J3Wh7QGQzQPOcpc1oaml+N58T0W1KcDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1697/1887] netfilter: cttimeout: prevent UAF during module unload
Date: Wed, 28 Oct 2026 18:03:13 +0100
Message-ID: <20261028170538.072098730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit fec9b1de0d02de8dafa3cc344bcb91cf28660643 ]

nf_ct_set_timeout() protects the timeout hook dereference and policy lookup
with rcu_read_lock(). cttimeout_exit(), however, unregisters the per-net
operations before it clears the hook.

This allows the following interleaving:

  CPU 0                              CPU 1
  cttimeout_exit()                   nf_ct_set_timeout()
    unregister_pernet_subsys()         rcu_read_lock()
      kfree(pernet)                     h = nf_ct_timeout_hook
                                        h->timeout_find_get()
                                          nfct_timeout_pernet()

The hook still points to ctnl_timeout_find_get() when CPU 1 looks up the
already freed per-net timeout list. KASAN reported:

  BUG: KASAN: slab-use-after-free in ctnl_timeout_find_get
  Read of size 8 by task poc/90
  Call Trace:
   ctnl_timeout_find_get+0x271/0x2a0 [nfnetlink_cttimeout]
   nf_ct_set_timeout+0x7b/0x3c0
   xt_ct_tg_check+0x724/0xb20
   xt_check_target+0x234/0xa90
   do_ipt_set_ctl+0x570/0x1270
  Allocated by task 89:
   __kmalloc_noprof+0x16e/0x460
   ops_init+0x6d/0x420
   register_pernet_operations+0x2f6/0x670
  Freed by task 91:
   kfree+0x131/0x390
   ops_undo_list+0x3d4/0x730
   unregister_pernet_operations+0x232/0x490
   unregister_pernet_subsys+0x1c/0x30
   cttimeout_exit+0x52/0x970 [nfnetlink_cttimeout]

Clear the hook and wait for existing readers before unregistering the
per-net operations. This blocks new policy lookups and ensures readers that
observed the hook finish before the per-net storage is freed.

Fixes: ebfbe67568a7 ("netfilter: cttimeout: use net_generic infra")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index eb4d4a3be922f..6067e99830e40 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -660,9 +660,9 @@ static void __exit cttimeout_exit(void)
 {
 	nfnetlink_subsys_unregister(&cttimeout_subsys);
 
-	unregister_pernet_subsys(&cttimeout_ops);
 	RCU_INIT_POINTER(nf_ct_timeout_hook, NULL);
 	synchronize_net();
+	unregister_pernet_subsys(&cttimeout_ops);
 }
 
 module_init(cttimeout_init);
-- 
2.53.0



