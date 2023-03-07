Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03241BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604FBC433D2;
	Tue,  7 Mar 2023 19:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215965;
	bh=2lVNwVA++hPTgB3aV3/5OAp8PmxpRvv+MjQHlaCaQsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxvrVpeUKjK+SGsugrE4isEKmsqh0hvFeDWKe9WQHbAJ0P7tFQ5w8Dj7EDj/fWtLE
	 3a3YzuixVDoazqwVeWN+q/azcKR9hi/23bWc1r1PvnoelBupzlma3xyDCv5COIsITQ
	 SpJLqUpwT1ev/8OB9Lve5DC5+Al3aZ8k67GkiKYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH 5.15 430/567] block: dont allow multiple bios for IOCB_NOWAIT issue
Date: Tue,  7 Mar 2023 18:02:46 +0100
Message-Id: <20230307165924.537411932@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

commit 67d59247d4b52c917e373f05a807027756ab216f upstream.

If we're doing a large IO request which needs to be split into multiple
bios for issue, then we can run into the same situation as the below
marked commit fixes - parts will complete just fine, one or more parts
will fail to allocate a request. This will result in a partially
completed read or write request, where the caller gets EAGAIN even though
parts of the IO completed just fine.

Do the same for large bios as we do for splits - fail a NOWAIT request
with EAGAIN. This isn't technically fixing an issue in the below marked
patch, but for stable purposes, we should have either none of them or
both.

This depends on: 613b14884b85 ("block: handle bio_split_to_limits() NULL return")

Cc: stable@vger.kernel.org # 5.15+
Fixes: 9cea62b2cbab ("block: don't allow splitting of a REQ_NOWAIT bio")
Link: https://github.com/axboe/liburing/issues/766
Reported-and-tested-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/fops.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/block/fops.c
+++ b/block/fops.c
@@ -243,6 +243,24 @@ static ssize_t __blkdev_direct_IO(struct
 			bio_endio(bio);
 			break;
 		}
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			/*
+			 * This is nonblocking IO, and we need to allocate
+			 * another bio if we have data left to map. As we
+			 * cannot guarantee that one of the sub bios will not
+			 * fail getting issued FOR NOWAIT and as error results
+			 * are coalesced across all of them, be safe and ask for
+			 * a retry of this from blocking context.
+			 */
+			if (unlikely(iov_iter_count(iter))) {
+				bio_release_pages(bio, false);
+				bio_clear_flag(bio, BIO_REFFED);
+				bio_put(bio);
+				blk_finish_plug(&plug);
+				return -EAGAIN;
+			}
+			bio->bi_opf |= REQ_NOWAIT;
+		}
 
 		if (is_read) {
 			bio->bi_opf = REQ_OP_READ;
@@ -252,9 +270,6 @@ static ssize_t __blkdev_direct_IO(struct
 			bio->bi_opf = dio_bio_write_op(iocb);
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			bio->bi_opf |= REQ_NOWAIT;
-
 		dio->size += bio->bi_iter.bi_size;
 		pos += bio->bi_iter.bi_size;
 


