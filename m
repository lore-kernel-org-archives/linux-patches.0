Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3CC2DA76C;
	Tue, 21 Jul 2026 20:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665044; cv=none; b=umcwYDWb3+PARg+1x1sGLiXKv2+lWMepg9hhuNbnvxbO5iJveHs6B38T6/2NbZqPYTnFQgcuAo4aI8AO9q/U2dIgik4ZFueQWWw2dEFcZ+/QhV1BrdWTN//Zlbyh4QM5Xmez9bsYKv0L4DGsunDCkxVLDZ2Zh4ZM8Tnc46atPWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665044; c=relaxed/simple;
	bh=BQTiffjYwm1ICBciQkm1zjyJUqzCsLr4UXE5/SbGUW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pmj2E5dLb3DvE2mDby0zwk7/ZLju8eg9MQLZihJAe+9cqCLmpuNT+zMwdjygMt1PdX/eVOJ3sT1f/s3XpE+BirOJYblkBA+cGeTC3Bq7mgSIkqNivIPBx9IJJY2rm6yssFJbiRrFRYsYLM2vSegdVYXDz7tw75MsKMHEe6wO0KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntoR7F/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntoR7F/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5B91F000E9;
	Tue, 21 Jul 2026 20:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665042;
	bh=UoDDVU4VmCh+Q7Ex/08ctA3X+1+IwzUi+YF6saiFXp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntoR7F/XFw/qpwbDgVZrZ5SuQDVCxY6fl8oEYp46bhAbjVvTm7wsrIspjqOTY2kX3
	 Oc9AG8D53VgjHXLczX/Jsc1Q06BRFjZ9vYzDrGaP9f2Wmq7hZYRZWhOKeYE4G7XrHG
	 VCXkiy0+NZw4TuCnY4TX5EMSOoOrHxziURUiEfHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijing Yin <yzjaurora@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.6 0155/1266] net: af_key: initialize alg_key_len for IPComp states
Date: Tue, 21 Jul 2026 17:09:52 +0200
Message-ID: <20260721152445.274142509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijing Yin <yzjaurora@gmail.com>

commit d129c3177d7b1138fd5066fcc63a698b3ba415b0 upstream.

pfkey_msg2xfrm_state() handles the IPComp (SADB_X_SATYPE_IPCOMP) case by
allocating x->calg and copying only the algorithm name:

	x->calg = kmalloc_obj(*x->calg);
	if (!x->calg) {
		err = -ENOMEM;
		goto out;
	}
	strcpy(x->calg->alg_name, a->name);
	x->props.calgo = sa->sadb_sa_encrypt;

Unlike the authentication (x->aalg) and encryption (x->ealg) branches of
the same function, the compression branch never initializes
calg->alg_key_len.  IPComp carries no key and the allocation only
reserves sizeof(struct xfrm_algo) (i.e. no room for a key), so the field
is left containing uninitialized slab data.

calg->alg_key_len is later used as a length by xfrm_algo_clone() when an
IPComp state is cloned during XFRM_MSG_MIGRATE:

	xfrm_state_migrate()
	  xfrm_state_clone_and_setup()
	    x->calg = xfrm_algo_clone(orig->calg);
	      kmemdup(orig, xfrm_alg_len(orig));

where xfrm_alg_len() returns sizeof(*alg) + (alg_key_len + 7) / 8.  With
a non-zero garbage alg_key_len, kmemdup() reads past the end of the
68-byte calg object.  Adding an IPComp SA via PF_KEY and then migrating
it triggers (net-next, KASAN, init_on_alloc=0):

  BUG: KASAN: slab-out-of-bounds in kmemdup_noprof+0x44/0x60
  Read of size 4164 at addr ff11000025a74980 by task diag2/9287
  CPU: 3 UID: 0 PID: 9287 Comm: diag2 7.1.0-rc6-g903db046d557 #1
  Call Trace:
   <TASK>
   dump_stack_lvl+0x10e/0x1f0
   print_report+0xf7/0x600
   kasan_report+0xe4/0x120
   kasan_check_range+0x105/0x1b0
   __asan_memcpy+0x23/0x60
   kmemdup_noprof+0x44/0x60
   xfrm_state_migrate+0x70a/0x1da0
   xfrm_migrate+0x753/0x18a0
   xfrm_do_migrate+0xb47/0xf10
   xfrm_user_rcv_msg+0x411/0xb50
   netlink_rcv_skb+0x158/0x420
   xfrm_netlink_rcv+0x71/0x90
   netlink_unicast+0x584/0x850
   netlink_sendmsg+0x8b0/0xdc0
   ____sys_sendmsg+0x9f7/0xb90
   ___sys_sendmsg+0x134/0x1d0
   __sys_sendmsg+0x16d/0x220
   do_syscall_64+0x116/0x7d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

  Allocated by task 9287:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0xaa/0xb0
   pfkey_add+0x2652/0x2ea0
   pfkey_process+0x6d0/0x830
   pfkey_sendmsg+0x42c/0x850
   __sys_sendto+0x461/0x4b0
   __x64_sys_sendto+0xe0/0x1c0
   do_syscall_64+0x116/0x7d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  The buggy address belongs to the object at ff11000025a74980
   which belongs to the cache kmalloc-96 of size 96
  The buggy address is located 0 bytes inside of
   allocated 68-byte region [ff11000025a74980, ff11000025a749c4)

Depending on the uninitialized value the same field can instead request
an oversized kmemdup() allocation and make the migration clone fail.

The XFRM netlink path is not affected: verify_one_alg() rejects an
XFRMA_ALG_COMP attribute shorter than xfrm_alg_len(), so a calg added via
XFRM_MSG_NEWSA is always self-consistent.

Initialize calg->alg_key_len to 0, matching the aalg/ealg branches.

Fixes: 80c9abaabf42 ("[XFRM]: Extension for dynamic update of endpoint address(es)")
Cc: stable@vger.kernel.org
Signed-off-by: Zijing Yin <yzjaurora@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/key/af_key.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1218,6 +1218,7 @@ static struct xfrm_state * pfkey_msg2xfr
 				goto out;
 			}
 			strcpy(x->calg->alg_name, a->name);
+			x->calg->alg_key_len = 0;
 			x->props.calgo = sa->sadb_sa_encrypt;
 		} else {
 			int keysize = 0;


