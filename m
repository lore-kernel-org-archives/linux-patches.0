Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207255;
	b=vx1hNdMJodv5Ca2Pw6PZFnWy6KgEb+g0pEGQd7cluCy/Bf7JnEyEeKox64lT96ApfgRO
	 LXTufNIz5X2t8FigSZUwup6AdvfdxJcuWANP45c5EstMO+voJvbNdgrqtW8qwYvQeY/iJ
	 yt8FXMkgxKPk4UcU70Vp6Lj1MyjHc5//mRWE+FfjO/qWC54CoSgWlzVgi2NzCzyuwIGuJ
	 DBgAm0w8hbKiwj7mMHBu8qBEqjxaG4kf3hJeG7OaDO+jIMd/ec7c6H4EnK6qQnBmCtec8
	 81N4GagCGe+Hs+LKAbJQxMGLCp2u3a3r4lF9r1Mka8e4DgVYDn7Izvh0aPq8C84JBUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XJzOWSfp9kl06lTejF4JsqxVHFOCvpNbT7GaQA1RTMc=;
	b=loey3QcFAIxGlFDdJu9UpjZNFVJqhJzJlW5L0rjeV0AIFqSXfyXgDVwI2Oe7rHqjTkCm
	 uQSAM3NsUmQlWV+8p4V+K7/Xamfo40MZ2Q0nbHOIUYPK3ja8mdUuhDaH1A/0OcucWq9H8
	 3YUcTQkM47yyA2ZnbnZ3coA/HzkeHahTjie6qufXo2iu7f8mKMZntfwEgGOgMlhpFgceA
	 PbsjMG8vuVTRqAU+ydoOGMxNU/ugZgvcLq4dnwamfDa88aSzNkFL3SnzCGPTGpNR21zIC
	 s3HmmXT+eYTSOO/olVq7Tmg/PqWcfcygl3FH/UJBLRYiw8+rsmCt7TNhLI8OWi2/LoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubgcVCqY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CE5606A31A;
	Wed, 28 Oct 2026 17:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubgcVCqY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C7C1F01825;
	Wed, 28 Oct 2026 17:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207255;
	bh=XJzOWSfp9kl06lTejF4JsqxVHFOCvpNbT7GaQA1RTMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubgcVCqYgAG0z6syrdiC9TGgAxgy+UQL1K+EyfHbvkGHSgJ12Y6jQOoTZGtONGXIL
	 ym5QEqHD3rHzbg7Q8F2tdFAhFPyTqEpX7IxSKDJAOScvRFzkvFLF+r5ex5VTQ0MfUE
	 RHaBeF4medikkcyr+lErN/RO6qSbN1VazMmvK7uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 41/88] io_uring/register: dont wrap 32b CQEs when resizing
Date: Wed, 28 Oct 2026 17:59:49 +0100
Message-ID: <20261028165943.078462689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -505,6 +505,7 @@ static int io_register_resize_rings(stru
 	struct io_uring_params *p = &config.p;
 	struct io_rings_layout *rl = &config.layout;
 	u32 *o_sq_array, *n_sq_array = NULL;
+	bool cqe32_tail = false;
 	int ret;
 
 	memset(&config, 0, sizeof(config));
@@ -654,6 +655,21 @@ overflow:
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


