Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71F313DDB8;
	Thu, 25 Jul 2024 14:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919125; cv=none; b=uoaEijk6+/xBroNS0uMj5irkqCdglweDqtVtZsUCXfWH9ZYqeTRm8B+HmknqBuZ/1iLpRHY2Y4NkgI7Jsbz8ZpZEQKKlgn+QAFgslhGWI92H3UYAMqr7Dkl1wfpMN3eelm3o1PLkYHfoqF3alC5N7gythZi/EG/mwS6TQuL7Vi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919125; c=relaxed/simple;
	bh=bCqBYNA0JIHF4s71c77rNjWIi8a719kfKuDVhRrA4lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0XUn7pLiaqOUfYKMDYVqnccERbpO6Z4q7SDYXet2Sif8hl3phg+l/60z0RLhIzcOpH7mYgov0B0+ZnaqCUQFgZw93sVQTS5/3A+O9CdSdoQ6Oy7l+fM/TW6cBY5rnamCFb55/PfNnbQWFovZwKTKX+K014eb29dCVCBphZZiFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFpDL5i6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFpDL5i6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B61C116B1;
	Thu, 25 Jul 2024 14:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919125;
	bh=bCqBYNA0JIHF4s71c77rNjWIi8a719kfKuDVhRrA4lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFpDL5i6vrM5zVOkwYjDvISe+y7WSc5eLvatI7X3mKh8fEpWlt9mSImixsB/aoEiS
	 cWcCuYudJ+YjNYjYfH/+roPQFdsnPf2cpK6bVzipEI2ijdQlSOL1wy8OdVcHpxQI5P
	 KK9cM3LO+jUEbEV3tBKSemaQ0lDNm7HSmoPesp3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Muhammad Ramdhan <ramdhan@starlabs.sg>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.15 05/87] bpf: Fix overrunning reservations in ringbuf
Date: Thu, 25 Jul 2024 16:36:38 +0200
Message-ID: <20240725142738.631594000@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit cfa1a2329a691ffd991fcf7248a57d752e712881 upstream.

The BPF ring buffer internally is implemented as a power-of-2 sized circular
buffer, with two logical and ever-increasing counters: consumer_pos is the
consumer counter to show which logical position the consumer consumed the
data, and producer_pos which is the producer counter denoting the amount of
data reserved by all producers.

Each time a record is reserved, the producer that "owns" the record will
successfully advance producer counter. In user space each time a record is
read, the consumer of the data advanced the consumer counter once it finished
processing. Both counters are stored in separate pages so that from user
space, the producer counter is read-only and the consumer counter is read-write.

One aspect that simplifies and thus speeds up the implementation of both
producers and consumers is how the data area is mapped twice contiguously
back-to-back in the virtual memory, allowing to not take any special measures
for samples that have to wrap around at the end of the circular buffer data
area, because the next page after the last data page would be first data page
again, and thus the sample will still appear completely contiguous in virtual
memory.

Each record has a struct bpf_ringbuf_hdr { u32 len; u32 pg_off; } header for
book-keeping the length and offset, and is inaccessible to the BPF program.
Helpers like bpf_ringbuf_reserve() return `(void *)hdr + BPF_RINGBUF_HDR_SZ`
for the BPF program to use. Bing-Jhong and Muhammad reported that it is however
possible to make a second allocated memory chunk overlapping with the first
chunk and as a result, the BPF program is now able to edit first chunk's
header.

For example, consider the creation of a BPF_MAP_TYPE_RINGBUF map with size
of 0x4000. Next, the consumer_pos is modified to 0x3000 /before/ a call to
bpf_ringbuf_reserve() is made. This will allocate a chunk A, which is in
[0x0,0x3008], and the BPF program is able to edit [0x8,0x3008]. Now, lets
allocate a chunk B with size 0x3000. This will succeed because consumer_pos
was edited ahead of time to pass the `new_prod_pos - cons_pos > rb->mask`
check. Chunk B will be in range [0x3008,0x6010], and the BPF program is able
to edit [0x3010,0x6010]. Due to the ring buffer memory layout mentioned
earlier, the ranges [0x0,0x4000] and [0x4000,0x8000] point to the same data
pages. This means that chunk B at [0x4000,0x4008] is chunk A's header.
bpf_ringbuf_submit() / bpf_ringbuf_discard() use the header's pg_off to then
locate the bpf_ringbuf itself via bpf_ringbuf_restore_from_rec(). Once chunk
B modified chunk A's header, then bpf_ringbuf_commit() refers to the wrong
page and could cause a crash.

