Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8421DFE04;
	Tue,  8 Oct 2024 13:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394064; cv=none; b=GbGMRRuNjQfyhFQVopN2unIoBqwDlfwD33Slr+7sdb7lgZ1K9zBUd2Irx2GbDsMfwwrqwmdiadZJXpUEO20wchX8GmR3lyuHXsl7v9wNYW6oGiKcHUb3cGZMlj81Js4QuKbehmugqpMYdJEaBBqn0A+JoLroUU7Guf+4LaDPS1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394064; c=relaxed/simple;
	bh=O6N5RWiITU7cIxBEbOBSZlERJAz6KGVpcgKxz1bmvY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izcUzEb+pmjtZGBPUV5dnf1YuBYfq1GE11b1E7cssN3q66Fv6efa6AOhtj35qPExuJTp5t+9dC0oYtVpq3+fPhQ4RYcsGRJlJNrYnSZfVxntlGQ2E4QxBZYP3I4unvAJgkrpQZAJgG3Db98tyv/fB/dv8OC3YEopLr9lWu3ZSbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Re43BzBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Re43BzBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80233C4CEC7;
	Tue,  8 Oct 2024 13:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394064;
	bh=O6N5RWiITU7cIxBEbOBSZlERJAz6KGVpcgKxz1bmvY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Re43BzBPhLIK6MmFeU8tnuR0AP9IXTYnBxTOcvB1kD8eNE+7T30r+6O4gNi/lHE2x
	 8mm/lUwKqZ4yPAhyVng8fdyY7pdgWl8fOgg64BOYWqDIi1yqVxua4uYI23ukeCNli2
	 3xnkX5hLA718SefAipzzX+Gjol/VyREsuIU9cT7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 337/386] io_uring/net: harden multishot termination case for recv
Date: Tue,  8 Oct 2024 14:09:42 +0200
Message-ID: <20241008115642.645407864@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit c314094cb4cfa6fc5a17f4881ead2dfebfa717a7 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index cf1060fb04f43..7412904387bfa 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -930,6 +930,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	size_t len = sr->len;
+	bool mshot_finished;
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
@@ -999,6 +1000,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	}
 
+	mshot_finished = ret <= 0;
 	if (ret > 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -1006,7 +1008,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	if (!io_recv_finish(req, &ret, &msg, ret <= 0, issue_flags))
+	if (!io_recv_finish(req, &ret, &msg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	return ret;
-- 
2.43.0



