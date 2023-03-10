Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBEB8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2395C433EF;
	Fri, 10 Mar 2023 14:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457642;
	bh=opavH/SUZltEg9QKd6fjyOn6r1eV/jpmnKjpEphS6Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2BMGMunZeCQLb9LQTFnW5fnuhd10aR75N6q5GklqFFy+gk74A95K3nZipTD1Y5Ek
	 L7A5VNux2h5YH69UcOM5ExM2Nx0j36uY/q2LWFenzyegsSoEwHHJzIQPIiRvUgXv0J
	 /ySyKslOWAnZcFPrfn2yyXoZbRbZBQQe6iXlhP7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinghui Li <korantli@tencent.com>,
	kernel test robot <lkp@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 195/200] io_uring: fix two assignments in if conditions
Date: Fri, 10 Mar 2023 14:40:02 +0100
Message-Id: <20230310133723.073697611@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xinghui Li <korantli@tencent.com>

commit df730ec21f7ba395b1b22e7f93a3a85b1d1b7882 upstream.

Fixes two errors:

"ERROR: do not use assignment in if condition
130: FILE: io_uring/net.c:130:
+       if (!(issue_flags & IO_URING_F_UNLOCKED) &&

ERROR: do not use assignment in if condition
599: FILE: io_uring/poll.c:599:
+       } else if (!(issue_flags & IO_URING_F_UNLOCKED) &&"
reported by checkpatch.pl in net.c and poll.c .

Signed-off-by: Xinghui Li <korantli@tencent.com>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20221102082503.32236-1-korantwork@gmail.com
[axboe: style tweaks]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c  |   16 +++++++++-------
 io_uring/poll.c |    7 +++++--
 2 files changed, 14 insertions(+), 9 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -126,13 +126,15 @@ static struct io_async_msghdr *io_msg_al
 	struct io_cache_entry *entry;
 	struct io_async_msghdr *hdr;
 
-	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-	    (entry = io_alloc_cache_get(&ctx->netmsg_cache)) != NULL) {
-		hdr = container_of(entry, struct io_async_msghdr, cache);
-		hdr->free_iov = NULL;
-		req->flags |= REQ_F_ASYNC_DATA;
-		req->async_data = hdr;
-		return hdr;
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		entry = io_alloc_cache_get(&ctx->netmsg_cache);
+		if (entry) {
+			hdr = container_of(entry, struct io_async_msghdr, cache);
+			hdr->free_iov = NULL;
+			req->flags |= REQ_F_ASYNC_DATA;
+			req->async_data = hdr;
+			return hdr;
+		}
 	}
 
 	if (!io_alloc_async_data(req)) {
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -678,10 +678,13 @@ static struct async_poll *io_req_alloc_a
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-		   (entry = io_alloc_cache_get(&ctx->apoll_cache)) != NULL) {
+	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		entry = io_alloc_cache_get(&ctx->apoll_cache);
+		if (entry == NULL)
+			goto alloc_apoll;
 		apoll = container_of(entry, struct async_poll, cache);
 	} else {
+alloc_apoll:
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (unlikely(!apoll))
 			return NULL;


