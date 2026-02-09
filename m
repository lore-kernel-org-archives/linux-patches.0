Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DF929D265;
	Mon,  9 Feb 2026 14:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647443; cv=none; b=MutfkODnDPt/E2ebt73UscQwI3E2HH3+c7UP6VZwrSxFiwxo9TSJyaKoBuUsjUFRgwQ4wYiYbvDSrEnSdDx1t8zZ+aIWUMqdCZCIHEsyzoIIPKD1iPa1SJieo3luwlsHeiC5ifHtN6jCXkJ1mbl6i7SB11MTWVu6A0RH+jvq2NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647443; c=relaxed/simple;
	bh=QGUIGlO5GeI+r/itJCYvhbN5Kscmk9VE1WNWMXD1SYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhiCU0FJLUFALBElUQMwP37lyvEvE2Z9Mw8nI8AKwjfBJMN7LuC7kjhHONzuX59rVIlYZNgFeGrGfycqJZOch71xFzikHq4wBlhi29CvVN5mGYB32VEXO/LbK6zW+KuPyuj5ICpdMEYBSYoTiJ9O4lWDWwCW7Y9e/uo90wx8SPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzQDzReu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzQDzReu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1254C116C6;
	Mon,  9 Feb 2026 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647443;
	bh=QGUIGlO5GeI+r/itJCYvhbN5Kscmk9VE1WNWMXD1SYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzQDzReuL+iIF1d3mpT3fpWyikH/GUUR2mJOaUrgVZ192/1scrTiX2OH4sJopffvO
	 DI6PUA07TPRRXNQ0pHg/efifv0sLSq6/ZpqozviPuP683LWTjIaqSAjYG9sXNS+2rZ
	 aDCVHKOWE++sjRzVgR6IGGWlRJYcyw07JMa47eUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/175] io_uring/rw: free potentially allocated iovec on cache put failure
Date: Mon,  9 Feb 2026 15:22:55 +0100
Message-ID: <20260209142324.087348673@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 io_uring/rw.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index abe68ba9c9dc8..d7388a4a3ea5e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -144,19 +144,22 @@ static inline int io_import_rw_buffer(int rw, struct io_kiocb *req,
 	return 0;
 }
 
-static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
+static bool io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_rw *rw = req->async_data;
 
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
-		return;
+		return false;
 
 	io_alloc_cache_vec_kasan(&rw->vec);
 	if (rw->vec.nr > IO_VEC_CACHE_SOFT_CAP)
 		io_vec_free(&rw->vec);
 
-	if (io_alloc_cache_put(&req->ctx->rw_cache, rw))
+	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
 		io_req_async_data_clear(req, 0);
+		return true;
+	}
+	return false;
 }
 
 static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
@@ -190,7 +193,11 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(req->flags & (REQ_F_REISSUE | REQ_F_REFCOUNT))) {
 		req->flags &= ~REQ_F_NEED_CLEANUP;
-		io_rw_recycle(req, issue_flags);
+		if (!io_rw_recycle(req, issue_flags)) {
+			struct io_async_rw *rw = req->async_data;
+
+			io_vec_free(&rw->vec);
+		}
 	}
 }
 
-- 
2.51.0



