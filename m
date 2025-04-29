Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BF0367;
	Tue, 29 Apr 2025 18:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950393; cv=none; b=FrRse02kPIkz4VAkoOg26AAHjmhdBdMBnRPiPimM3ZWvoitocdA9vNqH8EnJrXdhWa2S1vInwExc4Mp2vnDgQdWn5xeffgxWOiTVKvV0tOkMAMSuVywaaM8oJWdJOnZAtzShoXDxWIFbrncUNmIFq4SxdaRHgCQ8t+g3pKQ1x/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950393; c=relaxed/simple;
	bh=t0v/hTLFyn/g7TNdbUikbM0GcjiXlTdnXHKrQT+/j0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+7Ue13k1dyhK9pPmcdX7IAkJqWSb76LLR7AXENY+cARKjmFxZvVwezWKfnW8EP6OIU2MEQNGz2OMX1h/anHfznnu9tbVw3MsMkp9RhLSHYbKhywQlyYNkvfrBQezYQfzF27xGYwpzwOpx49XwtA6CsSSn/kGR/t0eWjzocT7/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rER1AMz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rER1AMz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E798C4CEE9;
	Tue, 29 Apr 2025 18:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950393;
	bh=t0v/hTLFyn/g7TNdbUikbM0GcjiXlTdnXHKrQT+/j0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rER1AMz0ANdj/mc3l6MGPOen8m8OQzLa4oE8s9jfFmDHBUxLAdcXh9vwVMvaSjVWw
	 eTXN4WGz6z19G55kPtxfchCIRgT0srxUaakfO1GK/xbrodN04akomb2FfNiOt/mHL0
	 Q4bD01oQASKpTKv/DX2WGMlOzlPV6taPrMnBjTGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 082/204] io_uring: fix sync handling of io_fallback_tw()
Date: Tue, 29 Apr 2025 18:42:50 +0200
Message-ID: <20250429161102.776038302@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit edd43f4d6f50ec3de55a0c9e9df6348d1da51965 upstream.

A previous commit added a 'sync' parameter to io_fallback_tw(), which if
true, means the caller wants to wait on the fallback thread handling it.
But the logic is somewhat messed up, ensure that ctxs are swapped and
flushed appropriately.

Cc: stable@vger.kernel.org
Fixes: dfbe5561ae93 ("io_uring: flush offloaded and delayed task_work on exit")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1247,21 +1247,22 @@ static __cold void io_fallback_tw(struct
 	while (node) {
 		req = container_of(node, struct io_kiocb, io_task_work.node);
 		node = node->next;
-		if (sync && last_ctx != req->ctx) {
+		if (last_ctx != req->ctx) {
 			if (last_ctx) {
-				flush_delayed_work(&last_ctx->fallback_work);
+				if (sync)
+					flush_delayed_work(&last_ctx->fallback_work);
 				percpu_ref_put(&last_ctx->refs);
 			}
 			last_ctx = req->ctx;
 			percpu_ref_get(&last_ctx->refs);
 		}
-		if (llist_add(&req->io_task_work.node,
-			      &req->ctx->fallback_llist))
-			schedule_delayed_work(&req->ctx->fallback_work, 1);
+		if (llist_add(&req->io_task_work.node, &last_ctx->fallback_llist))
+			schedule_delayed_work(&last_ctx->fallback_work, 1);
 	}
 
 	if (last_ctx) {
-		flush_delayed_work(&last_ctx->fallback_work);
+		if (sync)
+			flush_delayed_work(&last_ctx->fallback_work);
 		percpu_ref_put(&last_ctx->refs);
 	}
 }


