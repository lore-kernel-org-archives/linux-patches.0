Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D174EFFA2;
	Tue, 13 Oct 2026 12:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892905; cv=none; b=mTJSDXhs8yuI/QwMNdHW03fbNP1qFZnSZdx52GlP9N3OKRwlPPFq52Fg76bHBaj+HA/FeYeFZT2ZTfnJ01SZkcOlUXTRe9GASy6w5QVPd+WkfUJUFu4lYXdIB/0KDt1t8MWvJyuATDaksRaHs6wAVIgLsfg4iRae4D4L03t/j/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892905; c=relaxed/simple;
	bh=OxBy3u5h9JOi2S7T4WUz69fdbvqBnC2RMuDCq+cydR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2xP88iysRq3XKj5572U4MIyq+bArT6iKoa9Z60bNDMilav5fyZwb49A9rzJbgsgnEQ7kJFnhu/8ayRuF2IdoEsivxpkQ0nZBDvRtvBLZkItbkJ4/+QXSyIwb1P3Jk7NCt/bWRnLv9YE/9xPGxqI/Hy505A7W7c4dWc+MZXcQmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09ysAar2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09ysAar2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1FD1F000FF;
	Tue, 13 Oct 2026 12:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892904;
	bh=WANbt5kch7zuJ4jqyL4I6S4Oq/gF3rj/mIjrPRGE8oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09ysAar2RLWxlT1xYK685rif//YC2rF50jG1lnUYmnxVAEOwOtr9lkr+TH9WQRaw4
	 OsjNlGxw4rmnCfbTKYs4BF2zeRCXhjqugM3PYv9uf6bndHc9agT2Ls5sUgdUm1yt8v
	 Y73F6btq2hr+PibDka9n+FCNyBk5Idn4mkXdvEOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 046/621] tcp: reject net_iov in zerocopy receive mapping hints
Date: Tue, 13 Oct 2026 13:30:41 +0200
Message-ID: <20261013112921.957516383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 8b1f0af1fd5fd113432233ed8a3862ee7c30a84f upstream.

After copying a readable prefix, receive_fallback_to_copy() asks
tcp_zerocopy_set_hint_for_skb() where page mapping can resume. If the
next skb is unreadable, find_next_mappable_frag() passes its net_iov
fragment to can_map_frag().

skb_frag_page() returns NULL for a net_iov, but can_map_frag()
dereferences it in PageCompound(). A v7.2 KASAN run on a connected TCP
socket with 64 readable bytes followed by a 4096-byte NET_IOV_DMABUF
fragment reported:

  BUG: KASAN: null-ptr-deref in can_map_frag
  tcp_zerocopy_receive -> can_map_frag
  Kernel panic - not syncing: KASAN: panic_on_warn set

The diagnostic inserted the net_iov directly because the test host has
no devmem-capable NIC. Hardware end-to-end reachability remains untested
and requires CONFIG_NET_DEVMEM plus a supported DMA-buf-bound RX queue.

Reject all net_iov fragments before skb_frag_page(). This covers both
DMABUF and IOURING net_iov types while leaving page-backed checks
unchanged. With the guard, the same queue copied the readable prefix,
returned a 4096-byte skip hint, and completed without a fault.

Fixes: 9f6b619edf2e ("net: support non paged skb frags")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20260930102524.1659847-1-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1883,6 +1883,8 @@ static bool can_map_frag(const skb_frag_
 
 	if (skb_frag_size(frag) != PAGE_SIZE || skb_frag_off(frag))
 		return false;
+	if (skb_frag_is_net_iov(frag))
+		return false;
 
 	page = skb_frag_page(frag);
 


