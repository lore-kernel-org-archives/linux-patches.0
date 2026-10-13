Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5754547071;
	Tue, 13 Oct 2026 12:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895735; cv=none; b=WkLBXNeei2RbR0jrGJZJWRCx8I5FIT7q4t4G3lbf5FBHNy7pezzEHqH5+GDUxvn0qF52OrTckemhHeJZ/vfSxddWGHSwvqzFhHnySLWVfbiG9d+OH+NYZuHTEMuFmmYa34ewMhmrqzThwBSBvAiP3Ay9fZuFxpPZUT6cLbGfB6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895735; c=relaxed/simple;
	bh=YEdqG/kaW/ZeKzkm5hEZF8Z+ldlOCjn8zyGkgjktEPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDby2B9qnes7l/4ADojFMX/gSJwnaH0TCnQm1fuji1H5IBLDu9vMslOz7k9Jp+jtrYuQycUgbzLsky+ybrkB+/6vy0lzqGaHwnSLeev/kU2Mdx/7uxMbkeUcHIZMuwrrfBd0R6tYzL9BC0/S8fP1gkmAmfQ7F4WtBDsAaz7d0NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYD9jWLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYD9jWLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A321F000FF;
	Tue, 13 Oct 2026 12:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895734;
	bh=XJzyovYgr+M1FQ8K9H1SpOOa1D+8Yo4Tucn3ws0boSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYD9jWLB5NU8QGwI+QEdG8ryCHIxT7Ephr4IuEiF/PfMaGMKcRo04yCVxTxriCHHS
	 F2wSzKZ+8zA9SyYzEMP5d2tyy+2WGHKd7SkWms/KaKz5YsHlw23ednfcAWEUu7mc9p
	 0XhtkJfNA3H+qV76fCboDBAwkFOhwXD/O6U/Sgx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 376/497] tcp: reject net_iov in zerocopy receive mapping hints
Date: Tue, 13 Oct 2026 13:39:03 +0200
Message-ID: <20261013112916.823401634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -1830,6 +1830,8 @@ static bool can_map_frag(const skb_frag_
 
 	if (skb_frag_size(frag) != PAGE_SIZE || skb_frag_off(frag))
 		return false;
+	if (skb_frag_is_net_iov(frag))
+		return false;
 
 	page = skb_frag_page(frag);
 


