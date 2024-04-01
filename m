Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B623B2A4;
	Mon,  1 Apr 2024 16:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989658; cv=none; b=k1iWad44D5WLaNVzVSIjyMElClYHMgs0aYXxhA9lo/QYwIiFxqnTfV4UIgk0/Y1HLf++cBNpLlGRksdh1hTVpjvdq0OIAck7yPMSiDy98UJXPESE5gLeBt+mxgL75zGbl/fijCohVlb/iE8Gz3DO3fXgsHyYX9YLxBL/i7fMRr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989658; c=relaxed/simple;
	bh=2bDTntuTseL/OJVAqTRkulVnTwuhauun91Q+JIPa9yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdspcT0l4gLg4Qmw5MI1uT1s33xGAvFpLI0yjx+CHjVijXEv5zFHKCVpo5YyPeiBRLf86zrUxUPcNuZdL4vjIxqmzX1gozVfAe+Xb9wGZX5J8oiS5OMzrd7zJtVcAiXXKSmS3HiY+IXGzD/Rd5oXtxUpE6i9UQm6/vtkaI5iwe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRp2YsFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRp2YsFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E0DC433F1;
	Mon,  1 Apr 2024 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989658;
	bh=2bDTntuTseL/OJVAqTRkulVnTwuhauun91Q+JIPa9yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRp2YsFFgaVSREaTJdfIXGdbnNLa0vCq/udEJsH0D7TX41boEZnK+lu/Z6pf7FuGu
	 hGbvm6YhfZKdflEEyOHGkdYh1bBKWKcNnjgomm1Fd39OnfzUmQlkh8tPCv82khhAKv
	 EezL7UMcx2Sod9DmZpnjPuYbfveELB3xPno7Y2oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/396] io_uring/net: correctly handle multishot recvmsg retry setup
Date: Mon,  1 Apr 2024 17:42:43 +0200
Message-ID: <20240401152551.319074665@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

[ Upstream commit deaef31bc1ec7966698a427da8c161930830e1cf ]

If we loop for multishot receive on the initial attempt, and then abort
later on to wait for more, we miss a case where we should be copying the
io_async_msghdr from the stack to stable storage. This leads to the next
retry potentially failing, if the application had the msghdr on the
stack.

Cc: stable@vger.kernel.org
Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 4aaeada03f1e7..386a6745ae32f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -915,7 +915,8 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			kfree(kmsg->free_iov);
 		io_netmsg_recycle(req, issue_flags);
 		req->flags &= ~REQ_F_NEED_CLEANUP;
-	}
+	} else if (ret == -EAGAIN)
+		return io_setup_async_msg(req, kmsg, issue_flags);
 
 	return ret;
 }
-- 
2.43.0



