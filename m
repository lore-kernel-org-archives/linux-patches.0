Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209751;
	b=a2vTOqAFo+0WqTS5RM39E6oQD7T+ocMF/hd9ziOIf3MEpaLKWgmSSjYkw3IbCdxqyCYq
	 9hq3Hn526OHD8bgGwk84sHDk8hKY5edqZixWsihx3ArtVGM/RdFo7GXAgjQkOBU4tOWKv
	 qNmI7n1o2LXQNhQpEM8jPIDcp3FFrSNWISnV4ZV2ZTvqsDTUvbUWUiF3omlKtcyNXUouN
	 sSHHoaZdulXUHRbAfYxtQ9vYzvRjVlbuU7anlFuf947JHM4HD8skQCY0pPIbT+kKaH3oY
	 x1mi2RZ4FpnoP9in+qt+xtwMrZ0WDHMdmo/fxhHhpS0hiq0ScC9teT69liKn9sas/Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pW9eO/v1tb4qkYIKMmRIL5Bm3ASG5/6m4HbXbCswpXQ=;
	b=ENWPolCOdw78b1aPa18i9ShRD3vW5f9QSLr7Mchl8NikssIX/SIFlnRPbg8LzQsMznCD
	 PfDUhEnMLMOY9+d7NNs7UUfOMTIbrxKBQvrJqnBlIockrQdL9GtXFcvzJJjHg1hZ/b0k+
	 Gft7TccrC6dEOr85CiKteKhMeJ3mSJpHEob8qw+//t657rUi0BsUrFgJrCrdfHo+iIRip
	 E4Yto5NaqxerlOHQe6bBe1dTHitpw54W5FGM/rigjHIuOJ3hadL+UXCVl1dN+rvyy1mwo
	 a2N37uurjNWGI2VvV7CQTljVcR4YdqLZ9KnzF4VkIKnwUbX0/9UMoC7nM5fSI18o8eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cyv7xqrN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFCB606A31A;
	Wed, 28 Oct 2026 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cyv7xqrN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD101F01825;
	Wed, 28 Oct 2026 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209750;
	bh=pW9eO/v1tb4qkYIKMmRIL5Bm3ASG5/6m4HbXbCswpXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyv7xqrNgCDHWXudofAH7nqqK04VaUC4benwiFnYAubFiazYH2GDM3OCOeihEF7+W
	 w4lh74LS9isNDdmR3BEH6Wb8+J/4Jpi6by5Uj5Su8BVT1rWOA35HKT9rFk5OiydQ6I
	 Ha0uVK130H10zJWqxpZK2osmLcYsTgs0HizTLZbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 064/109] io_uring/register: dont wrap 32b CQEs when resizing
Date: Wed, 28 Oct 2026 18:00:48 +0100
Message-ID: <20261028165943.866232834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit 0edf1930b8ed3c398d3cbdbafd8f72dbd1a3d9e4 upstream.

On an IORING_SETUP_CQE_MIXED ring, a 32b CQE uses two contiguous CQ
entries and is never allowed to wrap the end of the ring. When posting,
io_cqe_cache_refill() inserts a dummy IORING_CQE_F_SKIP entry if only
one entry is left before the ring wraps, and the application relies on
that to read a 32b CQE as one contiguous 32 byte slot.

io_register_resize_rings() copies pending CQEs to the new ring one 16b
entry at a time, placing entry i at i & (new_entries - 1). When the CQ
ring is shrunk, a pending 32b CQE that was contiguous in the old ring
can land with its first half on the last entry of the new ring and its
second half on entry 0. For example, with 8 old entries, 4 new entries
and a 32b CQE at index 3, the halves end up at entries 3 and 0. The
application then reads the extra data of that CQE from past the end of
the CQ array, and the CQE content it sees is wrong.

This was found by code inspection and has not been reproduced.

Fix by failing the resize with -EOVERFLOW if a pending 32b CQE would
wrap the new ring, the same way the resize fails when the pending CQEs
don't fit.

Fixes: e26dca67fde1 ("io_uring: add support for IORING_SETUP_CQE_MIXED")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-25-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/register.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -406,6 +406,7 @@ static int io_register_resize_rings(stru
 	size_t size, sq_array_offset;
 	unsigned i, tail, old_head;
 	struct io_uring_params p;
+	bool cqe32_tail = false;
 	int ret;
 
 	/* limited to DEFER_TASKRUN for now */
@@ -558,6 +559,21 @@ overflow:
 			src_mask = (ctx->cq_entries << 1) - 1;
 			dst_mask = (p.cq_entries << 1) - 1;
 		}
+		/*
+		 * A 32b CQE on a CQE_MIXED ring takes two contiguous entries
+		 * and must not wrap. A smaller ring may place it on the last
+		 * entry, fail the resize if that happens.
+		 */
+		if (ctx->flags & IORING_SETUP_CQE_MIXED) {
+			if (cqe32_tail) {
+				cqe32_tail = false;
+			} else if (READ_ONCE(o.rings->cqes[index & src_mask].flags) &
+				   IORING_CQE_F_32) {
+				if ((index & dst_mask) == dst_mask)
+					goto overflow;
+				cqe32_tail = true;
+			}
+		}
 		memcpy(&n.rings->cqes[index & dst_mask], &o.rings->cqes[index & src_mask], cq_size);
 	}
 	WRITE_ONCE(n.rings->cq.head, old_head);


