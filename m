Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A949F1A08CA;
	Mon, 12 May 2025 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072530; cv=none; b=EDyPRxPE97UX4SPaCCwV0L7QuGWrWOvQ2CrbN1oFo0DcwdUSGC3XlTUTw4Dp8WupU+BstThbWEEe/u6AV9BA+VgXajGDMgjP+yje9R+ra5QnyQbLnv3g4+uFe9Uch8SsH/ukTXawnL/+lTPndKrMpyAe7mvkHzelygeK2n2veHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072530; c=relaxed/simple;
	bh=irBZ1/bQIABJsTSCTLK5WmArneAdVL4pz589dZ2OCwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIcGydV/vuRphNIqwvuLzxMnFJBjLEohTuCiMRIgRtL8v2NpC5CAgCT9ansnEGW2D4OU7eWLWtP5j81EXASbk4/BnUDj8yY6wR8vl32FuleoqNcCzZkej2WBhR9z3zROCB1jgmkM/rMZteo/eV788Cd13S3wZu4vDaByUzHe/Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpNlk9PN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpNlk9PN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BA2C4CEE9;
	Mon, 12 May 2025 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072530;
	bh=irBZ1/bQIABJsTSCTLK5WmArneAdVL4pz589dZ2OCwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpNlk9PN7RLWAZFpbhJmocAm9JC4/i2bELCcenlDVe0aoWWeAK4hgfKLy/XJfjlRg
	 k03yYhHSbA+mUdEClFl0Fnx2qUN0UiGUN2dnlDYDRentw/1VKuzBHppf9prh8WtENo
	 r/UUBUzt2+ou5OWpPzVPewMte3fN2ZUEd3kHUGYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norman Maurer <norman_maurer@apple.com>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 70/92] io_uring: ensure deferred completions are posted for multishot
Date: Mon, 12 May 2025 19:45:45 +0200
Message-ID: <20250512172025.976075921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

Commit 687b2bae0efff9b25e071737d6af5004e6e35af5 upstream.

Multishot normally uses io_req_post_cqe() to post completions, but when
stopping it, it may finish up with a deferred completion. This is fine,
except if another multishot event triggers before the deferred completions
get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
and cause confusion on the application side.

When multishot posting via io_req_post_cqe(), flush any pending deferred
completions first, if any.

Cc: stable@vger.kernel.org # 6.1+
Reported-by: Norman Maurer <norman_maurer@apple.com>
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -819,6 +819,14 @@ bool io_post_aux_cqe(struct io_ring_ctx
 {
 	bool filled;
 
+	/*
+	 * If multishot has already posted deferred completions, ensure that
+	 * those are flushed first before posting this one. If not, CQEs
+	 * could get reordered.
+	 */
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
+		__io_submit_flush_completions(ctx);
+
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags, allow_overflow);
 	io_cq_unlock_post(ctx);


