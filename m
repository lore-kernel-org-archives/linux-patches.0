Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3404546C82A;
	Thu, 20 Aug 2026 17:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248635; cv=none; b=EJeLOWWWUlQbNgppAP2X+Hu4XQmfAg51JM9gIXy5sUCF98kbbMlrW3bAQxRahTU6dYCQ13meGM1R0M7aEj6MyMBC78Qz+0oBdQTLypcD9rKk1yu3qgrDqdwpDmU2A5jmoBfRMSY+0aqevIsP6xJ9mGpsG8wv9NW+VvmFrNCRJZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248635; c=relaxed/simple;
	bh=bkKxs2efA1QzOaMJMmytjpVot9niF5UaBqJQXiecouI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+SnYKZh2I5Be9JBmtyVMKaMiDQMA0sTeIkkI89+yUaPv7cxjkH/cGoETVDsmaHXPGf8IXYOOjjAgY/Wbhwv+ufU3bO1sII37fcFpRZka70hJ3ErfUw6nZmZ4ICGSeQvff/Xh713eeXooH4PR29uPKUoR3tFAKSfVzSLOBqiZ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/ZA503q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/ZA503q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905A21F000E9;
	Thu, 20 Aug 2026 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248634;
	bh=G7TIr9ldr9BtpzZBihRvc39gXgnJLoVgVBwKosemiVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/ZA503qSGGU5J3j0aBXOhY85d//vlZ1olxRzKm5D4cpsn7Xm7Mb52xPieBlBiGhd
	 Ar8MxWqKt9Ewx5ASw7D3mQZSWrao8tMHitV68E7tFfOVnBJCs0KxpgpFxNXCFerLqK
	 0xC2JlLAfi0uX4mKOR5FPqUGjjNWCq0U8+fJZ9xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	David Howells <dhowells@redhat.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.1 296/303] RDMA/siw: Fix the sendmsg byte count in siw_tcp_sendpages
Date: Thu, 20 Aug 2026 16:57:12 +0200
Message-ID: <20260820145302.371758714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Falcato <pfalcato@suse.de>

commit c18646248fed07683d4cee8a8af933fc4fe83c0d upstream.

Ever since commit c2ff29e99a76 ("siw: Inline do_tcp_sendpages()"),
we have been doing this:

static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
                             size_t size)
[...]
        /* Calculate the number of bytes we need to push, for this page
         * specifically */
        size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
        /* If we can't splice it, then copy it in, as normal */
        if (!sendpage_ok(page[i]))
                msg.msg_flags &= ~MSG_SPLICE_PAGES;
        /* Set the bvec pointing to the page, with len $bytes */
        bvec_set_page(&bvec, page[i], bytes, offset);
        /* Set the iter to $size, aka the size of the whole sendpages (!!!) */
        iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
try_page_again:
        lock_sock(sk);
        /* Sendmsg with $size size (!!!) */
        rv = tcp_sendmsg_locked(sk, &msg, size);

This means we've been sending oversized iov_iters and tcp_sendmsg calls
for a while. This has a been a benign bug because sendpage_ok() always
returned true. With the recent slab allocator changes being slowly
introduced into next (that disallow sendpage on large kmalloc
allocations), we have recently hit out-of-bounds crashes, due to slight
differences in iov_iter behavior between the MSG_SPLICE_PAGES and
"regular" copy paths:

(MSG_SPLICE_PAGES)
skb_splice_from_iter
  iov_iter_extract_pages
    iov_iter_extract_bvec_pages
      uses i->nr_segs to correctly stop in its tracks before OoB'ing everywhere
  skb_splice_from_iter gets a "short" read

(!MSG_SPLICE_PAGES)
skb_copy_to_page_nocache copy=iov_iter_count
 [...]
   copy_from_iter
        /* this doesn't help */
        if (unlikely(iter->count < len))
                len = iter->count;
          iterate_bvec
            ... and we run off the bvecs

Fix this by properly setting the iov_iter's byte count, plus sending the
correct byte count to tcp_sendmsg_locked.

Link: https://patch.msgid.link/r/20250729120348.495568-1-pfalcato@suse.de
Cc: stable@vger.kernel.org
Fixes: c2ff29e99a76 ("siw: Inline do_tcp_sendpages()")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202507220801.50a7210-lkp@intel.com
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -339,18 +339,17 @@ static int siw_tcp_sendpages(struct sock
 
 		tcp_rate_check_app_limited(sk);
 		bvec_set_page(&bvec, page[i], bytes, offset);
-		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes);
 
 try_page_again:
 		lock_sock(sk);
-		rv = tcp_sendmsg_locked(sk, &msg, size);
+		rv = tcp_sendmsg_locked(sk, &msg, bytes);
 		release_sock(sk);
 
 		if (rv > 0) {
 			size -= rv;
 			sent += rv;
 			if (rv != bytes) {
-				offset += rv;
 				bytes -= rv;
 				goto try_page_again;
 			}


