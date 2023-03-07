Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA0DBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FF3C433EF;
	Tue,  7 Mar 2023 18:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213909;
	bh=k6NO6Lmlzk7HMv9q5V/O+LmveDGRRdckY038h6mhHj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLDafpebo/ohYJ/3wjO0fwNYQ5vLBAPpj1qNe6tg9DopLqsuZ2nComVAqy7zr+3jj
	 umZJ67vjz0cvs4/hdXS5haGsbMW1CxFeHlbBVSYsF+dRH2s6OeBpOs2cBz2+MZyrqo
	 VTP+xMtzMMpRXBlWhp8TCFAOcZQ4D9Yw3B8oEDyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 658/885] io_uring: use user visible tail in io_uring_poll()
Date: Tue,  7 Mar 2023 17:59:52 +0100
Message-Id: <20230307170030.747196792@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

commit c10bb64684813a326174c3eebcafb3ee5af52ca3 upstream.

We return POLLIN from io_uring_poll() depending on whether there are
CQEs for the userspace, and so we should use the user visible tail
pointer instead of a transient cached value.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/228ffcbf30ba98856f66ffdb9a6a60ead1dd96c0.1674484266.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2653,7 +2653,7 @@ static __poll_t io_uring_poll(struct fil
 	 * pushs them to do the flush.
 	 */
 
-	if (io_cqring_events(ctx) || io_has_work(ctx))
+	if (__io_cqring_events_user(ctx) || io_has_work(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;


