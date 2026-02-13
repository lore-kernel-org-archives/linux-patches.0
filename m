Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0134323645D;
	Fri, 13 Feb 2026 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990606; cv=none; b=m7oWmPe92uCHoWiG0a7BBqOdjyTrgqCS97kCHm61ml5NKD0JA7vlD0ThHCBRegxrw1utSMlzSZ4xCq4tA9pNtxVl0qj4n+YHK03l9QMuPG+YrF4sSdPuf5aubRtPJxOdmFhf0k4E4wdRLHmQhVHCnZzlMgI02+f7Ls/VvEDBXNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990606; c=relaxed/simple;
	bh=oSCvOGIVI/p2pRigBwrFD6KowZ4SOas5UUy+pLHA6yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gM5dzZ0fLFaFN9+CwWORqkoK5z/XhGr0tqUAbcCdwkwsbREIZs8Li0s4mC7tkX2PLNFSMT7vXl34KoGy8PuKMsJ/88rXl9nBN1ch3RNLVHQeDgyxWkUlxuT5CxKmg1hDpe8O/FjD+YxnG3wCWZYiUOyEgg9ax62Y9jdpCbxTdAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0e82ieR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0e82ieR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BA8C116C6;
	Fri, 13 Feb 2026 13:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990605;
	bh=oSCvOGIVI/p2pRigBwrFD6KowZ4SOas5UUy+pLHA6yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0e82ieRhnzQf9m2sPgB4F7LhlFVV0PHcZcKafLcOn8Z6Vl8axmq+u+L6CvmBHNUm
	 INSjMJQTrHTarAKH7vSMSIRQol9Tm0NO5y/r2KL8laDKeAlo95PeFSUXeYTzaVRa/0
	 b2+sija241mut1bI3Vd5uKNgD+NcTlCQ3PslM5kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <me@linux.beauty>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 02/49] io_uring: allow io-wq workers to exit when unused
Date: Fri, 13 Feb 2026 14:47:21 +0100
Message-ID: <20260213134708.815760245@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <me@linux.beauty>

commit 91214661489467f8452d34edbf257488d85176e4 upstream.

io_uring keeps a per-task io-wq around, even when the task no longer has
any io_uring instances.

If the task previously used io_uring for file I/O, this can leave an
unrelated iou-wrk-* worker thread behind after the last io_uring
instance is gone.

When the last io_uring ctx is removed from the task context, mark the
io-wq exit-on-idle so workers can go away. Clear the flag on subsequent
io_uring usage.

Signed-off-by: Li Chen <me@linux.beauty>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/tctx.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -122,6 +122,14 @@ int __io_uring_add_tctx_node(struct io_r
 				return ret;
 		}
 	}
+
+	/*
+	 * Re-activate io-wq keepalive on any new io_uring usage. The wq may have
+	 * been marked for idle-exit when the task temporarily had no active
+	 * io_uring instances.
+	 */
+	if (tctx->io_wq)
+		io_wq_set_exit_on_idle(tctx->io_wq, false);
 	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
 		node = kmalloc(sizeof(*node), GFP_KERNEL);
 		if (!node)
@@ -183,6 +191,9 @@ __cold void io_uring_del_tctx_node(unsig
 	if (tctx->last == node->ctx)
 		tctx->last = NULL;
 	kfree(node);
+
+	if (xa_empty(&tctx->xa) && tctx->io_wq)
+		io_wq_set_exit_on_idle(tctx->io_wq, true);
 }
 
 __cold void io_uring_clean_tctx(struct io_uring_task *tctx)


