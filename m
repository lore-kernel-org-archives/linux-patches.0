Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B2382C60;
	Tue, 29 Apr 2025 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946038; cv=none; b=ftX4MQja/fITd+LvPxrMuw0Kr6VngdstynSnQMd5coxVi+bBtdZu5ORbXV9Wcjn69k03zHJWClzKhs/wUclH4SMibZb4xBx3tCBlhCgIzSgk1QslgkMQGo2s2b6WY0kFoT0lX6oH9xptplOFqAU1sU4MF6bBB31CYadS9vUVroQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946038; c=relaxed/simple;
	bh=Zqfzxi4jzU57WdXGFLGiupZEedwky3ydFtsxLecUViw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjfAhj+XuuxR0KxnpgM7X7qM01ZZwr204PBQ0dMcABdI7OiXd5fKasUbEPmFeiKfrJH58WAnZ0LdFc8D4QHPZyxK0cJ/sJ/sO+2NCGmXBJk3OyxAGrX7Gwth9W6pj6Gkihs9qBaaWwwcyCJF/nezPm3COiy/CRv1V8E2/VBIVOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNs32E07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNs32E07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819F9C4CEEE;
	Tue, 29 Apr 2025 17:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946037;
	bh=Zqfzxi4jzU57WdXGFLGiupZEedwky3ydFtsxLecUViw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNs32E07LBMSkJAmjADRq/5Kd2+JedjXjn6s0AdP8zKNdDyXyagsdy2WmF7OASs1Q
	 Z0LNX+vJM/nYopIC10AmzmChwKpWmpe9pGZFLKtMk1f1oYuAyox9q91dJpQxqmLf4b
	 VW1RelWsyN2IzxBEtoDCVOHxt2sZ+g04LpMlh4AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 134/311] io_uring: fix sync handling of io_fallback_tw()
Date: Tue, 29 Apr 2025 18:39:31 +0200
Message-ID: <20250429161126.529960348@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1080,21 +1080,22 @@ static __cold void __io_fallback_tw(stru
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


