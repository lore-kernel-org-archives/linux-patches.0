Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223DB347FDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302464; cv=none; b=Qqz99hafa15rR7OWFlMdp0dUFfiPeu3PCLOD4yHBfH5fMbjoq5KZu7UW44HlCuUvqk6ixXK0ZkO4Oai8FnOWRaK1FjFk3C0cdpO+UNk0xHZjx7+vVBFmoq7eYxjTnyLPrkznycIU81GElZXLL9KLCv/BligVBVzhYBlqf7Y4kBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302464; c=relaxed/simple;
	bh=gsvBkg4/k8wIf/lOtXXhW4jc3ZJKEGlz8qO7HiOPIqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxQRHNVnWjH1VTRUqvWWzG5oc9vf1va0WVxpzBzUbPku12bF/S0jggjNpidOAmDMHMRzt4llO0AR2yqa11iT/L66HI/kt1rZ+nkTAustpQX7n3H2JTosq2ua6rVVGO5yJJIv48mFItVpRPJE6sdgz7UdWfiuyGA9G5z46gK7sAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PB5l0IZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PB5l0IZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994BDC19424;
	Sat, 28 Feb 2026 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302464;
	bh=gsvBkg4/k8wIf/lOtXXhW4jc3ZJKEGlz8qO7HiOPIqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PB5l0IZ7n8gy3SLcX9VQx6WMVFThtubRrL6RC5k6SwdhvFxUZH7yeDtvQqZCG/yTg
	 5mrvHVbMz8DyXR0xEJ7yHrIFBMg14F1+EPGBxOCINIFT6sodPf4U6c44J+vhNRrCsk
	 4drJFYS0I4z/gQp3XzakUNUe9UaAKxMAHNs2CC70kexo9mAKnNyYccJs8/ORr04lpW
	 PSDqmBr6AGohvz/ugIiFDjmAl2Rnn1GxIF33kfweAi+16uTK74W8lHe79DOVz97MGj
	 q2P5ZQXvxe3lE6Em4hGhJhYw8FSoRcKPFQ/nqqq+b16ifw8VA1p4QQ24Rv5jXmdpga
	 bMYfMVkweCT/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/232] io_uring/cancel: de-unionize file and user_data in struct io_cancel_data
Date: Sat, 28 Feb 2026 13:11:00 -0500
Message-ID: <20260228181127.1592657-207-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 22dbb0987bd1e0ec3b1e4ad20756a98f99aa4a08 ]

By having them share the same space in struct io_cancel_data, it ends up
disallowing IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_USERDATA from
working. Eg you cannot match on both a file and user_data for
cancelation purposes. This obviously isn't a common use case as nobody
has reported this, but it does result in -ENOENT potentially being
returned when trying to match on both, rather than actually doing what
the API says it would.

Fixes: 4bf94615b888 ("io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index fc98622e6166e..7e6d0fca7db28 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -4,10 +4,8 @@
 
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
-	union {
-		u64 data;
-		struct file *file;
-	};
+	u64 data;
+	struct file *file;
 	u8 opcode;
 	u32 flags;
 	int seq;
-- 
2.51.0

