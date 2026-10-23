Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774262;
	b=ICWaP4v0ldAJaFzARBwB8M8wmsW0wMsg+/jyYrLpCBl8ynACgDBSfronYVjPlDF0mnDj
	 lRSmBYht+WW+Hfi6wlcAv5UUB4OH1S/D0ktjNEEeGk/muowOs1eqXuhra9N7hnurjI1F9
	 yWiPdvtfES4ShVrl1Ga1SNwfKFQOvsdun5YBX0ZTxuWxeRQKFyWCD/yN3EHIyWiR1AJj9
	 S5NYqZaDJsigd3l2ZD+cW7/RxmSOkYOBepEJX23IzXeoFRSbzOeeqqHe0EbJcWRBsWGnz
	 b6Qu6HnKWr3jkZlD63FRogJ9C0uRp37TDKzxBOnFfk5Dat6HZe60RIrmKsxVUmPYP1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NJ32ltzbc3IRThJyhrpLfBWDQX3QYn79/SSae5wgn/0=;
	b=lb0/jphzlqYQteEYK8uoO0TFFRKC3IhONI5pukw4rnTHI5xq5dhgda4yuVWFE5sd7go0
	 tBbYWh1L9j5gR7DTMYfuu2aOTs0GGP9dP2HFBv1wUYbxxqPbIIr8mfeyB9yaZYfZ6gUrj
	 ahdefAvNL/7AHwd+/p8Ebt6KZCMRc9+djJ0kC9WI+puwz2gm9yv+1xcRtDFTjpIStPga1
	 VfzBGvMaC2iF5+KUYfCKEzj26HIZ45HFR6Tn/ioE9dgY5B9OtNMfJwcdOY5tvQ2Jh4rNx
	 HoVBfxlRIs+4O11b7s6TPdiR9+3vPOKlUTQMFMRSQCADctkGV+17hv808Q7uFj6nA5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IW1ZGC24;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08439606A31D;
	Fri, 23 Oct 2026 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IW1ZGC24
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586331F01828;
	Fri, 23 Oct 2026 16:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774261;
	bh=NJ32ltzbc3IRThJyhrpLfBWDQX3QYn79/SSae5wgn/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IW1ZGC24kYqNeJO69hvBWnxJ+tuJeLg+vhItmXqJokISXOogwKEemPMlWJyciVzXA
	 X5FbCk6orjimOMAaVo03nzg4He5XtJHI3dlcwdyXxpFijFHFDpT8WMDw1Su5sqMQGd
	 Za7qZK+/rD2d/x7yCW4dd0Msm3G4INQjJaUrSo/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Schauer <florian@schauer.to>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 138/193] page_pool: keep frag_offset aligned for odd-sized requests
Date: Fri, 23 Oct 2026 18:36:55 +0200
Message-ID: <20261023163717.472700035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Schauer <florian@schauer.to>

commit dc0df5a0c62ccea1d0e08d39a4dc9064de81d411 upstream.

page_pool_alloc_frag_netmem() rounds the requested fragment size with

	size = ALIGN(size, dma_get_cache_alignment());

dma_get_cache_alignment() returns 1 unless the architecture defines
ARCH_DMA_MINALIGN, which DMA-coherent architectures such as x86 do not.
There the ALIGN() is a no-op and pool->frag_offset advances by the raw,
unrounded size.

A single caller asking for an odd size then leaves frag_offset misaligned
for every fragment carved out of that page afterwards.  The pool is shared,
so the damage is not confined to the caller that caused it.

The per-cpu system_page_pool used by generic XDP hits this.
skb_pp_cow_data() allocates its fragments with the raw packet length:

	size = min_t(u32, len, PAGE_SIZE);
	truesize = size;
	page = page_pool_dev_alloc(pool, &page_off, &truesize);

