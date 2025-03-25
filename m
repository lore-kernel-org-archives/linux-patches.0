Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CD825A2DE;
	Tue, 25 Mar 2025 12:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905671; cv=none; b=XMEdLRbYjc/mudbCbKpKwmXJRctcImnN8lZlsjmtf5SuZsyTn856DJe0evtwVKsTfH02Nre3UR7/zZBJ0c60c7myPGsVBxF47unLN77W1WYBsWcaIrexaY1cBazwrJB1nC4cOxZY65dbc+SxQYIBv3ycpb7P56JGdsb4ECo+ekA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905671; c=relaxed/simple;
	bh=1w6VYJO4ERwQEPCsmxXExaxBwFxqysOEjxkjlUfLvZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReH+eEFFgyxhkfiFL5JeCjjckzemEh7KgMs8bp5ozFs7sPxhZiYPC0OE1Wn+0aYSEA827/zEYXNICjeCv1cBJmT0P4/E0IrLxqBYicx4MJnYU5sE6B378RajOFvNXmgdVibphxDU60Vkjf1yN/I2cPOkDRSM4WFbB9C24uh71+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfOwoHdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfOwoHdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D846C4CEE4;
	Tue, 25 Mar 2025 12:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905671;
	bh=1w6VYJO4ERwQEPCsmxXExaxBwFxqysOEjxkjlUfLvZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfOwoHdU5ZKsYqI63qcUBpFcroMNF9VD3rZoPDD+j8EhNTEcT1XMXuDwMrKmksZCh
	 7q+kfc7jZwlzRsGrtF++G0UE6RGVaV1qUKEoLNhC8h59olOPMgBW9mrtuooQtZGTiH
	 30FDz/bqjddcJizEd+anj3w82bt1RMGwO2qqu2Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 073/198] io_uring: add ring freeing helper
Date: Tue, 25 Mar 2025 08:20:35 -0400
Message-ID: <20250325122158.555292469@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 9c189eee73af1825ea9c895fafad469de5f82641 upstream.

We do rings and sqes separately, move them into a helper that does both
the freeing and clearing of the memory.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2525,6 +2525,14 @@ static void io_mem_free(void *ptr)
 		free_compound_page(page);
 }
 
+static void io_rings_free(struct io_ring_ctx *ctx)
+{
+	io_mem_free(ctx->rings);
+	io_mem_free(ctx->sq_sqes);
+	ctx->rings = NULL;
+	ctx->sq_sqes = NULL;
+}
+
 static void *io_mem_alloc(size_t size)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
@@ -2684,8 +2692,7 @@ static __cold void io_ring_ctx_free(stru
 		mmdrop(ctx->mm_account);
 		ctx->mm_account = NULL;
 	}
-	io_mem_free(ctx->rings);
-	io_mem_free(ctx->sq_sqes);
+	io_rings_free(ctx);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
@@ -3452,15 +3459,13 @@ static __cold int io_allocate_scq_urings
 	else
 		size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
 	if (size == SIZE_MAX) {
-		io_mem_free(ctx->rings);
-		ctx->rings = NULL;
+		io_rings_free(ctx);
 		return -EOVERFLOW;
 	}
 
 	ptr = io_mem_alloc(size);
 	if (IS_ERR(ptr)) {
-		io_mem_free(ctx->rings);
-		ctx->rings = NULL;
+		io_rings_free(ctx);
 		return PTR_ERR(ptr);
 	}
 


