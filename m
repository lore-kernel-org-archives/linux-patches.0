Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765FA3E63AA;
	Thu, 28 May 2026 19:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998042; cv=none; b=Rk623dAgiKXVmbtGmWp0mfLGdYL737M9ZKNOiEVqx3hftfPdeg4ymjDB2yJu++0ljh3SSaT1GGC0b3cDu7TSkOqPCgt9QjeIJ6TOjjSfxZtzeubmAdYnP5NyClXQmkpWAkrrCzy2j4tHEK7Dvb7Tp53dEKmLBpM5ghXMwKNiYek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998042; c=relaxed/simple;
	bh=K9K9eQAUGPwxMK1zMV0E2vEwegW4lmy5/5JOfm7w5pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0RIFruEOoEdGjZVxDXuXPCoWSKG+0vI37DOPhkHimY+CcjZYIdD1Dq+24sKr3xCOqoZ8rvh5rWI+kzjk7ZmMwaPHPpi8ji9EmX1zORDL7AJR0QcptI5JicuNF7DzMvjFrw0mWsi7WnZCU/qXd3ros+UUQNnxzN3DKtBaGDYeyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgVqva+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgVqva+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910681F000E9;
	Thu, 28 May 2026 19:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998038;
	bh=vwRWm748aOi2HdUY4NZtwnfvg+DNGZJ3jfUo+t1EiFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PgVqva+NGolYc2DIkQZTp/3Df6v4YIlmN7KmPEHeeC3XHDfMLCx0C8n87TXIEGqyg
	 CU77beauBO0pz0vOVyXIsFNEZoj3f5wOp3kMqE3HdUmgzOkXW2py/VYG5rDRKKT+Xs
	 JlyRAR8USxkjQ61dM3tXsOU2CoExAiyqF+adADz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heechan Kang <gganji11@naver.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 030/461] io_uring/waitid: clear waitid info before copying it to userspace
Date: Thu, 28 May 2026 21:42:39 +0200
Message-ID: <20260528194647.768965043@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -275,6 +275,7 @@ int io_waitid_prep(struct io_kiocb *req,
 	iw->options = READ_ONCE(sqe->file_index);
 	iw->head = NULL;
 	iw->infop = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	memset(&iw->info, 0, sizeof(iw->info));
 	return 0;
 }
 


