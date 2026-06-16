Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C33F43D4E9;
	Tue, 16 Jun 2026 17:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629422; cv=none; b=s2wtn/mA4qlXNpZwsuG4n88cwEkcY/Uukps5LUENk+LrwNvcRuzObzyNTixvhrAwX12BgeFyc2j0Cbotf3Q96oZXg67i72u8Ewa++PCaTNzyFyQDMMB4vPKIEUhQN3Ehda/cXkwPuILrBJtBlotprlSwY9EwVFVUdFMY9DK6CCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629422; c=relaxed/simple;
	bh=JMobSKfNOIV2Y2K4x5vjFS6ML8IBErCg8rwBykLyH90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENWoa3PNfugat/8MYAZBe812AmBJAw2PALL5n/XFiZ9xuO8ivyABvJapJDTHTq1fExRX5PNbuhSB68Aj8a551WsjU79CBAHTufON+VTiobk1JuxAv5g6ZKPJC7uJ+oe8jxq9pdikDRvhvU81QI0cHuS3az5oglw1rAk09iy+tL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gu4xu1GP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gu4xu1GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4771F00A3A;
	Tue, 16 Jun 2026 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629420;
	bh=8QZzTU1vIVKCfkHq7WericM+O+SMjqPEo90mWd5slak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gu4xu1GPOpwudJuPEclRBRNVSe0e3VCo0l/GSOA4y/WDUpqiqX1zhS2Nrjaz/xA6x
	 eWQWqb230/fHCSxOJKlq7fU1dOmOqQIszMXKtgj5i7tqZ1hPacL/W18qd2qkRguptx
	 k7Uci4Tr5UZ3Hxe5UYM/ilADr2Lv6ay+MMlWs/oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/452] net: skbuff: fix missing zerocopy reference in pskb_carve helpers
Date: Tue, 16 Jun 2026 20:28:01 +0530
Message-ID: <20260616145130.987824065@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
[Salvatore Bonaccorso: Adjust for context changes in v6.6.y]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2282b6ad4be21a..5f45a52cc8ca66 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6412,6 +6412,8 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 			skb_kfree_head(data, size);
 			return -ENOMEM;
 		}
+		if (skb_zcopy(skb))
+			net_zcopy_get(skb_zcopy(skb));
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
 			skb_frag_ref(skb, i);
 		if (skb_has_frag_list(skb))
@@ -6561,6 +6563,8 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 		skb_kfree_head(data, size);
 		return -ENOMEM;
 	}
+	if (skb_zcopy(skb))
+		net_zcopy_get(skb_zcopy(skb));
 	skb_release_data(skb, SKB_CONSUMED, false);
 
 	skb->head = data;
-- 
2.53.0



