Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04823B0AFC;
	Wed,  8 Apr 2026 18:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673621; cv=none; b=TWJdv5bf9uICOkuwPOvz0WmMqDypYiup7cfeJ8HXwrFt3CIHBD055cZSgJkUokXMcQybsHn3vv7NF2WeaBEXqGzBzsVZ8quKO8IS31WN5NtJRb4BR5wTgGlexNdrE7AiHTlY/hPLXZxjW/dAvdrCoCSslE/SGWMDGvvde74GlmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673621; c=relaxed/simple;
	bh=1V7o8+brqvdz5BtC88dJnkyh8tahEEWjvtglEnVYCZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTrNOPCJJ4F8iJ+LDKoC77svyIfPXoSuvVJp7V2WWLxMzT4qGXhd38mP4V0tHj77Dxb2yjOSFa8GcsBg0GfSmGIbQuf/K1GhjvgPNWkDnZn2KyDbjL2R/sqiOsr6aEReW0JNp8wobqQoob/oM02yH5MwXzkBOXktstkQchOjKXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7IsIVBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7IsIVBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378BCC19421;
	Wed,  8 Apr 2026 18:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673621;
	bh=1V7o8+brqvdz5BtC88dJnkyh8tahEEWjvtglEnVYCZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7IsIVBY76zjAeI4cBFzk47eSLbPaGf1Cfd+bYnCKJ3prKKleBFfzdvUqCOQoCxnd
	 ipQZlxmSz6G+XUFjDNUpThoOZJw2oQ9oFsJyS4R/d1KXvYe6MlGVTjKTvydNFYa6vm
	 OXYJXMpWQY0SywzFTr++aEaNjXLaKNZ+LpVj9uek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Michaelis <code@mgjm.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 025/242] io_uring/kbuf: propagate BUF_MORE through early buffer commit path
Date: Wed,  8 Apr 2026 20:01:05 +0200
Message-ID: <20260408175928.012466638@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

Commit 418eab7a6f3c002d8e64d6e95ec27118017019af upstream.

When io_should_commit() returns true (eg for non-pollable files), buffer
commit happens at buffer selection time and sel->buf_list is set to
NULL. When __io_put_kbufs() generates CQE flags at completion time, it
calls __io_put_kbuf_ring() which finds a NULL buffer_list and hence
cannot determine whether the buffer was consumed or not. This means that
IORING_CQE_F_BUF_MORE is never set for non-pollable input with
incrementally consumed buffers.

Likewise for io_buffers_select(), which always commits upfront and
discards the return value of io_kbuf_commit().

Add REQ_F_BUF_MORE to store the result of io_kbuf_commit() during early
commit. Then __io_put_kbuf_ring() can check this flag and set
IORING_F_BUF_MORE accordingy.

Reported-by: Martin Michaelis <code@mgjm.de>
Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://github.com/axboe/liburing/issues/1553
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -387,7 +387,10 @@ static inline bool __io_put_kbuf_ring(st
 		ret = io_kbuf_commit(req, bl, len, nr);
 		req->buf_index = bl->bgid;
 	}
-	req->flags &= ~REQ_F_BUFFER_RING;
+	if (ret && (req->flags & REQ_F_BUF_MORE))
+		ret = false;
+
+	req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUF_MORE);
 	return ret;
 }
 


