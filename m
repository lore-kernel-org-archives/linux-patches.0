Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1AC17AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAD0C433C7;
	Wed,  9 Aug 2023 11:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581120;
	bh=XQC8+iGxxE9zBySSBhy5e8kBDg4YBjsFmK52LaxctyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcCnwpq0vv69kAA3Fwhvx0eBd2ljZ1rVHGxmh4m6z2HJiLcTEc7RQ/XwdYxWEjoe+
	 WaGcvY7HtZ3SfoM/0YavGGjw3Kkp1mB1qarSZmixehcrgCY39tQHPI1Clwz75IlzzW
	 lyDXwAMs5Vk7D4J+G9Zl3YD4y0ze+JxSsFCmY0Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 111/201] io_uring: treat -EAGAIN for REQ_F_NOWAIT as final for io-wq
Date: Wed,  9 Aug 2023 12:41:53 +0200
Message-ID: <20230809103647.508267884@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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

commit a9be202269580ca611c6cebac90eaf1795497800 upstream.

io-wq assumes that an issue is blocking, but it may not be if the
request type has asked for a non-blocking attempt. If we get
-EAGAIN for that case, then we need to treat it as a final result
and not retry or arm poll for it.

Cc: stable@vger.kernel.org # 5.10+
Link: https://github.com/axboe/liburing/issues/897
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -6895,6 +6895,14 @@ static void io_wq_submit_work(struct io_
 			 */
 			if (ret != -EAGAIN || !(req->ctx->flags & IORING_SETUP_IOPOLL))
 				break;
+
+			/*
+			 * If REQ_F_NOWAIT is set, then don't wait or retry with
+			 * poll. -EAGAIN is final for that case.
+			 */
+			if (req->flags & REQ_F_NOWAIT)
+				break;
+
 			cond_resched();
 		} while (1);
 	}


