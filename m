Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9771779B1;
	Tue,  8 Oct 2024 12:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390899; cv=none; b=Y+UlRlQ6qp5xSyN6M+OekIC3D4ZCZuwJiwQngcldsDQmpRFQvA9mq3Xay9Fa9mNC0QPqq6Fabm+0vtkKMVgk0h7YMeCKCJZ97WmqSB3ySlICcasLDUsUaMTcN3nTAJsBbYgNoffZhUEZe/QhD/SdjQm/SN5+G3Fdg2UMtlxyEaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390899; c=relaxed/simple;
	bh=CElowgiTdofJCKzIGSUcOxc8Vrx6ugb5b0B/6Je/3OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfnXxmSlBpPpaQEYC3rbhcODWHCT9fR1VIvTuyX9J66tIqE5vmokRsc6slhKajWKED++IMYYvFNvb9Jf8sMXSrCCClHyaf9SjIqqhP6wPTVTgZ7F6lK7hSCk1pA4t1xfVwCzqUhTnQwYgyNYs+QvVyoryiv4v1VbSJ6O6J/cIbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHyWd5B0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHyWd5B0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA92C4CEC7;
	Tue,  8 Oct 2024 12:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390899;
	bh=CElowgiTdofJCKzIGSUcOxc8Vrx6ugb5b0B/6Je/3OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHyWd5B0M5mboTssflg2941nDiooNpat418cMNL9pc6LrWWy0PL5QjvA1J4KgPeR2
	 Q3WyqQlWu1YKVtc+6/Zfxb2TPXFF6aXA5QUqzo7OaE1sJML6P3o58d9cGiEp85bmSh
	 ru0G00zsMISwAF2KIJT9JXIrFdko7Tb0rnB6Bz7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 426/482] io_uring/net: harden multishot termination case for recv
Date: Tue,  8 Oct 2024 14:08:09 +0200
Message-ID: <20241008115705.166207740@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit c314094cb4cfa6fc5a17f4881ead2dfebfa717a7 upstream.

If the recv returns zero, or an error, then it doesn't matter if more
data has already been received for this buffer. A condition like that
should terminate the multishot receive. Rather than pass in the
collected return value, pass in whether to terminate or keep the recv
going separately.

Note that this isn't a bug right now, as the only way to get there is
via setting MSG_WAITALL with multishot receive. And if an application
does that, then -EINVAL is returned anyway. But it seems like an easy
bug to introduce, so let's make it a bit more explicit.

Link: https://github.com/axboe/liburing/issues/1246
Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55 ("io_uring: multishot recv")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1116,6 +1116,7 @@ int io_recv(struct io_kiocb *req, unsign
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	size_t len = sr->len;
+	bool mshot_finished;
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
@@ -1170,6 +1171,7 @@ out_free:
 		req_set_fail(req);
 	}
 
+	mshot_finished = ret <= 0;
 	if (ret > 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -1177,7 +1179,7 @@ out_free:
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags))
+	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	return ret;


