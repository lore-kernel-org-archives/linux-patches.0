Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2A8313550;
	Thu, 28 May 2026 20:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000469; cv=none; b=sOwxEZ6c21f95WIoKpGQFexzv8uQMWS3ZpAi59EFGR4EM+bqXwFXQrzJk+5rizH0Ra5YHmuPN2z1KH0Yqf1Sp1aRd6HLujGKPo4tnnvMW9c+f/HLW7SZfQWvFl5MYd961QIidcmGPDRSLTWQ1WXKHyhAb4/WGh0Wcz5GlBf+myA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000469; c=relaxed/simple;
	bh=D1JtSh+K1ktRa7P8fnyjIoLtZxhvff/XKXY4ob//lCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvwvdPOpi7InKuvgR9akvBsXON0ImghBECnc+sxuANk2rPk0KHmcKECdHdQG9vNmFmgVIn6oxjw5Gk4Xm5iJkHds0ruJhUjCeGcwoqhPQG79ED3jKqAKwmk/OGOZ8frqD4o02alOMuYgMh/AQ17kiG2ZEKQtj1r6lWJTlk0fJoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGQ7asPy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGQ7asPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082661F000E9;
	Thu, 28 May 2026 20:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000468;
	bh=QZ4i1P3YFUa+C6RVAEqB9ECtQCFkx4V2uWyZjdqYpuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGQ7asPyxw458+7wWBl+q+zNnwNkqk9F8Ly3YSf+6lW0/on88scz9WK0jwEXaadvn
	 146XTp1a0ysA0hQMozyqSanA5H0RYtWGfOF98g9rW2JLHZQeLFgo0wkhAjyilgz1m+
	 Pl6pq1XQK+aaltAuJmM0EooFaEA5QbfePw0i4o6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heechan Kang <gganji11@naver.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 056/272] io_uring/waitid: clear waitid info before copying it to userspace
Date: Thu, 28 May 2026 21:47:10 +0200
Message-ID: <20260528194630.950082681@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Heechan Kang <gganji11@naver.com>

commit 93d93f5f8da791e98159795c6ef683f45bd95d13 upstream.

IORING_OP_WAITID stores its result fields in struct io_waitid::info and
later copies them to userspace siginfo. The prep path initializes the
request arguments, but it does not initialize info itself.

If the wait operation completes without reporting a child event, the common
wait code can return without writing wo_info. In that case io_waitid_finish()
still copies iw->info to userspace, exposing stale bytes from the reused
io_kiocb command storage.

Clear the result storage during prep so the io_uring path matches the
regular waitid syscall, which uses a zero-initialized struct waitid_info.

Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Heechan Kang <gganji11@naver.com>
Link: https://patch.msgid.link/20260516184709.852814-1-gganji11@naver.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -294,6 +294,7 @@ int io_waitid_prep(struct io_kiocb *req,
 	iw->upid = READ_ONCE(sqe->fd);
 	iw->options = READ_ONCE(sqe->file_index);
 	iw->infop = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	memset(&iw->info, 0, sizeof(iw->info));
 	return 0;
 }
 


