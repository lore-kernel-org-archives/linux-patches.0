Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B771E5722;
	Mon, 21 Oct 2024 10:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506569; cv=none; b=E1SPJizg5Wqw1gzA5R8a7gqfIeivHjDPPK98vyOlh2qE5h7UYRl6d2F5gG1HyAhldaKI1c6BitiPbbMsmHZm+C0Ydx50esZs68rJmhw4Px34qDTd0ENAN6bBPI4/Sdq0Cns+AzHBkfdkZDIlkZwA15Hx/227souP1BBV2uNbUyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506569; c=relaxed/simple;
	bh=ggW9JPDdY1yZ9AuIFbP/h2WJ0XuTOZ4a13rfK5OLDcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzDkHlX6uzZKl5JUTlIbIG3+8J1CEPJrEnkqKaqwACKuIrHJpaE7lwvsYPUQ6vZwnrbtPxfDfjif50td8zAh7eQYvlUMOSfk59magMyFCge4g9UVA/hAYXUFGGeebR2BFmfE+6g1LNk3wMhA2d3WFOiBID2rqb79TCdvn0MVsxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwXyPQb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwXyPQb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3FFC4CEC7;
	Mon, 21 Oct 2024 10:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506569;
	bh=ggW9JPDdY1yZ9AuIFbP/h2WJ0XuTOZ4a13rfK5OLDcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwXyPQb+k1XtEh+f4bLEcetv934WMvdvdvgRIk+52D4WULU1qro0XXVFunugYnhJl
	 cKmdSLTPRF4+TJfrpcxSuf39mVwABdfS+yXGAtwUaPtdaCr3lyNwmeoogmVM102uFk
	 w3rNhE+l0Pzb8d//7zPOkdcFNtWgAoRs1OGyfFR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benedek Thaler <thaler@thaler.hu>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 049/135] io_uring/sqpoll: close race on waiting for sqring entries
Date: Mon, 21 Oct 2024 12:23:25 +0200
Message-ID: <20241021102301.249821778@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 28aabffae6be54284869a91cd8bccd3720041129 upstream.

When an application uses SQPOLL, it must wait for the SQPOLL thread to
consume SQE entries, if it fails to get an sqe when calling
io_uring_get_sqe(). It can do so by calling io_uring_enter(2) with the
flag value of IORING_ENTER_SQ_WAIT. In liburing, this is generally done
with io_uring_sqring_wait(). There's a natural expectation that once
this call returns, a new SQE entry can be retrieved, filled out, and
submitted. However, the kernel uses the cached sq head to determine if
the SQRING is full or not. If the SQPOLL thread is currently in the
process of submitting SQE entries, it may have updated the cached sq
head, but not yet committed it to the SQ ring. Hence the kernel may find
that there are SQE entries ready to be consumed, and return successfully
to the application. If the SQPOLL thread hasn't yet committed the SQ
ring entries by the time the application returns to userspace and
attempts to get a new SQE, it will fail getting a new SQE.

Fix this by having io_sqring_full() always use the user visible SQ ring
head entry, rather than the internally cached one.

Cc: stable@vger.kernel.org # 5.10+
Link: https://github.com/axboe/liburing/discussions/1267
Reported-by: Benedek Thaler <thaler@thaler.hu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -279,7 +279,14 @@ static inline bool io_sqring_full(struct
 {
 	struct io_rings *r = ctx->rings;
 
-	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == ctx->sq_entries;
+	/*
+	 * SQPOLL must use the actual sqring head, as using the cached_sq_head
+	 * is race prone if the SQPOLL thread has grabbed entries but not yet
+	 * committed them to the ring. For !SQPOLL, this doesn't matter, but
+	 * since this helper is just used for SQPOLL sqring waits (or POLLOUT),
+	 * just read the actual sqring head unconditionally.
+	 */
+	return READ_ONCE(r->sq.tail) - READ_ONCE(r->sq.head) == ctx->sq_entries;
 }
 
 static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)


