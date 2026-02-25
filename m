Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E079248886;
	Wed, 25 Feb 2026 01:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983749; cv=none; b=pwBIAaIDZadr1s9kTjqtHS4JR2TKmYKYMohvH3H23fCV7OHrmlCBmF/ITo+V5DBxp2717sa38ZBL3yeZQJVv6InqZdrDw4NaK4Cba5yj1r9EOljeHOhiKNDzdU4zlJzaMbzcxK99WLe6AwtIanOTq1+gPkfecxsdFuob879tTqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983749; c=relaxed/simple;
	bh=kbeCrC/NNO4LML2PQLISjxXIxQknEr9o+7CtOJmBSlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWc5V8AYeg7ZsP0iE2n7rV0uc3wbUuGXH7MpxgL/5lDA6PlXrjPnaQuIQs6pvtDEvqvw9erRfLM561Qa4EVFRVIQM5y+pyzBdgXkL1DiC+/AgRUCHVDnmv5Ioe5W5tVhcHmaAiTX/fYyh5Em0d+CJ06irDY1tN4xo0/sM/IAXiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zrp6bz2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zrp6bz2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8B5C116D0;
	Wed, 25 Feb 2026 01:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983748;
	bh=kbeCrC/NNO4LML2PQLISjxXIxQknEr9o+7CtOJmBSlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zrp6bz2/42r3KK4S1S/p7KBkWs0S6EiJKNWUHCPdM0x9wfeHDYE1gYKhJQp82yMgt
	 1HmB/47qjXACkpCQSLKeu+OYD2TheM3U8y6kNY7jeyQGGpF9GgJ4xVe6bp/mUnbZmj
	 +/BTDFswTlWOnXEHBq+p4QcB9Yz0dMcpkSrDt3TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/641] io_uring/sync: validate passed in offset
Date: Tue, 24 Feb 2026 17:16:06 -0800
Message-ID: <20260225012349.995257440@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

[ Upstream commit 649dd18f559891bdafc5532d737c7dfb56060a6d ]

Check if the passed in offset is negative once cast to sync->off. This
ensures that -EINVAL is returned for that case, like it would be for
sync_file_range(2).

Fixes: c992fe2925d7 ("io_uring: add fsync support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/sync.c b/io_uring/sync.c
index cea2d381ffd2a..ab7fa1cd7dd63 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -62,6 +62,8 @@ int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	sync->off = READ_ONCE(sqe->off);
+	if (sync->off < 0)
+		return -EINVAL;
 	sync->len = READ_ONCE(sqe->len);
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
-- 
2.51.0



