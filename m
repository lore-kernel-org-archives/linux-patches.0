Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B548F4F054D;
	Tue, 13 Oct 2026 11:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892043; cv=none; b=HB/b3bduJ0/5Tt93dWVEeUKVMWu1W1PPDKI5kU4aYdkqnxv+I3pJiaJVrGA0dhIN7i6lw9C2dYO0zEYUf4oF98WoFfjFaI8Nma9Vx6618kh5XKphEVp+Q29iLXquZ98iH1///WzJtzNZVzKD52A+pPdl8hcAreyZ86EPjI31f7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892043; c=relaxed/simple;
	bh=xIJnQe0A7rMo68yRUwKx/dHOa5MkAxtua1XXMFJpdQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNFBtejXr5203Fq5pjZvWD7QoK6pS4LBeMV9Vb0rzf4WYVB7Rj970twK90XAJCKJp7Xiz1ObHbNlt2KLmjyDzzV8EWabvTIGW1AisR+aHTnfmjy8y/TwQopI2jwheU6AZuZZsuhJh5miG7u9KMB4gzYYHe9WfApnaoC+rQ4j7aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Baj32pR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Baj32pR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09811F00893;
	Tue, 13 Oct 2026 11:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892042;
	bh=Aq8AHRgq1OZqc9u7X5QdZzxpnUhx/8p3xIzre3dy0n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Baj32pR+95a/2XKW+22MV2Wp1FRNCmNTonA5JWo69f8i5ni4A4CS6xOw/t4dTuIZ
	 gq68/Pq9s6cwoPZ7nmXy7nNFiosorTKhPGbsQ1j1hz98xHQkhOg94q57yS7JYfHwda
	 Z3cwSsprc7caMNov/S1pcuS425m5AkxCteB1vCC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 042/281] tcp: reject net_iov in zerocopy receive mapping hints
Date: Tue, 13 Oct 2026 13:35:58 +0200
Message-ID: <20261013112856.075181104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1908,6 +1908,8 @@ static bool can_map_frag(const skb_frag_
 
 	if (skb_frag_size(frag) != PAGE_SIZE || skb_frag_off(frag))
 		return false;
+	if (skb_frag_is_net_iov(frag))
+		return false;
 
 	page = skb_frag_page(frag);
 


