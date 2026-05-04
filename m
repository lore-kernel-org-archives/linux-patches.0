Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C813DE434;
	Mon,  4 May 2026 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903118; cv=none; b=e4GOZTqJC6Kdj/pO14bYSv/niyHUN39NltVll+r5C1RQ7PeLXaW/Bg3QxBT4Nu7lZlmdHPxeROquRqkWP9WRN+41ShGjfsk6UleQWE1RxQTcDcbpMXpU1QdLQKctFf/1t7TVoFde7SFBcxboJ+w845EO/uYM+TqModEkUy4jdxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903118; c=relaxed/simple;
	bh=66fFBONY5TMSHyROEx7ceP9Kv8suWXiuY2rDRjaN4Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1Vb0Gc3oA3H8YpjmdC0Icq6MTHxnsLvHHyUP9AH3QzmBeYGnELdCn03Zs7b6pph/yi20ujpeK8JWkESA6TcWPpOAcATS5dDrUr2R34fQIWBMYbf1KY74aC0qvxQgE4icIEy8U3PEdbx/OqTe8L7QKK4e1lfSlKsOO6IVM1EZEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07KEmcU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07KEmcU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBD6C2BCB8;
	Mon,  4 May 2026 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903118;
	bh=66fFBONY5TMSHyROEx7ceP9Kv8suWXiuY2rDRjaN4Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07KEmcU/FkO0pylS/m5CizauOirA38mw6AAfnSu8Lu0VZixwZqPJgoO477pPTa5/3
	 eF9iKEq2hQK3LKiLWY/k3ZEBc/wJSegisYbuwwhfSgtSJRygH2LvyyozyK7v3FywXX
	 Bg7UsjooHzBXbm8VhVbwNen5CW58u8xNZeALP/eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 111/307] io_uring/register: fix ring resizing with mixed/large SQEs/CQEs
Date: Mon,  4 May 2026 15:49:56 +0200
Message-ID: <20260504135146.985015780@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 45cd95763e198d74d369ede43aef0b1955b8dea4 upstream.

The ring resizing only properly handles "normal" sized SQEs or CQEs, if
there are pending entries around a resize. This normally should not be
the case, but the code is supposed to handle this regardless.

For the mixed SQE/CQE cases, the current copying works fine as they
are indexed in the same way. Each half is just copied separately. But
for fixed large SQEs and CQEs, the iteration and copy need to take that
into account.

Cc: stable@kernel.org
Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/register.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -599,10 +599,20 @@ static int io_register_resize_rings(stru
 	if (tail - old_head > p->sq_entries)
 		goto overflow;
 	for (i = old_head; i < tail; i++) {
-		unsigned src_head = i & (ctx->sq_entries - 1);
-		unsigned dst_head = i & (p->sq_entries - 1);
+		unsigned index, dst_mask, src_mask;
+		size_t sq_size;
 
-		n.sq_sqes[dst_head] = o.sq_sqes[src_head];
+		index = i;
+		sq_size = sizeof(struct io_uring_sqe);
+		src_mask = ctx->sq_entries - 1;
+		dst_mask = p->sq_entries - 1;
+		if (ctx->flags & IORING_SETUP_SQE128) {
+			index <<= 1;
+			sq_size <<= 1;
+			src_mask = (ctx->sq_entries << 1) - 1;
+			dst_mask = (p->sq_entries << 1) - 1;
+		}
+		memcpy(&n.sq_sqes[index & dst_mask], &o.sq_sqes[index & src_mask], sq_size);
 	}
 	WRITE_ONCE(n.rings->sq.head, old_head);
 	WRITE_ONCE(n.rings->sq.tail, tail);
@@ -619,10 +629,20 @@ overflow:
 		goto out;
 	}
 	for (i = old_head; i < tail; i++) {
-		unsigned src_head = i & (ctx->cq_entries - 1);
-		unsigned dst_head = i & (p->cq_entries - 1);
+		unsigned index, dst_mask, src_mask;
+		size_t cq_size;
 
-		n.rings->cqes[dst_head] = o.rings->cqes[src_head];
+		index = i;
+		cq_size = sizeof(struct io_uring_cqe);
+		src_mask = ctx->cq_entries - 1;
+		dst_mask = p->cq_entries - 1;
+		if (ctx->flags & IORING_SETUP_CQE32) {
+			index <<= 1;
+			cq_size <<= 1;
+			src_mask = (ctx->cq_entries << 1) - 1;
+			dst_mask = (p->cq_entries << 1) - 1;
+		}
+		memcpy(&n.rings->cqes[index & dst_mask], &o.rings->cqes[index & src_mask], cq_size);
 	}
 	WRITE_ONCE(n.rings->cq.head, old_head);
 	WRITE_ONCE(n.rings->cq.tail, tail);


