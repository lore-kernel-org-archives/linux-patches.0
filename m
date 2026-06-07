Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95D83195FD;
	Sun,  7 Jun 2026 10:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829038; cv=none; b=Ss1Y+JstYtHi+mrPRV/3p8z0AvmlDoXgXmXUxdNTs174s7lmN7rpEeNu2YsNFgYDR9EnhEmGuA0GWSM23/4ecD1GX5F7zuSF/ztNFKNm9wEE0ro1W/IgE9SaU1NSrycSi0YNz9cBnYy0uYRHeDgNIUzKe39KZMZyduYbKYoYsKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829038; c=relaxed/simple;
	bh=NW3kqRGak1NHU9Hj5Z40zPC86HoHyz8pPu04Q1laexY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pWWVznXGsdVwFLVHQt/LnVWA8GQ79VeiCuHH/hgoUOeLw/KndfWaSR9qgJ6qQWY+frP5j9qGYvLsYttvEEqRtEhH/9jabwT5CsuOxBlExDa/4O9RHNrD10UOwIExy0uDSmlYLFw7qbqnN5UUnHXt76Wg6rrwdfTRHvq9AXrgpD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCdRSWwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCdRSWwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA6A1F00893;
	Sun,  7 Jun 2026 10:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829037;
	bh=NtsaQ4lShnpTqNRzktyNF7+P5JCO0rvdvskIbgObqJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCdRSWwIccsSb1SXy1x5lygF1e6sMpbFJHQ/nX5joW7P8rLSHuWEB/5BQPcDFfkpx
	 QVwCYeUNK3aSORfdNgVlyOSOlQDgg7qPYd/9pyuB/UiJKH2BEUQUWRn8lINXIjeSzz
	 1SeaOag4DzUpFaATuqGbRihbwlEtW50Q+EM8njYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7f4987d0afb97dd090cb@syzkaller.appspotmail.com,
	David Carlier <devnexen@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 7.0 236/332] dma-buf: fix UAF in dma_buf_fd() tracepoint
Date: Sun,  7 Jun 2026 12:00:05 +0200
Message-ID: <20260607095736.719419406@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit ead6680f354f83966c796fc7f9463a3171789616 upstream.

Once FD_ADD() returns, the fd is live in the file descriptor table
and a thread sharing that table can close() it before DMA_BUF_TRACE()
runs. The close drops the last reference, __fput() frees the dma_buf,
and the tracepoint then dereferences dmabuf to take dmabuf->name_lock
-- slab-use-after-free.

Split FD_ADD() back into get_unused_fd_flags() + fd_install() and
emit the tracepoint between them. While the fdtable slot is reserved
with a NULL file pointer, a racing close() returns -EBADF without
entering __fput(), so the dma_buf stays alive across the trace. Same
approach as commit 2d76319c4cbb ("dma-buf: fix UAF in dma_buf_put()
tracepoint").

This undoes the FD_ADD() conversion done in commit 34dfce523c90
("dma: convert dma_buf_fd() to FD_ADD()"); FD_ADD() has no place to
hook the tracepoint safely.

Reported-by: syzbot+7f4987d0afb97dd090cb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7f4987d0afb97dd090cb
Fixes: 281a22631423 ("dma-buf: add some tracepoints to debug.")
Cc: stable@vger.kernel.org # 7.0.x
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patch.msgid.link/20260523181446.69525-1-devnexen@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-buf.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -792,9 +792,13 @@ int dma_buf_fd(struct dma_buf *dmabuf, i
 	if (!dmabuf || !dmabuf->file)
 		return -EINVAL;
 
-	fd = FD_ADD(flags, dmabuf->file);
+	fd = get_unused_fd_flags(flags);
+	if (fd < 0)
+		return fd;
+
 	DMA_BUF_TRACE(trace_dma_buf_fd, dmabuf, fd);
 
+	fd_install(fd, dmabuf->file);
 	return fd;
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_fd, "DMA_BUF");


