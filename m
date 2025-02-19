Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7492B1D88AC;
	Wed, 19 Feb 2025 08:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954001; cv=none; b=ITq7NOXSjrYeXZETx45RgDyJa4fSLu9s2usR0g/zJSPMvdxiOPexP4Es6+wz3qivLdNiF2XQ+bC0fT66NXNkIw5BfFoiT10Af+Av5GHvg0l0oZWKDGciMYrtd/yH1C9YjpNId0BqcHqDUJNHB8/hhBhX7u7KxCbOHOGVsFhFW9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954001; c=relaxed/simple;
	bh=wxuzjZpGkZ3wzzHvBcVOi4ksmYvc2xnMUXXzhdg1zIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzx3lV6j6jRPGvpR3G/P7XxlwxzNKkR1yQdtu4YOV9erL0SWL/jbXNgPcAKhQjaaiQ0snF0Rgff0opkkEFXpYOa/ZcNaxYWP0BH7u8iuyZsV8SQY2cdjmYN/rcJI72tvY/oP3oVT45rOqya7dWYiOClIFOMac7b/ySbKQpOs3OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ex8CrrFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ex8CrrFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD295C4CED1;
	Wed, 19 Feb 2025 08:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954001;
	bh=wxuzjZpGkZ3wzzHvBcVOi4ksmYvc2xnMUXXzhdg1zIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ex8CrrFX2+ExYzFD1irchHwSYzfsW/9bbvTBf6aWShwXO2eRMVK0dAgfI6ecjs86v
	 2+YIImVRPwh6x/MmwP648ctxa1MRPTpl0nmOqEoDKyA1Vd9vrRSZ3Ye3VhM6ohNvZ0
	 8dg3BzKmu2VeF7MruRKs/ZvFAug3T1Ej2J2k1pyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 063/274] block: cleanup and fix batch completion adding conditions
Date: Wed, 19 Feb 2025 09:25:17 +0100
Message-ID: <20250219082612.089856951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 1f47ed294a2bd577d5ae43e6e28e1c9a3be4a833 ]

The conditions for whether or not a request is allowed adding to a
completion batch are a bit hard to read, and they also have a few
issues. One is that ioerror may indeed be a random value on passthrough,
and it's being checked unconditionally of whether or not the given
request is a passthrough request or not.

Rewrite the conditions to be separate for easier reading, and only check
ioerror for non-passthrough requests. This fixes an issue with bio
unmapping on passthrough, where it fails getting added to a batch. This
both leads to suboptimal performance, and may trigger a potential
schedule-under-atomic condition for polled passthrough IO.

Fixes: f794f3351f26 ("block: add support for blk_mq_end_request_batch()")
Link: https://lore.kernel.org/r/20575f0a-656e-4bb3-9d82-dec6c7e3a35c@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blk-mq.h | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c596e0e4cb751..7b19b83349cf8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -872,12 +872,22 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 				       void (*complete)(struct io_comp_batch *))
 {
 	/*
-	 * blk_mq_end_request_batch() can't end request allocated from
-	 * sched tags
+	 * Check various conditions that exclude batch processing:
+	 * 1) No batch container
+	 * 2) Has scheduler data attached
+	 * 3) Not a passthrough request and end_io set
+	 * 4) Not a passthrough request and an ioerror
 	 */
-	if (!iob || (req->rq_flags & RQF_SCHED_TAGS) || ioerror ||
-			(req->end_io && !blk_rq_is_passthrough(req)))
+	if (!iob)
 		return false;
+	if (req->rq_flags & RQF_SCHED_TAGS)
+		return false;
+	if (!blk_rq_is_passthrough(req)) {
+		if (req->end_io)
+			return false;
+		if (ioerror < 0)
+			return false;
+	}
 
 	if (!iob->complete)
 		iob->complete = complete;
-- 
2.39.5



