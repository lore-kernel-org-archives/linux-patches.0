Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFB52E7163;
	Tue, 17 Jun 2025 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177045; cv=none; b=uZMKhAjVuFpU20IXXGq6l1jqz495Hj2cM1r3QUkE1cgIDIqjBnlI12JYNPsoyreDVxLXAXZLJHOKIxzRFy/lg1Nb2B4VHjsTl4IxbzZQvL8aXJz77o0Tt8eSKXDSCiPTCX+K+YA8YO3bAKF4PpdvDUR/m5QZ4c6YbrI3ZYXfJcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177045; c=relaxed/simple;
	bh=+J1ZxDdKzuEBCXOdhFVi0R43trBjrZmip4HoY5ZxvXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6zale+hMIgpAKVSkzopxX6NrJZ+usouDrVzwWVFtsPqVjo3bpsx8JIUhjPJfO3JBjRmYaLbJ9OJxErr690C49cLuWA0jvjOrTUT6WrVgFRcNwnI8NzVK8jGC2smMgmyh+CHtQTBFcILUzUMpSg0LbENlX0dfyykvM18S4J/JNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZd0/MnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZd0/MnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA80C4CEE7;
	Tue, 17 Jun 2025 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177045;
	bh=+J1ZxDdKzuEBCXOdhFVi0R43trBjrZmip4HoY5ZxvXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZd0/MnWAFYje2HBmemsCr6WX6+tsPlqz1HcEh3A2L25OEhhJk9wWoE6LsuEhY8yh
	 OX6dDJtgMybjy1gaR8CiIe/LAQxpolibR30H1MPMLROSdQF4UDWkQetR1cCwLm7kK7
	 +Dufyu6lsQr00fpVG2V7SnsAqmul9TL2tOZBsX+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 342/356] Revert "io_uring: ensure deferred completions are posted for multishot"
Date: Tue, 17 Jun 2025 17:27:37 +0200
Message-ID: <20250617152351.901875146@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 746e7d285dcb96caa1845fbbb62b14bf4010cdfb which is
commit 687b2bae0efff9b25e071737d6af5004e6e35af5 upstream.

Jens writes:
	There's some missing dependencies that makes this not work
	right, I'll bring it back in a series instead.

Link: https://lore.kernel.org/r/906ba919-32e6-4534-bbad-2cd18e1098ca@kernel.dk
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -920,14 +920,6 @@ static bool __io_post_aux_cqe(struct io_
 {
 	bool filled;
 
-	/*
-	 * If multishot has already posted deferred completions, ensure that
-	 * those are flushed first before posting this one. If not, CQEs
-	 * could get reordered.
-	 */
-	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
-		__io_submit_flush_completions(ctx);
-
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (!filled && allow_overflow)


