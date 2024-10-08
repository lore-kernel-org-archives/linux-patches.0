Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3409F1DE8BA;
	Tue,  8 Oct 2024 13:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392753; cv=none; b=H8M6HYz/TN3GWo63Ewvehd5gY9748nuLDo/UNbHWi97w3BpjhxeggQwKKmOlu0NQd/cW0+Xwz30VPRjCdDjgpMuZjCwq4pRhXS9Xp2DPJSl0g9ujPish5ayaUwywv2LnZi+J2bEz+viHG08UzjT3lOlQhijZyUnG/ZJKRbe+b3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392753; c=relaxed/simple;
	bh=shJKHnb3pkvfhWoTVsRomYrLAqhS/ouWzjstlfQpaRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBANdx0PBeEfQBjKrIOq1XDdELf4e92m/GENmXEYIuBYXfuLrE9H5QKAaJbHSmQjj6xjSqgmUvFUzeBokL+7vjcpPRoQxhOTHHyUvKDsNAvDbyC/tunLqDEl9jZ8JLsv3IEZnoxjx6jDOX0/ZVi6dLcj6D0EfdwI3S5wXIHJtfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdJtZNVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdJtZNVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DDFC4CEC7;
	Tue,  8 Oct 2024 13:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392753;
	bh=shJKHnb3pkvfhWoTVsRomYrLAqhS/ouWzjstlfQpaRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdJtZNVJJLNEfoj6TAqkV+D7IJ2QI4JMOzF83slFFW/X03K5ECM3jLDrLPojiloP8
	 ONYoUGFIOSLafMi5jbkiXckxU6SnAL8GoXqYgkBIZyRNguNiSzKdUikd372RvR76k7
	 w8tiIFJcQ9N0s6HNQzZCkF2d+E5k5HAlBjFzxln0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 507/558] io_uring/net: harden multishot termination case for recv
Date: Tue,  8 Oct 2024 14:08:57 +0200
Message-ID: <20241008115722.182557355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1126,6 +1126,7 @@ int io_recv(struct io_kiocb *req, unsign
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	size_t len = sr->len;
+	bool mshot_finished;
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
@@ -1180,6 +1181,7 @@ out_free:
 		req_set_fail(req);
 	}
 
+	mshot_finished = ret <= 0;
 	if (ret > 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -1187,7 +1189,7 @@ out_free:
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags))
+	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	return ret;


