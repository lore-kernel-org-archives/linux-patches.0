Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198EE3A4F4A;
	Sat, 17 Oct 2026 16:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253635; cv=none; b=HwTjkjEKiBumyxZ5HUYZ8whP3Ckr5JwaA2sVNQi8V4G4G/HuR/cwmfIfeP9gcrd5FsWE58c0zSacKlUbS19g4XL71nawshv4bAsLetTKTAO8++lzsmNMefT4tgQuEGVO0wlOD2RYs2Oq/TZm/0HWuGDl3GUjlPR/YOy/TYz/wWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253635; c=relaxed/simple;
	bh=J72G1xotOERj9hAWkmi9z6GsyuJBmLdCOaLh99RYNww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXJRf0CylthTskIv7WIdCrGVfMe8x6AwcrALgQgBo7Yn3uOvRYtqCw4+yc2MO2SHVkGnomeMlZHWh7r4OMOYtpP+9khRRzi3dPwWZq0OTdBsHdwtCjlNaYUe1S/Y4ioIdVal/1B3sKNcatPmz18lRJMNlCQNBjj/jtfL6HH+0OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHeQArox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHeQArox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4A61F000C4;
	Sat, 17 Oct 2026 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253631;
	bh=EQdA2Zff3zpZuHKdZoCOGSi1MvatUlr5a9BIP717M6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHeQAroxlyQijJ76nuTt3R5RcbEdihLkz24laln5/Vs0pWB6FEU0bgLnuBRk7rl4K
	 I2Y4JWuvl6IcMhehpgbZlqysOVqQL8Lsp1c12MblO4J0/jkEFSMgAQ30neoEzODxZP
	 54oyihQ+/zlWlurwKZ7vBVYVvAGbEqndmqkHqZKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/869] io_uring/rw: free potentially allocated iovec on cache put failure
Date: Sat, 17 Oct 2026 17:50:23 +0200
Message-ID: <20261017160041.720421437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4b9748055457ac3a0710bf210c229d01ea1b01b9 ]

If a read/write request goes through io_req_rw_cleanup() and has an
allocated iovec attached and fails to put to the rw_cache, then it may
end up with an unaccounted iovec pointer. Have io_rw_recycle() return
whether it recycled the request or not, and use that to gauge whether to
free a potential iovec or not.

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index d615c61bbbd2e..c8a536ce2fe32 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -156,22 +156,22 @@ static void io_rw_iovec_free(struct io_async_rw *rw)
 	}
 }
 
-static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
+static bool io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_rw *rw = req->async_data;
 	struct iovec *iov;
 
-	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
-		io_rw_iovec_free(rw);
-		return;
-	}
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
+		return false;
 	iov = rw->free_iovec;
 	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
 		if (iov)
 			kasan_mempool_poison_object(iov);
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
+		return true;
 	}
+	return false;
 }
 
 static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
@@ -205,7 +205,11 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(req->flags & REQ_F_REFCOUNT)) {
 		req->flags &= ~REQ_F_NEED_CLEANUP;
-		io_rw_recycle(req, issue_flags);
+		if (!io_rw_recycle(req, issue_flags)) {
+			struct io_async_rw *rw = req->async_data;
+
+			io_rw_iovec_free(rw);
+		}
 	}
 }
 
-- 
2.53.0



