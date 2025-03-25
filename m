Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7995326F440;
	Tue, 25 Mar 2025 12:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906358; cv=none; b=S+4ASy5NNxrGmgRDTLfSev4XazbzoFTaok3sN+b4WkRKJKjB4Y0yARao6zU/f8lDqhoh3GgLIcif+DvmvMfaQ3ebe1yN3Y6jycZ6Qg5CLNG8Mu5Ya3omQYPaHFwCSkU4ZCs1a+x7fSogs6y/qxe6EsIm9haqISXX/0dezCRxQRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906358; c=relaxed/simple;
	bh=+mNDA01syf//Ta9a9+EMbih9agk+cnBv9KaE2DU37Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6CktNG/LRw/TgSQQnoAe/7W9D8IudrihMf80Od+wTfObOi0Rj4P3RHgYzb6TELeNyO+gdaPvrXOme7UbFk1+wRdavuULpHjy2xRidlh2SkpnwhMIf2AM4I3cSt5VzMVUWf65Wwf8hzpzXXXi6KDhf0/pxQAlEOfKnB2wEDUstE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFh2qJ+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFh2qJ+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303C4C4CEE4;
	Tue, 25 Mar 2025 12:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906358;
	bh=+mNDA01syf//Ta9a9+EMbih9agk+cnBv9KaE2DU37Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFh2qJ+S0IXPNA2Rk/Gb54wiHuj9Tp6FRsHSjIlCFxTnTtqzTogCurVNiCNbkszPv
	 XMb5vxCnXjG1788ZxuSn/XcLr1QS0v5E6qKAIXjD7Ht5bYeZo+v+kfSUrpKJ0KrkAi
	 IGomD8ZDC0JGpXxGPwZc2FqH0up2pyRQsmRQ3loQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Raphael S. Carvalho" <raphaelsc@scylladb.com>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 075/116] mm: fix error handling in __filemap_get_folio() with FGP_NOWAIT
Date: Tue, 25 Mar 2025 08:22:42 -0400
Message-ID: <20250325122151.126508201@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael S. Carvalho <raphaelsc@scylladb.com>

commit 182db972c9568dc530b2f586a2f82dfd039d9f2a upstream.

original report:
https://lore.kernel.org/all/CAKhLTr1UL3ePTpYjXOx2AJfNk8Ku2EdcEfu+CH1sf3Asr=B-Dw@mail.gmail.com/T/

When doing buffered writes with FGP_NOWAIT, under memory pressure, the
system returned ENOMEM despite there being plenty of available memory, to
be reclaimed from page cache.  The user space used io_uring interface,
which in turn submits I/O with FGP_NOWAIT (the fast path).

retsnoop pointed to iomap_get_folio:

00:34:16.180612 -> 00:34:16.180651 TID/PID 253786/253721
(reactor-1/combined_tests):

                    entry_SYSCALL_64_after_hwframe+0x76
                    do_syscall_64+0x82
                    __do_sys_io_uring_enter+0x265
                    io_submit_sqes+0x209
                    io_issue_sqe+0x5b
                    io_write+0xdd
                    xfs_file_buffered_write+0x84
                    iomap_file_buffered_write+0x1a6
    32us [-ENOMEM]  iomap_write_begin+0x408
iter=&{.inode=0xffff8c67aa031138,.len=4096,.flags=33,.iomap={.addr=0xffffffffffffffff,.length=4096,.type=1,.flags=3,.bdev=0x…
pos=0 len=4096 foliop=0xffffb32c296b7b80
!    4us [-ENOMEM]  iomap_get_folio
iter=&{.inode=0xffff8c67aa031138,.len=4096,.flags=33,.iomap={.addr=0xffffffffffffffff,.length=4096,.type=1,.flags=3,.bdev=0x…
pos=0 len=4096

This is likely a regression caused by 66dabbb65d67 ("mm: return an ERR_PTR
from __filemap_get_folio"), which moved error handling from
io_map_get_folio() to __filemap_get_folio(), but broke FGP_NOWAIT
handling, so ENOMEM is being escaped to user space.  Had it correctly
returned -EAGAIN with NOWAIT, either io_uring or user space itself would
be able to retry the request.

It's not enough to patch io_uring since the iomap interface is the one
responsible for it, and pwritev2(RWF_NOWAIT) and AIO interfaces must
return the proper error too.

The patch was tested with scylladb test suite (its original reproducer),
and the tests all pass now when memory is pressured.

Link: https://lkml.kernel.org/r/20250224143700.23035-1-raphaelsc@scylladb.com
Fixes: 66dabbb65d67 ("mm: return an ERR_PTR from __filemap_get_folio")
Signed-off-by: Raphael S. Carvalho <raphaelsc@scylladb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1966,8 +1966,19 @@ no_page:
 
 		if (err == -EEXIST)
 			goto repeat;
-		if (err)
+		if (err) {
+			/*
+			 * When NOWAIT I/O fails to allocate folios this could
+			 * be due to a nonblocking memory allocation and not
+			 * because the system actually is out of memory.
+			 * Return -EAGAIN so that there caller retries in a
+			 * blocking fashion instead of propagating -ENOMEM
+			 * to the application.
+			 */
+			if ((fgp_flags & FGP_NOWAIT) && err == -ENOMEM)
+				err = -EAGAIN;
 			return ERR_PTR(err);
+		}
 		/*
 		 * filemap_add_folio locks the page, and for mmap
 		 * we expect an unlocked page.


