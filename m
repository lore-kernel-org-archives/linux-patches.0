Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309591C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF69C433C1;
	Wed, 23 Nov 2022 09:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197310;
	bh=hCcOxp8hsjUEilbht1UxvF/v83QNvLyRxB4jRPjcjiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOwIH+Mcma8QED5HCXv+37YyC59/kHZlBje0RdblEU7VPUYdSpNAqq3DfQOq91Qkw
	 uhVEafab8jOmSwnj3GUJCsDdbcRCh2dOzKebWSkjUousLLNp9LM3Yh3vd/yZgOCfq3
	 9ypD5qIDvVu6JXM50ahSmWUhcnMHQTTr9vHRdZRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 257/314] io_uring: fix tw losing poll events
Date: Wed, 23 Nov 2022 09:51:42 +0100
Message-Id: <20221123084637.171063454@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit 539bcb57da2f58886d7d5c17134236b0ec9cd15d upstream.

We may never try to process a poll wake and its mask if there was
multiple wake ups racing for queueing up a tw. Force
io_poll_check_events() to update the mask by vfs_poll().

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/00344d60f8b18907171178d7cf598de71d127b0b.1668710222.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -226,6 +226,13 @@ static int io_poll_check_events(struct i
 			return IOU_POLL_DONE;
 		if (v & IO_POLL_CANCEL_FLAG)
 			return -ECANCELED;
+		/*
+		 * cqe.res contains only events of the first wake up
+		 * and all others are be lost. Redo vfs_poll() to get
+		 * up to date state.
+		 */
+		if ((v & IO_POLL_REF_MASK) != 1)
+			req->cqe.res = 0;
 
 		/* the mask was stashed in __io_poll_execute */
 		if (!req->cqe.res) {


