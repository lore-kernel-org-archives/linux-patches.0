Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A95E548;
	Mon, 11 Dec 2023 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNT76YXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F7DC433C8;
	Mon, 11 Dec 2023 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321091;
	bh=o4wuwDeDGJZ3HEXeVWHA+VNUFbX3EXIErUpmVj9MUTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNT76YXtot7M7eByBEf8zNMTMHSi/9DereYMUb8yvvjyG9ODKyDewoHWxif4L+7d2
	 QBE02uND1sVUy1++O7kOdmL13LV1YEzwKh+xWGaFUeDfpCfWsAqnFAQdHKCcOZsory
	 oqaiTQT86IfbDhX9u3kzmEJfzTgway276QJT4Ffw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 5.15 107/141] io_uring/af_unix: disable sending io_uring over sockets
Date: Mon, 11 Dec 2023 19:22:46 +0100
Message-ID: <20231211182031.183041859@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 705318a99a138c29a512a72c3e0043b3cd7f55f4 upstream.

File reference cycles have caused lots of problems for io_uring
in the past, and it still doesn't work exactly right and races with
unix_stream_read_generic(). The safest fix would be to completely
disallow sending io_uring files via sockets via SCM_RIGHT, so there
are no possible cycles invloving registered files and thus rendering
SCM accounting on the io_uring side unnecessary.

Cc:  <stable@vger.kernel.org>
Fixes: 0091bfc81741b ("io_uring/af_unix: defer registered files gc to io_uring release")
Reported-and-suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   55 ----------------------------------------------------
 net/core/scm.c      |    6 +++++
 2 files changed, 6 insertions(+), 55 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -8627,49 +8627,6 @@ out_free:
 	return ret;
 }
 
-static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
-				int index)
-{
-#if defined(CONFIG_UNIX)
-	struct sock *sock = ctx->ring_sock->sk;
-	struct sk_buff_head *head = &sock->sk_receive_queue;
-	struct sk_buff *skb;
-
-	/*
-	 * See if we can merge this file into an existing skb SCM_RIGHTS
-	 * file set. If there's no room, fall back to allocating a new skb
-	 * and filling it in.
-	 */
-	spin_lock_irq(&head->lock);
-	skb = skb_peek(head);
-	if (skb) {
-		struct scm_fp_list *fpl = UNIXCB(skb).fp;
-
-		if (fpl->count < SCM_MAX_FD) {
-			__skb_unlink(skb, head);
-			spin_unlock_irq(&head->lock);
-			fpl->fp[fpl->count] = get_file(file);
-			unix_inflight(fpl->user, fpl->fp[fpl->count]);
-			fpl->count++;
-			spin_lock_irq(&head->lock);
-			__skb_queue_head(head, skb);
-		} else {
-			skb = NULL;
-		}
-	}
-	spin_unlock_irq(&head->lock);
-
-	if (skb) {
-		fput(file);
-		return 0;
-	}
-
-	return __io_sqe_files_scm(ctx, 1, index);
-#else
-	return 0;
-#endif
-}
-
 static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 				 struct io_rsrc_node *node, void *rsrc)
 {
@@ -8727,12 +8684,6 @@ static int io_install_fixed_file(struct
 
 	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
 	io_fixed_file_set(file_slot, file);
-	ret = io_sqe_file_register(ctx, file, slot_index);
-	if (ret) {
-		file_slot->file_ptr = 0;
-		goto err;
-	}
-
 	ret = 0;
 err:
 	if (needs_switch)
@@ -8846,12 +8797,6 @@ static int __io_sqe_files_update(struct
 			}
 			*io_get_tag_slot(data, i) = tag;
 			io_fixed_file_set(file_slot, file);
-			err = io_sqe_file_register(ctx, file, i);
-			if (err) {
-				file_slot->file_ptr = 0;
-				fput(file);
-				break;
-			}
 		}
 	}
 
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -26,6 +26,7 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/errqueue.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 
@@ -103,6 +104,11 @@ static int scm_fp_copy(struct cmsghdr *c
 
 		if (fd < 0 || !(file = fget_raw(fd)))
 			return -EBADF;
+		/* don't allow io_uring files */
+		if (io_uring_get_socket(file)) {
+			fput(file);
+			return -EINVAL;
+		}
 		*fpp++ = file;
 		fpl->count++;
 	}