Fix it by calculating the oldest pending_pos and check whether the range
from the oldest outstanding record to the newest would span beyond the ring
buffer size. If that is the case, then reject the request. We've tested with
the ring buffer benchmark in BPF selftests (./benchs/run_bench_ringbufs.sh)
before/after the fix and while it seems a bit slower on some benchmarks, it
is still not significantly enough to matter.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Reported-by: Muhammad Ramdhan <ramdhan@starlabs.sg>
Co-developed-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Co-developed-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240621140828.18238-1-daniel@iogearbox.net
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/ringbuf.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -41,9 +41,12 @@ struct bpf_ringbuf {
 	 * mapping consumer page as r/w, but restrict producer page to r/o.
 	 * This protects producer position from being modified by user-space
 	 * application and ruining in-kernel position tracking.
+	 * Note that the pending counter is placed in the same
+	 * page as the producer, so that it shares the same cache line.
 	 */
 	unsigned long consumer_pos __aligned(PAGE_SIZE);
 	unsigned long producer_pos __aligned(PAGE_SIZE);
+	unsigned long pending_pos;
 	char data[] __aligned(PAGE_SIZE);
 };
 
@@ -141,6 +144,7 @@ static struct bpf_ringbuf *bpf_ringbuf_a
 	rb->mask = data_sz - 1;
 	rb->consumer_pos = 0;
 	rb->producer_pos = 0;
+	rb->pending_pos = 0;
 
 	return rb;
 }
@@ -304,9 +308,9 @@ bpf_ringbuf_restore_from_rec(struct bpf_
 
 static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
 {
-	unsigned long cons_pos, prod_pos, new_prod_pos, flags;
-	u32 len, pg_off;
+	unsigned long cons_pos, prod_pos, new_prod_pos, pend_pos, flags;
 	struct bpf_ringbuf_hdr *hdr;
+	u32 len, pg_off, tmp_size, hdr_len;
 
 	if (unlikely(size > RINGBUF_MAX_RECORD_SZ))
 		return NULL;
@@ -324,13 +328,29 @@ static void *__bpf_ringbuf_reserve(struc
 		spin_lock_irqsave(&rb->spinlock, flags);
 	}
 
+	pend_pos = rb->pending_pos;
 	prod_pos = rb->producer_pos;
 	new_prod_pos = prod_pos + len;
 
-	/* check for out of ringbuf space by ensuring producer position
-	 * doesn't advance more than (ringbuf_size - 1) ahead
+	while (pend_pos < prod_pos) {
+		hdr = (void *)rb->data + (pend_pos & rb->mask);
+		hdr_len = READ_ONCE(hdr->len);
+		if (hdr_len & BPF_RINGBUF_BUSY_BIT)
+			break;
+		tmp_size = hdr_len & ~BPF_RINGBUF_DISCARD_BIT;
+		tmp_size = round_up(tmp_size + BPF_RINGBUF_HDR_SZ, 8);
+		pend_pos += tmp_size;
+	}
+	rb->pending_pos = pend_pos;
+
+	/* check for out of ringbuf space:
+	 * - by ensuring producer position doesn't advance more than
+	 *   (ringbuf_size - 1) ahead
+	 * - by ensuring oldest not yet committed record until newest
+	 *   record does not span more than (ringbuf_size - 1)
 	 */
-	if (new_prod_pos - cons_pos > rb->mask) {
+	if (new_prod_pos - cons_pos > rb->mask ||
+	    new_prod_pos - pend_pos > rb->mask) {
 		spin_unlock_irqrestore(&rb->spinlock, flags);
 		return NULL;
 	}


