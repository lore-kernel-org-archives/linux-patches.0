Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1385D2FB97B;
	Sun,  7 Jun 2026 10:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829081; cv=none; b=bRBs7mQW8vW3q2ukKtN/q/Jx7eJR/6Vk+8ygrDITXrtvQV25R8jGzrAkRfGE5AfXWz4X2vNV17AHPMh7QTv0NIR0g+nfodBosuy5ITvEvSL1/R0K7/sdl2HQH7DeXhFlVH69IkdM7dyLmM/q6NhUuXntKLPGaF+KQ6mzgtup8cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829081; c=relaxed/simple;
	bh=VrUERb7WaI2+0ZXcokcq0gjANM6VIT1hsWABI+uDcoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHrBPWWYVaX19KRWb4JWY36Ow+HfJHvOKLgP0Nx04zO8QouON23FOjBCiPUi2mz0BguSk/2eENfVYcO4BF1wJ3TxopsNBEq1XWR4koPanO9JggH6plcEbgGydlPSsooEvH8kkQquK6Y5513WCAl5NBhPVhnRRe+Vq8QjnnZExhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLisGMZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLisGMZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE74B1F00893;
	Sun,  7 Jun 2026 10:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829080;
	bh=w5Uz6RUiPGtB02XQ9AS13YmqjUtVndUosOA7tC9pvbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLisGMZ3PjewlfL/X85YudqVEMaarT0viDxht8mBHTpQ8CSVZ1D7HIR16ZmgaSNrV
	 oCDnZ6eQBdPsZjkXJ7wEniKKoGyccNds6odij4wQZL36BcShN2sGpK+7wfPtvX6jCT
	 G+c/e5Jt1w+KpM+93aA4QfGzxQwPcdlpFaszvCNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 194/307] net: skbuff: fix missing zerocopy reference in pskb_carve helpers
Date: Sun,  7 Jun 2026 11:59:51 +0200
Message-ID: <20260607095734.850931791@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minh Nguyen <minhnguyen.080505@gmail.com>

commit 98d0912e9f841e5529a5b89a972805f34cb1c69d upstream.

pskb_carve_inside_header() and pskb_carve_inside_nonlinear() both copy
the old skb_shared_info header into a new buffer via memcpy(), which
includes the destructor_arg pointer (uarg) for MSG_ZEROCOPY skbs.
Neither function calls net_zcopy_get() for the new shinfo, creating an
unaccounted holder: every skb_shared_info with destructor_arg set will
call skb_zcopy_clear() once when freed, but the corresponding
net_zcopy_get() was never called for the new copy. Repeated calls
drive uarg->refcnt to zero prematurely, freeing ubuf_info_msgzc while
TX skbs still hold live destructor_arg pointers.

KASAN reports use-after-free on a freed ubuf_info_msgzc:

  BUG: KASAN: slab-use-after-free in skb_release_data+0x77b/0x810
  Read of size 8 at addr ffff88801574d3e8 by task poc/220

  Call Trace:
   skb_release_data+0x77b/0x810
   kfree_skb_list_reason+0x13e/0x610
   skb_release_data+0x4cd/0x810
   sk_skb_reason_drop+0xf3/0x340
   skb_queue_purge_reason+0x282/0x440
   rds_tcp_inc_free+0x1e/0x30
   rds_recvmsg+0x354/0x1780
   __sys_recvmsg+0xdf/0x180

  Allocated by task 219:
   msg_zerocopy_realloc+0x157/0x7b0
   tcp_sendmsg_locked+0x2892/0x3ba0

  Freed by task 219:
   ip_recv_error+0x74a/0xb10
   tcp_recvmsg+0x475/0x530

The skb consuming the late access still referenced the same uarg via
shinfo->destructor_arg copied by pskb_carve_inside_nonlinear() without
a refcount bump. This has been verified to be reliably exploitable: a
working proof-of-concept achieves full root privilege escalation from
an unprivileged local user on a default kernel configuration.

The fix follows the pattern of pskb_expand_head() which has the same
memcpy/cloned structure. For pskb_carve_inside_header(), net_zcopy_get()
is placed after skb_orphan_frags() succeeds, so the orphan error path
needs no cleanup. For pskb_carve_inside_nonlinear(), net_zcopy_get() is
placed after all failure points and just before skb_release_data(), so
no error path needs cleanup at all -- matching pskb_expand_head() more
closely and avoiding the need for a balancing net_zcopy_put().

Fixes: 6fa01ccd8830 ("skbuff: Add pskb_extract() helper function")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Minh Nguyen <minhnguyen.080505@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260526041240.329462-1-minhnguyen.080505@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6704,6 +6704,8 @@ static int pskb_carve_inside_header(stru
 			skb_kfree_head(data, size);
 			return -ENOMEM;
 		}
+		if (skb_zcopy(skb))
+			net_zcopy_get(skb_zcopy(skb));
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
 			skb_frag_ref(skb, i);
 		if (skb_has_frag_list(skb))
@@ -6853,6 +6855,8 @@ static int pskb_carve_inside_nonlinear(s
 		skb_kfree_head(data, size);
 		return -ENOMEM;
 	}
+	if (skb_zcopy(skb))
+		net_zcopy_get(skb_zcopy(skb));
 	skb_release_data(skb, SKB_CONSUMED);
 
 	skb->head = data;