leaving frag_offset odd for whatever is carved out of that page next.  Its
own head allocation is already aligned -- SKB_HEAD_ALIGN(size) plus the
XDP_PACKET_HEADROOM its callers pass -- so it is a later user of the shared
pool that pays: page_pool_dev_alloc_va() returns a misaligned buffer,
napi_build_skb() installs it as skb->head, and skb_shinfo(skb) ==
skb->head + skb->end is misaligned with it.

skb_shinfo()->dataref is a 4-byte atomic_t at offset 0x20, so the
atomic_inc() in __skb_clone() straddles a cache line.  On x86 with split
lock detection -- fatal for kernel split locks by default -- this panics
the machine:

  Oops: Split lock detected
  RIP: 0010:skb_clone+0x154/0x1e0
  Call Trace:
   <IRQ>
   raw_local_deliver+0x1ed/0x2c0
   ip_protocol_deliver_rcu+0x54/0x1c0
   ip_local_deliver_finish+0x85/0x100
   ip_local_deliver+0x67/0x100
   __netif_receive_skb_one_core+0x85/0xa0
   process_backlog+0x87/0x130

Reproduced by attaching any generic-mode XDP program to loopback and
opening a RAW IPPROTO_UDP socket, which makes raw_local_deliver() clone
every locally delivered UDP packet; ordinary DNS traffic then triggers it,
roughly once per 2500 clones.  Observed on 6.12.101 and 7.1.8.

Tracing page_pool_alloc_frag_netmem() over one such run shows the
amplification -- two odd-sized requests, nine misaligned offsets:

  requested size & 7:   0: 17035    5: 1    7: 1
  frag_offset & 7:      0: 17028    3: 1    4: 1    5: 1    6: 1    7: 5

and skb_pp_cow_data() returning heads that were aligned on entry:

  head 0xffff8f4c86aeac00 -> 0xffff8f4c53a9a9c4 (&7=4)
  head 0xffff8f4d6a8a42c0 -> 0xffff8f4c4f7b7a45 (&7=5)

Round the fragment size up to at least the alignment struct skb_shared_info
requires, so fragments are always suitably aligned for the objects callers
build on them.  Architectures needing a larger DMA alignment keep it.

This also makes the remainder computed in page_pool_alloc_netmem(),

	*size = max_size - *offset;

aligned, since max_size is a power of two -- which fixes the matching
misalignment of skb->end.

Verified with a controlled A/B under QEMU/KVM: same tree, same config,
same compiler, same rootfs and identical traffic, differing only by this
patch.  A SEC("xdp.frags") XDP_PASS program on lo plus UDP datagrams
larger than max_head_size drives skb_pp_cow_data()'s fragment loop, which
passes raw packet lengths to the pool.  Measured at the return of
skb_pp_cow_data():

                          unpatched   patched
  skb_pp_cow_data calls       40800     40800
  misaligned skb->head         1120         0
  dataref at line offset >60     80         0

The last row counts the accesses that actually fault:
skb_shinfo()->dataref sits at head+end+0x20 and is a 4-byte atomic, so
`lock incl` splits a 64-byte cache line only when that address lands at
offset 61..63.  All 80 occurrences were at offset 61; the panic reported
above was at offset 62.  Eliminating the misalignment removes every one
of them.

Same class of bug as commit 3bed3cc4156e ("net: Do not allocate page
fragments that are not skb aligned"), which fixed the older
netdev_alloc_frag()/napi_alloc_frag() allocators.

Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Schauer <florian@schauer.to>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260828060822.2628276-1-florian@schauer.to
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/page_pool.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -1071,7 +1071,8 @@ netmem_ref page_pool_alloc_frag_netmem(s
 	if (WARN_ON(size > max_size))
 		return 0;
 
-	size = ALIGN(size, dma_get_cache_alignment());
+	size = ALIGN(size, max_t(unsigned int, dma_get_cache_alignment(),
+				 __alignof__(struct skb_shared_info)));
 	*offset = pool->frag_offset;
 
 	if (netmem && *offset + size > max_size) {


