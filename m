Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01361DE8BE;
	Wed, 19 Feb 2025 09:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955891; cv=none; b=BjGYA1L/HkaVDC+M/A2wNxGiO2Fs4IQdTx12spDD+ma4ZF/X1IBOSDZdnMBEsdERGJkECkzJfagpYJ9nooP+8IY3tPNaFfcbXaTiVMmPRNhWGrq9BHo82Du78tuhoH5HExaVyEc47iTZRoqiL6bsLw3ZdewlZ9s9rg52QoQvs2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955891; c=relaxed/simple;
	bh=Tk4i5ULN77lerpbqngSwsf5NM9hZOuQg76LqlvEH2hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPOy2wtglEsaeyl7YlUXahe/KUOZLQPPbnB6i2t3Jj4uxD/9jZZzYdL/BdLYNAsshGiZzf5lo6wGlSddbBc8xx9+Vup2zERxQ5HCIwBtMFaIKLiD1J9XAXao7gz+0UfzAX/ChCCEiiPe9Bghdlf28Djq0cPePRxcjJqyhLAvJxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3OD8ius; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3OD8ius"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41E7C4CED1;
	Wed, 19 Feb 2025 09:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955891;
	bh=Tk4i5ULN77lerpbqngSwsf5NM9hZOuQg76LqlvEH2hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3OD8iusZ9xf3QWuSSh4C1+VhhfcREr1jq3YVJlAZFpGrd2KL7HkueAqyH8wuPlGB
	 ff3u7RIrYFRyYEEwmLgNPy2b+xSQ9bBKxwkT5swxRCsgXC+c6XYJS7XHXyKHFGolPv
	 oNCfLKSt+wMgxsbKvBvmPN6/rjTBbRLHierAPiXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pumpkin Chang <pumpkin@devco.re>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 148/152] io_uring/kbuf: reallocate buf lists on upgrade
Date: Wed, 19 Feb 2025 09:29:21 +0100
Message-ID: <20250219082555.902385898@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 8802766324e1f5d414a81ac43365c20142e85603 upstream.

IORING_REGISTER_PBUF_RING can reuse an old struct io_buffer_list if it
was created for legacy selected buffer and has been emptied. It violates
the requirement that most of the field should stay stable after publish.
Always reallocate it instead.

Cc: stable@vger.kernel.org
Reported-by: Pumpkin Chang <pumpkin@devco.re>
Fixes: 2fcabce2d7d34 ("io_uring: disallow mixed provided buffer group registrations")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -301,6 +301,12 @@ void io_destroy_buffers(struct io_ring_c
 	}
 }
 
+static void io_destroy_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+{
+	xa_erase(&ctx->io_bl_xa, bl->bgid);
+	io_put_bl(ctx, bl);
+}
+
 int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_provide_buf *p = io_kiocb_to_cmd(req, struct io_provide_buf);
@@ -642,12 +648,13 @@ int io_register_pbuf_ring(struct io_ring
 		/* if mapped buffer ring OR classic exists, don't allow */
 		if (bl->is_mapped || !list_empty(&bl->buf_list))
 			return -EEXIST;
-	} else {
-		free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
-		if (!bl)
-			return -ENOMEM;
+		io_destroy_bl(ctx, bl);
 	}
 
+	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	if (!bl)
+		return -ENOMEM;
+
 	if (!(reg.flags & IOU_PBUF_RING_MMAP))
 		ret = io_pin_pbuf_ring(&reg, bl);
 	else


