Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B9815C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DB0C433D6;
	Mon,  5 Dec 2022 19:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269004;
	bh=F65nbDNIfgAAm0HODyIWU116wKocwNDAjDepT1FwhJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eh7mGZb7rq30KYHUV/a/6RjN6+C3ypeHoyKlB329b07+Oax8Q1yvAs0b/IYcCCpuA
	 +EZchRCLLKS6DCm6V5GF92Y3xHxnsHnJ0jKdnIysz2vitQntZCMtzckc6RG9vvhwQK
	 o6HORTnTtgPhp7SdDok1WSgXGhmKGZBU2GtRUQ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 091/120] io_uring: make poll refs more robust
Date: Mon,  5 Dec 2022 20:10:31 +0100
Message-Id: <20221205190809.311460468@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

[ upstream commit a26a35e9019fd70bf3cf647dcfdae87abc7bacea ]

poll_refs carry two functions, the first is ownership over the request.
The second is notifying the io_poll_check_events() that there was an
event but wake up couldn't grab the ownership, so io_poll_check_events()
should retry.

We want to make poll_refs more robust against overflows. Instead of
always incrementing it, which covers two purposes with one atomic, check
if poll_refs is elevated enough and if so set a retry flag without
attempts to grab ownership. The gap between the bias check and following
atomics may seem racy, but we don't need it to be strict. Moreover there
might only be maximum 4 parallel updates: by the first and the second
poll entries, __io_arm_poll_handler() and cancellation. From those four,
only poll wake ups may be executed multiple times, but they're protected
by a spin.

Cc: stable@vger.kernel.org
Reported-by: Lin Ma <linma@zju.edu.cn>
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c762bc31f8683b3270f3587691348a7119ef9c9d.1668963050.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5322,7 +5322,29 @@ struct io_poll_table {
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	GENMASK(30, 0)
+#define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+
+/*
+ * We usually have 1-2 refs taken, 128 is more than enough and we want to
+ * maximise the margin between this amount and the moment when it overflows.
+ */
+#define IO_POLL_REF_BIAS       128
+
+static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
+{
+	int v;
+
+	/*
+	 * poll_refs are already elevated and we don't have much hope for
+	 * grabbing the ownership. Instead of incrementing set a retry flag
+	 * to notify the loop that there might have been some change.
+	 */
+	v = atomic_fetch_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
+	if (v & IO_POLL_REF_MASK)
+		return false;
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+}
 
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
@@ -5332,6 +5354,8 @@ struct io_poll_table {
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
+	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
 
@@ -5447,6 +5471,16 @@ static int io_poll_check_events(struct i
 		 */
 		if ((v & IO_POLL_REF_MASK) != 1)
 			req->result = 0;
+		if (v & IO_POLL_RETRY_FLAG) {
+			req->result = 0;
+			/*
+			 * We won't find new events that came in between
+			 * vfs_poll and the ref put unless we clear the
+			 * flag in advance.
+			 */
+			atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
+			v &= ~IO_POLL_RETRY_FLAG;
+		}
 
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = poll->events };


