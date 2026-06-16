Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB3247AF5F;
	Tue, 16 Jun 2026 17:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631511; cv=none; b=SOP5yIRwDewOw6MDdP9D2cvONErcbMLQz6KaVeV1fQMBC3sAd8M3x7dtk70aE+hiBq9QWcOWXIYs5u/pNArSUtQR+WRWGWVlr/Q24N66LnjxZNsXqITqnf7cttENhnz0a0rDSvjaUWQF/smG8S/Cad0cDJ7tk9nvf2gOyVBIo/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631511; c=relaxed/simple;
	bh=ScQBYN7hJs30NNlJj5cTJPoCHbBA8WasdGXLGgyurRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tduMZRSNVgU4xj+OHufya7Db768zLR7OMA2DvUx4ERezU2jPDYs3XGHr7sDyB6K5m4yAYY0xcAvBlUgVN7iHYra6y8+/rAVFMFQZsN1eVJodnB6kB/p06JCUQ2y0Xv1fZaQU1fzdssRnRU1eiBSOLSIsNLfNkVdN35sJ/jJPnhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQr6LZH3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQr6LZH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1259A1F000E9;
	Tue, 16 Jun 2026 17:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631510;
	bh=syRaDJOu4WYhLWjyb9449uzHrezx5Jfj1xREmM8Txsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQr6LZH3jH104NnUY8/kfaYlc/ifq28lrEAox//TEkoroLlRbyIwEDlrGnwyICBBA
	 PDCGYyMhBbWVlkGFypAsnyIRN1PutjENXso2tc5178UCZMrL7mq/0JAtbmGMZWixUY
	 E8VOoA6Or2DUAOi+SfaKC869M16njaaUS31D2wwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/522] net: skbuff: fix missing zerocopy reference in pskb_carve helpers
Date: Tue, 16 Jun 2026 20:26:21 +0530
Message-ID: <20260616145136.935162133@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[Salvatore Bonaccorso: Backport for context changes, as 6.1.y has not
511a3eda2f8d ("net: dropreason: propagate drop_reason to
skb_release_data()")].
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 41b2aaed7a14aa..f1f5b2b25f8522 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6247,6 +6247,8 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 			kfree(data);
 			return -ENOMEM;
 		}
+		if (skb_zcopy(skb))
+			net_zcopy_get(skb_zcopy(skb));
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
 			skb_frag_ref(skb, i);
 		if (skb_has_frag_list(skb))
@@ -6396,6 +6398,8 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 		kfree(data);
 		return -ENOMEM;
 	}
+	if (skb_zcopy(skb))
+		net_zcopy_get(skb_zcopy(skb));
 	skb_release_data(skb);
 
 	skb->head = data;
-- 
2.53.0



