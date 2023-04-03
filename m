Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7110F6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC60DC433EF;
	Mon,  3 Apr 2023 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532834;
	bh=o9EEU5vGc9NncwTA6ud1hmxZS7/nE4GGzCJQsCCPfIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkJkCQ55XyOLbVqSJW1ZvWd7XKdBUpoIAqJs5Q2fdfr20sW69DhvLggCHxAeUS2It
	 h1fNq1+UCx965nUiee/KdtLGhkX0wz8rfGNSO2QbvUhTzZIfnWjVvjbQBNl7TDE/Tr
	 wwy7ofTNqnha/hSlO0Vu7DjpNLzJIJHP9Axw6OSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 135/181] io_uring/poll: clear single/double poll flags on poll arming
Date: Mon,  3 Apr 2023 16:09:30 +0200
Message-Id: <20230403140419.463627909@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 005308f7bdacf5685ed1a431244a183dbbb9e0e8 upstream.

Unless we have at least one entry queued, then don't call into
io_poll_remove_entries(). Normally this isn't possible, but if we
retry poll then we can have ->nr_entries cleared again as we're
setting it up. If this happens for a poll retry, then we'll still have
at least REQ_F_SINGLE_POLL set. io_poll_remove_entries() then thinks
it has entries to remove.

Clear REQ_F_SINGLE_POLL and REQ_F_DOUBLE_POLL unconditionally when
arming a poll request.

Fixes: c16bda37594f ("io_uring/poll: allow some retries for poll triggering spuriously")
Cc: stable@vger.kernel.org
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -742,6 +742,7 @@ int io_arm_poll_handler(struct io_kiocb
 	apoll = io_req_alloc_apoll(req, issue_flags);
 	if (!apoll)
 		return IO_APOLL_ABORTED;
+	req->flags &= ~(REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL);
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 


