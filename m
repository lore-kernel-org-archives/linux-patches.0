Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912CA267F65;
	Tue,  8 Apr 2025 11:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111309; cv=none; b=ViLhzJXS13m2T6fH2/N7AyIkgZlZDj9XhxLhEnPLEAvkLgdFevTQxMsARRIG5KrhdHzg9G8eZ5Yvg/ZntSbw/O/6dJlsRX/DcFQmWPJhaa8etAEU0ESNZlAJe5fiRQciBHN+WoBGAYPPQGGl6XuolLEIDSIaFNiW//tfN4JAhqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111309; c=relaxed/simple;
	bh=40XGAJCAm9FRGZE0B731HkUaIXme0XJ5MkY01ujtzlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWX5dUOdJ/F5Wu1pYTJc49BvsMP/EKdNJkaC6lY7pMNz4LoAsbPHTvK43aDBYMJvUUFVjJbIaHy1fMVuVULCJ/aS+bKy2wQzuswK4JkNXBoNH6rKgSCaFOp3TMzpjDBjz/Ll0oibpoCX7yS4tgPx/WtURbs0qx6KVIQNvCN5Kms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibKIaUrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibKIaUrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD66C4CEE5;
	Tue,  8 Apr 2025 11:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111309;
	bh=40XGAJCAm9FRGZE0B731HkUaIXme0XJ5MkY01ujtzlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibKIaUrmA2W9uWSQbX+XLLCVf0eOdUSiBd7YSfAH1g0PPT7Z+kbtBqz9PK6cMVhh1
	 JsqGpELWGUkGhBaSUQySYGrGyxPSHoqN+1/GdbenBqlbKhIy8vzoUuED2P60CMJwdK
	 vjQAh/B4KR47OWSTo/OFVULLGpLNdBGiApqAS+lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Li Zetao <lizetao1@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 345/731] io_uring: use lockless_cq flag in io_req_complete_post()
Date: Tue,  8 Apr 2025 12:44:02 +0200
Message-ID: <20250408104922.300767726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 62aa9805d123165102273eb277f776aaca908e0e ]

io_uring_create() computes ctx->lockless_cq as:
ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)

So use it to simplify that expression in io_req_complete_post().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/20250212005119.3433005-1-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 3f0cb8de56b9 ("io_uring: fix retry handling off iowq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 573b3f542b82a..99b83487c8158 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -899,7 +899,7 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
 	 * the submitter task context, IOPOLL protects with uring_lock.
 	 */
-	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
+	if (ctx->lockless_cq) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 		return;
-- 
2.39.5



