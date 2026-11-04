Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826845;
	b=pMFlyXsTvxv4HX1r5cpTbXLBOhUn4IbTvRQ1yxMB1CJqw00cS5Od4v2txnU6qXQnmlE1
	 vpLT1VD1sme2AUr/0gICued9TcM3WFG7ouv2wgbc7wzDnB/chLtQ/Z/Ryn/vtFKZim7Vn
	 pP4FJHJ/A3PKKd9zTeqaJjv7e/Rwv+g27kDvHCbm8zVomTkf8kdpTi0ywBxsxy/IWyBUK
	 Zu6T1YZTUXy/XBPNvft5bwqBqOJFg/ynMwxY2j3nnb/UNAsPwtD9B3p0jO2MqTppUzGeL
	 676sQmAK9rNN3W9L6vqRN098W4buxOqMBm9rtPMSz8CWljrG9KrkkpiANvl+d/kxqiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MpWbhBzEE57p7PGUC59q/huWqdJVMib1eNX1g55wbug=;
	b=4UMgbNgbQRuy3IQ1lv9UT2pt7aY/dtAKzluHbZQawJ3wrO8o3UILkSnwKiZm2RDvC5LT
	 +zOUy7uZFnaHTwOV0BYtNXGT5zkCYbgMCIWqY/fUt1GCJ51XpGiM6MmkbqXKt5fsr8vfh
	 KhBtL9wG0SQFTD/EnDgIZIRzd+N5mKbLo3xmOhil5qkP8ln43VDkdIO2OOx2/zyoJcdy/
	 axBhOD8PIR4RR63V/vFOgkA8b+SOAqs5BFZQlAd6Y8MZSkZysLUAgdzt/qKocCjQr9Tst
	 Rnd99POSfqRGZ1+zQFeMFV6Zu28J7vAKY7SXwrDznjrVnvJ5lIbC63NEByVjhsMypKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dpb2xv8M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8760607040D;
	Wed,  4 Nov 2026 21:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dpb2xv8M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D61E1F00919;
	Wed,  4 Nov 2026 21:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826844;
	bh=MpWbhBzEE57p7PGUC59q/huWqdJVMib1eNX1g55wbug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dpb2xv8Mr7HqLtGOyjm5G/tU0I4/wzbnK8Oo7IipvNob6QSwdgbDJnfzh4ZjLQJTn
	 28RY/DCYY6zaUvYBZJFQlLyhLm9GIchkMwlBXUmmz+7z7j1hEcBWfy51A88XEpbf5I
	 yGz86KQml2PqrsU8fQvg1uC/FsYjBhjgq0MWGSaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 041/547] io_uring/register: dont wrap 32b CQEs when resizing
Date: Wed,  4 Nov 2026 16:03:45 -0500
Message-ID: <20261104211039.492914638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 0edf1930b8ed3c398d3cbdbafd8f72dbd1a3d9e4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/register.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/io_uring/register.c b/io_uring/register.c
index dab3eb4258dff..d7e9963ab9b02 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -505,6 +505,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	struct io_uring_params *p = &config.p;
 	struct io_rings_layout *rl = &config.layout;
 	u32 *o_sq_array, *n_sq_array = NULL;
+	bool cqe32_tail = false;
 	int ret;
 
 	memset(&config, 0, sizeof(config));
@@ -654,6 +655,21 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 			src_mask = (ctx->cq_entries << 1) - 1;
 			dst_mask = (p->cq_entries << 1) - 1;
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
-- 
2.53.0



