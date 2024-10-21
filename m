Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB491E6DD4;
	Mon, 21 Oct 2024 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507802; cv=none; b=Dnsa6uJKE0yRRrDTyVWPM4ak/pl4joo3YDGbYNgZaWXMvrv02qdwP1F2gLWZeSiU10KyZEiKawCoXaZZw0+KJwyPGPVgT4ubjJGBVIK6HCeYcSHCDCaRsOs3+BUI3x11Eil5LADb2LuzYUnZDMW5RHiqU2U5KgTa9qW0hupL/Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507802; c=relaxed/simple;
	bh=KMQLbukrfxeSla+uBhpyJQIXsI09j0N8kYl4tEjwshc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIydnf48rY/ZigO/z3WYy2o5XVtLCG+4N05QBrMwpKf52Ca2pp2FfmblS5/FChu+8hhpZZI9ZG88f+stzoRYpy4BCfxnMsthsE0kkLc5S57u5K2bMpPIKypx3TUrDliaBoZynXKNT9rf+oL7yHSOWizTKnmvh/oqeFhwu76XY6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQel2uEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQel2uEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5D2C4CEC3;
	Mon, 21 Oct 2024 10:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507801;
	bh=KMQLbukrfxeSla+uBhpyJQIXsI09j0N8kYl4tEjwshc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQel2uEoFIhf4SRIZsLgA+QTplEjERXyZKFosxLE9stX5oH86nEaXOrXAKiOev8Xi
	 1ZVrRHCyl+l8MKlUCc8ON3Qn80fQlROMfojQgmWom0JKXgn5Yy+Ilf7tcHT24lO/sX
	 y035kqgPkUNGnDd7H2zW7IS2cz00okFrI30QJio8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benedek Thaler <thaler@thaler.hu>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 23/52] io_uring/sqpoll: close race on waiting for sqring entries
Date: Mon, 21 Oct 2024 12:25:44 +0200
Message-ID: <20241021102242.533757096@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 io_uring/io_uring.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1580,7 +1580,14 @@ static inline bool io_sqring_full(struct
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
 
 static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)


